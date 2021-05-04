FROM nginx:1.14

# Install curl for health check
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl

# Configure NGINX
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy static files
COPY css /var/www/html/css
COPY img /var/www/html/img
RUN chown -R nginx:nginx /var/www/html

HEALTHCHECK --interval=15s --timeout=10s --start-period=60s --retries=2 CMD curl -f http://127.0.0.1/health-check.php || exit 1
