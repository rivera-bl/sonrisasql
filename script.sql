
CREATE TABLE boleta (
    id             INTEGER NOT NULL,
    fecha_emision  DATE NOT NULL,
    estado         VARCHAR2(50) NOT NULL,
    hora_id        INTEGER NOT NULL
);

CREATE UNIQUE INDEX boleta__idx ON
    boleta (
        hora_id
    ASC );

ALTER TABLE boleta ADD CONSTRAINT boleta_pk PRIMARY KEY ( id );

CREATE TABLE familia_producto (
    id      INTEGER NOT NULL,
    nombre  VARCHAR2(30) NOT NULL
);

ALTER TABLE familia_producto ADD CONSTRAINT familia_producto_pk PRIMARY KEY ( id );

CREATE TABLE ficha_economica (
    id          INTEGER NOT NULL,
    tipo_ficha  NVARCHAR2(50) NOT NULL,
    documento   VARCHAR2(255) NOT NULL,
    persona_id  INTEGER NOT NULL
);

ALTER TABLE ficha_economica ADD CONSTRAINT ficha_economica_pk PRIMARY KEY ( id );

CREATE TABLE hora (
    id           INTEGER NOT NULL,
    fecha        DATE NOT NULL,
    estado       VARCHAR2(50) NOT NULL,
    persona_id   INTEGER NOT NULL,
    servicio_id  INTEGER NOT NULL
);

ALTER TABLE hora ADD CONSTRAINT hora_pk PRIMARY KEY ( id );

CREATE TABLE orden_pedido (
    id                INTEGER NOT NULL,
    fecha_solicitada  DATE NOT NULL,
    persona_id        INTEGER NOT NULL
);

ALTER TABLE orden_pedido ADD CONSTRAINT orden_pedido_pk PRIMARY KEY ( id );

CREATE TABLE orden_pedido_producto (
    precio_unitario  INTEGER NOT NULL,
    cantidad         INTEGER NOT NULL,
    orden_pedido_id  INTEGER NOT NULL,
    producto_id      INTEGER NOT NULL,
    proveedor_id     INTEGER NOT NULL
);

CREATE TABLE persona (
    id                  INTEGER NOT NULL,
    rut                 VARCHAR2(20) NOT NULL,
    contraseña          VARCHAR2(20) NOT NULL,
    nombre              VARCHAR2(50) NOT NULL,
    apellido_paterno    VARCHAR2(50) NOT NULL,
    apellido_materno    VARCHAR2(50) NOT NULL,
    fecha_nacimiento    DATE NOT NULL,
    telefono            VARCHAR2(20) NOT NULL,
    correo_electronico  VARCHAR2(80) NOT NULL,
    estado              CHAR(1) NOT NULL
);

ALTER TABLE persona ADD CONSTRAINT persona_pk PRIMARY KEY ( id );

CREATE TABLE persona_tipo_usuario (
    persona_id       INTEGER NOT NULL,
    tipo_usuario_id  INTEGER NOT NULL
);

ALTER TABLE persona_tipo_usuario ADD CONSTRAINT persona_tipo_usuario_pk PRIMARY KEY ( persona_id,
                                                                                      tipo_usuario_id );

