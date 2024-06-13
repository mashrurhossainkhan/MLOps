# MLOp

# Problem Statement:

Deploy an ML model using AWS services like EC2 and S3, and how to set up a CI/CD pipeline with GitHub Actions, Docker, and Kubernetes

# Prerequisites

1. EC2 Instance: An EC2 instance with Docker and Kubernetes installed.
2. S3 Bucket: Used for storing video data.
3. GitHub Repository: ML model code is hosted.
4. Docker: Installed on EC2 instance.
5. Kubernetes Cluster: Set up Kubernetes (EKS on AWS is a good choice).

# Step 1: Set Up an S3 Bucket

Create an S3 Bucket to store the Video data

# Step 2: Set Up an EC2 Instance

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
`.
```

Install kubectl:

```sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker ${USER}
`.
```

configure AWS ALI:

```
sudo apt-get install awscli -y
aws configure
```
