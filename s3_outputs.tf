resource "random_string" "outputs_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "OutputBucket" {
  bucket        = "llm-rag-outputs-${random_string.kbsuffix.result}"
  force_destroy = true
}

data "aws_iam_policy_document" "StepFunctionsPutObjects" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.StepFunctionsRole.arn]
    }
    actions = [
      "s3:PutObject",
      "s3:PutObject*",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObject*"
    ]
    resources = ["${aws_s3_bucket.OutputBucket.arn}/*"]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.StepFunctionsRole.arn]
    }
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.OutputBucket.arn]
  }
}

resource "aws_s3_bucket_policy" "OutputBucket" {
  bucket = aws_s3_bucket.OutputBucket.bucket
  policy = data.aws_iam_policy_document.StepFunctionsPutObjects.json
}
