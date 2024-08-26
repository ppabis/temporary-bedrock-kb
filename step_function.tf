resource "aws_sfn_state_machine" "BedrockKBandRAG" {
  role_arn = aws_iam_role.StepFunctionsRole.arn
  name     = "Bedrock-KB-and-RAG"

  definition = jsonencode(
    yamldecode(
      templatefile(
        "${path.module}/step_functions/step-function-${var.step_function_ver}.yaml",
        {
          # Configuration of Create OSS Stack
          # Template URL such as https://templates-bucket-1234.s3.us-west-2.amazonaws.com/my-template.yaml
          oss_collection_stack_name   = var.oss_collection_stack_name
          oss_collection_template_url = "https://${aws_s3_object.CollectionTemplate.bucket}.s3.${data.aws_region.current.name}.amazonaws.com/${aws_s3_object.CollectionTemplate.key}"

          # Configuration of craete KB Stack
          kb_stack_name         = var.kb_stack_name
          kb_stack_template_url = "https://${aws_s3_object.KnowledgeBaseTemplate.bucket}.s3.${data.aws_region.current.name}.amazonaws.com/${aws_s3_object.KnowledgeBaseTemplate.key}"

          # Configuration for Knowledge Base and Inference
          embedding_model_arn   = var.embedding_model_arn
          inference_model_arn   = var.inference_model_arn
          inference_temperature = var.inference_temperature
          inference_top_p       = var.inference_top_p
          inference_max_tokens  = var.inference_max_tokens

          # Knowledge Base index configuration
          vector_index_name = var.vector_index_name
          vector_name       = var.vector_name
          vector_dimensions = var.vector_dimensions
          text_name         = var.text_name
          metadata_name     = var.metadata_name

          lambda_role_arn         = aws_iam_role.LambdaRole.arn
          bedrock_role_arn        = aws_iam_role.BedrockKBRole.arn
          cloudformation_role_arn = aws_iam_role.CloudFormationRole.arn

          lambda_function_arn_version = "${aws_lambda_function.create_index.arn}:$LATEST"

          knowledge_bucket_name = aws_s3_bucket.KnowledgeBase.bucket
          output_bucket_name    = aws_s3_bucket.OutputBucket.bucket
        }
      )
    )
  )
}
