#include <assert.h>
#include "KernelAdd.cuh"
#include <iostream>
#include <fstream>

#define ILP 8

int main(int argc, char* argv[]) {

	int N = atoi(argv[1]);
	int blockSize = atoi(argv[2]);
	float *x = (float*)malloc(N * sizeof(float));
	float *y = (float*)malloc(N * sizeof(float));
    	float *result = (float*)malloc(N * sizeof(float));

	float *d_x, *d_y, *d_result;

	cudaMalloc(&d_x, N * sizeof(float));
	cudaMalloc(&d_y, N * sizeof(float));
    	cudaMalloc(&d_result, N * sizeof(float));

	for (int i = 0; i < N; ++i) {
		x[i] = 1.0f;
		y[i] = 2.0f;
	}


	cudaMemcpy(d_x, x, N * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, y, N * sizeof(float), cudaMemcpyHostToDevice);

	int numBlocks = (N + blockSize - 1) / blockSize;
	
	cudaEvent_t start;
	cudaEvent_t stop;

	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	cudaEventRecord(start);
	KernelAdd<<<numBlocks / ILP, blockSize>>>(N, d_x, d_y, d_result);
	cudaEventRecord(stop);

	cudaDeviceSynchronize();
  	cudaEventSynchronize(stop);

	float millis = 0;
	cudaEventElapsedTime(&millis, start, stop);
	std::ofstream myfile;
  	myfile.open ("out.txt");
	myfile << blockSize<<" "<<N<<" "<<millis<<"\n";
  	myfile.close();
	
	cudaMemcpy(result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
	
	for(int i = 0; i < N; ++i) {
		 assert(result[i] == 3.0f);
	}
	cudaFree(d_x);
	cudaFree(d_y);
	cudaFree(d_result);
	free(x);
	free(y);
	free(result);
}
