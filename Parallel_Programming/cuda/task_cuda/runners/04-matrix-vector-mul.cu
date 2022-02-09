#include <MatrixVectorMul.cuh>
#include <assert.h>
#include <iostream>
#include <fstream>
#include <cmath>

#define ILP 8

void FillArray(float* A, int width, int height, float x) {
        for(int row = 0; row < height; ++row) {
                for(int col = 0; col < width; ++col) {
			A[row * width + col] = x;
			}
                }
        }

int main(int argc, char* argv[]) {
	int N = atoi(argv[1]);
        int Size = atoi(argv[2]);
	
	const int blockSizePoint = sqrt(Size); 
	int width = sqrt(N) / 2;
        int height = sqrt(N) * 2;
        int matrix_area = width * height;
	int vector_area = width * 1;
	int new_vector_area = height * 1;

        float *MA = (float*)malloc(matrix_area * sizeof(float));
        float *MB = (float*)malloc(vector_area * sizeof(float));
        float *MC = (float*)malloc(new_vector_area * sizeof(float));

        float *d_MA = NULL;
       	float *d_MB = NULL;
       	float *d_MC = NULL;
        cudaMalloc(&d_MA, matrix_area * sizeof(float));
        cudaMalloc(&d_MB, vector_area * sizeof(float));
        cudaMalloc(&d_MC, new_vector_area * sizeof(float));

        FillArray(MA, width, height, 2.0f); //for Matrix
        FillArray(MB, 1,    width, 1.0f); // for Vector
        cudaMemcpy(d_MA, MA, matrix_area * sizeof(float), cudaMemcpyHostToDevice);
        cudaMemcpy(d_MB, MB, vector_area * sizeof(float), cudaMemcpyHostToDevice);
        dim3 blockSize(blockSizePoint,blockSizePoint);
        dim3 numBlocks((height + blockSize.x - 1) / (blockSize.x), (width + blockSize.y - 1) / (blockSize.y));
        
	cudaEvent_t start;
        cudaEvent_t stop;

        cudaEventCreate(&start);
        cudaEventCreate(&stop);

        cudaEventRecord(start);
	MatrixVectorMul<<<numBlocks, blockSize>>>(height, width, d_MA, d_MB, d_MC);
	cudaEventRecord(stop);

        cudaDeviceSynchronize();
        cudaEventSynchronize(stop);

        float millis = 0;
        cudaEventElapsedTime(&millis, start, stop);
        std::ofstream myfile;
        myfile.open ("out.txt");
        myfile << Size<<" "<<N<<" "<<millis<<"\n";
        myfile.close();


        cudaMemcpy(MC, d_MC, new_vector_area * sizeof(float), cudaMemcpyDeviceToHost);
	for (int row = 0; row <	height; ++row) {
		assert(MC[row] == 2.0f * width);
	}
        cudaFree(d_MA);
        cudaFree(d_MB);
        cudaFree(d_MC);
        free(MA);
        free(MB);
       	free(MC);
}


