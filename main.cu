#include "stdio.h"
#include <iostream>

__global__ void printFromGPU(){
    printf("Olá!  Sou a thread [%d, %d] falando da GPU!\n",
           threadIdx.x, blockIdx.x);
}


int main(){

    std::cout << "Olá!  Sou a CPU!!" << std::endl;
    printFromGPU<<<1,1>>>();
    cudaDeviceSynchronize();

    return 0;
}

