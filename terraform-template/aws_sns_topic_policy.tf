#---------------------------------------------------------------
# Amazon SNS Topic Policy
#---------------------------------------------------------------
#
# SNSトピックへのアクセスを制御するIAMポリシーをアタッチします。
# トピックへのアクセス権限（パブリッシュ、サブスクライブなど）を
# AWS アカウント、IAMユーザー、AWSサービスに付与できます。
#
# AWS公式ドキュメント:
#   - Example cases for Amazon SNS access control: https://docs.aws.amazon.com/sns/latest/dg/sns-access-policy-use-cases.html
#   - Using identity-based policies with Amazon SNS: https://docs.aws.amazon.com/sns/latest/dg/sns-using-identity-based-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sns_topic_policy" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # SNSトピックのARN
  # - 対象となるSNSトピックのAmazon Resource Name
  # - 例: arn:aws:sns:us-east-1:123456789012:my-topic
  arn = aws_sns_topic.example.arn

  # IAMポリシードキュメント（JSON形式）
  # - SNSトピックへのアクセスを制御するポリシー
  # - data.aws_iam_policy_documentを使用して動的に生成することを推奨
  # - PrincipalにアカウントIDのみを指定すると、AWSがルートユーザーのARNに
  #   自動変換するため、完全なARN形式での指定を推奨
  #   例: arn:aws:iam::123456789012:root
  #
  # 典型的なポリシー構造:
  # - Statement: アクセス許可ステートメントの配列
  #   - Sid: ステートメント識別子（オプション）
  #   - Effect: "Allow" または "Deny"
  #   - Principal: アクセスを許可/拒否するエンティティ
  #     - AWS: AWSアカウント、IAMユーザー、IAMロールのARN
  #     - Service: AWSサービスのプリンシパル名（例: events.amazonaws.com）
  #   - Action: 許可するSNSアクション
  #     - SNS:Publish: メッセージの発行
  #     - SNS:Subscribe: サブスクリプションの作成
  #     - SNS:Receive: メッセージの受信
  #     - SNS:GetTopicAttributes: トピック属性の取得
  #     - SNS:SetTopicAttributes: トピック属性の設定
  #     - SNS:AddPermission: アクセス許可の追加
  #     - SNS:RemovePermission: アクセス許可の削除
  #     - SNS:DeleteTopic: トピックの削除
  #     - SNS:ListSubscriptionsByTopic: サブスクリプション一覧の取得
  #   - Resource: トピックのARN（通常は "*" または具体的なトピックARN）
  #   - Condition: 条件付きアクセス（オプション）
  #     - StringEquals: 文字列の完全一致
  #     - StringLike: ワイルドカードを使用した文字列のマッチング
  #     - ArnLike: ARNパターンマッチング
  #     - IpAddress: IPアドレスの範囲指定
  #     例: AWS:SourceOwner, AWS:SourceAccount, AWS:SourceArn など
  policy = data.aws_iam_policy_document.example.json

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リージョン
  # - このリソースを管理するAWSリージョン
  # - 指定しない場合はプロバイダー設定のリージョンを使用
  # - 例: us-east-1, ap-northeast-1
  # region = "ap-northeast-1"

  # リソースID
  # - Terraformが使用する内部識別子
  # - 通常は指定不要（自動的にトピックARNが使用される）
  # - カスタムIDを使用する場合のみ指定
  # id = "custom-id"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - owner
#   - SNSトピックを所有するAWSアカウントID
#   - 例: 123456789012
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: data.aws_iam_policy_documentとの組み合わせ
#---------------------------------------------------------------
# data "aws_iam_policy_document" "example" {
#   policy_id = "__default_policy_ID"
#
#   statement {
#     sid = "__default_statement_ID"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#
#     actions = [
#       "SNS:Subscribe",
#       "SNS:SetTopicAttributes",
#       "SNS:RemovePermission",
#       "SNS:Receive",
#       "SNS:Publish",
#       "SNS:ListSubscriptionsByTopic",
#       "SNS:GetTopicAttributes",
#       "SNS:DeleteTopic",
#       "SNS:AddPermission",
#     ]
#
#     resources = [
#       aws_sns_topic.example.arn,
#     ]
#
#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceOwner"
#       values   = [var.account_id]
#     }
#   }
# }
#
# resource "aws_sns_topic" "example" {
#   name = "my-topic-with-policy"
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 他のAWSアカウントにパブリッシュ権限を付与
#---------------------------------------------------------------
# data "aws_iam_policy_document" "cross_account" {
#   statement {
#     sid    = "AllowCrossAccountPublish"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::111122223333:root"]
#     }
#
#     actions = ["SNS:Publish"]
#
#     resources = [aws_sns_topic.example.arn]
#   }
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: AWSサービスからのアクセス許可
#---------------------------------------------------------------
# data "aws_iam_policy_document" "service_access" {
#   statement {
#     sid    = "AllowCloudWatchEvents"
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["events.amazonaws.com"]
#     }
#
#     actions = ["SNS:Publish"]
#
#     resources = [aws_sns_topic.example.arn]
#
#     condition {
#       test     = "ArnLike"
#       variable = "AWS:SourceArn"
#       values   = ["arn:aws:events:*:${var.account_id}:rule/*"]
#     }
#   }
# }
#---------------------------------------------------------------
