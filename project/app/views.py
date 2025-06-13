# views.py
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User
import random, string

otp_storage = {}

def generate_otp():
    return ''.join(random.choices(string.ascii_letters + string.digits, k=7))


from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.models import BaseUserManager
from rest_framework_simplejwt.tokens import RefreshToken

from .models import User  # your custom user model

def signup_view(request):
    if request.method == 'POST':
        name = request.POST.get('username')
        phone = request.POST.get('phone_number')
        email = request.POST.get('email')

        # Server-side validation
        if len(phone) != 10 or not phone.isdigit():
            messages.error(request, "Enter a valid 10-digit phone number")
            return redirect('signup')

        if User.objects.filter(phone_number=phone).exists():
            messages.error(request, "Phone number already registered")
            return redirect('signup')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Email already registered")
            return redirect('signup')

        # Generate random password using BaseUserManager
        # random_password = BaseUserManager().make_random_password()

        # Create user
        user = User.objects.create_user(
            username=name,
            email=email,
            phone_number=phone,
            # password=random_password
        )

        # Generate JWT token
        refresh = RefreshToken.for_user(user)
        user.jwt_token = str(refresh.access_token)
        user.save()

        messages.success(request, "Signup successful! Please login.")
        return redirect('login')

    return render(request, 'signup.html')



def login_view(request):
    if request.method == 'POST':
        phone = request.POST.get('phone_number')
        try:
            user = User.objects.get(phone_number=phone)
            if not user.jwt_token:
                messages.error(request, "Invalid token")
                return redirect('login')
            otp = generate_otp()
            otp_storage[phone] = otp
            print(f"\U0001F511 OTP for {phone}: {otp}")
            request.session['phone_number'] = phone
            messages.success(request, "OTP sent")
            return redirect('verify_otp')
        except User.DoesNotExist:
            messages.error(request, "Please SignUp your number")
    return render(request, 'login.html')

def verify_otp_view(request):
    phone = request.session.get('phone_number')
    if not phone:
        return redirect('login')

    if request.method == 'POST':
        input_otp = request.POST.get('otp')
        if otp_storage.get(phone) == input_otp:
            user = User.objects.get(phone_number=phone)
            login(request, user)
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            request.session['access_token'] = access_token
            # response = redirect('dashboard')
            response = redirect('formpage')
            response.set_cookie('auth_token', access_token)
            return response
        else:
            messages.error(request, "OTP is not valid")
    return render(request, 'verify_otp.html')


# @login_required
# def dashboard_view(request):
#     # return render(request, 'dashboard.html')
#     return render(request, 'formpage.html')

def logout_view(request):
    logout(request)
    messages.success(request, "Logged out successfully.")
    response = redirect('login')
    response.delete_cookie('jwt_token')
    return response




############# for formpage functionalities  deleted for for all user

# from django.shortcuts import render, redirect, get_object_or_404
# from .models import KycDetails, User
# from django.contrib.auth.decorators import login_required
# from django.contrib import messages

# @login_required
# def form_page(request):
#     user = request.user

#     # Show all data to main user, or only their own data
#     if user.is_main_user:
#         kyc_list = KycDetails.objects.all()
#     else:
#         kyc_list = KycDetails.objects.filter(user=user)

#     if request.method == "POST":
#         name = request.POST.get('name')
#         mobile = request.POST.get('mobile_number')
#         aadhar = request.POST.get('aadhar_number')
#         pan = request.POST.get('pan_number')
#         aadhar_img = request.FILES.get('aadhar_image')
#         pan_img = request.FILES.get('pan_image')

#         if not all([name, mobile, aadhar, pan, aadhar_img, pan_img]):
#             messages.error(request, "All fields are required.")
#         else:
#             KycDetails.objects.create(
#                 user=user,
#                 name=name,
#                 mobile_number=mobile,
#                 aadhar_number=aadhar,
#                 pan_number=pan,
#                 aadhar_image=aadhar_img,
#                 pan_image=pan_img
#             )
#             messages.success(request, "KYC submitted successfully.")
#             return redirect("formpage")

#     return render(request, "formpage.html", {"kyc_list": kyc_list})


# @login_required
# def edit_kyc(request, kyc_id):
#     kyc = get_object_or_404(KycDetails, id=kyc_id)

#     if not (request.user.is_main_user or request.user == kyc.user):
#         messages.error(request, "You are not authorized.")
#         return redirect("formpage")

#     if request.method == "POST":
#         kyc.name = request.POST.get('name')
#         kyc.mobile_number = request.POST.get('mobile_number')
#         kyc.aadhar_number = request.POST.get('aadhar_number')
#         kyc.pan_number = request.POST.get('pan_number')

