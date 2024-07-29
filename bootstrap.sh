#! /bin/bash
# Install Podman if Docker is not available
if ! command -v podman &> /dev/null
then
    echo "Podman not found, installing..."
    sudo yum update -y
    sudo yum install -y podman
fi

# Build Docker image
echo "Building Docker image..."
sudo podman build -t app:v2 /tmp || { echo 'Failed to build Docker image'; exit 1; }

# Tag Docker image
echo "Tagging Docker image..."
sudo podman tag app:v2 docker.io/mahesh15/app:v2 || { echo 'Failed to tag Docker image'; exit 1; }

# Log in to Docker Hub
echo "Logging in to Docker Hub..."
echo "Mahesh@15041995" | sudo podman login docker.io --username mahesh15 --password-stdin || { echo 'Failed to log in to Docker Hub'; exit 1; }

# Push Docker image to Docker Hub
echo "Pushing Docker image..."
sudo podman push app:v2 docker.io/mahesh15/app:v2|| { echo 'Failed to push Docker image'; exit 1; }

# Pull Docker image
echo "Pulling Docker image..."
sudo podman pull mahesh15/app:v2 || { echo 'Failed to pull Docker image'; exit 1; }

# Run Docker container
echo "Running Docker container..."
sudo podman run -d -p 80:80 --name dazn mahesh15/app:v2 || { echo 'Failed to run Docker container'; exit 1; }
