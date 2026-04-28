# awsCli How To - Create A New Security Group

## Abstract
```bash
SG_ID=$( aws ec2 create-security-group \
--description "Empty Security Group" \
--group-name "patientping-empty" \
--vpc-id $VPCID \
--query "GroupId" \
--output text)
```

## Directory

## Useful Links

## Tags
