Cuando se llama al programa encuadroSift desde php, los fprintf(stderr,"") se muestran en el error.log de apache

La funcion php toma como resultado l printf del encuadroSift.
A la hora de generar descriptores retorna 1.
A la hora de comparar en caso de encontrar un resultado retorna el id, caso contrario retorna 0 
 
Ejemplo de compilar a mano:
gcc -o encuadro encuadroSift.c `mysql_config --cflags --libs`
./encuadroSift /var/www/obras/torres.pgm 161 localhost root root proyecto
/home/server/proyecto/prueba_binario# ./encuadroSift /var/www/obras/torres.pgm 162 localhost root root proyecto

Para compilar se utiliza el Make

