1.a

Endpoint for lambda function:
```
    https://anfubt0ib8.execute-api.eu-west-1.amazonaws.com/Prod/generate-image/
```

Prompt for postman:   
```json
    
        {
            "prompt": "myself on top of pyramid"
        }
```

1.b

The url for the GitHub actions with my SAM deploy (latest one) : 

```
    https://github.com/SSpvse/DevOps_Exam/actions/runs/12001128919/job/33451206622
```

2.a

sqs-queue url:
```
    https://sqs.eu-west-1.amazonaws.com/244530008913/stsp_71_image-generation-queue
```
Using terminal to prompt the lambda functon using my queue:
```
    aws sqs send-message --queue-url https://sqs.eu-west-1.amazonaws.com/244530008913/stsp_71_image-generation-queue --message-body "me on top of the pyramid"
```

2.b

