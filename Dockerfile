# Imagen base de PHP con Apache
FROM php:8.1-apache

# Instala extensiones necesarias para Laravel
RUN apt-get update && apt-get install -y \
    zip unzip curl libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configura el directorio de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto
COPY . .

# Configura permisos para Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Instala las dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Expone el puerto 80
EXPOSE 80

# Comando de inicio
CMD php artisan key:generate && php artisan config:cache && apache2-foreground
