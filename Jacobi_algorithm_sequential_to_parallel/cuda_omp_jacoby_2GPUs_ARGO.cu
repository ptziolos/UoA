#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <omp.h>

using namespace std;

static const int blockSize = 256;

/*************************************************************
* Unroll the last 6 iterations of the loop for each block
*************************************************************/
__device__
void warp(volatile double *partial_sum, int tid) {
	partial_sum[tid] += partial_sum[tid + 32];
	partial_sum[tid] += partial_sum[tid + 16];
	partial_sum[tid] += partial_sum[tid + 8];
	partial_sum[tid] += partial_sum[tid + 4];
	partial_sum[tid] += partial_sum[tid + 2];
	partial_sum[tid] += partial_sum[tid + 1];
}


/*************************************************************
* Performs parallel reduction (Binary Tree Structure)
*************************************************************/
__global__
void quickAdd(double *input, int N) {
	// Allocate shared memory
	__shared__ double partial_sum[blockSize];

	// Load elements AND do first add of reduction
	int index = blockIdx.x * (blockSize * 2) + threadIdx.x;
	int stride = gridDim.x * blockSize;

	if (threadIdx.x == 0) {
		for (int l = 0; l < blockSize; l++) {
			partial_sum[l] = 0;
		}
	}
	__syncthreads();


	// Store first partial result instead of just the elements
	for (int k = index; k < N; k += stride) {
		if (k + blockSize < N) {
			partial_sum[threadIdx.x] += input[k] + input[k + blockSize];
			input[k] = 0;
			input[k + blockSize] = 0;
		}
		else {
			partial_sum[threadIdx.x] += input[k];
			input[k] = 0;
		}

	}
	__syncthreads();

	// Start at 1/2 block stride and divide by two each iteration
	for (int s = blockSize / 2; s > 32; s = s >> 1) {
		if (threadIdx.x < s) {
			partial_sum[threadIdx.x] += partial_sum[threadIdx.x + s];
		}
		__syncthreads();
	}

	if (threadIdx.x < 32) {
		warp(partial_sum, threadIdx.x);
	}

	// Let the thread 0 of the block write it's result to main memory
	if (threadIdx.x == 0) {
		input[blockIdx.x] = partial_sum[0];
	}
}


/*************************************************************
* Performs one iteration of the Jacobi method and computes
* the residual value.
*************************************************************/
__global__
void one_jacobi_iteration(int tid, double xStart, double yStart, int maxXCount, int maxYCount,
	double *src, double *dst, double deltaX, double deltaY, double alpha, double omega, double *errors)
{
#define SRC(XX,YY) src[(YY)*maxXCount+(XX)-tid*(maxYCount-2)*maxXCount]
#define DST(XX,YY) dst[(YY)*maxXCount+(XX)-tid*(maxYCount-2)*maxXCount]
#define ERR(XX,YY) errors[(YY)*maxXCount+(XX)-tid*(maxYCount-2)*maxXCount]

	double fX, fY;
	double updateVal;
	double f;
	// Coefficients
	double cx = 1.0 / (deltaX*deltaX);
	double cy = 1.0 / (deltaY*deltaY);
	double cc = -2.0*cx - 2.0*cy - alpha;

	int i_index = blockIdx.x * blockDim.x + threadIdx.x + 1;
	int i_stride = blockDim.x * gridDim.x;

	int j_index = blockIdx.y * blockDim.y + threadIdx.y + 1;
	int j_stride = blockDim.y * gridDim.y;

	for (int y = ((int)(tid * (maxYCount - 2))) + j_index; y < ((int)(tid * (maxYCount - 2))) + maxYCount - 1; y = y + j_stride) {
		for (int x = i_index; x < maxXCount - 1; x = x + i_stride) {
			fY = yStart + (y - 1)*deltaY;
			fX = xStart + (x - 1)*deltaX;
			f = -alpha*(1.0 - fX*fX)*(1.0 - fY*fY) - 2.0*(1.0 - fX*fX) - 2.0*(1.0 - fY*fY);
			updateVal = ((SRC(x - 1, y) + SRC(x + 1, y))*cx + (SRC(x, y - 1) + SRC(x, y + 1))*cy + SRC(x, y)*cc - f) / cc;
			DST(x, y) = SRC(x, y) - omega*updateVal;
			ERR(x, y) = updateVal*updateVal;
		}
	}

}


