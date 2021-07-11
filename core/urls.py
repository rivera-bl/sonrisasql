from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from .views import home, contacto, agenda, about, registro, ingreso, upload

urlpatterns = [
    path('', home, name="home"),
    path('contacto/', contacto, name="contacto"),
    path('agenda/', agenda, name="agenda"),
    path('about/', about, name="about"),
    path('registro/', registro, name="registro"),
    path('ingreso/', ingreso, name="ingreso"),
    path('upload/', upload, name="upload"),
    # path('ficha/', list_ficha, name="list_ficha"),
    # path('ficha/', upload_ficha, name="upload_ficha"),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
