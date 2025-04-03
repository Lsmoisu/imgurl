FROM  php:7.1-apache
RUN apt-get update && apt-get install -y wget libjpeg-dev  libpng-dev libfreetype6-dev libmagickwand-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    # ImageMagick
    && pecl install http://pecl.php.net/get/imagick-3.4.3.tgz \
    # Rewrite
    && sed -i '166s/None/All/g' /etc/apache2/apache2.conf \
    && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

# Ext
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd && docker-php-ext-enable imagick


# Application
ENV IMAGE_VERSION=latest
COPY . /var/www/html
RUN chmod a+w /var/www/html/imgs /var/www/html/data \
    && chown -R www-data:www-data /var/www/html/
USER www-data
VOLUME ["/var/www/html/data","/var/www/html/imgs"]

CMD ["apache2-foreground"]
