CALCULADORA BASICA EN FLUTTER
Este proyecto consiste en una aplicación de calculadora desarrollada con Flutter. Su objetivo es servir como práctica para el uso de widgets fundamentales, la gestión del estado y la implementación de lógica aritmética en una interfaz sencilla y funcional.

--- Descripcion general ---
La calculadora permite realizar operaciones básicas como suma, resta, multiplicación y división. La interfaz muestra tres elementos importantes:
1. El número previo de la operación.
2. El operador seleccionado.
3. El número actual introducido por el usuario, ya sea mediante botones o mediante un campo de texto.

Además, la aplicación mantiene un historial de operaciones que se actualiza cada vez que se ejecuta una operación con el botón de igual. El historial puede limpiarse junto con el resto del estado mediante el botón "C".

--- Caracteristicas principales ---
- Implementación con StatefulWidget para gestionar cambios en la interfaz.
- Uso de Scaffold, AppBar, TextField y ElevatedButton como elementos fundamentales de la UI.
- Sincronización entre la entrada mediante botones y la entrada mediante teclado.
- Validación de operadores y valores numéricos.
- Manejo de errores, como división por cero.
- Historial de operaciones integrado en la interfaz.
- Actualización dinámica de la pantalla para mostrar la operación en construcción (número previo, operador y número actual).
- Limpieza automática de los campos de entrada tras completar una operación.

--- Mejoras futuras ---
- Persistencia del historial mediante almacenamiento local.
- Añadir pruebas unitarias para validar la lógica aritmética.
- Mejoras estéticas en la interfaz y animaciones.
- Soporte para operaciones encadenadas más avanzadas.