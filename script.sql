BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                   FROM user_objects
                   WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'MATERIALIZED VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
   FOR cur_rec IN (SELECT * 
                   FROM all_synonyms 
                   WHERE table_owner IN (SELECT USER FROM dual))
   LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || cur_rec.synonym_name;
      END;
   END LOOP;
END;
/

ALTER SESSION SET nls_date_format = 'YYYY-MM-DD hh24:mi:ss';

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
    medico_persona_id   INTEGER NOT NULL,
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


CREATE OR REPLACE PROCEDURE insertar_hora (
    fecha               VARCHAR2,
    estado              VARCHAR2,
    medico_persona_id   INTEGER,
    persona_id          INTEGER,
    servicio_id         INTEGER,
    newId out number
)
IS
BEGIN
    newId := seq_hora.NEXTVAL;
    
    INSERT INTO hora (
        id,
        fecha,
        estado,
        medico_persona_id,
        persona_id,
        servicio_id
    ) VALUES (
        newId,
        to_date(fecha, 'yyyy/mm/dd'),
        estado,
        medico_persona_id,
        persona_id,
        servicio_id
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
INSERT INTO tipo_usuario (id, nombre) VALUES (seq_tipo_usuario.nextval, 'médico');

INSERT INTO persona
    (id, rut, contraseña, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, telefono, correo_electronico)
    VALUES
    (seq_persona.NEXTVAL, '1111111-1', '1234', 'Ignacio', 'Etchepare', 'Quijada', to_date('1992/11/25', 'yyyy/mm/dd'), '123456789', 'correo@portafolio.cl');
INSERT INTO persona
    (id, rut, contraseña, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, telefono, correo_electronico)
    VALUES
    (seq_persona.NEXTVAL, '2222222-2', '1234', 'Juanito', 'Pérez', 'Rodríguez', to_date('1992/11/25', 'yyyy/mm/dd'), '123456788', 'doctor@portafolio.cl');

INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 1);
INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 2);
INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 3);
INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (1, 4);

INSERT INTO persona_tipo_usuario (persona_id, tipo_usuario_id) VALUES (2, 5);

INSERT INTO servicio (id, nombre) VALUES (seq_servicio.nextval, 'Diagnóstico Inicial');
INSERT INTO servicio (id, nombre) VALUES (seq_servicio.nextval, 'Consulta Urgencia Dental');

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

CREATE OR REPLACE  PROCEDURE insertar_proveedor (
    nombre              VARCHAR2,
    rubro               VARCHAR2,
    nombre_contacto     VARCHAR2,
    apellido_contacto     VARCHAR2,
    telefono_contacto     VARCHAR2,    
    correo_contacto     VARCHAR2,
    newId out number
) is
BEGIN
    newId := seq_proveedor.NEXTVAL;
    INSERT INTO proveedor (
        id,
        nombre,
        rubro,
        nombre_contacto,
        apellido_contacto,
        telefono_contacto,
        correo_contacto
    ) VALUES (
        newId,
        nombre,
        rubro,
        nombre_contacto,
        apellido_contacto,
        telefono_contacto,
        correo_contacto
    );

END;
/
commit;
create or replace NONEDITIONABLE PROCEDURE modificar_proveedor (
    old_id                  NUMBER,
    new_nombre                 VARCHAR2,
    new_rubro          VARCHAR2,
    new_nombre_contacto              VARCHAR2,
    new_apellido_contacto    VARCHAR2,
    new_telefono_contacto    VARCHAR2,
    new_correo_contacto    VARCHAR2
)
IS
BEGIN
    UPDATE proveedor
    SET
    nombre = new_nombre,
    rubro = new_rubro,
    nombre_contacto = new_nombre_contacto,
    apellido_contacto = new_apellido_contacto,
    telefono_contacto = new_telefono_contacto,
    correo_contacto = new_correo_contacto
        
    WHERE
        id = old_id;
    COMMIT;
END;
/

CREATE OR REPLACE  PROCEDURE insertar_hora (
    fecha              VARCHAR2,
    cliente_persona_id               VARCHAR2,
    medico_persona_id               VARCHAR2,
    servicio_id     VARCHAR2,
    newId out number
) is
BEGIN
    newId := seq_hora.NEXTVAL;
    INSERT INTO hora (
        id,
        fecha,
        persona_id,
        medico_persona_id,
        servicio_id,
        estado
    ) VALUES (
        newId,
        to_date(fecha, 'YYYY-MM-DD HH24:MI:SS'),
        cliente_persona_id,
        medico_persona_id,
        servicio_id,
        'PENDIENTE'
    );

END;
/


CREATE OR REPLACE NONEDITIONABLE PROCEDURE insertar_familia_producto (
    nombre  VARCHAR2,
    newid   OUT NUMBER
) IS
BEGIN
    newid := seq_familia_producto.nextval;
    INSERT INTO familia_producto (
        id,
        nombre
    ) VALUES (
        newid,
        nombre
    );

END;
/

CREATE OR REPLACE NONEDITIONABLE PROCEDURE modificar_familia (
    old_id      NUMBER,
    new_nombre  VARCHAR2
) IS
BEGIN
    UPDATE familia_producto
    SET
        nombre = new_nombre
    WHERE
        id = old_id;

    COMMIT;
END;
/

create or replace PROCEDURE insertar_producto (
    nombre        VARCHAR2,
    precio_venta  NUMBER,
    stock_minimo  NUMBER,
    familia_producto_id NUMBER,
    newid         OUT NUMBER
) IS
BEGIN
    newid := seq_producto.nextval;
    INSERT INTO producto (
        id,
        nombre,
        precio_venta,
        stock,
        stock_minimo,
        familia_producto_id,
        estado
    ) VALUES (
        newid,
        nombre,
        precio_venta,
        0,
        stock_minimo,
        familia_producto_id,
        1
    );

END;
/



create or replace NONEDITIONABLE PROCEDURE modificar_producto (
    old_id                  NUMBER,
    new_nombre                 VARCHAR2,
    new_precio_venta NUMBER,
    new_stock_minimo NUMBER,
    new_stock NUMBER,
    new_familia_producto_id NUMBER
   )
IS
BEGIN
    UPDATE producto
    SET
    nombre = new_nombre,
    precio_venta = new_precio_venta,
    stock_minimo = new_stock_minimo,
    stock = new_stock,
    familia_producto_id = new_familia_producto_id
    WHERE
        id = old_id;
    COMMIT;
END;
/

commit;
