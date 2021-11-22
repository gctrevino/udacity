AWS_PROFILE=udacity
STACK_NAME_NETWORK=udacity-network
TEMPLATE_FILE_NETWORK=cfn-network.yaml
PARAMETERS_FILE_NETWORK=cfn-network-parameters.json

list-stacks:
	@echo "Deploying network..."
	@aws cloudformation list-stacks | jq .

create-stack-network:
	@echo "Creating stack..."
	@aws cloudformation create-stack --stack-name ${STACK_NAME_NETWORK} --template-body file://${TEMPLATE_FILE_NETWORK} --capabilities CAPABILITY_IAM --parameters file://${PARAMETERS_FILE_NETWORK} | jq .

update-stack-network:
	@echo "Updating stack..."
	@aws cloudformation update-stack --stack-name ${STACK_NAME_NETWORK} --template-body file://${TEMPLATE_FILE_NETWORK} --capabilities CAPABILITY_IAM --parameters file://${PARAMETERS_FILE_NETWORK} | jq .

delete-stack-network:
	@echo "Deleting stack..."
	@aws cloudformation delete-stack --stack-name ${STACK_NAME_NETWORK} | jq .

watch-stack-network-status:
	@echo "Watching stack status..."
	@(STACK_STATUS=`aws cloudformation describe-stacks --stack-name $(STACK_NAME_NETWORK) 2> /dev/null |  jq '. | .Stacks[0].StackStatus'`; \
	    until echo $${STACK_STATUS} | grep -E "(UPDATE_COMPLETE|CREATE_COMPLETE|ROLLBACK_COMPLETE)"; \
		do echo "Stack status: $${STACK_STATUS}"; \
		sleep 5; \
		STACK_STATUS=`aws cloudformation describe-stacks --stack-name $(STACK_NAME_NETWORK) 2> /dev/null |  jq '. | .Stacks[0].StackStatus'`; \
		done; \
	)

create-stack-servers:
	@echo "Creating stack..."
	@aws cloudformation create-stack --stack-name udacity-servers --template-body file://cfn-servers.yaml --capabilities CAPABILITY_IAM --parameters file://cfn-servers-parameters.json | jq .

update-stack-servers:
	@echo "Updating stack..."
	@aws cloudformation update-stack --stack-name udacity-servers --template-body file://cfn-servers.yaml --capabilities CAPABILITY_IAM --parameters file://cfn-servers-parameters.json | jq .

delete-stack-servers:
	@echo "Deleting stack..."
	@aws cloudformation delete-stack --stack-name udacity-servers | jq .

watch-stack-servers-status:
	@echo "Watching stack status..."
	@(STACK_STATUS=`aws cloudformation describe-stacks --stack-name udacity-servers 2> /dev/null |  jq '. | .Stacks[0].StackStatus'`; \
	    until echo $${STACK_STATUS} | grep -E "(UPDATE_COMPLETE|CREATE_COMPLETE|ROLLBACK_COMPLETE)"; \
		do echo "Stack status: $${STACK_STATUS}"; \
		sleep 5; \
		STACK_STATUS=`aws cloudformation describe-stacks --stack-name udacity-servers 2> /dev/null |  jq '. | .Stacks[0].StackStatus'`; \
		done; \
	)

create-stack-storage:
	@echo "Creating stack..."
	@aws cloudformation create-stack --stack-name udacity-storage --template-body file://cfn-storage.yaml --capabilities CAPABILITY_IAM --parameters file://cfn-storage-parameters.json | jq .

update-stack-storage:
	@echo "Updating stack..."
	@aws cloudformation update-stack --stack-name udacity-storage --template-body file://cfn-storage.yaml --capabilities CAPABILITY_IAM --parameters file://cfn-storage-parameters.json | jq .

delete-stack-storage:
	@echo "Deleting stack..."
#	@aws s3 rm s3://udacityproject-project2-storage/ -r
	@aws cloudformation delete-stack --stack-name udacity-storage | jq .

create-infra: create-stack-network watch-stack-network-status create-stack-servers watch-stack-servers-status
	@echo "Creating infrastructure..."

delete-infra: delete-stack-servers delete-stack-network
	@echo "Deleting infrastructure..."

#aws cloudformation describe-stacks --stack-name udacity-network | jq '. | .Stacks[0].StackStatus'
#{"Stacks":[{"StackStatus":"NO STACK"}]}

delete-stack:
	@echo "Deleting stack $(STACK_NAME)..."
	@aws cloudformation delete-stack --stack-name $(STACK_NAME) | jq .
