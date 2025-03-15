# 🏡🏗️ Overview
This project deploys a House Price Prediction Model using AWS EKS, Terraform, Docker, and Kubernetes.
The model is served as a Flask API, exposed via a LoadBalancer service.

## 🚀 Deployment Steps
### 1️⃣ Set Up AWS CLI & Authentication
Make sure AWS CLI is installed and authenticated:
```
aws configure
```

Alternatively, if using AWS SSO, run:
```
aws sso login --profile my-eks-profile
```

Check your IAM User Permissions:
```
aws sts get-caller-identity
```
If unauthorized, ensure your IAM role has access to sts:AssumeRole.

### Set Up Terraform for AWS EKS
#### Initialize Terraform and apply the configuration:
```
terraform init
terraform plan
terraform apply -auto-approve
```
P.S. If you see IAM Role errors, ensure the user has sts:AssumeRole permission.

### 3️⃣ Configure kubectl for EKS Cluster
#### After Terraform completes, update kubectl to use the EKS cluster:

```
aws eks update-kubeconfig --name <name of EKS cluster> --region us-east-1 --role-arn <arn of the role created>
```

#### Check if the nodes are up and running:
```
kubectl get nodes
kubectl describe nodes
```

#### If nodes are NotReady, check node group details:
```
aws eks describe-nodegroup --cluster-name hppmodelapp-eks-cluster --nodegroup-name trial-nodes --query "nodegroup.nodeRole" --output text
```

### 4️⃣ Build & Push Docker Image to AWS ECR
#### Create ECR Repository:
```
aws ecr create-repository --repository-name hpp-app --region us-east-1
```

#### Authenticate Docker with AWS ECR:
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 381491906666.dkr.ecr.us-east-1.amazonaws.com
```

#### Build & Push Image:
```
docker buildx build --platform linux/amd64 --load -t 381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest .
docker push 381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest
```

#### Check if the image is available:
```
aws ecr describe-images --repository-name hpp-app --region us-east-1
```

### 5️⃣ Deploy Kubernetes Resources
#### Apply Deployment & Service:
```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

#### Check pods & service:
```
kubectl get pods -A
kubectl get services
```

P.S. Common Issue: ImagePullBackOff
Fix: Ensure the node IAM role has permissions to pull images from ECR:
```
aws iam attach-role-policy --role-name default-eks-node-group --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
```

### 6️⃣ Testing the API
#### Find the LoadBalancer URL:
```
kubectl get services
```

#### Send a POST request with sample data:
```
curl -X POST "http://<EXTERNAL-IP>:5001/predict" \
     -H "Content-Type: application/json" \
     --data '{"features":[60, 8450, 5, 2003, 2003, 0, 856, "RL", "Inside", "1Fam", "VinylSd"]}'
```

OR Alternatively, test using Python:
```
python3.12 tests/test2.py
```

#### Issues fixed
| Issue | Cause | Fix |
|-------|-------|-----|
| `Unauthorized` error in `kubectl` commands | IAM role does not have cluster access | Add IAM role in `aws-auth` config map |
| `ImagePullBackOff` | Node cannot pull image from ECR | Attach `AmazonEC2ContainerRegistryReadOnly` policy to node IAM role |
| `exec /usr/local/bin/flask: exec format error` | Image built for the wrong architecture | Build with `--platform linux/amd64` |
| `400 Bad Request: Failed to decode JSON` | Incorrect JSON formatting in request | Ensure `--data` uses valid JSON |
| `Push declined due to repository rule violations` | Secrets detected in Git push | Remove secrets and rewrite commit history |
| `ErrImageNeverPull` | Image tag or repo mismatch in Kubernetes | Verify ECR image and deployment manifest |
| `CrashLoopBackOff` | App keeps restarting due to an error | Check logs via `kubectl logs -l app=model_deployment_hpp --tail=50` |


# Deployment Screenshots (Terminal)
<img width="1195" alt="image" src="https://github.com/user-attachments/assets/526143fe-1f83-48ad-8b56-4f0240bb9ee3" />

<img width="1185" alt="image" src="https://github.com/user-attachments/assets/5dff4c61-e35f-4bbd-a0b0-90eae7246d95" />

<img width="660" alt="image" src="https://github.com/user-attachments/assets/5c21dad4-6588-4702-a591-fa5fde861840" />

