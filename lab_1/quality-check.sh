#!/bin/bash

# Run linting tool
ng lint

# Run unit tests
ng test

# Check for vulnerabilities with npm audit
npm audit

# If any of the previous commands returned a non-zero exit code, report an error
if [ $? -ne 0 ]; then
  echo "The client app has problems with its quality."
  exit 1
fi

# If all commands completed successfully, report success
echo "The client app passed all quality checks."