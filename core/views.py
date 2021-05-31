from django.shortcuts import render, redirect
from .forms import HoraForm, RegistroForm, IngresoForm
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
import cx_Oracle

dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')

def home(request):
    return render(request, 'core/home.html')

def contacto(request):
    return render(request, 'core/contacto.html')

def agenda(request):
    data = {
            # 'form': HoraForm()
            # toma el id del usuario en la tabla auth_user, no el de persona
            'form': HoraForm(initial={'persona': request.user.id})
            # ? select p.id from persona p JOIN auth_user a ON p.rut = a.username;
    }

    if request.method == 'POST':
        formulario = HoraForm(data=request.POST)
        if formulario.is_valid():
            conn = cx_Oracle.connect(
                    user=r'portafolio', 
                    password='portafolio', 
                    dsn=dsn_tns)
            cursor = conn.cursor()
            newId = cursor.var(int)

            # me tira error ORA-01861: literal does not match format string
            cursor.callproc('insertar_hora', [
                request.POST.get("fecha"),
                "1",
                request.user.id,
                1,
                newId])
            conn.commit()
            return redirect(to="home")
        data["form"] = formulario
    return render(request, 'core/agenda.html', data)

def about(request):
    return render(request, 'core/about.html')

def ingreso(request):
    data = {
        'form': IngresoForm()
    }
    con = cx_Oracle.connect(user=r'portafolio', password='portafolio', dsn=dsn_tns)

    if request.method == 'POST':
        cursor = con.cursor()
        cursor.execute('select * from persona where rut = :rut and contraseña = :contraseña', (request.POST.get("rut"), request.POST.get("contraseña")))
        resultadoPersona = cursor.fetchone()
        if resultadoPersona is not None:
            cursor1 = con.cursor()
            cursor1.execute('select * from auth_user where username = :rut', { 'rut': request.POST.get("rut") })
            resultadoAuth = cursor1.fetchone()
            user = None
            if resultadoAuth is None:
                user = User.objects.create_user(
                    request.POST.get("rut"),
                    resultadoPersona[8],
                    request.POST.get("contraseña"))
            else:
                user = authenticate(username=request.POST.get("rut"), password=request.POST.get("contraseña"))
            login(request, user)
            messages.success(request, "Registro Exitoso")
            return redirect(to="home")
            con.close()
        else:
            print('No registrado')
    return render(request, 'registration/ingreso.html', data)

def registro(request):
    data = {
        'form': RegistroForm()
    }

    if request.method == 'POST':
        formulario = RegistroForm(data=request.POST)
        if formulario.is_valid():
            conn = cx_Oracle.connect(
                    user=r'portafolio', 
                    password='portafolio', 
                    dsn=dsn_tns)
            cursor = conn.cursor()
            newId = cursor.var(int)

            cursor.callproc('insertar_persona', [
                request.POST.get("rut"),
                request.POST.get("contraseña"),
                request.POST.get("nombre"),
                request.POST.get("apellido_paterno"),
                request.POST.get("apellido_materno"),
                request.POST.get("fecha_nacimiento"),
                request.POST.get("telefono"),
                request.POST.get("correo_electronico"),
                newId])
            cursor.callproc('agregar_permiso_usuario', [newId, "cliente"])
            conn.commit()

            userid = request.POST.get("rut", '')
            usermail = request.POST.get("correo_electronico", '')
            userpass = request.POST.get("contraseña", '')
            user = User.objects.create_user(
                    userid,
                    usermail,
                    userpass)
            login(request, user)
            return redirect(to="home")
        data["form"] = formulario

    return render(request, 'registration/registro.html', data)
