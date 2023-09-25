from django.db import models
class FileField(models.FileField):
    def value_to_string(self,obj):
        return obj.file.url
    
class User(models.Model): 
    phone = models.CharField(max_length=10,primary_key=True)
    name = models.CharField(max_length=200)
    email = models.EmailField()
    password = models.CharField(max_length=20)
    address = models.CharField(max_length=500)
    pincode = models.CharField(max_length=8)
    is_vet = models.BooleanField(default=False)
    is_vendor = models.BooleanField(default=False)
    is_shelter = models.BooleanField(default=False)
    num_pets = models.IntegerField(null=True,blank=True)
    picture = FileField(null=True)
    def __str__(self) -> str:
        return self.name

class Pet(models.Model): 
    pet_id = models.AutoField(primary_key=True)
    userid = models.CharField(max_length=10,null=True,blank=True)
    shelterid = models.CharField(max_length=10,null=True,blank=True)
    name = models.CharField(max_length=100,default='')
    breed = models.CharField(max_length=100,default='golden')
    age = models.CharField(max_length=2,default='0')
    weight = models.CharField(max_length=3,default='0')
    special_needs = models.CharField(max_length=500,null=True,blank=True)
    gender = models.CharField(default='M',
        max_length=50,
        choices=[('Male', 'M'),('Female', 'F'),],)
    description = models.CharField(max_length=500,default='')
    picture = FileField(null=True)
    isFav = models.BooleanField(default=False)
    def __str__(self) -> str:
        return str(self.pet_id )+ self.name
    
class FavPet(models.Model): 
    favpetid = models.AutoField(primary_key=True)
    pet_id = models.IntegerField(null=True,blank=True)
    userid = models.CharField(max_length=10,null=True,blank=True)
    def __str__(self) -> str:
        return str(self.pet_id )
    
class Adoption(models.Model):
    id = models.AutoField(primary_key=True)
    userid = models.CharField(max_length=10,default='')
    pet_id = models.IntegerField(default='')
    pet_name = models.CharField(max_length=100,default='')
    reason = models.CharField(max_length=500,default='')
    date = models.CharField(max_length=50,default='')
    status = models.BooleanField(default=False)
    

    
class Medical(models.Model):
    id = models.AutoField(primary_key=True)
    pet_id = models.IntegerField(default='')
    userid = models.CharField(max_length=10,default='')
    vetid = models.CharField(max_length=10,null=True)
    date = models.CharField(max_length=50,default='')
    diagnosis = models.CharField(max_length=500,default='')
    treatment = models.CharField(max_length=500,default='')
    report = FileField(null=True)
    apptid = models.CharField(max_length=50,default='',null=True)
    
class Services(models.Model):
    id = models.AutoField(primary_key=True)
    vetid = models.CharField(max_length=10,default='')
    name =  models.CharField(max_length=200,default='')
    def __str__(self) -> str:
        return self.name

class Slot(models.Model):
    id = models.AutoField(primary_key=True)
    vetid = models.CharField(max_length=10)
    start_time = models.TimeField()
    end_time = models.TimeField()
    
    
class AvailableSlot(models.Model):
    vetid = models.CharField(max_length=10)
    date = models.CharField(max_length=20)
    slotid = models.IntegerField()
    status = models.BooleanField(default=False)
    
class Appointments(models.Model):
    id = models.AutoField(primary_key=True)
    vetid = models.CharField(max_length=10,default='')
    userid = models.CharField(max_length=10,default='')
    vetname = models.CharField(max_length=200,default='')
    petid = models.IntegerField(default='')
    time = models.TimeField()
    date = models.CharField(max_length=20)
    medicalid = models.IntegerField(null=True,blank=True)
    status = models.BooleanField(default=False)
    
class Category(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100,default='')
    picture = FileField(null=True)
    def __str__(self) -> str:
        return str(self.id) +" "+ self.name
    
class Product(models.Model):
    id = models.AutoField(primary_key=True)
    category_id = models.IntegerField(default='')
    vendor_id = models.CharField(max_length=10,default='')
    name = models.CharField(max_length=100,default='')
    description = models.CharField(max_length=500,default='')
    stock = models.CharField(max_length=4,default='')
    unit = models.CharField(max_length=4,default='',null=True,blank=True)
    amount = models.CharField(max_length=4,default='',null=True,blank=True)
    price = models.CharField(max_length=6,default='')
    picture = FileField(null=True)
    def __str__(self) -> str:
        return str(self.id) +" "+ self.name
    
class Order(models.Model):
    id = models.AutoField(primary_key=True)
    userid = models.CharField(max_length=10,default='')
    productid = models.IntegerField(default='')
    status = models.BooleanField(default=False)


class CartItem(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)

    def __str__(self):
        return f"{self.user.username}'s Cart Item: {self.product.name}"