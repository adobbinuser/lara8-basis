FROM php:7.3-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libzip-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxpm-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    ffmpeg \
    cron \
    mc \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo \
    pdo_mysql \
    mbstring \
    zip \
    exif \
    pcntl

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-freetype-dir
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer

# Copy existing application directory contents
COPY ./ /application

# Set working directory
WORKDIR /application

RUN (crontab -l ; echo "* * * * * /usr/local/bin/php /application/artisan schedule:run >>/dev/null 2>&1") | crontab

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD service cron start; php-fpm;
