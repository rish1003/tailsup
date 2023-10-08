from datetime import date
from datetime import datetime
from django.shortcuts import get_list_or_404
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.parsers import JSONParser

from tailsup.serializers import *
from .models import *

from django.contrib.auth import authenticate
from django.utils import timezone
from django.db.models import Q

import stripe
from django.conf import settings
import requests

# Configure Stripe with your API keys
stripe.api_key = settings.STRIPE_SECRET_KEY


@api_view(['GET'])
def getUserDetails(request,id):
    if request.method == 'GET':
        user = User.objects.get(pk = id)
        serializer = UserSerializer(user)
        return Response(serializer.data)
    
@api_view(['GET'])
def getPetDetails(request,id):
    if request.method == 'GET':
        pets = get_list_or_404(Pet, userid=id)
        serializer = PetSerializer(pets, many=True)
        return Response(serializer.data)
    
@api_view(['GET'])
def getShelterPets(request):
    if request.method == 'GET':
        pets = Pet.objects.exclude(shelterid__isnull=True).exclude(shelterid__exact='')
        serializer = PetSerializer(pets, many=True)
        return Response(serializer.data)


@api_view(['GET'])
def get_favorite_pets(request, user):
    favorite_pets = FavPet.objects.filter(userid=user)
    pet_ids = [fav_pet.pet_id for fav_pet in favorite_pets]
    pets = Pet.objects.filter(pk__in=pet_ids)
    pet_serializer = PetSerializer(pets, many=True)
    return Response(pet_serializer.data)



@api_view(['POST'])
def sign_in(request):
    data = JSONParser().parse(request)
    phone = data.get('phone')
    password = data.get('password')
    print(phone,password)
    
    try:
        user = User.objects.get(phone=phone)
        if (password == user.password):
            return Response({'message': 'Authentication successful', 'user_id': user.name}, status=status.HTTP_200_OK)
        else:
            return Response({'message': 'Authentication failed'}, status=status.HTTP_401_UNAUTHORIZED)
    except User.DoesNotExist:
        return Response({'message': 'No such user'}, status=status.HTTP_401_UNAUTHORIZED)
    
@api_view(['POST','PUT'])
def newuser(request):
    if request.method == 'POST':
       serializer = UserSerializer(data= request.data)
       if serializer.is_valid():
           serializer.save()
           return Response({"Created user: ":serializer.data},status=status.HTTP_200_OK)
       return Response(serializer.errors)
   
