FROM ubuntu:16.04

RUN apt-get update && apt-get install -y nginx apache2-utils fcgiwrap

RUN rm -f /var/www/html/* && mkdir -p /etc/nginx/ssl && touch /etc/nginx/.htpasswd && chown www-data:www-data /etc/nginx/.htpasswd
COPY ssl /etc/nginx/ssl
COPY ngx-default /etc/nginx/sites-available/default
RUN mkdir -p /var/www/scripts
COPY init /var/www
COPY upload /var/www/scripts
RUN chmod +x /var/www/init && chmod +x /var/www/scripts/upload
RUN chown -R www-data:www-data /var/www

EXPOSE 443
CMD spawn-fcgi -s /var/run/fcgiwrap.socket -u www-data -- /usr/sbin/fcgiwrap && nginx && tail -f /var/log/nginx/error.log /var/log/nginx/access.log | grep -v password
