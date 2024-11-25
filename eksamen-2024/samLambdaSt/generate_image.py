import base64
import boto3
import json
import random
import os

# Set up the AWS clients
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")


def lambda_handler(event, context):
    # Extract prompt from the event body
    body = json.loads(event['body'])
    prompt = body.get('prompt', '')

    # Ensure prompt is provided
    if not prompt:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Missing required parameter: prompt'})
        }

    # Define the model ID and S3 bucket name (from environment variables or hardcoded)
    model_id = "amazon.titan-image-generator-v1"  # Ensure this is the correct model
    bucket_name = os.environ.get('BUCKET_NAME')
    candidate_number = os.environ.get('CANDIDATE_NUMBER', 'unknown')  # Get candidate number from environment variable

    # Generate a random seed for the image generation
    seed = random.randint(0, 2147483647)

    s3_image_path = f"{candidate_number}/titan_{seed}.png"  # Candidate-specific folder

    # Build the request body for bedrock image generation
    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }

    try:
        # Invoke the Bedrock model with the request
        response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())

        # Extract & decode the base64 image data
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Upload the image data to S3
        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

        # Return the S3 URI of the saved image
        s3_uri = f"s3://{bucket_name}/{s3_image_path}"
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Image generated and saved successfully', 's3_uri': s3_uri})
        }

    except Exception as e:
        # Handle any errors that happen during the process
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Failed to generate image', 'error': str(e)})
        }
