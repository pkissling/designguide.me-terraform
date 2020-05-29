DOMAIN := designguide.me
AWS_DEFAULT_REGION ?= eu-central-1

default: apply

state:
	aws s3 ls s3://$(DOMAIN)-tfstate > /dev/null || aws s3api create-bucket --bucket $(DOMAIN)-tfstate --acl private --region $(AWS_DEFAULT_REGION) --create-bucket-configuration LocationConstraint=$(AWS_DEFAULT_REGION) > /dev/null
	aws s3api put-bucket-versioning --bucket $(DOMAIN)-tfstate --versioning-configuration Status=Enabled > /dev/null
	aws dynamodb list-tables | grep '$(DOMAIN)-tfstate' > /dev/null || aws dynamodb create-table --attribute-definitions AttributeName=LockID,AttributeType=S --table-name $(DOMAIN)-tfstate --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 > /dev/null

init: state
	terraform init

plan: init
	terraform plan -var 'domain=$(DOMAIN)' -var 'aws_region=$(AWS_DEFAULT_REGION)'

apply: init
	terraform apply -auto-approve -var 'domain=$(DOMAIN)' -var 'aws_region=$(AWS_DEFAULT_REGION)'
