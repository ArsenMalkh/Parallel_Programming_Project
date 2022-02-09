#include <ScalarMulRunner.cuh> 
#include <CommonKernels.cuh>
#include <ScalarMul.cuh>
#include <iostream>
 
#define ILP 8 

//Ivchenko code from Seminar
__global__ void Reduce(float* in_data, float* out_data) { extern __shared__
	float shared_data[];
 
    unsigned int tid = threadIdx.x; unsigned int index = blockIdx.x *
	    blockDim.x + threadIdx.x;
 
    shared_data[tid] = in_data[index]; __syncthreads();
 
    for (unsigned int s = 1; s < blockDim.x; s *= 2) { if (tid % (2 * s) == 0)
	    { shared_data[tid] += shared_data[tid + s]; } __syncthreads(); }
 
    if (tid == 0) { out_data[blockIdx.x] = shared_data[0]; } 
}
 
 
float ScalarMulTwoReductions(int numElements, float* vector1, float* vector2,
		int blockSize) {
        float *d_vec1, *d_vec2, *d_result;
        cudaMalloc(&d_vec1, numElements * sizeof(float));
        cudaMalloc(&d_vec2, numElements * sizeof(float));
        cudaMalloc(&d_result, numElements * sizeof(float));
 
        cudaMemcpy(d_vec1, vector1, numElements * sizeof(float), cudaMemcpyHostToDevice);
        cudaMemcpy(d_vec2, vector2, numElements * sizeof(float), cudaMemcpyHostToDevice);
 
        int numblocks = (numElements + blockSize - 1) / blockSize;
	KernelMul<<<numblocks / ILP, blockSize>>>(numElements, d_vec1, d_vec2, d_result);
        cudaDeviceSynchronize();
        float* d_res1;
        cudaMalloc(&d_res1, numblocks * sizeof(float));
        Reduce<<<numblocks, blockSize, blockSize * sizeof(float)>>>(d_result, d_res1);
        cudaDeviceSynchronize();
 
        float* d_out;
        cudaMalloc(&d_out, sizeof(float));
 
        int reduceblockSize = (numblocks + blockSize - 1) / blockSize;
       	Reduce<<<reduceblockSize, blockSize, blockSize * sizeof(float)>>>(d_res1, d_out);
        cudaDeviceSynchronize();
 
        float res;
        cudaMemcpy(&res, d_out, sizeof(float), cudaMemcpyDeviceToHost);
 
        cudaFree(d_vec1);
        cudaFree(d_vec2);
        cudaFree(d_result);
        cudaFree(d_out);
        cudaFree(d_res1);
        return res;
 
 
}

float ScalarMulSumPlusReduction(int numElements, float* vector1, float* vector2, int blockSize) {
        float *d_vec1, *d_vec2, *d_result;
 
	int numblocks = (numElements + blockSize - 1) / blockSize;

        cudaMalloc(&d_vec1, numElements * sizeof(float));
        cudaMalloc(&d_vec2, numElements * sizeof(float));
        cudaMalloc(&d_result, numblocks * sizeof(float));
 
        cudaMemcpy(d_vec1, vector1, numElements * sizeof(float), cudaMemcpyHostToDevice);
        cudaMemcpy(d_vec2, vector2, numElements * sizeof(float), cudaMemcpyHostToDevice);
 
        ScalarMulBlock<<<numblocks, blockSize>>>(numElements, d_vec1, d_vec2, d_result);
        cudaDeviceSynchronize();
 
        float* d_out;
        cudaMalloc(&d_out, sizeof(float));
        int reduceblockSize = (numblocks + blockSize - 1) / blockSize;
        Reduce<<<reduceblockSize, numblocks, numblocks * sizeof(float)>>>(d_result, d_out);
        cudaDeviceSynchronize();
        float res;
        cudaMemcpy(&res, d_out, sizeof(float), cudaMemcpyDeviceToHost);
 
        cudaFree(d_vec1);
        cudaFree(d_vec2);
        cudaFree(d_result);
        cudaFree(d_out);
        return res;
}
