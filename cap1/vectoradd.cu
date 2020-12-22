//
// Created by eric on 22/12/2020.
//
#include "stdio.h"
#include <iostream>
#include <ctime>
#include <sys/time.h>

#define N 512

__global__ void deviceAdd(int* a, int* b, int* c){
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

void fillArray(int* data){
    for (int idx = 0; idx < N; idx++){
        data[idx] = idx;
    }
}

void printResults(int* a, int* b, int* c){
    for (int idx = 0; idx < N; idx++){
        printf("A[%d] + B[%d] = %d\n", a[idx], b[idx], c[idx]);
    }
}

int main(){
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    struct timeval inicio, fim;

    int size = N * sizeof(int);
    std::size_t tam = N * sizeof(int);

    a = (int *)malloc(size);
    fillArray(a);

    b = (int *)malloc(size);
    fillArray(b);

    c = (int *)malloc(size);

    cudaMalloc((void **)&d_a, tam);
    cudaMalloc((void **)&d_b, tam);
    cudaMalloc((void **)&d_c, tam);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    gettimeofday(&inicio, NULL);
    deviceAdd<<<N,1>>>(d_a, d_b, d_c);   //<<<blocos, threads>>>
    gettimeofday(&fim, NULL);

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    printResults(a, b, c);

    int diferenca = fim.tv_usec - inicio.tv_usec;
    printf("Tempo de execucao = %d\n", diferenca);

    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);

    return 0;
}
