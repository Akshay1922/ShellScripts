aws ec2 describe-instances --query 'Reservations[0].[Instances][0][0]{ID:InstanceId,ImageID:ImageId,state:State[Name]}'
aws ec2 describe-instances --query 'Reservations[0].[Instances].[*].{ID:InstanceId,ImageID:ImageId,state:State[Name]}'
aws ec2 describe-instances --query 'Reservations[0].[Instances].[AmiLaunchIndex].{ID:InstanceId,ImageID:ImageId,state:State[Name]}'

$ aws ec2 describe-instances --query 'Reservations[*].{ID:[Instances][0][0].[InstanceId],ImageID:[Instances][0][0].[ImageId],state:[Instances][0][0].[State].[Name]}'

aws ec2 describe-instances --query 'Reservations[*].{[Instances][0][0].{ID:InstanceId,ImageID:ImageId}}'

final query
aws ec2 describe-instances --query 'Reservations[*].{ID:[Instances][0][0].[InstanceId][0],ImageID:[Instances][0][0].[ImageId][0],state:[Instances][0][0].[State][0].[Name][0]}'

final query of start instance output
aws ec2 start-instances --instance-ids i-0fb212f2d8549fa29 --query 'StartingInstances[*].{ID:[CurrentState][0].[Name][0]}' --output text

aws ec2 describe-volumes --query 'Volumes[*].{ID:VolumeId,InstanceId:Attachments[0].InstanceId,AZ:AvailabilityZone,Size:Size}'

####  commands ###
aws ec2 start-instances --instance-ids i-0567a7bf61a724e76

{
    "StartingInstances": [
        {
            "CurrentState": {
                "Code": 0,
                "Name": "pending"
            },
            "InstanceId": "i-0567a7bf61a724e76",
            "PreviousState": {
                "Code": 80,
                "Name": "stopped"
            }
        }
    ]
}

state=$(aws ec2 start-instances --instance-ids $Instance_id --query 'StartingInstances[*].{ID:[CurrentState][0].[Name][0]}' --output text)

-cmd   aws ec2 start-instances --instance-ids i-0567a7bf61a724e76 --query 'StartingInstances[*].CurrentState[].Name' --output text
-output  pending

#######--------------------------------------------###############

aws ec2 create-vpc --cidr-block 10.100.0.0/16

{
    "Vpc": {
        "CidrBlock": "10.100.0.0/16",
        "DhcpOptionsId": "dopt-5EXAMPLE",
        "State": "pending",
        "VpcId": "vpc-0a60eb65b4EXAMPLE",
        "OwnerId": "123456789012",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [],
        "CidrBlockAssociationSet": [
            {
                "AssociationId": "vpc-cidr-assoc-07501b79ecEXAMPLE",
                "CidrBlock": "10.100.0.0/16",
                "CidrBlockState": {
                    "State": "associated"
                }
            }
        ],
        "IsDefault": false,
    }
}

VPC_ID=$(aws ec2 create-vpc --cidr-block 10.100.0.0/24 --query '{ID:Vpc.VpcId}' --output text)
-output  vpc-0a87f619f4b00912b

###############----------------------------------#################

aws ec2 create-subnet --vpc-id vpc-0a87f619f4b00912b --cidr-block 10.100.0.0/28

{
    "Subnet": {
        "AvailabilityZone": "ap-south-1b",
        "AvailabilityZoneId": "aps1-az3",
        "AvailableIpAddressCount": 11,
        "CidrBlock": "10.100.0.0/28",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "subnet-02b5b6156949671f3",
        "VpcId": "vpc-0a87f619f4b00912b",
        "OwnerId": "647478727829",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "SubnetArn": "arn:aws:ec2:ap-south-1:647478727829:subnet/subnet-02b5b6156949671f3"
    }
}

Subnet_ID=$(aws ec2 create-subnet --vpc-id vpc-0a87f619f4b00912b --cidr-block 10.100.0.0/28 --query '{ID:Subnet.SubnetId}' --output text)
-output  subnet-00a66c2fa3fd6feca

#########----------------------------------------################

aws ec2 create-internet-gateway

{
    "InternetGateway": {
        "Attachments": [],
        "InternetGatewayId": "igw-0957dac6b1baaa0e1",
        "OwnerId": "647478727829",
        "Tags": []
    }
}

IGW_ID=$(aws ec2 create-internet-gateway --query '{ID:InternetGateway.InternetGatewayId}' --output text)
-output  igw-0fd9d96ca81d5115f

