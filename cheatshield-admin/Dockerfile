# First Stage: Build
FROM ghcr.io/global-scholarship-services-indonesia/docker-base/laravel:main AS build

ARG ENV
ENV ENV=${ENV}

ARG DOTENV_PRIVATE_KEY
ENV DOTENV_PRIVATE_KEY=${DOTENV_PRIVATE_KEY}

# Set working directory
WORKDIR /var/www

# Copy only dependency files first to leverage caching
COPY composer.json composer.lock ./
COPY package.json bun.lockb ./

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts
RUN --mount=type=cache,id=bun,target=/root/.bun/install/cache bun install --frozen-lockfile
RUN curl -sfS https://dotenvx.sh/install.sh | sh

# Copy application files
COPY . .
COPY .env.${ENV} .env

# build deps
RUN bun run build

# Second Stage: Runtime
FROM ghcr.io/global-scholarship-services-indonesia/docker-base/laravel:main

# inject private key to decrypt dotenvx
ARG DOTENV_PRIVATE_KEY
ENV DOTENV_PRIVATE_KEY=${DOTENV_PRIVATE_KEY}

# Install dotenvx
RUN curl -sfS https://dotenvx.sh/install.sh | sh

# Set working directory
WORKDIR /var/www

# copy files
COPY --from=build /var/www .

RUN chown -R www-data:www-data /var/www/storage /var/www/public && \
    chmod -R 755 /var/www/storage

# Copy supervisor configuration
COPY ./docker/supervisor/supervisord.conf /etc/supervisord.conf

# Copy nginx configuration
COPY ./docker/nginx/nginx.conf /etc/nginx/sites-available/default

EXPOSE 80

CMD ["dotenvx", "run", "--", "./start.sh"]
