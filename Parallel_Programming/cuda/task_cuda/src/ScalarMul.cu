#include <ScalarMul.cuh>

/*
 * Calculates scalar multiplication for block
 */
__global__ void ScalarMulBlock(int numElements, float* vector1, float* vector2, float *result) {
	int index = blockDim.x * blockIdx.x + threadIdx.x;
	int stride = gridDim.x * blockDim.x;

	for(int i = index; i < numElements; i += stride) {
		atomicAdd(&result[blockIdx.x], vector1[i] * vector2[i]);
	}
}

