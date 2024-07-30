--Tabla "Clientes":
create table clientes(
idCliente number,
nombre varchar(45),
direccion varchar(45),
correoElectronico varchar(25),
telefono varchar(45),
primary key(idCliente))

--Tabla "Productos":
create table productos(
idProducto number,
idCategoria number,
nombre varchar(45),
descripcion varchar(45),
precio number,
costo number, --para calcular la ganancia
primary key(idProducto, idCategoria))


--Tabla "Pedidos":
create table pedidos(
idPedido number,
idCliente number,
fecha date,
total number,
primary key(idPedido, idCliente))


--Tabla "Detalles_Pedido":
create table detallesPedido(
idDetallePedido number,
idPedido number,
idProducto number,
cantidad number,
subtotal number,
primary key(idDetallePedido, idPedido, idProducto))

--Tabla "Factura"
create table factura(
idFactura number,
idCliente number,
idProducto number,
fechaPedido date,
primary key(idFactura, idCliente, idProducto))

--Tabla "detallesFactura"
create table detallesFactura(
idFacturaDetalle number,
idFactura number,
idProducto number,
precioUnidad number,
cantidad number,
primary key(idFacturaDetalle, idFactura, idProducto))

--Tabla "categoriaProducto"
create table categoriaProducto(
idCategoria number,
nombre varchar(45),
primary key(idCategoria))

--Tabla "ventas"
create table ventas(
idVenta number,
fecha date,
total number, --el monto total de la venta
primary key(idVenta))

--Tabla detallesVenta
create table detallesVenta(
idDetalleVenta number,
idVenta number,
idProducto number,
cantidad number,
subtotal number,
primary key(idDetalleVenta, idVenta, idProducto))


--Tabla puntosVenta
create table puntosVenta(
idPuntoVenta number,
ganancias number,
primary key(idPuntoVenta))
--Esta tabla seria para registrar informacion especifica de cada punto de venta
--y se supone relacionarla con las ventas realizadas en la tabla de ventas

--create table puntosVenta(
--idPuntoVenta number,
--...
--primary key(idPuntoVenta))
