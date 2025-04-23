FROM ubuntu:latest
#Update and install nginx (web server) and stress (will be used to stress the cpu)
RUN apt-get update && apt-get install -y nginx stress
# Create a custom index.html
RUN echo "<h1>Hello from my DEPI Web</h1>" > /var/www/html/index.html
# Modify the default site config
RUN sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-available/default
RUN sed -i 's/listen [::]:80 default_server;/listen [::]:8080 default_server;/' /etc/nginx/sites-available/default
# Expose port 8080 
EXPOSE 8080
# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]