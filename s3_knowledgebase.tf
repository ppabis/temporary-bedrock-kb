resource "random_string" "kbsuffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "KnowledgeBase" {
  bucket        = "knowledge-base-${random_string.kbsuffix.result}"
  force_destroy = true
}

data "aws_iam_policy_document" "KnowledgeBaseGetList" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.BedrockKBRole.arn]
    }
    actions   = ["s3:GetObject", "s3:GetObject*"]
    resources = ["${aws_s3_bucket.KnowledgeBase.arn}/*"]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.BedrockKBRole.arn]
    }
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.KnowledgeBase.arn]
  }
}

resource "aws_s3_bucket_policy" "KnowledgeBase" {
  bucket = aws_s3_bucket.KnowledgeBase.bucket
  policy = data.aws_iam_policy_document.KnowledgeBaseGetList.json
}