#         if request.FILES.get('aadhar_image'):
#             kyc.aadhar_image = request.FILES['aadhar_image']
#         if request.FILES.get('pan_image'):
#             kyc.pan_image = request.FILES['pan_image']

#         kyc.save()
#         messages.success(request, "KYC updated successfully.")
#         return redirect("formpage")

#     return render(request, "edit_kyc.html", {"kyc": kyc})


# @login_required
# def delete_kyc(request, kyc_id):
#     kyc = get_object_or_404(KycDetails, id=kyc_id)

#     if not (request.user.is_main_user or request.user == kyc.user):
#         messages.error(request, "You are not authorized.")
#     else:
#         kyc.delete()
#         messages.success(request, "KYC deleted.")

#     return redirect("formpage")



################ delete option only acccess in main user
################ otherwise normal user delete the record only delete(hide) the paricular role

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import KycDetails, User

@login_required
def form_page(request):
    user = request.user

    # Show records: main user = all, others = only their visible records
    if user.is_main_user:
        kyc_list = KycDetails.objects.all()
    else:
        kyc_list = KycDetails.objects.filter(user=user, is_hidden=False)

    # Handle form submission
    if request.method == "POST":
        name = request.POST.get('name')
        mobile = request.POST.get('mobile_number')
        aadhar = request.POST.get('aadhar_number')
        pan = request.POST.get('pan_number')
        aadhar_img = request.FILES.get('aadhar_image')
        pan_img = request.FILES.get('pan_image')

        if not all([name, mobile, aadhar, pan, aadhar_img, pan_img]):
            messages.error(request, "All fields are required.")
        else:
            KycDetails.objects.create(
                user=user,
                name=name,
                mobile_number=mobile,
                aadhar_number=aadhar,
                pan_number=pan,
                aadhar_image=aadhar_img,
                pan_image=pan_img
            )
            messages.success(request, "KYC submitted successfully.")
            return redirect("formpage")

    return render(request, "formpage.html", {"kyc_list": kyc_list})


@login_required
def edit_kyc(request, kyc_id):
    kyc = get_object_or_404(KycDetails, id=kyc_id)

    # Authorization check
    if not (request.user.is_main_user or request.user == kyc.user):
        messages.error(request, "You are not authorized to edit this entry.")
        return redirect("formpage")

    if request.method == "POST":
        kyc.name = request.POST.get('name')
        kyc.mobile_number = request.POST.get('mobile_number')
        kyc.aadhar_number = request.POST.get('aadhar_number')
        kyc.pan_number = request.POST.get('pan_number')

        if request.FILES.get('aadhar_image'):
            kyc.aadhar_image = request.FILES['aadhar_image']
        if request.FILES.get('pan_image'):
            kyc.pan_image = request.FILES['pan_image']

        kyc.save()
        messages.success(request, "KYC updated successfully.")
        return redirect("formpage")

    return render(request, "edit_kyc.html", {"kyc": kyc})


@login_required
def delete_kyc(request, kyc_id):
    kyc = get_object_or_404(KycDetails, id=kyc_id)

    # Authorization check
    if not (request.user.is_main_user or request.user == kyc.user):
        messages.error(request, "You are not authorized to delete this entry.")
        return redirect("formpage")

    if request.user.is_main_user:
        # Hard delete
        kyc.delete()
        messages.success(request, "KYC permanently deleted.")
    else:
        # Soft delete
        kyc.is_hidden = True
        kyc.save()
        messages.success(request, "KYC record deleted successfully.")

    return redirect("formpage")



################################################################


################### for profile page functionalities

# from django.contrib.auth.decorators import login_required
# from django.shortcuts import render, redirect
# from django.contrib import messages
# from .models import CustomUser

# @login_required
# def profile_view(request):
#     user = request.user

#     if request.method == 'POST':
#         user.username = request.POST.get('username')
#         user.email = request.POST.get('email')
#         user.phone_number = request.POST.get('phone_number')
#         user.save()
#         messages.success(request, "Profile updated successfully.")
#         return redirect('profile')

#     return render(request, 'profile.html', {'user_obj': user})



@login_required
def profile_view(request):
    user = request.user

    if request.method == 'POST':
        user.username = request.POST['username']
        user.email = request.POST['email']
        user.phone_number = request.POST['phone_number']
        user.save()
        messages.success(request, "Profile updated successfully.")
        return redirect('profile')

    return render(request, 'profile.html', {'user_obj': user})

