# Generated by Django 4.2.5 on 2023-09-24 10:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tailsup', '0018_remove_adoption_shelterid_adoption_reason'),
    ]

    operations = [
        migrations.AddField(
            model_name='adoption',
            name='date',
            field=models.CharField(default='', max_length=500),
        ),
    ]
