from django import forms
from .models import Hora, Persona, Servicio, FichaEconomica, PersonaTipoUsuario
from django.contrib.auth.models import User
import datetime

class DateInput(forms.DateInput):
    input_type = 'date'

class HoraForm(forms.ModelForm):
    servicio = forms.ModelChoiceField(queryset=Servicio.objects.all(),
                                    to_field_name = 'id',
                                    empty_label="Seleccionar Servicio")
    medico_persona_id = forms.ModelChoiceField(queryset=PersonaTipoUsuario.objects.all().filter(tipo_usuario=5),
                                    #to_field_name = 'persona',
                                    empty_label="Seleccionar Médico")
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
