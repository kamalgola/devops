#!/bin/sh

echo "Please enter a number: \n 1 = microservices-dev \n 2 = role-for-ec2 \n 3 = microservices-internet \n 4 = microservices-network \n 5=ELB"
while :
do
  read INPUT_STRING
  case $INPUT_STRING in
	1)
		STACK_NAME="microservices-dev"
		aws cloudformation delete-stack --stack-name ${STACK_NAME}
		echo "AutoScaling Group Stack Deleted"
		sleep 10
		;;
	2)	
		aws cloudformation delete-stack --stack-name role-for-ec2
		echo "EC Roles Stack Deleted"
		sleep 10
		;;
	3)
		aws cloudformation delete-stack --stack-name microservices-internet
		echo "Internet Stack Deleted"
		sleep 10
		;;
	4)
		aws cloudformation delete-stack --stack-name microservices-network
		echo "VPC Stack Deleted"
		;;
        5)
                aws cloudformation delete-stack --stack-name microservices-dev-elb
                echo "ELB Stack Deleted"
                ;;

        *)
                echo "Not a valid option"
                break
		;;
  esac
done
echo "\nRun and Try again!!!"

