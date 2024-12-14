#!/bin/bash

php artisan optimize
php artisan config:clear
php artisan config:cache

/usr/bin/supervisord -n -c /etc/supervisord.conf
