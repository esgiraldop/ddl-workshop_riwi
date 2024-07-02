-- Creating database
CREATE DATABASE plumbing;

-- Conecting to the database
\c plumbing;

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL
);

CREATE TABLE servicios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio DECIMAL NOT NULL,
    cliente_id INT NOT NULL REFERENCES clientes(id) -- A service is associated to one client
);

CREATE TABLE plomeros (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL
);

-- Intermediate table for services and plumbers
CREATE TABLE plomeros_servicios (
    id SERIAL PRIMARY KEY,
    plomero_id INT NOT NULL REFERENCES plomeros(id),
    servicio_id INT NOT NULL REFERENCES servicios(id)
);

CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(id),
    servicio_id INT NOT NULL REFERENCES servicios(id),
    plomero_id INT NOT NULL REFERENCES plomeros(id),
    fecha DATE NOT NULL,
    total DECIMAL NOT NULL
);

CREATE TABLE descuentos (
    id SERIAL PRIMARY KEY,
    factura_id INT NOT NULL REFERENCES facturas(id),
    monto DECIMAL NOT NULL
);

CREATE TABLE pagos (
    id SERIAL PRIMARY KEY,
    factura_id INT REFERENCES facturas(id),
    monto DECIMAL NOT NULL,
    fecha DATE NOT NULL
);

CREATE TABLE auditoria (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    accion VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    cliente_id INT REFERENCES clientes(id),
    servicio_id INT REFERENCES servicios(id),
    plomero_id INT REFERENCES plomeros(id),
    factura_id INT REFERENCES facturas(id),
    descuento_id INT REFERENCES descuentos(id),
    pago_id INT REFERENCES pagos(id)
);

--Correcting tables

-- Adding the attribute direccion to Clientes
ALTER TABLE clientes
ADD COLUMN direccion VARCHAR(255);

-- Adding date to table Servicios
ALTER TABLE servicios
ADD COLUMN fecha DATE;

-- Adding direccion to table Plomeros
ALTER TABLE plomeros
ADD COLUMN direccion VARCHAR(255);

-- Adding direccion to table facturas
ALTER TABLE facturas
ADD COLUMN direccion VARCHAR(255);

-- Altering factura_id column in Pagos table so it is not null
ALTER TABLE pagos
ALTER COLUMN factura_id SET NOT NULL;

-- Dropping column "descuento_id" from table "auditoria" so it has no relation with table "descuentos" anymore
ALTER TABLE auditoria
DROP COLUMN descuento_id;