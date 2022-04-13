:: email address that's going to receive all those SES setup mailboxes
set EMAIL=your@email.add
:: bucket name where we'll upload artifacts to
set TEMPLATE_BUCKET=aws-warez
:: replace with your prefered region
set REGION=us-east-1
set STACK_NAME=Email-SES-SNS-Lambda
set ROOT_TEMPLATE=template.yaml
set OUTPUT_TEMPLATE=packaged-template.yaml

:: install NodeJS project dependecies:
cd source
call npm install
cd ..

:: Package and produce an output template
aws cloudformation package --template %ROOT_TEMPLATE% --s3-bucket %TEMPLATE_BUCKET% --output-template-file %OUTPUT_TEMPLATE% --region %REGION%

:: Deploy the output template of the package command
aws cloudformation deploy --template-file %OUTPUT_TEMPLATE% --stack-name %STACK_NAME% --parameter-overrides Recipient=%EMAIL% --capabilities CAPABILITY_IAM --region %REGION%
