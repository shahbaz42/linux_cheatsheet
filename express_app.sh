#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <repository_name>"
    exit 1
fi

repository_name="$1"

echo "Creating directory $repository_name..."
mkdir "$repository_name"

echo "Changing directory to $repository_name..."
cd "$repository_name" || exit 1

echo "Creating app.js file..."
touch app.js

echo "Creating package.json file..."
npm init -y

echo "Creating necessary directories..."
mkdir src
mkdir src/controllers
mkdir src/models
mkdir src/routes
mkdir src/utils
mkdir src/services

# Check if "type" field is present in package.json
if ! grep -q '"type":' package.json; then
    echo "Making package type module in package.json..."
    sed -i '1s/{/{\n  "type": "module",/' package.json
fi

echo "Adding start script in package.json..."
sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"start": "node app.js"/' package.json

echo "Creating necessary files..."
touch .env
echo "node_modules" > .gitignore

echo "Writing the boilerplate code in app.js"
echo "import express from 'express';
import dotenv from 'dotenv';
dotenv.config();
const PORT = process.env.PORT || 8000;

const app = express();

app.get('/', (req, res) => {
    res.send('Server is up and running!');
});

app.listen(PORT, () => {
    console.log(\`Server is running on port \${PORT}\`);
});" > app.js

echo "Writing the code in .env file"
echo "PORT=8000" > .env

echo "Installing necessary packages..."
npm i express dotenv

echo "Initializing git..."
git init

echo "Running the application..."
npm start
