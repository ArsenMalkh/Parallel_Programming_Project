#include <MatrixMul.cuh>
#include <assert.h>

void FillArray(float* A, int width, int height, float x) {
        for(int row = 0; row < height; ++row) {
                for(int col = 0; col < width; ++col) {
                        A[row * width + col] = x;
                        }
                }
        }

void FillArray2(float* A, int width, int height, float x) {
        for(int row = 0; row < height; ++row) {
                for(int col = 0; col < width; ++col) {
                        if(row == col) {
                                A[row * width + col] = 2.0f;
                        }
                }
        }
}


int main() {
        int widthA = 1 << 10;
        int heightA = 1 << 10;
	int widthB = 1 << 10;
	int heightB = widthA; 
        int matrix_areaA = widthA * heightA;
	int matrix_areaB = widthB * heightB;

        float *MA = (float*)malloc(matrix_areaA * sizeof(float));
        float *MB = (float*)malloc(matrix_areaB * sizeof(float));
        float *MC = (float*)malloc(heightA * widthB * sizeof(float));

        float *d_MA = NULL;
        float *d_MB = NULL;
        float *d_MC = NULL;
        cudaMalloc(&d_MA, matrix_areaA * sizeof(float));
        cudaMalloc(&d_MB, matrix_areaB * sizeof(float));
        cudaMalloc(&d_MC, heightA * widthB * sizeof(float));

        FillArray(MA, heightA, widthA, 2.25f);
        FillArray2(MB, heightB, widthB, 1.0f);
        cudaMemcpy(d_MA, MA, matrix_areaA * sizeof(float), cudaMemcpyHostToDevice);
        cudaMemcpy(d_MB, MB, matrix_areaB * sizeof(float), cudaMemcpyHostToDevice);
        dim3 blockSize(32,32);
        dim3 numBlocks((heightA + blockSize.x - 1) / (blockSize.x), (widthB + blockSize.y - 1) / (blockSize.y));

        MatrixMul<<<numBlocks, blockSize>>>(heightA, widthA,  widthB, d_MA, d_MB, d_MC);

        cudaDeviceSynchronize();
        cudaMemcpy(MC, d_MC, heightA * widthB * sizeof(float), cudaMemcpyDeviceToHost);

        for(int i = 0; i < heightA; ++i) {
                for(int j = 0; j < widthB; ++j) {
                        assert(MC[i*widthB + j] = 4.5f);
                }
        }

        cudaFree(d_MA);
        cudaFree(d_MB);
        cudaFree(d_MC);
        free(MA);
        free(MB);
        free(MC);
}
               

