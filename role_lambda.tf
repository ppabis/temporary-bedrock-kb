# This is an IAM role for a Lambda function that will be used to create
# a vector index. Because it cannot be done via CloudFormation.

data "aws_iam_policy_document" "LambdaRoleTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "AllowLambdaAOSS" {
  statement {
    actions   = ["aoss:APIAccessAll"]
    resources = ["arn:aws:aoss:${data.aws_region.current.name}:${data.aws_caller_identity.me.account_id}:collection/*"]
  }
}

resource "aws_iam_role" "LambdaRole" {
  name               = "CreateIndexVectorLambdaRole"
  assume_role_policy = data.aws_iam_policy_document.LambdaRoleTrustPolicy.json
}

resource "aws_iam_role_policy" "LambdaInlinePolicy" {
  name   = "LambdaInlinePolicy"
  role   = aws_iam_role.LambdaRole.name
  policy = data.aws_iam_policy_document.AllowLambdaAOSS.json
}

resource "aws_iam_role_policy_attachment" "LambdaBasicExecutionRole" {
  role       = aws_iam_role.LambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
