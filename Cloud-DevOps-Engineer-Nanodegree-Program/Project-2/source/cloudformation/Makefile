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

delete-stack:
	@echo "Deleting stack $(STACK_NAME)..."
	@aws cloudformation delete-stack --stack-name $(STACK_NAME) | jq .

watch-stack-network-status:
	@echo "Watching stack status..."
	@(STACK_STATUS=`aws cloudformation describe-stacks --stack-name $(STACK_NAME_NETWORK) 2> /dev/null |  jq '. | .Stacks[0].StackStatus'`; \
	    until echo $${STACK_STATUS} | grep -E "(UPDATE_COMPLETE|CREATE_COMPLETE|NO STACK)"; \
		do echo "Stack status: $${STACK_STATUS}"; \
		sleep 5; \
		STACK_STATUS=`aws cloudformation describe-stacks --stack-name $(STACK_NAME_NETWORK) 2> /dev/null |  jq '. | .Stacks[0].StackStatus'`; \
		done; \
	)

create-infra: create-stack-network watch-stack-network-status
	@echo "Creating infrastructure..."

#aws cloudformation describe-stacks --stack-name udacity-network | jq '. | .Stacks[0].StackStatus'
#{"Stacks":[{"StackStatus":"NO STACK"}]}