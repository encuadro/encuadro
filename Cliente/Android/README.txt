Pasos para hacer correr la aplicacion android desde eclipse:

Actualizar sdk
En caso que sea necesario actualizar sdk desde el sdk manager
Proyecto->propiedades->lint 
La función llamada missing translation cambiarla a warning. Para solucionar los errores de “translation not found”.
La funcion duplicateIds cambiarla a warning. Para solucionar los errores de ids duplicados.
Proyecto->Propiedades->Android
En Proyect build Target, seleccionar “Android 4.4W”
En Library agregar la Aplicacion CaptureActivity 
Procurar que el checkbox “IsLibrary” no este seleccionado
