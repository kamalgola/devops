aws cloudformation create-stack --stack-name microservices-network --template-body file://vpc_cft.yml
if [ $? -ne 0 ]; then
echo "Already exist"
else
echo "VPC Stack Creation Inprogress"
aws cloudformation wait stack-create-complete  --stack-name microservices-network && echo "VPC Stack Creation Complete"
fi

aws cloudformation create-stack --stack-name microservices-internet --template-body file://internet_cft.yml --parameters ParameterKey=NetworkStack,ParameterValue=microservices-network
if [ $? -ne 0 ]; then
echo "Already exist"
else
echo "Network Stack Creation Inprogress"
aws cloudformation wait stack-create-complete  --stack-name microservices-internet && echo "Network Stack Creation Complete"
fi

aws cloudformation create-stack --stack-name role-for-ec2 --template-body file://ec2_roles_cft.yml --capabilities "CAPABILITY_NAMED_IAM"
if [ $? -ne 0 ]; then
echo "Already exist"
else
echo "EC2 Role Stack Creation Inprogress"
aws cloudformation wait stack-create-complete  --stack-name role-for-ec2 && echo "EC2 Role Stack Creation Complete"
fi


STACK_NAME="$1"
IMAGE_ID=$(aws ec2 describe-images --owners amazon --filters Name=name,Values='amzn-ami-*-amazon-ecs-optimized' --query 'sort_by(Images, &CreationDate)[-1].ImageId' --output text)
aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://auto_scaling_group.yml --parameters ParameterKey=NetworkStack,ParameterValue=microservices-network ParameterKey=AMI,ParameterValue=${IMAGE_ID} ParameterKey=KeyName,ParameterValue=demouser ParameterKey=NumNodes,ParameterValue=2
if [ $? -ne 0 ]; then
echo "Already exist"
else
echo "AutoScaling Stack Creation Inprogress"
aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME}
echo "AutoScaling Stack Creation Complete"
fi


#aws cloudformation create-stack --stack-name microservices-dev-elb --template-body file://elb_cft.yml --parameters ParameterKey=NetworkStack,ParameterValue=microservices-network ParameterKey=ElbName,ParameterValue=microservices-dev
#if [ $? -ne 0 ]; then
#echo "Already exist"
#else
#echo "ELB Stack Creation Inprogress"
#aws cloudformation wait stack-create-complete --stack-name microservices-dev-elb
#echo "ELB Stack Creation Complete"
#fi
