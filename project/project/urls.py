"""
URL configuration for project project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from app import views  # import your view

urlpatterns = [
    path('admin/', admin.site.urls),
    # path('', include("app.urls")),
    # path('', views.signup_view, name='home'),  # 👈 This sets the root URL to show signup.html
    # path('signup/', views.signup_view, name='signup'),
    # path('login/', views.otp_login_view, name='otp_login'),
    # path('verify-otp/', views.verify_otp_view, name='verify_otp'),
    # path('forgot-password/', views.forgot_password_view, name='forgot_password'),
    # path('reset-link/<uid>/<token>/', views.reset_password_link_view, name='reset_link'),
    # path('reset-password/', views.reset_password_view, name='reset_password'),
    # path('dashboard/', views.dashboard_view, name='dashboard'),
    path('', views.signup_view, name='signup'),
    path('login/', views.login_view, name='login'),
    path('verify-otp/', views.verify_otp_view, name='verify_otp'),
    # path('dashboard/', views.dashboard_view, name='dashboard'),
    # path('logout/', views.logout_view, name='logout'),

    # path('users/', views.user_list_view, name='user_list'),
    # path('user/edit/<int:user_id>/', views.user_edit_view, name='user_edit'),
    # path('user/delete/<int:user_id>/', views.user_delete_view, name='user_delete'),


        path('dashboard/', views.dashboard_view, name='dashboard'),
    path('users/', views.user_list, name='user_list'),
    path('users/edit/<int:user_id>/', views.user_edit, name='user_edit'),
    path('users/delete/<int:user_id>/', views.user_delete, name='user_delete'),
    path('logout/', views.logout_view, name='logout'),

        path("form/", views.form_page, name="formpage"),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('profile/', views.profile, name='profile'),
]
