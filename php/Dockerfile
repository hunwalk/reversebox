ARG PHP_TAG
FROM ${PHP_TAG}

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    curl


RUN docker-php-ext-install pdo_mysql zip bcmath

# Get latest Composer

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -d /home/hunwalk hunwalk

# Set working directory
WORKDIR ${HOME_MOUNT}

# Copy existing application directory contents
USER hunwalk

COPY . .

