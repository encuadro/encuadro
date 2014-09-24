#! /bin/bash


dir="/home/encuadro/encuadro/server/"
#directorio a respaldar
origen="data/zonas"
#respaldo="/home/encuadro/respaldo"
#carpeta donde se alojara el respaldo
respaldo="/tmp/respaldo"
#cliente remoto 
remoto="git@192.168.10.198:."
fecha=`date +%Y-%m-%d-%R`
#archivo temporal con el backup.sql
temp="/tmp/"$fecha"-respaldo.sql"
#archivo respaldo
destino=$respaldo"/"$fecha"-respaldo.tar.gz"

echo "posicionando en "$dir
cd $dir

#validar que exista la carpeta origen
#en caso de que no exista se interrumpe la ejecucion
if [ ! -d $origen ];
then
echo "Error: No existe el directorio que se desea respaldar: "$origen
exit 1;
fi

#haciendo el dump de sql
mysqldump --user=root --password=root proyecto > $temp
ret=`echo $?`
if [ $ret == 0 ];
then
echo "Se creo el respaldo de la bd"
else
echo "Error no se pudo crear el respaldo de la bd"
exit 1
fi

#si no existe la carpeta respaldo la crea
if [ ! -d $respaldo ];
then
echo "Creando directorio respaldo"
mkdir $respaldo
chmod 777 $respaldo 
fi

tar -czvf $destino $origen $temp --exclude ".*"
chmod 777 $destino

res=`echo $?`
if [ $res == 0 ];
then
echo "Se realizo el respaldo exitosamente "
else 
echo "No se pudo realizar el respaldo " 
exit 1
fi

echo "Enviando archivo a cliente remoto"
rsync -avz $destino $remoto 

rm $temp

exit 0
