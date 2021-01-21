create schema db_agroservicio;
use db_agroservicio;

create table PRODUCTOS (
    id_producto int(10) not null auto_increment,
    nombre varchar(45) not null,
    fabricante varchar(45) not null,
    categoria varchar(45) not null,
    precio double not null,
    constraint pk_producto primary key (id_producto)
);

create table VENTAS (
    id_venta int(10) not null auto_increment,
    fecha datetime not null,
    constraint pk_venta primary key (id_venta)
);

create table PRODUCTOS_VENTAS (
    id_venta int(10) not null,
    id_producto int(10) not null,
    cantidad int(5) not null,
    precio_venta double not null,
    constraint pk_productos_venta primary key (id_venta, id_producto),
    constraint fk_productos_ventas_id_producto foreign key (id_producto) references PRODUCTOS(id_producto),
    constraint fk_ventas_id_venta foreign key (id_venta) references VENTAS(id_venta)
);

create table COMPRAS (
    id_compra int(10) not null auto_increment,
    fecha datetime not null,
    constraint pk_compra primary key (id_compra)
);

create table PRODUCTOS_COMPRAS (
    id_compra int(10) not null,
    id_producto int(10) not null,
    cantidad int(5) not null,
    precio_compra double not null,
    constraint pk_productos_compra primary key (id_compra, id_producto),
    constraint fk_productos_compras_id_producto foreign key (id_producto) references PRODUCTOS(id_producto),
    constraint fk_compras_id_compra foreign key (id_compra) references COMPRAS(id_compra)
);