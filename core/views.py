from django.shortcuts import render, redirect
from .forms import HoraForm, RegistroForm
# from .forms import HoraForm, CustomUserCreationForm
from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User

def home(request):
    return render(request, 'core/home.html')

def contacto(request):
    return render(request, 'core/contacto.html')

def agenda(request):
    data = {
        'form': HoraForm()
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

    # if request.method == 'POST':
    #     formulario = RegistroForm(data=request.POST)
    #     if formulario.is_valid():
    #         formulario.save()
    #         user = authenticate (
    #                 username=formulario.cleaned_data["rut"],
    #                 password=formulario.cleaned_data["contraseña"])
    #         login(request, user)
    #         messages.success(request, "Registro Exitoso")
    #         return redirect(to="home")
    #     data["form"] = formulario

    if request.method == 'POST':
        formulario = RegistroForm(data=request.POST)
        if formulario.is_valid():
            formulario.save()
            userid = request.POST.get("rut", '')
            usermail = request.POST.get("correo_electronico", '')
            userpass = request.POST.get("contraseña", '')
            user = User.objects.create_user(
                    userid,
                    usermail,
                    userpass)
            # user = authenticate(
            #         username=formulario.cleaned_data["username"],
            #         password=formulario.cleaned_data["password1"])
            login(request, user)
            messages.success(request, "Registro Exitoso")
            return redirect(to="home")
        data["form"] = formulario

    return render(request, 'registration/registro.html', data)
