//
// Created by eric on 31/12/2020.
//

#include <iostream>
#include <cstdlib>

__global__ void addVector(int a, int b, int* c){
    *c = a + b;
}

int main(){
    int c = 0; // no host
    int count = 0;
    int* dev_c;  // no device

    cudaMalloc((void**)&dev_c, sizeof(int)); // aloca memória no device

    addVector<<<1,1>>>(2, 7, dev_c);  // <<<bloco, thread>>>(parâmetros da função)

    cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);  // copia do device pro host

    printf("Resultado:  %d\n", c);

    cudaFree(dev_c); // libera memória do device

    cudaGetDeviceCount(&count);

    printf("Total de dispositivos graficos = %d\n", count);



    return 0;
}