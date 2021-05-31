from django.shortcuts import render, redirect
from .forms import HoraForm, RegistroForm
# from .forms import HoraForm, CustomUserCreationForm
from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
import cx_Oracle

def home(request):
    return render(request, 'core/home.html')

def contacto(request):
    return render(request, 'core/contacto.html')

def agenda(request):
    data = {
            'form': HoraForm(initial={'id': request.user.id})
    }

    if request.method == 'POST':
        formulario = HoraForm(data=request.POST)
        if formulario.is_valid():
            formulario.save()
            data["mensaje"] = "Hora Agendada"
        else:
            data["form"] = formulario

    return render(request, 'core/agenda.html', data)

def about(request):
    return render(request, 'core/about.html')

def registro(request):
    data = {
            'form': RegistroForm()
    }

    if request.method == 'POST':
        formulario = RegistroForm(data=request.POST)
        if formulario.is_valid():
            dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')
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
            messages.success(request, "Registro Exitoso")
            return redirect(to="home")
        data["form"] = formulario

    return render(request, 'registration/registro.html', data)
