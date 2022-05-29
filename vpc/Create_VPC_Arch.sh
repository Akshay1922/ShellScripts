#!/bin/bash

Cidr_Block=$1
echo "$Cidr_Block"
if [ $Cidr_Block != "" ]; then
    ##create VPC
    VPC_ID=$(aws ec2 create-vpc --cidr-block 10.100.0.0/24 --query '{ID:Vpc.VpcId}' --output text)
    echo "VPC is created with this $Cidr_Block CIDR Block and VPC ID is $VPC_ID "

    ## Update-vpc-id in the commands below:
    echo "Please enter the CIDR Block for 1st Subnet"
    read CIDR_1st_Subnet
    Subnet_ID1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $CIDR_1st_Subnet --query '{ID:Subnet.SubnetId}' --output text)
    echo "1st Subnet created with this $CIDR_1st_Subnet CIDR Block and Subnet ID is $Subnet_ID1 "

    echo "Please enter the CIDR Block for 2nd Subnet"
    read CIDR_2nd_Subnet
    Subnet_ID2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $CIDR_2nd_Subnet --query '{ID:Subnet.SubnetId}' --output text)
    echo "2nd Subnet created with this $CIDR_2nd_Subnet CIDR Block and Subnet ID is $Subnet_ID2 "

    ## Create an Internet Gateway
    IGW_ID=$(aws ec2 create-internet-gateway --query '{ID:InternetGateway.InternetGatewayId}' --output text)
    echo "Internet Gateway is created and IGW ID is $IGW_ID"

    ## Copy InternetGatewayId from the output
    ## Update the internet-gateway-id and vpc-id in the command below:
    aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
    echo "IGW is Attached"

    ## Create a custom route table
    RTB_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query '{ID:RouteTable.RouteTableId}' --output text)
    echo "Custome Rout Table is created, The Rout Table ID is $RTB_ID"

    ## Copy RouteTableId from the output as Update the route-table-id and gateway-id in the command below:
    Create_RTB=$(aws ec2 create-route --route-table-id $RTB_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --query {ID:Return} --output text)
    if [ $Create_RTB = "True" ]; then
        echo "IGW Gateway is attached to Rout Table"
    else
        echo "IGW Gateway is not attached to Rout Table"
    fi

    ## Check route has been created and is active
    #aws ec2 describe-route-tables route-table-id rtb-0cd00c603db266202

    # Retrieve subnet IDs
    # Update VPC ID in the command below:
    #aws ec2 describe-subnets --filters "Name=vpc-id, Values=vpc-0a87f619f4b00912b" --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}'

    # Associate subnet with custom route table to make public as Update subnet-id and route-table-id in the command below:

    Associated_Status1=$(aws ec2 associate-route-table --subnet-id $Subnet_ID1 --route-table-id $RTB_ID --query '{ID:AssociationState.State}' --output text)
    if [ $Associated_Status1 = "associated" ]; then
        echo "$RTB_ID this rout table is attched to $Subnet_ID1 this subnet "
    else
        echo "$RTB_ID this rout table is not attched to $Subnet_ID1 this subnet "
    fi

    Associated_Status2=$(aws ec2 associate-route-table --subnet-id $Subnet_ID2 --route-table-id $RTB_ID --query '{ID:AssociationState.State}' --output text)
    if [ $Associated_Status2 = "associated" ]; then
        echo "$RTB_ID this rout table is attched to $Subnet_ID2 this subnet "
    else
        echo "$RTB_ID this rout table is not attched to $Subnet_ID2 this subnet "
    fi

    #Configure subnet to issue a public IP to EC2 instances
    ## Update subnet-id in the command below:
    aws ec2 modify-subnet-attribute --subnet-id $Subnet_ID1 --map-public-ip-on-launch
    aws ec2 modify-subnet-attribute --subnet-id $Subnet_ID2 --map-public-ip-on-launch
    echo "these both subnets are public subnets and Auto assign public IP is on"
else
    echo "Please enter VPC CIDR Block"
fi