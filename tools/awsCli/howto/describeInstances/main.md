# awsCli How To - Describe Instances

## Abstract
```bash
aws ec2 describe-instances \
	--filters "Name=tag:Name,Values=patientping-web" \
	--query 'Reservations[*].Instances[*].{ID:InstanceId, State:State.Name, PrivateIP:PrivateIpAddress}' \
	--output table
```

## Directory

## Useful Links

## Tags
