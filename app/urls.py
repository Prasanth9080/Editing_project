from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

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

    # reset password
    # path('password-change/', auth_views.PasswordChangeView.as_view(template_name='registration/password_change_form.html', success_url='/password-change-done/'), name='password_change'),
    # path('password-change-done/', auth_views.PasswordChangeDoneView.as_view(template_name='registration/password_change_done.html'), name='password_change_done'),
    path('change-password/', views.change_password_view, name='change_password'),

    # forgot password
    # path('password-reset/', auth_views.PasswordResetView.as_view(template_name='password_reset.html', email_template_name='password_reset_email.html'), name='password_reset'),
    # path('password-reset/done/', auth_views.PasswordResetDoneView.as_view(template_name='password_reset_done.html'), name='password_reset_done'),
    # path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(template_name='password_reset_confirm.html'), name='password_reset_confirm'),
    # path('reset/done/', auth_views.PasswordResetCompleteView.as_view(template_name='password_reset_complete.html'), name='password_reset_complete'),
    # path('test-email/', views.test_email, name='test_email'),

    path('password-reset/', views.password_reset_request, name='password_reset'),
    path('password-reset/done/', auth_views.PasswordResetDoneView.as_view(template_name='password_reset_done.html'), name='password_reset_done'),
    path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(template_name='password_reset_confirm.html'), name='password_reset_confirm'),
    path('reset/done/', auth_views.PasswordResetCompleteView.as_view(template_name='password_reset_complete.html'), name='password_reset_complete'),
]
