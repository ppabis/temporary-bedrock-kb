resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "CloudFormationTemplates" {
  bucket        = "cloudformation-templates-${random_string.suffix.result}"
  force_destroy = true
}

data "aws_iam_policy_document" "CloudFormationTemplatesGetList" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.CloudFromationRole.arn,
        aws_iam_role.StepFunctionsRole.arn
      ]
    }
    actions   = ["s3:GetObject", "s3:GetObject*"]
    resources = ["${aws_s3_bucket.CloudFormationTemplates.arn}/*"]
  }

  statement {
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.CloudFromationRole.arn,
        aws_iam_role.StepFunctionsRole.arn
      ]
    }
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.CloudFormationTemplates.arn]
  }
}

resource "aws_s3_bucket_policy" "CloudFormationTemplates" {
  bucket = aws_s3_bucket.CloudFormationTemplates.bucket
  policy = data.aws_iam_policy_document.CloudFormationTemplatesGetList.json
}

resource "aws_s3_object" "CollectionTemplate" {
  bucket         = aws_s3_bucket.CloudFormationTemplates.bucket
  key            = "collection.yml"
  content_base64 = filebase64("${path.module}/cloudformation/collection.yml")
  source_hash    = filemd5("${path.module}/cloudformation/collection.yml") # will help with the object updates
}

resource "aws_s3_object" "KnowledgeBaseTemplate" {
  bucket         = aws_s3_bucket.CloudFormationTemplates.bucket
  key            = "knowledge-base.yml"
  content_base64 = filebase64("${path.module}/cloudformation/knowledge-base.yml")
  source_hash    = filemd5("${path.module}/cloudformation/knowledge-base.yml") # will help with the object updates
}
