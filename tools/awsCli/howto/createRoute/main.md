# awsCli How To - Create Route 

## Abstract
create a route and set the CIDR
```bash
aws ec2 create-route \
	--route-table-id $RT_ID \
	--destination-cidr-block 0.0.0.0/0 \
	--gateway-id $IGW_ID

```
## Directory

## Useful Links

## Tags
