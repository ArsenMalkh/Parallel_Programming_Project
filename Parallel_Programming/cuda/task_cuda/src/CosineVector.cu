#include <CosineVector.cuh>
#include <ScalarMulRunner.cuh>
#include <cmath>
#include <iostream>


float CosineVector(int numElements, float* vector1, float* vector2) {
	int blockSize = 1024;
	float firstAbs = sqrt(ScalarMulTwoReductions(numElements, vector1, vector1, blockSize));
	float secondAbs = sqrt(ScalarMulTwoReductions(numElements, vector2, vector2, blockSize));
	return ScalarMulTwoReductions(numElements, vector1, vector2, 1024) / (firstAbs * secondAbs);
}

