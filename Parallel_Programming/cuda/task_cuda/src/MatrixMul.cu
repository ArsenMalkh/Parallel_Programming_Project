#include <MatrixMul.cuh>

#define Size 32

__global__ void MatrixMul(int heightA, int widthA, int widthB, float *matrixA, float *matrixB, float *matrixResult)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int idxA, idxB, Cval = 0;

    __shared__ float subA[Size][Size];
    __shared__ float subB[Size][Size];

    for (int x = 0; x < gridDim.x; x++)
    {
        idxA = row * widthA + x * blockDim.x + threadIdx.x;
        subA[threadIdx.y][threadIdx.x] = 0.0;
        if(idxA < heightA * widthA)
        {
            subA[threadIdx.y][threadIdx.x] = matrixA[idxA];
        }
        idxB = (x * blockDim.x + threadIdx.y) * widthB + col;
        subB[threadIdx.y][threadIdx.x] = 0.0;
        if(idxA < widthA * heightA && idxB < heightA * widthB)
        {
            subB[threadIdx.y][threadIdx.x] = matrixB[idxB];
        }
        __syncthreads();

        for (int k = 0; k < blockDim.y; k++)
        {
            Cval += subA[threadIdx.y][k] * subB[k][threadIdx.x];
        }
        __syncthreads();
    }
    if(row < heightA && col < widthB)
    {
        matrixResult[row * widthB + col] = Cval;
    }
}

