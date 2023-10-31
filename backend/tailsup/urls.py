"""
URL configuration for tailsup project.

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
from django.urls import path
from tailsup import views,settings
from django.conf.urls.static import static
from rest_framework.urlpatterns import format_suffix_patterns 
urlpatterns = [
    path('admin/', admin.site.urls),
    path('count/',views.user_counts),
    path('userdetails/<str:id>',views.getUserDetails),
    path('petdetails/<str:id>',views.getPetDetails),
    path('signin/', views.sign_in),
    path('register/',views.register_user),
    path('pets/', views.getShelterPets),
    path('favorite_pets/<str:user>', views.get_favorite_pets),
    path('favoritepetids/<str:user_id>',views.get_favorite_pet_ids),
    path('addfavpet/',views.add_fav_pet),
    path('removefavpet/',views.remove_fav_pet),
    path('addadoptionrecord/',views.add_adoption_record),
    path('fetch_adoption/<str:user_id>/',views.fetch_adoption_applications),
    path('get_vet',views.get_vet_users),
    path('get_orders/<str:user>',views.get_orders),
    path('products/', views.list_all_products, name='list_all_products'),
    path('products/category/<int:category_id>/', views.list_products, name='list_products_by_category'),
    path('categories/', views.list_all_categories, name='list_all_categories'),
    path('products/<int:product_id>/', views.find_product_by_id, name='find_product_by_id'),
    path('products/category/<int:category_id>', views.find_products_by_category, name='find_products_by_category'),
    path('products/search/<str:keyword>/', views.search_products, name='search_products'),
    path('cart/<str:user>', views.get_cart, name='get_cart'),
    path('cart/add/<int:product_id>/', views.add_to_cart, name='add_to_cart'),
    path('cart/update/<str:user>', views.update_cart, name='update_cart_item'),
    path('cart/remove/<int:cart_item_id>/', views.remove_from_cart, name='remove_from_cart'),
    path('cart/edit/<str:uid>',views.edit_cart_items),
    path('users/', views.user_list, name='user-list'),
    path('users/<int:user_id>', views.user_delete, name='user-delete'),
    path('place-order/<str:user>/<str:price>', views.place_order, name='place_order'),
    path('createpet/<str:user>', views.create_pet),
    path('complete-order/<int:order_id>/', views.complete_order, name='complete_order'),
    path('services/<str:phone>', views.retrieve_services_for_vet, name='retrieve_services_for_vet'),
    path('slots/<str:vet_id>', views.list_all_slots_for_vet, name='list_all_slots_for_vet'),
    path('slots/check/<str:date>/<int:slot_id>/<str:vet>', views.check_slot_status, name='check_slot_status'),
    path('slots/book/<str:date>/<int:slot_id>/<str:user>/<str:vet>', views.book_appointment, name='book_slot'),
    path('appointments/past/<str:user_id>', views.past_appointments, name='past_appointments'),
    path('appointments/upcoming/<str:user_id>', views.upcoming_appointments, name='upcoming_appointments'),
    path('appointments/diagnoses/<str:appointment_id>', views.get_diagnoses_for_appointment, name='get_diagnoses_for_appointment'),
    
]+static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)

urlpatterns = format_suffix_patterns(urlpatterns)
