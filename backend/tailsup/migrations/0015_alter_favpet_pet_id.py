# Generated by Django 4.2.5 on 2023-09-23 19:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tailsup', '0014_favpet'),
    ]

    operations = [
        migrations.AlterField(
            model_name='favpet',
            name='pet_id',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]