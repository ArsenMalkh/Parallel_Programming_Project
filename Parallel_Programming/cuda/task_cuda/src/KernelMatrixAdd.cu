#include <KernelMatrixAdd.cuh>

#define ILP 8

__global__ void KernelMatrixAdd(int height, int width, float* A, float* B, float* result) {
	int tid = threadIdx.x + ILP * blockDim.x * blockIdx.x;
        for (int i = 0; i < ILP; ++i) {
                int current_tid = tid + i * blockDim.x;
		result[current_tid] = A[current_tid] + B[current_tid];
        }

}

