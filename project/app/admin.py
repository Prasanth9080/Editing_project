

from django.contrib import admin
from .models import User,KycDetails

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'phone_number','is_main_user', 'date_joined', 'last_login', 'jwt_token')
    list_filter = ('is_main_user',)
    search_fields = ('username', 'phone_number', 'email')

@admin.register(KycDetails)
class KycDetailsAdmin(admin.ModelAdmin):
    list_display = ("name","mobile_number","aadhar_number","aadhar_image","pan_number","pan_image")