/**********************************************************
* Checks the error between numerical and exact solutions
**********************************************************/
double checkSolution(double xStart, double yStart,
	int maxXCount, int maxYCount,
	double *u,
	double deltaX, double deltaY,
	double alpha)
{
#define U(XX,YY) u[(YY)*maxXCount+(XX)]
	int x, y;
	double fX, fY;
	double localError, error = 0.0;

	for (y = 1; y < (maxYCount - 1); y++)
	{
		fY = yStart + (y - 1)*deltaY;
		for (x = 1; x < (maxXCount - 1); x++)
		{
			fX = xStart + (x - 1)*deltaX;
			localError = U(x, y) - (1.0 - fX*fX)*(1.0 - fY*fY);
			error += localError*localError;
		}
	}
	return sqrt(error) / ((maxXCount - 2)*(maxYCount - 2));
}


int main(int argc, char **argv)
{
	int n, m, mits;
	double alpha, tol, relax;
	double maxAcceptableError;
	double error, err[2];
	double *u, *u_old, *tmp;
	double *d_u_0, *d_u_old_0, *d_u_1, *d_u_old_1;
	double *d_errors_0, *d_errors_1;
	int allocCount, halfCount;
	int iterationCount, maxIterationCount;
	double t1, t2;
	double xLeft, yBottom, xRight, yUp;
	double deltaX, deltaY;
	int numBlocks_0, numBlocks_1;
	int TID;
	double zero = 0.0;

	/*printf("Input n,m - grid dimension in x,y direction:\n");
	scanf("%d,%d", &n, &m);
	printf("Input alpha - Helmholtz constant:\n");
	scanf("%lf", &alpha);
	printf("Input relax - successive over-relaxation parameter:\n");
	scanf("%lf", &relax);
	printf("Input tol - error tolerance for the iterrative solver:\n");
	scanf("%lf", &tol);
	printf("Input mits - maximum solver iterations:\n");
	scanf("%d", &mits);*/

	n = 1680;
	m = n;
	alpha = 1.0;
	relax = 0.8;
	tol = 1e-15;
	mits = 50;

	printf("-> %d, %d, %g, %g, %g, %d\n", n, m, alpha, relax, tol, mits);

	allocCount = (n + 2) * (m + 2);
	halfCount = (n + 2) * (int)((m + 2) / 2);

	// Those two calls also zero the boundary elements
	u = (double*)calloc(allocCount, sizeof(double));
	u_old = (double*)calloc(allocCount, sizeof(double));

	if (u == NULL || u_old == NULL)
	{
		printf("Not enough memory for two %ix%i matrices\n", n + 2, m + 2);
		exit(1);
	}
	maxIterationCount = mits;
	maxAcceptableError = tol;

	// Solve in [-1, 1] x [-1, 1]
	xLeft = -1.0, xRight = 1.0;
	yBottom = -1.0, yUp = 1.0;

	deltaX = (xRight - xLeft) / (n - 1);
	deltaY = (yUp - yBottom) / (m - 1);

	iterationCount = 0;
	error = HUGE_VAL;

	// CUDA device settings
	numBlocks_0 = (halfCount + blockSize - 1) / blockSize;
	numBlocks_1 = ((allocCount - halfCount) + blockSize - 1) / blockSize;

	dim3 block((int)sqrt(blockSize), (int)sqrt(blockSize), 1);
	dim3 grid_0((int)sqrt(numBlocks_0), (int)sqrt(numBlocks_0), 1);
	dim3 grid_1((int)sqrt(numBlocks_1), (int)sqrt(numBlocks_1), 1);


	/********************************* ___Start timing___*********************************/
	clock_t start = clock(), diff;


	/************************\|/-_0_-\|/****************************/
	cudaSetDevice(0);

	// Allocate Memory to GPU 0
	cudaMalloc(&d_u_0, (halfCount + n + 2) * sizeof(double));
	cudaMalloc(&d_u_old_0, (halfCount + n + 2) * sizeof(double));
	cudaMalloc(&d_errors_0, halfCount * sizeof(double));

	// copy to GPU 0
	cudaMemcpy(d_u_0, u, (halfCount + n + 2) * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(d_u_old_0, u_old, (halfCount + n + 2) * sizeof(double), cudaMemcpyHostToDevice);


	/************************\|/-_1_-\|/****************************/
	cudaSetDevice(1);

	// Allocate Memory to GPU 1
	cudaMalloc(&d_u_1, (allocCount - halfCount + n + 2) * sizeof(double));
	cudaMalloc(&d_u_old_1, (allocCount - halfCount + n + 2) * sizeof(double));
	cudaMalloc(&d_errors_1, (allocCount - halfCount) * sizeof(double));

	// copy to GPU 1
	cudaMemcpy(d_u_1, &u[halfCount - n - 2], (allocCount - halfCount + n + 2) * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(d_u_old_1, &u_old[halfCount - n - 2], (allocCount - halfCount + n + 2) * sizeof(double), cudaMemcpyHostToDevice);


	/* Iterate as long as it takes to meet the convergence criterion */
	while (iterationCount < maxIterationCount && error > maxAcceptableError)
	{
#pragma omp parallel num_threads(2)
		{
			TID = omp_get_thread_num();

			if (TID == 0) {
				cudaSetDevice(0);

				// CUDA kernel function (one_jacobi_iteration) call
				one_jacobi_iteration << <grid_0, block >> >(0, xLeft, yBottom, n + 2, (m / 2) + 2,
					d_u_old_0, d_u_0, deltaX, deltaY, alpha, relax, d_errors_0);

				// CUDA kernel function (quickAdd) calls
				quickAdd << <numBlocks_0, blockSize >> >(d_errors_0, halfCount);
				quickAdd << <1, blockSize >> >(d_errors_0, halfCount);

				cudaMemcpy(&err[0], d_errors_0, sizeof(double), cudaMemcpyDeviceToHost);
				cudaMemcpy(d_errors_0, &zero, sizeof(double), cudaMemcpyHostToDevice);

				// Swap the buffers of GPU 0
				tmp = d_u_old_0;
				d_u_old_0 = d_u_0;
				d_u_0 = tmp;

			}
			else {
				cudaSetDevice(1);

				// CUDA kernel function (one_jacobi_iteration) call
				one_jacobi_iteration << <grid_1, block >> >(1, xLeft, yBottom, n + 2, ((m + 1) / 2) + 2,
					d_u_old_1, d_u_1, deltaX, deltaY, alpha, relax, d_errors_1);

				// CUDA kernel function (quickAdd) calls
				quickAdd << <numBlocks_1, blockSize >> >(d_errors_1, (allocCount - halfCount));
				quickAdd << <1, blockSize >> >(d_errors_1, (allocCount - halfCount));

				cudaMemcpy(&err[1], d_errors_1, sizeof(double), cudaMemcpyDeviceToHost);
				cudaMemcpy(d_errors_1, &zero, sizeof(double), cudaMemcpyHostToDevice);

				// Swap the buffers of GPU 0
				tmp = d_u_old_1;
				d_u_old_1 = d_u_1;
				d_u_1 = tmp;
			}
		}
#pragma omp barrier

		// copy to Host from GPU 1
		cudaSetDevice(1);
		cudaMemcpy(&u_old[halfCount - n - 2], d_u_old_1, (allocCount - halfCount + n + 2) * sizeof(double), cudaMemcpyDeviceToHost);

		// copy to Host from GPU 0
		cudaSetDevice(0);
		cudaMemcpy(u_old, d_u_old_0, halfCount * sizeof(double), cudaMemcpyDeviceToHost);

		// copy to GPU 0 from Host
		// cudaSetDevice(0);
		cudaMemcpy(d_u_old_0, u_old, (halfCount + n + 2) * sizeof(double), cudaMemcpyHostToDevice);

		// copy to GPU 1 from Host
		cudaSetDevice(1);
		cudaMemcpy(d_u_old_1, &u_old[halfCount - n - 2], (allocCount - halfCount + n + 2) * sizeof(double), cudaMemcpyHostToDevice);

		error = sqrt(err[0] + err[1]) / (n * m);

		// Increment iteration
		iterationCount++;
	}

	diff = clock() - start;
	int msec = diff * 1000 / CLOCKS_PER_SEC;

	/*********************************___End timing___*********************************/


	printf("Iterations=%3d\n", iterationCount);
	printf("Time taken %d seconds %d milliseconds\n", msec / 1000, msec % 1000);
	printf("Residual %e\n", error);

	// u_old holds the solution after the most recent buffers swap
	double absoluteError = checkSolution(xLeft, yBottom,
		n + 2, m + 2,
		u_old,
		deltaX, deltaY,
		alpha);

	printf("The error of the iterative solution is %e\n", absoluteError);


	cudaSetDevice(0);
	cudaFree(d_u_0);
	cudaFree(d_u_old_0);
	cudaFree(d_errors_0);


	cudaSetDevice(1);
	cudaFree(d_u_1);
	cudaFree(d_u_old_1);
	cudaFree(d_errors_1);

	return 0;
}
