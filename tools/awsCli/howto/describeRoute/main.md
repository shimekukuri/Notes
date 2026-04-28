# awsCli How To - Get Route Table Id

## Abstract
```bash
RT_ID=$(aws ec2 describe-route-tables \
    --filters "Name=tag:Name,Values=patientping-public-rt" "Name=vpc-id,Values=$VPC_ID" \
    --query 'RouteTables[0].RouteTableId' \
    --output text)
```

## Directory

## Useful Links

## Tags
