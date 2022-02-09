#include "KernelMul.cuh"

#define ILP 8

__global__ void KernelMul(int numElements, float* x, float* y, float* result) {
        int tid = threadIdx.x + ILP * blockDim.x * blockIdx.x;
        for (int i = 0; i < ILP; ++i) {
                int current_tid = tid + i * blockDim.x;
                result[current_tid] = x[current_tid] * y[current_tid];
        }
}
