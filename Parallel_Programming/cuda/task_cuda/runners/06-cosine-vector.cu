#include <CosineVector.cuh>
#include <assert.h>

int main() {
	
	int N = 1 << 20;	
	float* vector1 = (float*)malloc(N * sizeof(float));
	float* vector2 = (float*)malloc(N * sizeof(float));
	
	vector1[0] = 6.0f;
	vector1[1] = 8.0f;

	vector2[1] = 4.0f;
       	vector2[2] = 3.0f;

	float res = CosineVector(N, vector1, vector2);

	assert(res == 0.64f);
	free(vector1);
	free(vector2);
	return 0;
}

