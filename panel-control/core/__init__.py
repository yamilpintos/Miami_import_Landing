"""
Núcleo compartido de datos de MIAMI_IMPORT (panel-control = fuente de verdad).

Este paquete define la configuración, la conexión a la base y TODOS los modelos
ORM. La tienda (`web-tienda`) usa una COPIA idéntica de este paquete: cualquier
cambio de esquema se hace acá primero y se replica allá. Las migraciones
(Alembic) las corre únicamente panel-control.
"""
