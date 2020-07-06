DOMAIN := designguide.me
AWS_DEFAULT_REGION ?= eu-central-1
MAIL_MESSAGES_TO ?= dummy@dummy.de  # Overwritten by Travis CI env vars
MAIL_MESSAGES_FROM ?= dummy@dummy.de  # Overwritten by Travis CI env vars

default: apply

state:
	aws s3 ls s3://$(DOMAIN)-tfstate > /dev/null || aws s3api create-bucket --bucket $(DOMAIN)-tfstate --acl private --region $(AWS_DEFAULT_REGION) --create-bucket-configuration LocationConstraint=$(AWS_DEFAULT_REGION) > /dev/null
	aws s3api put-bucket-versioning --bucket $(DOMAIN)-tfstate --versioning-configuration Status=Enabled > /dev/null
	aws dynamodb list-tables | grep '$(DOMAIN)-tfstate' > /dev/null || aws dynamodb create-table --attribute-definitions AttributeName=LockID,AttributeType=S --table-name $(DOMAIN)-tfstate --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 > /dev/null

zip_function: state
	rm -rf target && mkdir target
	cd function/src && zip ../../target/deployer.zip deployer.js

init: zip_function
	terraform init

plan: init
	terraform plan -var 'domain=$(DOMAIN)' -var 'aws_region=$(AWS_DEFAULT_REGION)' -var 'mail_messages_from=$(MAIL_MESSAGES_FROM)' -var 'mail_messages_to=$(MAIL_MESSAGES_TO)'

apply: init
	terraform apply -auto-approve -var 'domain=$(DOMAIN)' -var 'aws_region=$(AWS_DEFAULT_REGION)' -var 'mail_messages_from=$(MAIL_MESSAGES_FROM)' -var 'mail_messages_to=$(MAIL_MESSAGES_TO)'