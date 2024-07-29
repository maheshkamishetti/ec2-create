# Use AlmaLinux as the base image
FROM almalinux:latest

# Install Nginx
RUN yum update -y && \
    yum install -y nginx && \
    yum clean all

# Remove the default index.html file
RUN rm -rf /usr/share/nginx/html/index.html

# Copy your custom index.html into the container
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to allow external access
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

