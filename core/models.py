# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Boleta(models.Model):
    id = models.AutoField(primary_key=True)
    fecha_emision = models.DateField()
    estado = models.CharField(max_length=50)
    hora = models.ForeignKey('Hora', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'boleta'


class FamiliaProducto(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'familia_producto'


class FichaEconomica(models.Model):
    id = models.AutoField(primary_key=True)
    tipo_ficha = models.CharField(max_length=50)
    documento = models.CharField(max_length=255)
    persona = models.ForeignKey('Persona', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'ficha_economica'


class Hora(models.Model):
    id = models.AutoField(primary_key=True)
    fecha = models.DateField()
    estado = models.CharField(max_length=50)
    persona = models.ForeignKey('Persona', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'hora'


class HoraServicio(models.Model):
    hora = models.OneToOneField(Hora, models.DO_NOTHING, primary_key=True)
    servicio = models.ForeignKey('Servicio', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'hora_servicio'
        unique_together = (('hora', 'servicio'),)


class OrdenPedido(models.Model):
    id = models.AutoField(primary_key=True)
    fecha_solicitada = models.DateField()
    persona = models.ForeignKey('Persona', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'orden_pedido'


class OrdenPedidoProducto(models.Model):
    precio_unitario = models.BigIntegerField()
    cantidad = models.BigIntegerField()
    orden_pedido = models.ForeignKey(OrdenPedido, models.DO_NOTHING)
    producto = models.ForeignKey('Producto', models.DO_NOTHING)
    proveedor = models.ForeignKey('Proveedor', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'orden_pedido_producto'


class Persona(models.Model):
    def __str__(self):
        return '%s' % self.rut + ' ' + self.nombre + ' ' + self.apellido_paterno
    id = models.AutoField(primary_key=True)
    rut = models.CharField(unique=True, max_length=20)
    contraseña = models.CharField(max_length=20)
    nombre = models.CharField(max_length=50)
    apellido_paterno = models.CharField(max_length=50)
    apellido_materno = models.CharField(max_length=50)
    fecha_nacimiento = models.DateField()
    telefono = models.CharField(max_length=20)
    correo_electronico = models.CharField(max_length=80)
    estado = models.CharField(max_length=1)
    class Meta:
        managed = False
        db_table = 'persona'

class PersonaTipoUsuario(models.Model):
    persona = models.OneToOneField(Persona, models.DO_NOTHING, primary_key=True)
    tipo_usuario = models.ForeignKey('TipoUsuario', models.DO_NOTHING)
    class Meta:
        managed = False
        db_table = 'persona_tipo_usuario'
        unique_together = (('persona', 'tipo_usuario'),)

class TipoUsuario(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=30)
    class Meta:
        managed = False
        db_table = 'tipo_usuario'


class Producto(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=30)
    precio_venta = models.BigIntegerField()
    stock = models.BigIntegerField()
    stock_minimo = models.BigIntegerField()
    estado = models.CharField(max_length=1)
    familia_producto = models.ForeignKey(FamiliaProducto, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'producto'


class Proveedor(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    rubro = models.CharField(max_length=200)
    nombre_contacto = models.CharField(max_length=50)
    apellido_contacto = models.CharField(max_length=50)
    telefono_contacto = models.CharField(max_length=30)
    correo_contacto = models.CharField(max_length=200)

    class Meta:
        managed = False
        db_table = 'proveedor'


class Recepcion(models.Model):
    id = models.AutoField(primary_key=True)
    fecha = models.DateField()
    persona = models.ForeignKey(Persona, models.DO_NOTHING)
    proveedor = models.ForeignKey(Proveedor, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'recepcion'


class RecepcionProducto(models.Model):
    cantidad = models.BigIntegerField()
    fecha_vencimiento = models.DateField()
    recepcion = models.ForeignKey(Recepcion, models.DO_NOTHING)
    producto = models.ForeignKey(Producto, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'recepcion_producto'


class Servicio(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=150)

    class Meta:
        managed = False
        db_table = 'servicio'


class ServicioProducto(models.Model):
    cantidad = models.BigIntegerField()
    servicio = models.ForeignKey(Servicio, models.DO_NOTHING)
    producto = models.ForeignKey(Producto, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'servicio_producto'