CREATE TABLE producto (
    id                   INTEGER NOT NULL,
    nombre               VARCHAR2(30) NOT NULL,
    precio_venta         INTEGER NOT NULL,
    stock                INTEGER NOT NULL,
    stock_minimo         INTEGER NOT NULL,
    estado               CHAR(1) NOT NULL,
    familia_producto_id  INTEGER NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY ( id );

CREATE TABLE proveedor (
    id                 INTEGER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    rubro              VARCHAR2(200) NOT NULL,
    nombre_contacto    VARCHAR2(50) NOT NULL,
    apellido_contacto  VARCHAR2(50) NOT NULL,
    telefono_contacto  VARCHAR2(30) NOT NULL,
    correo_contacto    VARCHAR2(200) NOT NULL
);

ALTER TABLE proveedor ADD CONSTRAINT proveedor_pk PRIMARY KEY ( id );

CREATE TABLE recepcion (
    id            INTEGER NOT NULL,
    fecha         DATE NOT NULL,
    persona_id    INTEGER NOT NULL,
    proveedor_id  INTEGER NOT NULL
);

ALTER TABLE recepcion ADD CONSTRAINT recepcion_pk PRIMARY KEY ( id );

CREATE TABLE recepcion_producto (
    cantidad           INTEGER NOT NULL,
    fecha_vencimiento  DATE NOT NULL,
    recepcion_id       INTEGER NOT NULL,
    producto_id        INTEGER NOT NULL
);

CREATE TABLE servicio (
    id      INTEGER NOT NULL,
    nombre  VARCHAR2(150) NOT NULL
);

ALTER TABLE servicio ADD CONSTRAINT servicio_pk PRIMARY KEY ( id );

CREATE TABLE servicio_producto (
    cantidad     INTEGER NOT NULL,
    servicio_id  INTEGER NOT NULL,
    producto_id  INTEGER NOT NULL
);

CREATE TABLE tipo_usuario (
    id      INTEGER NOT NULL,
    nombre  VARCHAR2(30) NOT NULL
);

ALTER TABLE tipo_usuario ADD CONSTRAINT tipo_usuario_pk PRIMARY KEY ( id );

ALTER TABLE boleta
    ADD CONSTRAINT boleta_hora_fk FOREIGN KEY ( hora_id )
        REFERENCES hora ( id );

ALTER TABLE ficha_economica
    ADD CONSTRAINT ficha_economica_persona_fk FOREIGN KEY ( persona_id )
        REFERENCES persona ( id );

ALTER TABLE hora
    ADD CONSTRAINT hora_persona_fk FOREIGN KEY ( persona_id )
        REFERENCES persona ( id );

ALTER TABLE hora
    ADD CONSTRAINT hora_servicio_fk FOREIGN KEY ( servicio_id )
        REFERENCES servicio ( id );

ALTER TABLE orden_pedido
    ADD CONSTRAINT orden_pedido_persona_fk FOREIGN KEY ( persona_id )
        REFERENCES persona ( id );

ALTER TABLE orden_pedido_producto
    ADD CONSTRAINT orden_pedido_producto_orden_pedido_fk FOREIGN KEY ( orden_pedido_id )
        REFERENCES orden_pedido ( id );

ALTER TABLE orden_pedido_producto
    ADD CONSTRAINT orden_pedido_producto_producto_fk FOREIGN KEY ( producto_id )
        REFERENCES producto ( id );

ALTER TABLE orden_pedido_producto
    ADD CONSTRAINT orden_pedido_producto_proveedor_fk FOREIGN KEY ( proveedor_id )
        REFERENCES proveedor ( id );

ALTER TABLE persona_tipo_usuario
    ADD CONSTRAINT persona_tipo_usuario_persona_fk FOREIGN KEY ( persona_id )
        REFERENCES persona ( id );

ALTER TABLE persona_tipo_usuario
    ADD CONSTRAINT persona_tipo_usuario_tipo_usuario_fk FOREIGN KEY ( tipo_usuario_id )
        REFERENCES tipo_usuario ( id );

ALTER TABLE producto
    ADD CONSTRAINT producto_familia_producto_fk FOREIGN KEY ( familia_producto_id )
        REFERENCES familia_producto ( id );

ALTER TABLE recepcion
    ADD CONSTRAINT recepcion_persona_fk FOREIGN KEY ( persona_id )
        REFERENCES persona ( id );

ALTER TABLE recepcion_producto
    ADD CONSTRAINT recepcion_producto_producto_fk FOREIGN KEY ( producto_id )
        REFERENCES producto ( id );

ALTER TABLE recepcion_producto
    ADD CONSTRAINT recepcion_producto_recepcion_fk FOREIGN KEY ( recepcion_id )
        REFERENCES recepcion ( id );

ALTER TABLE recepcion
    ADD CONSTRAINT recepcion_proveedor_fk FOREIGN KEY ( proveedor_id )
        REFERENCES proveedor ( id );

ALTER TABLE servicio_producto
    ADD CONSTRAINT servicio_producto_producto_fk FOREIGN KEY ( producto_id )
        REFERENCES producto ( id );

ALTER TABLE servicio_producto
    ADD CONSTRAINT servicio_producto_servicio_fk FOREIGN KEY ( servicio_id )
        REFERENCES servicio ( id );


alter table persona modify( estado char(1) default '1' );

CREATE SEQUENCE seq_boleta START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_familia_producto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ficha_economica START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_hora START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_orden_pedido START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_persona START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_producto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_proveedor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_recepcion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_servicio START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tipo_usuario START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE insertar_persona (
    rut                 VARCHAR2,
    contraseña          VARCHAR2,
    nombre              VARCHAR2,
    apellido_paterno    VARCHAR2,
    apellido_materno    VARCHAR2,
    fecha_nacimiento    VARCHAR2,
    telefono            VARCHAR2,
    correo_electronico  VARCHAR2,
    newId out number
)
IS
BEGIN
    newId := seq_persona.NEXTVAL;
    
    INSERT INTO persona (
        id,
        rut,
        contraseña,
        nombre,
        apellido_paterno,
        apellido_materno,
        fecha_nacimiento,
        telefono,
        correo_electronico
    ) VALUES (
        newId,
        rut,
        contraseña,
        nombre,
        apellido_paterno,
        apellido_materno,
        to_date(fecha_nacimiento, 'yyyy/mm/dd'),
        telefono,
        correo_electronico
    );
END;
/

CREATE OR REPLACE PROCEDURE agregar_permiso_usuario (
    id_persona NUMBER,
    tipo_usuario VARCHAR2
) AS
    id_tipo_usuario NUMBER;
BEGIN
    SELECT id INTO id_tipo_usuario FROM tipo_usuario WHERE nombre = tipo_usuario;

    if id_tipo_usuario is not null then
        INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (id_persona, id_tipo_usuario);
    end if;
END;
/

INSERT INTO tipo_usuario (id, nombre) VALUES (seq_tipo_usuario.nextval, 'cliente');
INSERT INTO tipo_usuario (id, nombre) VALUES (seq_tipo_usuario.nextval, 'empleado');
INSERT INTO tipo_usuario (id, nombre) VALUES (seq_tipo_usuario.nextval, 'proveedor');
INSERT INTO tipo_usuario (id, nombre) VALUES (seq_tipo_usuario.nextval, 'administrador');

INSERT INTO persona
    (id, rut, contraseña, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, telefono, correo_electronico)
    VALUES
    (seq_persona.NEXTVAL, '1111111-1', '1234', 'Ignacio', 'Etchepare', 'Quijada', to_date('1992/11/25', 'yyyy/mm/dd'), '123456789', 'correo@portafolio.cl');

INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 1);
INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 2);
INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 3);
INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 4);

INSERT INTO servicio (id, nombre) VALUES (seq_servicio.nextval, 'Diagnóstico Inicial')
INSERT INTO servicio (id, nombre) VALUES (seq_servicio.nextval, 'Consulta Urgencia Dental')

create or replace PROCEDURE modificar_persona (
    old_id                  NUMBER,
    new_rut                 VARCHAR2,
    new_contraseña          VARCHAR2,
    new_nombre              VARCHAR2,
    new_apellido_paterno    VARCHAR2,
    new_apellido_materno    VARCHAR2,
    new_fecha_nacimiento    VARCHAR2,
    new_telefono            VARCHAR2,
    new_correo_electronico  VARCHAR2
)
IS
BEGIN
    UPDATE persona
    SET
        rut = new_rut,
        contraseña = new_contraseña,
        nombre = new_nombre,
        apellido_paterno = new_apellido_paterno,
        apellido_materno = new_apellido_materno,
        fecha_nacimiento = to_date(new_fecha_nacimiento, 'yyyy/mm/dd'),
        telefono = new_telefono,
        correo_electronico = new_correo_electronico
    WHERE
        id = old_id;
    COMMIT;
END;
/


commit;
