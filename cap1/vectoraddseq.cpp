//
// Created by eric on 22/12/2020.
//
#include "stdio.h"
#include <iostream>
#include <ctime>
#include <sys/time.h>

#define N 10000

void hostAdd(int* a, int* b, int* c){
    for (int idx = 0; idx < N; idx++){
        c[idx] = a[idx] + b[idx];
    }
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
    struct timeval inicio, fim;

    int size = N * sizeof(int);

    a = (int *)malloc(size);
    fillArray(a);

    b = (int *)malloc(size);
    fillArray(b);

    c = (int *)malloc(size);

    gettimeofday(&inicio, NULL);
    hostAdd(a, b, c);
    gettimeofday(&fim, NULL);
    printResults(a, b, c);

    int diferenca = fim.tv_usec - inicio.tv_usec;
    printf("Tempo de execucao = %d\n", diferenca);

    free(a); free(b); free(c);

    return 0;
}

