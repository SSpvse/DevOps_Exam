sqs url:
https://sqs.eu-west-1.amazonaws.com/244530008913/stsp_71_image-generation-queue

aws sqs send-message --queue-url https://sqs.eu-west-1.amazonaws.com/244530008913/stsp_71_image-generation-queue --message-body "cat riding a bear with christmas hat, in a cartoonie style"



lambda_arn = "arn:aws:lambda:eu-west-1:244530008913:function:stsp_71_image-generation-function"
lambda_execution_role_arn = "arn:aws:iam::244530008913:role/stsp_71_lambda_execution_role"
sqs_queue_url = "https://sqs.eu-west-1.amazonaws.com/244530008913/stsp_71_image-generation-queue"
(base) StefanS:infra stefanspasenic$


