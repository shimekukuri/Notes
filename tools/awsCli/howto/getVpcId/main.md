# awsCli How To - Get Vpc Id

## Abstract
This is how you would get the vpc id of a vpc with a given name 

```bash
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=patientping" --query "Vpcs[0].VpcId" --output text)
echo "Using VPC: $VPC_ID"
```

Without the storage: 
```bash
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=patientping" --query "Vpcs[0].VpcId" --output text
```

## Directory

## Useful Links

## Tags
