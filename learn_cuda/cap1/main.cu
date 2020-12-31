#include "stdio.h"
#include <iostream>

__global__ void printFromGPU(){
    printf("Olá!  Sou a thread [%d, %d] falando da GPU!\n",
           threadIdx.x, blockIdx.x);
    printf("\n");
}


int main(){
    system("clear");
    std::cout << "Olá!  Sou a CPU!!" << std::endl;
    printFromGPU<<<1,1>>>();  // 1 thread 1 bloco

    printFromGPU<<<2,1>>>();  // 2 threads em 2 blocos

    printFromGPU<<<1,2>>>();  // 2 threads no mesmo bloco
    cudaDeviceSynchronize();

    return 0;
}

