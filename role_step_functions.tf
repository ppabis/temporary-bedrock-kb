/*
    We allow step functions to create and delete the knowledge base and OpenSearch collection,
    as well as perform inference on a Bedrock model and retrieval from the knowledge base.
*/
data "aws_iam_policy_document" "StepFunctionsTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "StepFunctionsPolicy" {
  statement {
    actions   = ["cloudformation:*"]
    resources = ["*"]
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.CloudFromationRole.arn]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["cloudformation.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "bedrock:InvokeModel",
      "bedrock:ListDataSources",
      "bedrock:ListIngestionJobs",
      "bedrock:ListKnowledgeBases",
      "bedrock:GetIngestionJob",
      "bedrock:GetDataSource",
      "bedrock:GetKnowledgeBase",
      "bedrock:StartIngestionJob",
      "bedrock:Retrieve",
      "bedrock:RetrieveAndGenerate"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "StepFunctionsRole" {
  name               = "StepFunctionsBedrockKBRole"
  assume_role_policy = data.aws_iam_policy_document.StepFunctionsTrustPolicy.json
}
