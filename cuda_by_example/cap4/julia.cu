//
// Created by eric on 18/01/2021.
//

#include "../exemplos/common/book.h"
#include "../exemplos/common/cpu_bitmap.h"

#define DIM 1000

struct cuComplex{
    float r;
    float i;

    cuComplex(float a, float b) : r(a), i(b) {};

    __device__ float magnitude2(){
        return r*r + i*i;
    }

    __device__ cuComplex operator*(const cuComplex& a){
        return cuComplex(r*a.r - i*a.i, i*a.r + r*a.i);
    }

    __device__ cuComplex operator+(const cuComplex& a){
        return cuComplex(r + a.r, i + a.i);
    }
};

__device__ int julia(int x, int y, cuComplex& semente){
    const float escala = 1.5;

    float jx = escala * (float)(DIM/2 - x)/(DIM/2);
    float jx = escala * (float)(DIM/2 - y)(DIM/2);

    cuComplex a(jx, jy);

    for (int i=0; i < 200; ++i){
        a = a*a + semente;

        if(a.magnitude2() > 1000)
            return 0;
    }

    return 1;
}

__global__ void kernel(unsigned char* ptr, cuComplex& semente){
    int x = blockIdx.x;
    int y = blockIdx.y;
    int offset = x + y*gridDim.x;

    int julia_valor = julia(x, y, semente);

    ptr[offset*4 + 0] = 255*julia_valor;
    ptr[offset*4 + 1] = 0;
    ptr[offset*4 + 2] = 0;
    ptr[offset*4 + 3] = 255;

}

int main(){
    CPUBitmap bitmap(DIM, DIM);
    unsigned char* dev_bitmap;

    cudaMalloc((void**)&dev_bitmap, bitmap.image_size());
    dim3 grid(DIM, DIM);

    kernel<<<grid, 1>>>(dev_bitmap);

    cudaMemcpy(bitmap.get_ptr(), dev_bitmap, bitmap.image_size(),
               cudaMemcpyDeviceToHost);

    bitmap.display_and_exit();

    cudaFree(dev_bitmap);
    return 0;
}


