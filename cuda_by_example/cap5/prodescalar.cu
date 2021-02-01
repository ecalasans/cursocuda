//
// Created by eric on 29/01/2021.
//

#include <iostream>
#include "stdio.h"
#include <ctime>

#define imin(a, b) (a<b?a:b)

const int N = 33*1024;
const int THREADS_POR_BLOCO = 256;

__global__ void dot(float* a, float* b, float* c){
    __shared__ float cache[THREADS_POR_BLOCO];

    int tid = threadIdx.x + blockIdx.x*blockDim.x;
    int indice_cache = threadIdx.x;

    float temp = 0;

    while (tid < N){
        temp += a[tid] * b[tid];
        tid += blockDim.x*gridDim.x;
    }

    cache[indice_cache] += temp;

    //REDUÇÃO
    int i = blockIdx.x/2;

    while (i != 0){
        if (indice_cache < i){
            cache[indice_cache] += cache[indice_cache + i];
        }
        __syncthreads();
        i /= 2;
    }

    if (indice_cache == 0){
        c[blockIdx.x] = cache[0];
    }
}

const int BLOCOS_POR_GRADE = imin(32, (N + THREADS_POR_BLOCO -1)/THREADS_POR_BLOCO);

int main(){
    float *a, *b, c, *parcial_c;
    float *dev_a, *dev_b, *dev_parcial_c;

    //ALOCAÇÃO
    a = new float[N];
    b = new float[N];
    parcial_c = new float[BLOCOS_POR_GRADE];

    cudaMalloc((void**)&dev_a, N* sizeof(float));
    cudaMalloc((void**)&dev_b, N* sizeof(float ));
    cudaMalloc((void**)dev_parcial_c, BLOCOS_POR_GRADE* sizeof(float));

    //PREENCHE OS VETORES
    for (int i = 0; i < N; ++i){
        a[i] = i;
        b[i] = i*2;
    }

    //COPIA VETORES PARA A GPU
    cudaMemcpy(dev_a, a, N* sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N* sizeof(float), cudaMemcpyHostToDevice);
    return 0;
}
