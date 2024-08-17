# This is an IAM role that will allow Bedrock Knowledge Base to synchronize between S3
# and OpenSearch Serverless.
# We will allow it to call any embedding model.

data "aws_caller_identity" "me" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "BedrockKBTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.me.account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.me.account_id}:knowledge-base/*"]
      variable = "aws:SourceArn"
    }
  }
}

data "aws_iam_policy_document" "BedrockKBPolicy" {
  statement {
    actions   = ["bedrock:InvokeModel"]
    resources = ["arn:aws:bedrock:${data.aws_region.current.name}::foundation-model/*"]
  }

  statement {
    actions   = ["aoss:APIAccessAll"]
    resources = ["arn:aws:aoss:${data.aws_region.current.name}:${data.aws_caller_identity.me.account_id}:collection/*"]
  }
}

resource "aws_iam_role" "BedrockKBRole" {
  name               = "BedrockKBRole"
  assume_role_policy = data.aws_iam_policy_document.BedrockKBTrustPolicy.json
}

resource "aws_iam_role_policy" "BedrockKBPolicy" {
  name   = "BedrockKBPolicy"
  role   = aws_iam_role.BedrockKBRole.name
  policy = data.aws_iam_policy_document.BedrockKBPolicy.json
}
