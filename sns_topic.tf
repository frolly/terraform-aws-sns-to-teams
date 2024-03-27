resource "aws_sns_topic" "aws_sns_topic_teams" {
  name = join("-", [var.entity, var.project, var.environment, "topic"])
  delivery_policy = jsonencode({
    "http" = {
      "defaultHealthyRetryPolicy" = {
        "minDelayTarget"     = 20,
        "maxDelayTarget"     = 20,
        "numRetries"         = 3,
        "numMaxDelayRetries" = 0,
        "numNoDelayRetries"  = 0,
        "numMinDelayRetries" = 0,
        "backoffFunction"    = "linear"
      },
      "disableSubscriptionOverrides" = false,
      "defaultThrottlePolicy" = {
        "maxReceivesPerSecond" : 1
      }
    }
  })
}

resource "aws_sns_topic_policy" "sns_topic_policy_teams" {
  arn    = aws_sns_topic.aws_sns_topic_teams.arn
  policy = data.aws_iam_policy_document.iam_policy_document_teams.json
}

data "aws_iam_policy_document" "iam_policy_document_teams" {
  policy_id = "__default_policy_ID"
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      aws_sns_topic.aws_sns_topic_teams.arn,
    ]
    sid = "__default_statement_ID"
  }
}

# data "aws_iam_policy_document" "iam_policy_document_teams" {
#   statement {
#     sid     = "AllowedPublishers"
#     actions = ["sns:Publish"]
#     effect  = "Allow"
#     principals {
#       type = "AWS"
#       identifiers = [
#         format("arn:aws:iam::%s:root", data.aws_caller_identity.current.id)
#       ]
#     }
#     resources = [aws_sns_topic.aws_sns_topic_teams.arn]
#   }
#   statement {
#     sid     = "AllowedSubscribers"
#     actions = ["sns:Subscribe"]
#     effect  = "Allow"
#     principals {
#       type = "AWS"
#       identifiers = [
#         format("arn:aws:iam::%s:root", data.aws_caller_identity.current.id)
#       ]
#     }
#     resources = [aws_sns_topic.aws_sns_topic_teams.arn]
#   }
# }