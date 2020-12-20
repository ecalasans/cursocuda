//
// Created by eric on 20/12/2020.
//
#include "stdio.h"
#include "cuda.h"

__global__ void printFromGPU(){
    printf("Olá!  Sou a thread [%d, %d] falando da GPU!\n",
           threadIdx.x, blockIdx.x);
}


int main(){
    printf("Olá!  Sou a CPU!\n");
    printFromGPU<<<1,1>>>();
    cudaDeviceSynchronize();

    return 0;
}
