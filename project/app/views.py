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

# def signup_view(request):
#     if request.method == 'POST':
#         name = request.POST.get('username')
#         phone = request.POST.get('phone_number')

#         if len(phone) != 10 or not phone.isdigit():
#             messages.error(request, "Enter a valid 10-digit phone number")
#             return redirect('signup')

#         if User.objects.filter(phone_number=phone).exists():
#             messages.error(request, "Phone number already registered")
#             return redirect('signup')

#         user = User.objects.create_user(username=name, phone_number=phone, password=User.objects.make_random_password())
#         refresh = RefreshToken.for_user(user)
#         user.jwt_token = str(refresh.access_token)
#         user.save()

#         messages.success(request, "Signup successful")
#         return redirect('login')
#     return render(request, 'signup.html')

def signup_view(request):
    if request.method == 'POST':
        name = request.POST.get('username')
        phone = request.POST.get('phone_number')
        email = request.POST.get('email')

        # Server-side phone validation
        if len(phone) != 10 or not phone.isdigit():
            messages.error(request, "Enter a valid 10-digit phone number")
            return redirect('signup')

        if User.objects.filter(phone_number=phone).exists():
            messages.error(request, "Phone number already registered")
            return redirect('signup')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Email already registered")
            return redirect('signup')

        # Create user
        user = User.objects.create_user(
            username=name,
            phone_number=phone,
            email=email,
            password=User.objects.make_random_password()
        )

        # JWT generation
        refresh = RefreshToken.for_user(user)
        user.jwt_token = str(refresh.access_token)
        user.save()

        messages.success(request, "Signup successful")
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
            messages.error(request, "Please enter valid number")
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

@login_required
def dashboard_view(request):
    return render(request, 'dashboard.html')
    # return render(request, 'formpage.html')

def logout_view(request):
    logout(request)
    messages.success(request, "Logged out successfully.")
    response = redirect('login')
    response.delete_cookie('jwt_token')
    return response


##########################

##### accessing for main user::

# from django.shortcuts import render, redirect, get_object_or_404
# from django.contrib.auth.decorators import login_required
# from django.contrib import messages
# from .models import User

# def main_user_required(view_func):
#     def _wrapped_view(request, *args, **kwargs):
#         if not request.user.is_authenticated or not request.user.is_main_user:
#             messages.error(request, "Unauthorized access")
#             return redirect('dashboard')
#         return view_func(request, *args, **kwargs)
#     return _wrapped_view

# @login_required
# @main_user_required
# def user_list_view(request):
#     users = User.objects.exclude(id=request.user.id)  # exclude self
#     return render(request, 'user_list.html', {'users': users})

# @login_required
# @main_user_required
# def user_edit_view(request, user_id):
#     user = get_object_or_404(User, id=user_id)
#     if request.method == 'POST':
#         user.username = request.POST.get('username')
#         user.email = request.POST.get('email')
#         user.phone_number = request.POST.get('phone_number')
#         user.save()
#         messages.success(request, "User updated successfully")
#         return redirect('user_list')
#     return render(request, 'user_edit.html', {'user': user})

# @login_required
# @main_user_required
# def user_delete_view(request, user_id):
#     user = get_object_or_404(User, id=user_id)
#     user.delete()
#     messages.success(request, "User deleted successfully")
#     return redirect('user_list')



from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from .models import User

# @login_required
# def dashboard_view(request):
#     if request.user.is_superuser:
#         return redirect('user_list')
#     return render(request, 'dashboard.html')

# from django.contrib.auth.decorators import login_required
# from .models import User

# @login_required
# def dashboard_view(request):
#     if request.user.is_main_user:
#         users = User.objects.all()
#     else:
#         users = None  # Hide user list for normal users

#     return render(request, 'dashboard.html', {
#         'users': users
#     })




@login_required
def dashboard_view(request):
    if request.user.is_main_user:
        # Exclude the logged-in main user from the list
        users = User.objects.exclude(id=request.user.id)
    else:
        users = None  # Normal users don't see other users

    return render(request, 'dashboard.html', {
        'users': users
    })

@login_required
def user_list(request):
    if not request.user.is_superuser:
        messages.error(request, "Access denied.")
        return redirect('dashboard')

    users = User.objects.exclude(id=request.user.id)  # Optional: hide self
    return render(request, 'user_list.html', {'users': users})


@login_required
def user_edit(request, user_id):
    if not request.user.is_superuser:
        messages.error(request, "Access denied.")
        return redirect('dashboard')

    user = get_object_or_404(User, id=user_id)

    if request.method == 'POST':
        user.username = request.POST.get('username')
        user.email = request.POST.get('email')
        user.phone_number = request.POST.get('phone_number')
        user.save()
        messages.success(request, "User updated successfully.")
        return redirect('user_list')

    return render(request, 'user_edit.html', {'user': user})


@login_required
def user_delete(request, user_id):
    if not request.user.is_superuser:
        messages.error(request, "Access denied.")
        return redirect('dashboard')

    user = get_object_or_404(User, id=user_id)
    user.delete()
    messages.success(request, "User deleted.")
    return redirect('user_list')



######## another file code 

def form_page(request):
    if request.method == 'POST':
        name = request.POST.get("name")
        email = request.POST.get("email")
        print(f"Name: {name}, Email: {email}")
    return render(request, "formpage.html")

def dashboard(request):
    return render(request, 'dashboard.html')

def profile(request):
    return render(request, 'profile.html')


# views.py
from django.shortcuts import render, redirect
from .models import KycDetails

def form_page(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        mobile = request.POST.get('mobile_number')
        aadhar_number = request.POST.get('aadhar_number')
        pan_number = request.POST.get('pan_number')
        aadhar_image = request.FILES.get('aadhar_image')
        pan_image = request.FILES.get('pan_image')

        # Check that required fields are not None
        if name and mobile and aadhar_number and pan_number and aadhar_image and pan_image:
            KycDetails.objects.create(
                name=name,
                mobile_number=mobile,
                aadhar_number=aadhar_number,
                pan_number=pan_number,
                aadhar_image=aadhar_image,
                pan_image=pan_image
            )
            return redirect('formpage')  # Redirect to avoid resubmission
        else:
            return render(request, 'formpage.html', {
                'error': 'All fields are required.'
            })

    return render(request, 'formpage.html')
