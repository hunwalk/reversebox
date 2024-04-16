FROM node:21-bookworm

# free up 1000 for home user
RUN groupmod -g 1001 node && usermod -u 1001 -g 1001 node

# resolve permission issues
RUN useradd -G www-data,root -u 1000 -d /home/hunwalk hunwalk

# Set working directory
WORKDIR /home/hunwalk

# Copy existing application directory contents
USER hunwalk

COPY . .