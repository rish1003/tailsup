# Generated by Django 4.2.5 on 2023-09-22 14:00

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tailsup', '0008_pet_picture_alter_category_picture_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='num_pets',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]
