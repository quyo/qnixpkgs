
ARG PHP_BASE_IMAGE


FROM ${PHP_BASE_IMAGE}

# RUN apk add --update --no-cache freetype freetype-dev libjpeg-turbo libjpeg-turbo-dev libpng libpng-dev libwebp libwebp-dev \
#  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
#  && docker-php-ext-install -j$(nproc) gd \
#  && apk del --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev


# Use the default configuration
ARG PHP_MODE
RUN mv "$PHP_INI_DIR/php.ini-$PHP_MODE" "$PHP_INI_DIR/php.ini"

# The default config can be customized by copying configuration files into the $PHP_INI_DIR/conf.d/ directory.
COPY php.ini-custom "$PHP_INI_DIR/conf.d/zzz-custom.ini"


COPY www /srv
