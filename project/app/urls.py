from django.urls import path
from . views import *
from app import views

urlpatterns = [
    path("", views.login, name="login"),
]
