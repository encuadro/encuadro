FUNCION DE ENCUADROSIFT

El encuadroSift tiene dos funciones la de generar descriptores y la de compararlos
A la hora de generar descriptores retorna 1.
A la hora de comparar en caso de encontrar un resultado retorna el id, caso contrario retorna 0 

RETORNO

Este resultado se da a conocer mediante un printf.
La funcion php toma como resultado ese printf. Por eso es muy importante que el programa tenga solo una salida prinft y que esta sea de las funciones.

LOG

Cuando se llama al programa encuadroSift desde php, los fprintf(stderr,"") se muestran en el error.log de apache

 
Ejemplo de compilar a mano:
gcc -o encuadro encuadroSift.c `mysql_config --cflags --libs`
./encuadroSift /var/www/obras/torres.pgm 161 localhost root root proyecto
/home/server/proyecto/prueba_binario# ./encuadroSift /var/www/obras/torres.pgm 162 localhost root root proyecto

Para compilar se utiliza el Make


Actualizado 15/09/2014
