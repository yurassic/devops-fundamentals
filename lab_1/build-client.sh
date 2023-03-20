#!/bin/bash

# Set environment variable for app configuration
ENV_CONFIGURATION="production"

# Check if client-app.zip exists, and remove it if it does
if [ -f "dist/client-app.zip" ]; then
  rm dist/client-app.zip
fi

# Install app dependencies
npm install

# Build the client app with the specified configuration
ng build --configuration=$ENV_CONFIGURATION

# Compress built content/files into client-app.zip file in dist folder
zip -r dist/client-app.zip dist/*
