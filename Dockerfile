

# Stage 1: Build the Flutter web application
FROM ubuntu:22.04 AS build

# Install prerequisites
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Clone Flutter repository and set PATH
WORKDIR /app
RUN git clone https://github.com/flutter/flutter.git
ENV PATH="$PATH:/app/flutter/bin"

# Run flutter doctor and build the web app
RUN flutter doctor
COPY . /app/
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

