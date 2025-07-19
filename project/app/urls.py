from django.urls import path
from . import views

urlpatterns = [
    path('', views.signup_view, name='signup'),
    path('login/', views.login_view, name='login'),
    path('verify-otp/', views.verify_otp_view, name='verify_otp'),
    # path('dashboard/', views.dashboard_view, name='dashboard'),
    path('logout/', views.logout_view, name='logout'),


    path('form/', views.form_page, name='formpage'),
    path('add-my-kyc/', views.add_my_kyc, name='add_my_kyc'),
    path('add-other-kyc/', views.add_other_kyc, name='add_other_kyc'),
    # path('edit/<int:kyc_id>/', views.edit_kyc, name='edit_kyc'),
    # path('delete/<int:kyc_id>/', views.delete_kyc, name='delete_kyc'),
    path("edit-kyc/<int:kyc_id>/<str:kyc_type>/", views.edit_kyc, name="edit_kyc"),
    path("delete-kyc/<int:kyc_id>/<str:kyc_type>/", views.delete_kyc, name="delete_kyc"),
    path('download-kyc-excel/<str:kyc_type>/', views.download_kyc_excel, name='download_kyc_excel'),
    path('download-kyc-pdf/<str:kyc_type>/', views.download_kyc_pdf, name='download_kyc_pdf'),
    # path('download/pdf/<str:kyc_type>/', views.download_kyc_pdf, name='download_kyc_pdf'),

    path('profile/', views.profile_view, name='profile'),

    # download excel
    path('download-kyc/', views.download_kyc_excel, name='download_kyc_excel'),
    path('download/pdf/', views.download_kyc_pdf, name='download_kyc_pdf'),
    path('download-kyc-excel/<str:kyc_type>/', views.download_kyc_excel, name='download_kyc_excel'),
    path('download-kyc-pdf/<str:kyc_type>/', views.download_kyc_pdf, name='download_kyc_pdf'),
    # sub-kyc
    path('download-subkyc-pdf/', views.download_subkyc_pdf, name='download_subkyc_pdf'),
    path('download-subkyc-excel/', views.download_subkyc_excel, name='download_subkyc_excel'),
]
