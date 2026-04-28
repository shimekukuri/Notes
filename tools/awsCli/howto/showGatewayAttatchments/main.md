# awsCli How To - Show Gateway Attatchments 

## Abstract
```bash
aws ec2 describe-internet-gateways \
    --internet-gateway-ids $IGW_ID \
    --query 'InternetGateways[*].{ID:InternetGatewayId, VPC:Attachments[0].VpcId, State:Attachments[0].State}' \
    --output table
```

## Directory

## Useful Links

## Tags
