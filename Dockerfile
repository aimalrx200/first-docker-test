# Use a Node.js base image for building the React application
FROM node:20-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application for production
RUN npm run build

# Use a lightweight NGINX image to serve the static files
FROM nginx:alpine

# Copy the built React app from the 'build' stage into NGINX's public directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Command to start NGINX when the container runs
CMD ["nginx", "-g", "daemon off;"]