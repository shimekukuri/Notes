# awsCli How To - Run Instances 

## Abstract
```bash
aws ec2 run-instances \
--image-id $AZL_ID \
--count 1 \
--instance-type t3.micro \
--key-name "patientping-key" \
--security-group-ids $SG_ID \
--subnet-id $PUBLIC_A_ID \
--no-associate-public-ip-address \
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=patientping-web}]"
```

## Directory

## Useful Links

## Tags
