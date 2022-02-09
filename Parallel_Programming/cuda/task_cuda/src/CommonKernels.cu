#include "CommonKernels.cuh"

#define ILP 8

__global__ void KernelMul(int numElements, float* vector1, float* vector2, float* result) {
        int tid = threadIdx.x + ILP * blockDim.x * blockIdx.x;
        for (int i = 0; i < ILP; ++i) {
                int current_tid = tid + i * blockDim.x;
                result[current_tid] = vector1[current_tid] * vector2[current_tid];
        }
}