@api_view(['POST','PUT'])
def user_update(request):
    username = request.data["phone"]
    if request.method=='PUT':
        try:
            u = User.objects.get(phone = username)
        except User.DoesNotExist:
            return Response({"status":0})
        serializer = UserSerializer(u,data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(data="updated",status=status.HTTP_200_OK)
        else :
            return Response(serializer.errors)

@api_view(['GET'])
def get_favorite_pet_ids(request, user_id):
    try:
        # Get a list of pet IDs favorited by the user
        favorite_pet_ids = FavPet.objects.filter(userid=user_id).values_list('pet_id', flat=True)

        # Convert the queryset to a list
        favorite_pet_ids = list(favorite_pet_ids)

        return Response({'favorite_pet_ids': favorite_pet_ids})
    
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
@api_view(['POST'])
def create_pet(request,user):
    pet_data = request.data
    picture = request.FILES.get('picture')
    pet = Pet(
        name=pet_data['name'],
        breed=pet_data['breed'],
        age =pet_data['age'],
        weight =pet_data['weight'],
        special_needs = pet_data['special_needs'],
        gender = pet_data['gender'],
        description =pet_data['description'],
        userid = user,
        picture=picture  
    )

    pet.save()

    return Response({'message': 'Pet created successfully'}, status=status.HTTP_200_OK)



@api_view(['POST'])
def add_fav_pet(request):
    data = JSONParser().parse(request)
    print(data)
    userid = data.get('user')
    petid = data.get('pet')
    
    if FavPet.objects.filter(userid=userid, pet_id=petid).exists():
            return Response({'message': 'FavPet record already exists'}, status=status.HTTP_400_BAD_REQUEST)

        # Create a new FavPet record
    favpet = FavPet(userid=userid, pet_id=petid)
    favpet.save()

    return Response({'message': 'FavPet record created successfully'}, status=status.HTTP_201_CREATED)
    
@api_view(['POST'])
def remove_fav_pet(request):
    data = JSONParser().parse(request)
    userid = data.get('user')
    petid = data.get('pet')

    try:
        favpet = FavPet.objects.get(userid=userid, pet_id=petid)
        favpet.delete()
        return Response({'message': 'FavPet record removed successfully'}, status=status.HTTP_204_NO_CONTENT)
    except FavPet.DoesNotExist:
        return Response({'message': 'FavPet record does not exist'}, status=status.HTTP_404_NOT_FOUND)
    


@api_view(['POST'])
def add_adoption_record(request):
    if request.method == 'POST':
        userid = request.data.get('userid')
        petid = request.data.get('petid')
        reason = request.data.get('reason')
        
        if reason == "":
            return Response({'error': 'Reason is required'}, status=status.HTTP_400_BAD_REQUEST)
     
        else:
            if not Adoption.objects.filter(pet_id=petid,userid=userid):
                try:
                    current_date = timezone.now().strftime("%d-%m-%Y")
                    pet = Pet.objects.get(pk=petid)
                    pet_name = pet.name

                    adoption = Adoption.objects.create(
                        userid=userid,
                        pet_id=petid,
                        reason=reason,
                        status=False,
                        date=current_date,
                        pet_name=pet_name
                    )

                    return Response({'message': 'Adoption record created successfully'}, status=status.HTTP_200_OK)

                except Pet.DoesNotExist:
                    return Response({'message': 'Pet not found'}, status=status.HTTP_406_NOT_ACCEPTABLE)
            else:
                return Response({'message': 'Already Submitted Application'}, status=status.HTTP_226_IM_USED)

    return Response({'error': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def fetch_adoption_applications(request, user_id):
    if request.method == 'GET':
        try:
            adoption_applications = Adoption.objects.filter(userid=user_id)
            user = User.objects.get(phone=user_id)
            serializer = AdoptionSerializer(adoption_applications, many=True)
            data = {
                'username': user.name,
                'adoption_applications': serializer.data,
            }

            return Response(data, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
    return Response({'error': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def get_vet_users(request):
    if request.method == 'GET':
        vet_users = User.objects.filter(is_vet=True)
        serializer = UserSerializer(vet_users, many=True)
        return Response(serializer.data)
    

@api_view(['GET'])
def retrieve_services_for_vet(request, phone):
    try:
        # Assuming the phone field in User model corresponds to the vet's phone
        services = Services.objects.filter(vetid=phone)
        service_names = [service.name for service in services]  # Extract service names
        return Response(service_names)
    except Services.DoesNotExist:
        return Response({'error': 'Services not found for the vet'}, status=404)

    

@api_view(['GET'])
def list_all_slots_for_vet(request, vet_id):
    try:
        slots = Slot.objects.filter(vetid=vet_id)
        serializer = SlotSerializer(slots, many=True)
        return Response(serializer.data)
    except Slot.DoesNotExist:
        return Response({'error': 'Slots not found for the vet'}, status=404)



@api_view(['GET'])
def check_slot_status(request, date, slot_id,vet):
    try:
        # Find the AvailableSlot based on the provided date and slot_id
        slot = AvailableSlot.objects.get(vetid = vet, date=date, slotid=slot_id)
        slottime = Slot.objects.get(id=slot_id)
        if slot.status:
            
            return Response({'status': 'Booked'})
    
        else:
            slot.status = True
            slot.save()
            return Response({'status': 'Available','st_time' : slottime.start_time})
    except AvailableSlot.DoesNotExist:
        return Response({'status': 'Slot not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def book_appointment(request, date, slot_id,user,vet):
    response = requests.get(f'http://127.0.0.1:8000/slots/check/{date}/{slot_id}/{vet}')
    if response.status_code == 200:
        data = response.json()
        stat = data.get('status')
        slotst = data.get('st_time')

        if stat == 'Available':
            vet = User.objects.get(phone=vet)
            appointment = Appointments(vetid=vet,userid=user,time=slotst,date=date,medicalid=None,status=False,vetname=vet.name)
            appointment.save()
            
            return Response({'message': 'Appointment booked successfully'})
        elif stat == 'Booked':
            return Response({'message': 'Appointment slot is already booked'})
        else:
            return Response({'message': 'Unknown status'})
    elif response.status_code == 404:
        return Response({'message': 'Slot not found'}, status=status.HTTP_404_NOT_FOUND)
    else:
        # Handle other possible HTTP response codes
        return Response({'message': 'Error occurred'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
def past_appointments(request, user_id):
    str_Date = date.today().strftime('%d-%m-%Y')
    past_appointments = Appointments.objects.filter(userid=user_id)
    past_appointments_fulfilled = []

    for p in past_appointments:
        if datetime.strptime(p.date,'%d-%m-%Y') < datetime.strptime(str_Date,'%d-%m-%Y'):
            past_appointments_fulfilled.append(p)
    
    serializer = AppointmentsSerializer(past_appointments_fulfilled, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def upcoming_appointments(request, user_id):
    str_Date = date.today().strftime('%d-%m-%Y')
    past_appointments = Appointments.objects.filter(userid=user_id)

    past_appointments_fulfilled = []

    for p in past_appointments:
        if datetime.strptime(p.date,'%d-%m-%Y') > datetime.strptime(str_Date,'%d-%m-%Y'):
            past_appointments_fulfilled.append(p)
    
    serializer = AppointmentsSerializer(past_appointments_fulfilled, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def get_diagnoses_for_appointment(request, appointment_id):
    try:
        diagnoses = Medical.objects.filter(apptid=appointment_id)
        serializer = MedicalSerializer(diagnoses, many=True)
        return Response(serializer.data)
    except Appointments.DoesNotExist:
        return Response({'error': 'Appointment not found'}, status=404)
    
@api_view(['GET'])
def list_all_products(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def list_products(request, category_id):
    products = Product.objects.filter(category_id=category_id)
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def list_all_categories(request):
    categories = Category.objects.all()
    serializer = CategorySerializer(categories, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def find_product_by_id(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
        serializer = ProductSerializer(product)
        return Response(serializer.data)
    except Product.DoesNotExist:
        return Response({'error': 'Product not found'}, status=404)

@api_view(['GET'])
def find_products_by_category(request, category_id):
    products = Product.objects.filter(category_id=category_id)
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def search_products(request, keyword):
    products = Product.objects.filter(Q(name__icontains=keyword) | Q(description__icontains=keyword))
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def get_cart(request,user):

    cart_items = CartItem.objects.filter(userid=user)
    serializer = CartItemSerializer(cart_items, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def add_to_cart(request, product_id):
    user = request.user
    product = Product.objects.get(id=product_id)
    quantity = request.data.get('quantity', 1)  # Use request.data for DRF
    cart_item_data = {
        'user': user.id,
        'product': product.id,
        'quantity': quantity,
    }
    serializer = CartItemSerializer(data=cart_item_data)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'Item added to cart successfully'})
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def update_cart(request, user):
    try:
        cart_items_data = request.data.get('cart_items', [])
        for item_data in cart_items_data:
            item_id = item_data.get('id')
            quantity = item_data.get('quantity')
            
            try:
                cart_item = CartItem.objects.get(id=item_id, userid=user)
                cart_item.quantity = quantity
                cart_item.save()
            except CartItem.DoesNotExist:
                return Response({"error": f"Cart item with id {item_id} not found for the user."}, status=status.HTTP_404_NOT_FOUND)
        
        cart_items = CartItem.objects.filter(userid=user)
        serializer = CartItemSerializer(cart_items, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['DELETE'])
def remove_from_cart(request, cart_item_id):
    try:
        cart_item = CartItem.objects.get(id=cart_item_id)
    except CartItem.DoesNotExist:
        return Response({'message': 'Cart item not found'}, status=status.HTTP_404_NOT_FOUND)
    cart_item.delete()
    return Response({'message': 'Item removed from cart successfully'})

@api_view(['POST'])
def place_order(request,user,price):
    user_id = user
    order_items = request.data.get('order_items', [])
    total_price = price 
    order_items_data = []

    for item in order_items:
        product_id = int(item['id'])
        quantity = item['quantity']
        
        try:
            product = Product.objects.get(id=product_id)
            stock = int(product.stock)
            price = int(product.price)
            if  stock >= quantity:
                # Update product stock and calculate the item price
                stock -= quantity
                product.stock = str(stock)
                product.save()
                item_price = price * quantity
                total_price += item_price
                
                order_items_data.append({
                    'product_id': product_id,
                    'quantity': quantity,
                    'item_price': item_price
                })
            else:
                return Response({'error': 'Insufficient stock for one or more products.'}, status=status.HTTP_400_BAD_REQUEST)
        except Product.DoesNotExist:
            return Response({'error': f'Product with ID {product_id} not found.'}, status=status.HTTP_404_NOT_FOUND)
    

    new_order = NewOrders(userid=user_id,total=total_price,status=False)
    new_order.save()
    CartItem.objects.filter(userid=user_id).delete()
    return Response({'message': 'Order Places'}, status=status.HTTP_200_OK)

@api_view(['PUT'])
def complete_order(request, order_id):
    try:
        order = Order.objects.get(id=order_id)
    except Order.DoesNotExist:
        return Response({'error': 'Order not found.'}, status=status.HTTP_404_NOT_FOUND)
    
    order.status = 'Completed'
    order.save()
    
    return Response({'message': 'Order marked as completed.'})


@api_view(['GET'])
def get_orders(request, user):
    orders = NewOrders.objects.filter(userid = user) 
    serializer = NewOrderSerializer(orders, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)
    