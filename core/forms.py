from django import forms
from .models import Hora, Persona
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
import datetime

class HoraForm(forms.ModelForm):
    class Meta:
        model = Hora
        # fields = ["id", "fecha", "estado", "persona"]
        fields = '__all__'

        # MONTHS = {
        #     6:('junio'), 7:('julio'), 8:('agosto'),
        #     9:('septiembre'), 10:('octubre'), 11:('noviembre'), 12:('diciembre')
        # }

        widgets = {
            "fecha": forms.SelectDateWidget(
                years=range(datetime.date.today().year, datetime.date.today().year+2),
                attrs=({'style': 'width: 33%; display: inline-block;'}),
                # months=MONTHS
                # days=range(datetime.date.today().day, datetime.date.today().day+2)
                )
        }

class RegistroForm(forms.ModelForm):
    class Meta:
        model = Persona
        # fields = '__all__'
        exclude = ("estado",)

# class CustomUserCreationForm(UserCreationForm):
#     pass
