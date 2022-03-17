#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cstdlib>
#include <iostream>
#include <vector>
#include <algorithm>
#include <cassert>
#include <numeric>
//for __syncthreads()
#ifndef __CUDACC__ 
#define __CUDACC__
#endif
#include <device_functions.h>

using namespace std;

using std::accumulate;
using std::generate;
using std::cout;
using std::vector;

#define SHMEM_SIZE 256

__global__ void sumReduction(int *v, int *v_r) {
	// Allocate shared memory
	__shared__ int partial_sum[SHMEM_SIZE];

	// Calculate thread ID
	int tid = blockIdx.x * blockDim.x + threadIdx.x;

	// Load elements into shared memory
	partial_sum[threadIdx.x] = v[tid];
	__syncthreads();

	// Start at 1/2 block stride and divide by two each iteration
	for (int s = blockDim.x / 2; s > 0; s >>= 1) {
		// Each thread does work unless it is further than the stride
		if (threadIdx.x < s) {
			partial_sum[threadIdx.x] += partial_sum[threadIdx.x + s];
		}
		__syncthreads();
	}

	// Let the thread 0 for this block write it's result to main memory
	// Result is inexed by this block
	if (threadIdx.x == 0) {
		v_r[blockIdx.x] = partial_sum[0];
	}
}

int main() {
	// Vector size
	//int N = 1 << 16;
	int N = 400;

	size_t bytes = N * sizeof(int);

	// Host data
	vector<int> h_v(N);
	vector<int> h_v_r(N);

	// Initialize the input data
	//generate(begin(h_v), end(h_v), []() { return rand() % 10; });
	generate(begin(h_v), end(h_v), []() { return 1; });

	// Allocate device memory
	int *d_v, *d_v_r;
	cudaMalloc(&d_v, bytes);
	cudaMalloc(&d_v_r, bytes);

	// Copy to device
	cudaMemcpy(d_v, h_v.data(), bytes, cudaMemcpyHostToDevice);

	// TB Size
	const int TB_SIZE = 256;

	// Grid Size (No padding)
	int GRID_SIZE = (N + TB_SIZE - 1) / TB_SIZE;

	// Call kernels
	sumReduction << <GRID_SIZE, TB_SIZE >> >(d_v, d_v_r);

	sumReduction << <1, TB_SIZE >> >(d_v_r, d_v_r);

	// Copy to host;
	cudaMemcpy(h_v_r.data(), d_v_r, bytes, cudaMemcpyDeviceToHost);

	// Print the result
	assert(h_v_r[0] == std::accumulate(begin(h_v), end(h_v), 0));

	cout << h_v_r[0] << endl;
	cout << "COMPLETED SUCCESSFULLY\n";

	return 0;
}