# Generated by Django 4.2.5 on 2023-09-16 14:53

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tailsup', '0002_adoption_appointments_category_medical_order_product_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='product',
            name='amount',
            field=models.CharField(default='', max_length=4),
        ),
        migrations.AddField(
            model_name='product',
            name='unit',
            field=models.CharField(default='', max_length=4),
        ),
    ]