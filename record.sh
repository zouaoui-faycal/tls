#!/bin/bash

export IP=$(aws ec2 describe-network-interfaces --network-interface-ids $(aws ecs describe-tasks \
            --cluster tls \
            --tasks $(aws ecs list-tasks --cluster tls | jq -r '.taskArns[0]') | jq '.tasks[0].attachments[0].details[] | select(.name == "networkInterfaceId") | .value' -r ) \
            --query 'NetworkInterfaces[0].Association.PublicIp' | jq -r)


aws route53 change-resource-record-sets \
    --hosted-zone-id Z00187549JV95XL8MOGB \
    --change-batch "{
      \"Changes\": [
        {
          \"Action\": \"CREATE\",
          \"ResourceRecordSet\": {
            \"Name\": \"tls.wedreamteam.com\",
            \"Type\": \"A\",
            \"TTL\": 300,
            \"ResourceRecords\": [
              {
                \"Value\": \"$IP\"
              }
            ]
          }
        }
      ]
    }"