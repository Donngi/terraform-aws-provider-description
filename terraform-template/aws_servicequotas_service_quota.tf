#---------------------------------------------------------------
# AWS Service Quotas - サービスクォータ
#---------------------------------------------------------------
#
# AWSサービスのクォータ（サービス制限）値を管理するリソースです。
# 特定のサービスのクォータを引き上げリクエストし、適用された値を管理します。
# クォータコードおよびサービスコードはAWS CLIや
# aws_servicequotas_service_quota データソースで確認できます。
#
# AWS公式ドキュメント:
#   - Service Quotas ユーザーガイド: https://docs.aws.amazon.com/servicequotas/latest/userguide/intro.html
#   - クォータコードの確認方法: https://docs.aws.amazon.com/servicequotas/latest/userguide/gs-request-quota.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicequotas_service_quota
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicequotas_service_quota" "example" {
  #-------------------------------------------------------------
  # クォータ識別設定
  #-------------------------------------------------------------

  # service_code (Required)
  # 設定内容: クォータを管理するAWSサービスのサービスコードを指定します。
  # 設定可能な値: AWSサービスを識別する文字列（例: "ec2", "s3", "lambda"）
  # 参考: aws_servicequotas_service データソースや AWS CLIで確認可能
  service_code = "ec2"

  # quota_code (Required)
  # 設定内容: 変更対象のクォータを識別するクォータコードを指定します。
  # 設定可能な値: クォータを識別する文字列（例: "L-1216C47A"）
  # 参考: aws_servicequotas_service_quota データソースや AWS CLIで確認可能
  quota_code = "L-1216C47A"

  #-------------------------------------------------------------
  # クォータ値設定
  #-------------------------------------------------------------

  # value (Required)
  # 設定内容: 適用するクォータの値（上限値）を指定します。
  # 設定可能な値: 正の数値。現在の適用値より大きい値を指定してください。
  # 注意: 引き上げリクエストが承認されるまで適用値は変わらない場合があります。
  #   adjustable が false のクォータは変更できません。
  value = 5

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は作成後に参照可能です:
#
# id             - サービスコードとクォータコードの複合キー（例: ec2/L-1216C47A）
# arn            - クォータのARN
# adjustable     - クォータが調整可能かどうかを示すbool値
# default_value  - クォータのデフォルト値（AWSが設定するデフォルト上限）
# quota_name     - クォータの名称
# request_id     - 引き上げリクエストのID
# request_status - 引き上げリクエストのステータス
# service_name   - サービスの名称
# usage_metric   - CloudWatchでの使用量メトリクス情報（リスト）
#---------------------------------------------------------------
