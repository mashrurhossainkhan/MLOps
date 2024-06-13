# MLOp

# Problem Statement:

Deploy an ML model using AWS services like EC2 and S3, and how to set up a CI/CD pipeline with GitHub Actions, Docker, and Kubernetes

# Prerequisites

1. EC2 Instance: An EC2 instance with Docker and Kubernetes installed.
2. GitHub Repository: ML model code is hosted.
3. Docker: Installed on EC2 instance.
4. Kubernetes Cluster: Set up Kubernetes (EKS on AWS is a good choice).

# Step 1: Set Up an EC2 Instance

o Create an EC2 instance with a suitable instance type (e.g., For training deep learning models, P3 and P4 instances are ideal due to their powerful GPUs and large memory. For deploying models and running inferences, G4 and G5 instances are more cost-effective and sufficient.).
o SSH into your EC2 instance.

Install docker:

```sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker ${USER}
```

Install kubectl:

```sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker ${USER}
```

configure AWS ALI:

```
sudo apt-get install awscli -y
aws configure
```

# Step 2: Create a Dockerfile

```
FROM python:3
COPY . /MLmodel
WORKDIR /MLmodel
RUN pip install -r requirements.txt
CMD ["python", "decisiontreeclassifier.py"]
```

# Step 3: Create k8s-deployment.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: decisiontreeclassifier-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: decisiontreeclassifier-app
  template:
    metadata:
      labels:
        app: decisiontreeclassifier-app
    spec:
      containers:
        - name: decisiontreeclassifier-container
          image: <docker-image>:latest
          ports:
            - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: decisiontreeclassifier-service
spec:
  selector:
    app: decisiontreeclassifier-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer
```

here, using LoadBalancer can help to handle higher loads and provides fault tolerance.

# Step 4: Set Up GitHub Actions for CI/CD

.github/workflows/ci-cd-pipeline.yml

```
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3'

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Build Docker image
        run: docker build -t your-docker-image:${{ github.sha }} .

      - name: Log in to Docker Hub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Push Docker image
        run: docker push your-docker-image:${{ github.sha }}

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-west-2

      - name: Update Kubernetes deployment
        run: |
          aws eks update-kubeconfig --name your-eks-cluster
          kubectl set image deployment/decisiontreeclassifier-deployment decisiontreeclassifier-container=your-docker-image:${{ github.sha }}

```

Then Add the secrets to github:
Add the following secrets under "Settings" > "Secrets" > "Actions":

```
DOCKER_USERNAME:  Docker Hub username.
DOCKER_PASSWORD:  Docker Hub password.
AWS_ACCESS_KEY_ID: Yur AWS access key ID.
AWS_SECRET_ACCESS_KEY:  AWS secret access key.
```

# Step 5: Deploy to Kubernetes

In EC2 instance's CLI:

```
aws eks update-kubeconfig --name your-eks-cluster

```

Deploy initial Kubernetes resources using the k8s-deployment.yaml file

```
kubectl apply -f k8s-deployment.yaml

```
