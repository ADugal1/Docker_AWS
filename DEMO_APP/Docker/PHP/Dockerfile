FROM php:7.3-fpm-stretch

# Configure PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql

# Copy PHP files
COPY *.php /var/www/html/
COPY lib /var/www/html/lib
RUN chown -R www-data:www-data /var/www/html

HEALTHCHECK --interval=15s --timeout=10s --start-period=60s --retries=2 CMD curl -f http://127.0.0.1/health-check.php || exit 1
