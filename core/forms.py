from django import forms
from .models import Hora, Persona, Servicio
from django.contrib.auth.models import User
import datetime

class HoraForm(forms.ModelForm):
    persona = forms.ModelChoiceField(queryset=Persona.objects.all(),
                                    to_field_name = 'id',
                                    empty_label="Seleccionar persona")

    servicio = forms.ModelChoiceField(queryset=Servicio.objects.all(),
                                    to_field_name = 'id',
                                    empty_label="Seleccionar Servicio")
    class Meta:
        model = Hora
        fields = '__all__'
        exclude = ("estado", "id")

        widgets = {
            "fecha": forms.SelectDateWidget(
                years=range(datetime.date.today().year, datetime.date.today().year+2),
                attrs=({'style': 'width: 33%; display: inline-block;'}),
                )
        }

class IngresoForm(forms.ModelForm):
    contraseña=forms.CharField(widget=forms.PasswordInput())
    class Meta:
        model = Persona
        fields = ['rut', 'contraseña']

class RegistroForm(forms.ModelForm):
    contraseña=forms.CharField(widget=forms.PasswordInput())
    class Meta:
        model = Persona
        exclude = ("estado",)
