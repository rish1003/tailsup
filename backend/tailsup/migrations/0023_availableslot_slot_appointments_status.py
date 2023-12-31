# Generated by Django 4.2.5 on 2023-09-25 11:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tailsup', '0022_cartitem'),
    ]

    operations = [
        migrations.CreateModel(
            name='AvailableSlot',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('vetid', models.CharField(max_length=10)),
                ('date', models.DateField()),
                ('slotid', models.IntegerField()),
                ('status', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='Slot',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('vetid', models.CharField(max_length=10)),
                ('start_time', models.TimeField()),
                ('end_time', models.TimeField()),
            ],
        ),
        migrations.AddField(
            model_name='appointments',
            name='status',
            field=models.BooleanField(default=False),
        ),
    ]
