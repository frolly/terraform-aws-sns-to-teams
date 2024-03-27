resource "aws_sns_topic_subscription" "sns_topic_subscription_teams" {
  topic_arn = aws_sns_topic.aws_sns_topic_teams.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_function_teams.arn
}