# awsCli How To - Get Route Table Routes and Associations

## Abstract
```bash
aws ec2 describe-route-tables \
	--route-table-ids $RT_ID \
	--query 'RouteTables[*].{Routes:Routes, Associations:Associations[*].SubnetId}' \
	--output json

```

## Directory

## Useful Links

## Tags
