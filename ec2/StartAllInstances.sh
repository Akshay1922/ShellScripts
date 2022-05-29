# Start All instances which are in stopped state
REGION_NAME=$1
if [ $REGION_NAME = ""]; then
    REGION_NAME="ap-south-1"
fi
Instance_Count=$(aws ec2 describe-instances --region $REGION_NAME --query 'Reservations[*].Instances[*].[InstanceId]' --output text | wc -l)
a=0
echo "Total number of instances in $REGION_NAME is $Instance_Count"
while [ $a -lt $Instance_Count ]
    do
        #echo $a
        qry_Instance_id='Reservations['$a'].{ID:[Instances][0][0].[InstanceId][0]}'
        qry_Instance_state='Reservations['$a'].{state:[Instances][0][0].[State][0].[Name][0]}'
        Instance_id=$(aws ec2 describe-instances --region $REGION_NAME --query $qry_Instance_id --output text)
        Instance_state=$(aws ec2 describe-instances --region $REGION_NAME --query $qry_Instance_state --output text)

        if [ $Instance_state != "running" ]; then
            output=$(aws ec2 start-instances --instance-ids $Instance_id --query 'StartingInstances[*].CurrentState[].Name' --output text)
            echo "Now $Instance_id this instance going in $output state"
        else
            echo "$Instance_id this instance is Already started"
        fi
        a=`expr $a + 1`
    done