########-----------------------------------------###################

aws ec2 attach-internet-gateway --vpc-id vpc-0a87f619f4b00912b --internet-gateway-id igw-0fd9d96ca81d5115f

#######-----------------------------------------##################

 aws ec2 create-route-table --vpc-id vpc-0a87f619f4b00912b

{
    "RouteTable": {
        "Associations": [],
        "PropagatingVgws": [],
        "RouteTableId": "rtb-0ae4cb01ec0c20c26",
        "Routes": [
            {
                "DestinationCidrBlock": "10.100.0.0/24",
                "GatewayId": "local",
                "Origin": "CreateRouteTable",
                "State": "active"
            }
        ],
        "Tags": [],
        "VpcId": "vpc-0a87f619f4b00912b",
        "OwnerId": "647478727829"
    }
}

RTB_ID=$(aws ec2 create-route-table --vpc-id vpc-0a87f619f4b00912b --query '{ID:RouteTable.RouteTableId}' --output text)
-output  rtb-08caeb9e5263eda67

##########-----------------------------------------#####################

aws ec2 create-route --route-table-id rtb-08caeb9e5263eda67 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0fd9d96ca81d5115f --query {ID:Return} --output text

{
    "Return": true
}

Create_RTB=$(aws ec2 create-route --route-table-id rtb-08caeb9e5263eda67 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0fd9d96ca81d5115f --query {ID:Return} --output text)
-output True

############---------------------------------------####################
-optional

aws ec2 describe-route-tables --route-table-id rtb-08caeb9e5263eda67

############----------------------------------########################

aws ec2 describe-subnets --filters "Name=vpc-id, Values=vpc-0a87f619f4b00912b"

{
    "Subnets": [
        {
            "AvailabilityZone": "ap-south-1b",
            "AvailabilityZoneId": "aps1-az3",
            "AvailableIpAddressCount": 11,
            "CidrBlock": "10.100.0.0/28",
            "DefaultForAz": false,
            "MapPublicIpOnLaunch": false,
            "MapCustomerOwnedIpOnLaunch": false,
            "State": "available",
            "SubnetId": "subnet-02b5b6156949671f3",
            "VpcId": "vpc-0a87f619f4b00912b",
            "OwnerId": "647478727829",
            "AssignIpv6AddressOnCreation": false,
            "Ipv6CidrBlockAssociationSet": [],
            "SubnetArn": "arn:aws:ec2:ap-south-1:647478727829:subnet/subnet-02b5b6156949671f3"
        },
        {
            "AvailabilityZone": "ap-south-1b",
            "AvailabilityZoneId": "aps1-az3",
            "AvailableIpAddressCount": 11,
            "CidrBlock": "10.100.0.16/28",
            "DefaultForAz": false,
            "MapPublicIpOnLaunch": false,
            "MapCustomerOwnedIpOnLaunch": false,
            "State": "available",
            "SubnetId": "subnet-00a66c2fa3fd6feca",
            "VpcId": "vpc-0a87f619f4b00912b",
            "OwnerId": "647478727829",
            "AssignIpv6AddressOnCreation": false,
            "Ipv6CidrBlockAssociationSet": [],
            "SubnetArn": "arn:aws:ec2:ap-south-1:647478727829:subnet/subnet-00a66c2fa3fd6feca"
        }
    ]
}

aws ec2 describe-subnets --filters "Name=vpc-id, Values=vpc-0a87f619f4b00912b" --query 'Subnets[0].{ID:SubnetId}' --output text
-output  subnet-02b5b6156949671f3

aws ec2 describe-subnets --filters "Name=vpc-id, Values=vpc-0a87f619f4b00912b" --query 'Subnets[1].{ID:SubnetId}' --output text
-output  subnet-00a66c2fa3fd6feca

#################---------------------------#########################3

aws ec2 associate-route-table --subnet-id subnet-02b5b6156949671f3 --route-table-id rtb-08caeb9e5263eda67

{
    "AssociationId": "rtbassoc-0a1964586eb797be9",
    "AssociationState": {
        "State": "associated"
    }
}

Associated_Status=$(aws ec2 associate-route-table --subnet-id subnet-02b5b6156949671f3 --route-table-id rtb-08caeb9e5263eda67 --query '{ID:AssociationState.State}' --output text)
-output  associated

############-----------------------------------#####################

aws ec2 modify-subnet-attribute --subnet-id subnet-02b5b6156949671f3 --map-public-ip-on-launch


###############--------------------------------######################
