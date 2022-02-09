#include <KernelMatrixAdd.cuh>
#include <assert.h>
#include <fstream>
#include <cmath>

#define ILP 8

void FillMatrix(float* A, int width, int height, float x) {
	for(int row = 0; row < height; ++row) {
		for(int col = 0; col < width; ++col) {
			A[row * width + col] = x;	
		}
	}
}

int main(int argc, char* argv[]) {
	
	int N = atoi(argv[1]);
	int blockSize = atoi(argv[2]);
	
	int width = sqrt(N) / 2;
	int height = sqrt(N) * 2;
	int area = width * height;
	float *MA = (float*)malloc(area * sizeof(float));
	float *MB = (float*)malloc(area * sizeof(float));
	float *MC = (float*)malloc(area * sizeof(float));

	float *d_MA, *d_MB, *d_MC;
 	
	cudaMalloc(&d_MA, area * sizeof(float));
        cudaMalloc(&d_MB, area * sizeof(float));
        cudaMalloc(&d_MC, area * sizeof(float));

	FillMatrix(MA, width, height, 3.0f);
	FillMatrix(MB, width, height, 4.0f);

	cudaMemcpy(d_MA, MA, area * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_MB, MB, area * sizeof(float), cudaMemcpyHostToDevice);

        int numBlocks = (area + blockSize - 1) / blockSize;
	
	cudaEvent_t start;
        cudaEvent_t stop;

        cudaEventCreate(&start);
        cudaEventCreate(&stop);

        cudaEventRecord(start);
        KernelMatrixAdd<<<numBlocks / ILP, blockSize>>>(height, width, d_MA, d_MB, d_MC);
	cudaEventRecord(stop);

        cudaDeviceSynchronize();
        cudaEventSynchronize(stop);

        float millis = 0;
        cudaEventElapsedTime(&millis, start, stop);
        std::ofstream myfile;
        myfile.open ("out.txt");
        myfile << blockSize<<" "<<N<<" "<<millis<<"\n";
        myfile.close();


        cudaMemcpy(MC, d_MC, area * sizeof(float), cudaMemcpyDeviceToHost);

        for(int row = 0; row < height; ++row) {
		for(int col = 0; col < width; ++col) {
			assert(MC[row * width + col] == 7.0f);
		}
        }
        cudaFree(d_MA);
        cudaFree(d_MB);
        cudaFree(d_MC);
        free(MA);
        free(MB);
        free(MC);
}

