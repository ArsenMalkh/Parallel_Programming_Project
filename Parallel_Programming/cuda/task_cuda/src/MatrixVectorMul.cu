#include <MatrixVectorMul.cuh>

#define ILP 8

__global__ void MatrixVectorMul(int height, int width, float* matrix, float* vector, float* result) {
	int row = blockIdx.x * blockDim.x + threadIdx.x;
	int col = blockIdx.y * blockDim.y + threadIdx.y;
	int stride_row = blockDim.x * gridDim.x;
	int stride_col = blockDim.y * gridDim.y;

	for(int i = row; i < height; i += stride_row) {
		for(int j = col; j< width; j += stride_col) {
			atomicAdd(&result[i], matrix[row * width + j] * vector[j]);
		}
	}

	/*for(int i = 0; i < ILP; ++i) {
		int current_x = row + i * blockDim.x;
		for(int j = 0;j < ILP; ++j) {
			int current_y = col + j * blockDim.y;
			atomicAdd(&result[current_x], matrix[current_x * width + current_y] * vector[current_y]);
		}
	}*/

}

