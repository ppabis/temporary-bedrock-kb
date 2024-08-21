/*
These are the needed outputs
  KnowledgeBucket:
    Type: String
    Description: S3 bucket name containing knowledge base content

  BedrockRoleArn:
    Type: String
    Description: ARN of the Bedrock KB role
  
  LambdaRoleArn:
    Type: String
    Description: ARN of the Lambda role that will create index

  EmbeddingModelArn:
    Type: String
    Description: ARN of the embedding model

The command for cloudformation create stack will be:
$ aws cloudformation create-stack \
 --stack-name my-kb \
 --region us-west-2 \
 --template-url $(tofu output -raw TemplateUrl) \
 --parameters ParameterKey=KnowledgeBucket,ParameterValue=$(tofu output -raw KnowledgeBucket) \
 ParameterKey=BedrockRoleArn,ParameterValue=$(tofu output -raw BedrockRoleArn) \
 ParameterKey=LambdaRoleArn,ParameterValue=$(tofu output -raw LambdaRoleArn) \
 ParameterKey=EmbeddingModelArn,ParameterValue=$(tofu output -raw EmbeddingModelArn)
*/

output "KnowledgeBucket" {
  value = aws_s3_bucket.KnowledgeBase.bucket
}

output "BedrockRoleArn" {
  value = aws_iam_role.BedrockKBRole.arn
}

output "LambdaRoleArn" {
  value = aws_iam_role.LambdaRole.arn
}

output "EmbeddingModelArn" {
  value = "arn:aws:bedrock:us-west-2::foundation-model/cohere.embed-multilingual-v3"
}

output "CloudFormationRoleArn" {
  value = aws_iam_role.CloudFormationRole.arn
}

output "TemplateUrl" {
  value = "https://${aws_s3_object.CollectionTemplate.bucket}.s3.us-west-2.amazonaws.com/${aws_s3_object.CollectionTemplate.key}"
}
