#include <stdio.h>
int main(int argc, char* argv[])
{
int resultado = 0;
printf("Los sumandos son: %d \t %d \n",atoi(argv[1]),atoi(argv[2]));
resultado = atoi(argv[1]) + atoi(argv[2]);

printf("El resultado de la suma es: %d \n",resultado);
}

