#!/bin/bash
set -e

#bucket name where we'll upload artifacts to
TEMPLATE_BUCKET='yourbucket'
#email address that's going to receive all those SES setup mailboxes
EMAIL='your@email.address'
#replace with your prefered region
REGION='us-east-1'
STACK_NAME='Email-SES-SNS-Lambda'
TEMPLATE_FILE='template.yaml'
OUTPUT_TEMPLATE='packaged-template.yaml'

#Package and produce an output template
aws cloudformation package --template $TEMPLATE_FILE --s3-bucket $TEMPLATE_BUCKET --output-template-file $OUTPUT_TEMPLATE --region $REGION

aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $STACK_NAME \
    --parameter-overrides Recipient=$EMAIL \
    --capabilities CAPABILITY_IAM \
    --region $REGION
