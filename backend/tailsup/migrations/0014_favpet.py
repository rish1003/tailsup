# Generated by Django 4.2.5 on 2023-09-23 19:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tailsup', '0013_delete_favpets'),
    ]

    operations = [
        migrations.CreateModel(
            name='FavPet',
            fields=[
                ('favpetid', models.AutoField(primary_key=True, serialize=False)),
                ('pet_id', models.CharField(blank=True, max_length=10, null=True)),
                ('userid', models.CharField(blank=True, max_length=10, null=True)),
            ],
        ),
    ]
