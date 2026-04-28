# awsCli How To - Create Route Table

## Abstract
Create the Route and capture it into a var
```bash
RT_ID=$(aws ec2 create-route-table \
	--vpc-id $VPC_ID \
	--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=patientping-public-rt}]' \
	--query 'RouteTable.RouteTableId' \
	--output text)
```
Without the capture
```bash
aws ec2 create-route-table \
	--vpc-id $VPC_ID \
	--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=patientping-public-rt}]' \
	--query 'RouteTable.RouteTableId' \
	--output text
```

## Directory

## Useful Links

## Tags
