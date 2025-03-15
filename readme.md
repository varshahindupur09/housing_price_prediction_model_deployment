cd terraform-eks 
terraform init  
terraform apply

aws eks update-kubeconfig --name hppmodelapp-eks-cluster --region us-east-1
Updated context arn:aws:eks:us-east-1:381491906666:cluster/hppmodelapp-eks-cluster in /Users/varshahindupur/.kube/config

cat ~/.kube/config

aws eks update-kubeconfig --name hppmodelapp-eks-cluster --region us-east-1

aws sts get-caller-identity

aws eks update-kubeconfig --name hppmodelapp-eks-cluster --region us-east-1 --role-arn arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-role

kubectl get nodes

aws sts assume-role --role-arn arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-role --role-session-name eks-session



error:
An error occurred (AccessDenied) when calling the AssumeRole operation: User: arn:aws:sts::381491906666:assumed-role/hppmodelapp-eks-cluster-role/eks-session is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-role/eks-session
E0313 21:22:27.094716    3484 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://F3AD61BE789AC51B07CA4EAA6596DED8.gr7.us-east-1.eks.amazonaws.com/api?timeout=32s\": getting credentials: exec: executable aws failed with exit code 254"
Unable to connect to the server: getting credentials: exec: executable aws failed with exit code 254


(.venv) (base) varshahindupur@Varshas-MacBook-Air terraform-eks % kubectl get nodes
E0313 21:22:13.121927    3447 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server has asked for the client to provide credentials"


-----

aws sts get-caller-identity

new token
aws sts assume-role --role-arn "arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-20250314012359529900000002" --role-session-name eks-session
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

aws sts get-caller-identity
aws sts assume-role --role-arn "arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-20250314012359529900000002" --role-session-name eks-session

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=

env | grep AWS

aws sts get-caller-identity


nano ~/.aws/config

[profile my-eks-profile]
sso_start_url = https://d-9067cb5282.awsapps.com/start 
sso_region = us-east-1
sso_account_id = 381491906666
sso_role_name = AdministratorAccess

aws configure sso

add sessionname, start url, region, registration scopes from IAM Identity center by creating username

aws eks update-kubeconfig --name hppmodelapp-eks-cluster --region us-east-1

check if role is mapped to aws cluster:
kubectl get configmap -n kube-system aws-auth -o yaml

kubectl edit configmap aws-auth -n kube-system

retry:
aws sts assume-role --role-arn "arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-20250314012359529900000002" --role-session-name eks-session

aws eks update-kubeconfig --name hppmodelapp-eks-cluster --region us-east-1 --role-arn arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-cluster-20250314012359529900000002

kubectl config view --minify

aws eks describe-cluster --name hppmodelapp-eks-cluster --query cluster.roleArn

had to go to console to add the manage access and add entry for the cluster role

kubectl get pods -A

kubectl get deployments -A

aws iam list-roles --query "Roles[?RoleName=='AWSServiceRoleForAmazonEKS'].RoleName"

[
    "AWSServiceRoleForAmazonEKS"
]
[cloudshell-user@ip-10-140-127-72 ~]$ 

kubectl apply -f deployment.yaml 

kubectl get services -A

kubectl get all -A

deploying test app:
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

kubectl get pods


curl -X POST "http://<EXTERNAL-IP>:5001/predict" \
     -H "Content-Type: application/json" \
     -d '{"sqft": 1500, "location": "New York", "bedrooms": 3, "bathrooms": 2}'

kubectl describe deployment house-price-prediction-app-deployment

aws eks list-nodegroups --cluster-name hppmodelapp-eks-cluster

aws eks update-nodegroup-config --cluster-name hppmodelapp-eks-cluster --nodegroup-name default-20250314013455925700000015 --scaling-config minSize=1,maxSize=3,desiredSize=2

kubectl describe nodes


ecr:
aws ecr create-repository --repository-name hpp-app --region us-east-1
381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app
381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 381491906666.dkr.ecr.us-east-1.amazonaws.com

docker build -t hpp-app:latest .

docker images | grep hpp-app

docker tag hpp-app:latest 381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest

docker push 381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest

add image in deployment.yaml and run: kubectl apply -f deployment.yaml

kubectl set image deployment/house-price-prediction-app-deployment house-price-prediction-container=381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest --record

kubectl get pods -A

(.venv) (base) varshahindupur@Varshas-MacBook-Air model_deployment % aws iam attach-role-policy \
  --role-name default-eks-node-group-20250204221544500500000002 \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

(.venv) (base) varshahindupur@Varshas-MacBook-Air model_deployment % aws iam attach-role-policy \
  --role-name default-eks-node-group-20250314012359530800000003 \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

kubectl set image deployment/house-price-prediction-app-deployment house-price-prediction-container=381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest --record

kubectl edit deployment house-price-prediction-app-deployment

kubectl delete pod -n kube-system -l k8s-app=kube-proxy

clear's docker's cache:
docker builder prune --force
docker system prune -a --volumes --force

docker buildx build --platform linux/amd64 --load -t 381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest .

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 381491906666.dkr.ecr.us-east-1.amazonaws.com
docker push 381491906666.dkr.ecr.us-east-1.amazonaws.com/hpp-app:latest



