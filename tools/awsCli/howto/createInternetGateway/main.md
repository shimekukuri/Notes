# awsCli How To - Create an Internet Gateway

## Abstract
This also returns the id of the InternetGateway
```bash
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=patientping-igw}]' --query InternetGateway.InternetGatewayId --output text
```
which can be captured like so: 

```bash
IGW_ID=$(aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=patientping-igw}]' --query InternetGateway.InternetGatewayId --output text)
```

## Directory

## Useful Links

## Tags
