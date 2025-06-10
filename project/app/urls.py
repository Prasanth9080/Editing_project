from django.urls import path
from . import views

urlpatterns = [
    path('', views.signup_view, name='signup'),
    path('login/', views.login_view, name='login'),
    path('verify-otp/', views.verify_otp_view, name='verify_otp'),
    # path('dashboard/', views.dashboard_view, name='dashboard'),
    path('logout/', views.logout_view, name='logout'),


    path('form/', views.form_page, name='formpage'),
    path('edit/<int:kyc_id>/', views.edit_kyc, name='edit_kyc'),
    path('delete/<int:kyc_id>/', views.delete_kyc, name='delete_kyc'),

    path('profile/', views.profile_view, name='profile'),
]
