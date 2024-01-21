#!/bin/bash

# Update the ECS task using the AWS CLI
                  
update_task_command="aws ecs  update-service --cluster tls --service tls-svc --force-new-deployment --output json --no-cli-pager"
echo "restart task"
echo $update_task_command 
$update_task_command 

sleep 20

# Wait for the task to reach the "RUNNING" status
while true; do
    task_status=$(aws ecs describe-tasks --cluster tls --tasks $(aws ecs list-tasks --cluster tls | jq  '.taskArns[0]' -r) --query 'tasks[0].lastStatus' --output text)

    if [ "$task_status" == "RUNNING" ]; then
        echo "Task is now in RUNNING state."
        break
    elif [ "$task_status" == "STOPPED" ]; then
        echo "Task is in STOPPED state. Something went wrong."
        exit 1
    else
        echo "Task is still in $task_status state. Waiting..."
        sleep 5
    fi
done

echo "Update and wait process completed."
