from django.urls import path
from .views import home, contacto, agenda, about, registro

urlpatterns = [
    path('', home, name="home"),
    path('contacto/', contacto, name="contacto"),
    path('agenda/', agenda, name="agenda"),
    path('about/', about, name="about"),
    path('registro/', registro, name="registro"),
]
