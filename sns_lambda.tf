data "archive_file" "archive_file_lambda_teams" {
  type        = "zip"
  source_file = "${path.module}/lambdas/lambda_function.py"
  output_path = "lambdas/lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_function_teams" {
  filename         = "lambdas/lambda_function_payload.zip"
  function_name    = join("-", [var.entity, var.project, var.environment, "lambda_teams"])
  role             = aws_iam_role.iam_role_lambda_teams.arn
  handler          = "lambda_function.init"
  source_code_hash = data.archive_file.archive_file_lambda_teams.output_base64sha256
  runtime          = var.lambda_python_version
  timeout          = "300"
  memory_size      = "2048"
  publish          = true
  depends_on       = [data.archive_file.archive_file_lambda_teams]
  environment {
    variables = {
      url_teams_webhook = var.url_teams_webhook
      consigne_title    = var.consigne_title
      consigne_url      = var.consigne_url
      debug             = var.debug
    }
  }
}

data "aws_iam_policy_document" "iam_policy_document_assume_role_teams" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_role_lambda_teams" {
  name               = join("-", [var.entity, var.project, var.environment, "lambda"])
  assume_role_policy = data.aws_iam_policy_document.iam_policy_document_assume_role_teams.json
}

resource "aws_iam_policy" "iam_policy_lambda_teams" {
  name        = join("-", [var.entity, var.project, var.environment, "policy_teams"])
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = file("${path.module}/lambdas/lambda_role.json")
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_teams" {
  role       = aws_iam_role.iam_role_lambda_teams.name
  policy_arn = aws_iam_policy.iam_policy_lambda_teams.arn
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_teams" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function_teams.function_name}"
  retention_in_days = 3
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_lambda_permission" "lambda_permission_teams" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_teams.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.aws_sns_topic_teams.arn
}