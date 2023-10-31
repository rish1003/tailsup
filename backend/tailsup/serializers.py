from rest_framework import serializers
from .models import *

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'
        
class User2Serializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('is_vet', 'is_vendor', 'is_shelter')


class PetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pet
        fields = ['pet_id','userid','shelterid','name','breed','age','weight','special_needs','gender','description','picture','isFav']
    
class FavPetSerializer(serializers.ModelSerializer):
    class Meta:
        model = FavPet
        fields = '__all__' 
        
class AdoptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Adoption
        fields = '__all__' 
        
class ServicesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Services
        fields = '__all__' 
        
class SlotSerializer(serializers.ModelSerializer):
    class Meta:
        model = Slot
        fields = '__all__' 
        
class AvailableSlotSerializer(serializers.ModelSerializer):
    class Meta:
        model = AvailableSlot
        fields = '__all__' 
        
class AppointmentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointments
        fields = '__all__' 
class MedicalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medical
        fields = '__all__' 
        
        
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'

class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = '__all__' 
        
class CartItemSerializer(serializers.ModelSerializer):
    product_name = serializers.SerializerMethodField()
    product_price = serializers.SerializerMethodField()
    class Meta:
        model = CartItem
        fields = '__all__' 
    def get_product_name(self, obj):
        return obj.product.name if obj.product else None
    def get_product_price(self, obj):
        return obj.product.price if obj.product else None
    
class NewOrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewOrders
        fields = '__all__'