#---------------------------------------------------------------
# AWS CloudWatch Logs Delivery Destination
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsの配信先（Delivery Destination）をプロビジョニングするリソースです。
# Delivery Destinationは、VendedログやX-Rayトレースなどを受信するための
# ターゲットリソース（CloudWatch Logs、S3、Firehose、X-Ray）を定義します。
#
# AWS公式ドキュメント:
#   - CloudWatch Logs概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html
#   - AWSサービスからのログ配信: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AWS-logs-and-resource-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_delivery_destination
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_delivery_destination" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: この配信先の名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 配信先を識別するための一意の名前
  name = "example-delivery-destination"

  #-------------------------------------------------------------
  # 配信先タイプ設定
  #-------------------------------------------------------------

  # delivery_destination_type (Optional)
  # 設定内容: 配信先のタイプを指定します。
  # 設定可能な値:
  #   - "S3": Amazon S3バケットへの配信
  #   - "CWL": CloudWatch Logsロググループへの配信
  #   - "FH": Amazon Data Firehoseへの配信
  #   - "XRAY": X-Rayトレースの配信
  # 省略時: delivery_destination_configurationのdestination_resource_arnから自動的に判定
  # 注意: X-Rayトレース配信先の場合は必須で"XRAY"を指定
  delivery_destination_type = null

  #-------------------------------------------------------------
  # 出力フォーマット設定
  #-------------------------------------------------------------

  # output_format (Optional)
  # 設定内容: 配信先に送信されるログのフォーマットを指定します。
  # 設定可能な値:
  #   - "json": JSON形式
  #   - "plain": プレーンテキスト形式
  #   - "w3c": W3C拡張ログファイル形式
  #   - "raw": 生のログ形式
  #   - "parquet": Apache Parquet形式（S3配信時に利用可能）
  # 省略時: デフォルトのフォーマットが適用
  output_format = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 配信先設定ブロック
  #-------------------------------------------------------------

  # delivery_destination_configuration (Optional)
  # 設定内容: ログを受信するAWSリソースを設定します。
  # 必須条件: CloudWatch Logs、Amazon S3、Firehose配信先の場合は必須
  # 注意: X-Rayトレース配信先の場合は不要
  delivery_destination_configuration {
    # destination_resource_arn (Optional)
    # 設定内容: 配信先となるAWSリソースのARNを指定します。
    # 設定可能な値:
    #   - CloudWatch Logsロググループ: arn:aws:logs:{region}:{account-id}:log-group:{log-group-name}
    #   - S3バケット: arn:aws:s3:::{bucket-name}
    #   - Firehose配信ストリーム: arn:aws:firehose:{region}:{account-id}:deliverystream/{stream-name}
    # 必須条件: delivery_destination_configurationブロックを指定する場合は必須
    destination_resource_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:example-log-group"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-delivery-destination"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 配信先のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# X-Rayトレースを受信するための配信先を作成する場合は、
# delivery_destination_typeに"XRAY"を指定し、
# delivery_destination_configurationブロックは省略します。
#
# resource "aws_cloudwatch_log_delivery_destination" "xray" {
#   name                      = "xray-traces"
#   delivery_destination_type = "XRAY"
#
#   tags = {
#     Name = "xray-traces-destination"
#   }
# }
#---------------------------------------------------------------
