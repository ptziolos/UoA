#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <time.h>
//for __syncthreads()
#ifndef __CUDACC__ 
#define __CUDACC__
#endif
#include <device_functions.h>


using namespace std;

static const int blockSize = 256;

void print_1D_array(int n, int N, double *a) {
	cout << "\nThe 1D array is" << endl;
	for (int i = 0; i < N; i++) {
		if (((i + 1) % n) == 1) {
			cout << endl;
		}
		cout << a[i] << "  ";
	}
	cout << endl;
}


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

	for (int l = 0; l < blockSize; l++) {
		partial_sum[l] = 0;
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
void one_jacobi_iteration(double xStart, double yStart, int maxXCount, int maxYCount,
	double *src, double *dst, double deltaX, double deltaY, double alpha, double omega, double *errors)
{
#define SRC(XX,YY) src[(YY)*maxXCount+(XX)]
#define DST(XX,YY) dst[(YY)*maxXCount+(XX)]
#define ERR(XX,YY) errors[(YY)*(maxXCount-2)+(XX)]

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

	for (int y = j_index; y < maxYCount - 1; y = y + j_stride) {
		for (int x = i_index; x < maxXCount - 1; x = x + i_stride) {
			fY = yStart + (y - 1)*deltaY;
			fX = xStart + (x - 1)*deltaX;
			f = -alpha*(1.0 - fX*fX)*(1.0 - fY*fY) - 2.0*(1.0 - fX*fX) - 2.0*(1.0 - fY*fY);
			updateVal = ((SRC(x - 1, y) + SRC(x + 1, y))*cx + (SRC(x, y - 1) + SRC(x, y + 1))*cy + SRC(x, y)*cc - f) / cc;
			DST(x, y) = SRC(x, y) - omega*updateVal;
			ERR(x - 1, y - 1) = updateVal*updateVal;
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
	double error;
	double *u, *u_old, *tmp;
	double *d_u, *d_u_old;
	double *d_errors;
	int allocCount;
	int iterationCount, maxIterationCount;
	double t1, t2;
	double xLeft, yBottom, xRight, yUp;
	double deltaX, deltaY;
	int numBlocks;

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

	allocCount = (n + 2)*(m + 2);
	// Those two calls also zero the boundary elements
	u = (double*)calloc(allocCount, sizeof(double)); //reverse order
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

	// Allocate Memory to GPU
	cudaMalloc(&d_u, allocCount * sizeof(double));
	cudaMalloc(&d_u_old, allocCount * sizeof(double));
	cudaMalloc(&d_errors, n * m * sizeof(double));

	numBlocks = (n * m + blockSize - 1) / blockSize;

	//numBlocks = 1;

	dim3 block((int)sqrt(blockSize), (int)sqrt(blockSize), 1);
	dim3 grid((int)sqrt(numBlocks), (int)sqrt(numBlocks), 1);

	// copy to GPU
	cudaMemcpy(d_u, u, allocCount * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(d_u_old, u_old, allocCount * sizeof(double), cudaMemcpyHostToDevice);


	/********************************* ___Start timing___*********************************/
	clock_t start = clock(), diff;

	/* Iterate as long as it takes to meet the convergence criterion */
	while (iterationCount < maxIterationCount && error > maxAcceptableError)
	{
		// CUDA kernel function (one_jacobi_iteration) call
		one_jacobi_iteration << <grid, block >> >(xLeft, yBottom,
			n + 2, m + 2, d_u_old, d_u, deltaX, deltaY, alpha, relax, d_errors);

		// Swap the buffers
		tmp = d_u_old;
		d_u_old = d_u;
		d_u = tmp;

		// CUDA kernel function (quickAdd) call
		quickAdd << <numBlocks / 2, blockSize >> >(d_errors, n*m);
		quickAdd << <1, blockSize >> >(d_errors, n*m);

		cudaMemcpy(&error, d_errors, sizeof(double), cudaMemcpyDeviceToHost);

		error = sqrt(error) / (n * m);

		// Increment iteration 
		iterationCount++;
	}

	diff = clock() - start;
	int msec = diff * 1000 / CLOCKS_PER_SEC;

	/*********************************___End timing___*********************************/


	// copy to Host
	cudaMemcpy(u, d_u, allocCount * sizeof(double), cudaMemcpyDeviceToHost);
	cudaMemcpy(u_old, d_u_old, allocCount * sizeof(double), cudaMemcpyDeviceToHost);

	printf("Iterations=%3d\n", iterationCount);
	printf("Time taken %d seconds %d milliseconds\n", msec / 1000, msec % 1000);
	printf("Residual %e\n", error);
	//print_1D_array(n+2, (n+2)*(m+2), u_old);

	// u_old holds the solution after the most recent buffers swap
	double absoluteError = checkSolution(xLeft, yBottom,
		n + 2, m + 2,
		u_old,
		deltaX, deltaY,
		alpha);

	printf("The error of the iterative solution is %e\n", absoluteError);

	cudaFree(d_u);
	cudaFree(d_u_old);
	cudaFree(d_errors);

	return 0;
}
