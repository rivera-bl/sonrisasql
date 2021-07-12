from django import forms
from .models import Hora, Persona, Servicio, FichaEconomica
from django.contrib.auth.models import User
import datetime

class DateInput(forms.DateInput):
    input_type = 'date'

class HoraForm(forms.ModelForm):
    servicio = forms.ModelChoiceField(queryset=Servicio.objects.all(),
                                    to_field_name = 'id',
                                    empty_label="Seleccionar Servicio")
    class Meta:
        model = Hora
        fields = '__all__'
        exclude = ("estado", "id", "persona")
        widgets = { 'fecha': DateInput() }

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
        widgets = { 'fecha_nacimiento': DateInput() }

class UploadForm(forms.ModelForm):
    class Meta:
        model = FichaEconomica
        fields = ['tipo_ficha', 'documento']
