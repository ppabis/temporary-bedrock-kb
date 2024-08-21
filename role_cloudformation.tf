data "aws_iam_policy_document" "CloudFormationTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "CloudFormationRole" {
  name               = "CloudFormationRole"
  assume_role_policy = data.aws_iam_policy_document.CloudFormationTrustPolicy.json
}

resource "aws_iam_role_policy_attachment" "CloudFormationPolicyAttachment" {
  # Quite a dumb way to define a role but meh, whatever ¯\_(ツ)_/¯
  role       = aws_iam_role.CloudFormationRole.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
