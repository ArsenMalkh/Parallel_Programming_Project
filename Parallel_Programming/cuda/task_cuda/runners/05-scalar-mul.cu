#include <ScalarMulRunner.cuh>
#include <assert.h>
#include <iostream>

int main() {
	int N = 1 << 20;
	float *vec1 = (float*)malloc(N * sizeof(float));
	float *vec2 = (float*)malloc(N * sizeof(float));

	for(int i = 0; i < N; ++i) {
		vec1[i] = 2.0f;
		vec2[i] = 3.0f;
	}
	int blockSize = 1 << 10; //поставимь 1024 чтобы в конце в Суммирование через shared memory получился один блок.
	float result = ScalarMulSumPlusReduction(N, vec1, vec2, blockSize);
	std::cout<< result<<"\n";
	result = ScalarMulTwoReductions(N, vec1, vec2, blockSize);
	std::cout<< result<<"\n";
	
	free(vec1);
	free(vec2);
	return 0;
}

