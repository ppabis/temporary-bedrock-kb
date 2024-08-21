data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_s3_object" "lambda" {
  bucket      = aws_s3_bucket.CloudFormationTemplates.bucket
  key         = "lambda.zip"
  source      = data.archive_file.lambda.output_path
  source_hash = data.archive_file.lambda.output_base64sha256
}
resource "aws_lambda_function" "create_index" {
  function_name     = "CreateIndexVector"
  s3_bucket         = aws_s3_bucket.CloudFormationTemplates.bucket
  s3_key            = aws_s3_object.lambda.key
  s3_object_version = aws_s3_object.lambda.version_id
  source_code_hash  = data.archive_file.lambda.output_base64sha256
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.12"
  role              = aws_iam_role.LambdaRole.arn
  timeout           = 60
  memory_size       = 128
}
