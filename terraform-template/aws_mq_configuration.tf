#---------------------------------------------------------------
# Amazon MQ Configuration
#---------------------------------------------------------------
#
# Amazon MQブローカーの設定（Configuration）をプロビジョニングするリソース。
# ActiveMQおよびRabbitMQブローカー用の設定を作成・管理する。
#
# AWS公式ドキュメント:
#   - Amazon MQ Developer Guide: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/welcome.html
#   - Amazon MQ broker configuration parameters: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-configuration-parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mq_configuration" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # name (必須)
  # 設定の名前。
  # ブローカー設定を識別するための一意の名前を指定する。
  name = "example-configuration"

  # engine_type (必須・作成後変更不可)
  # ブローカーエンジンのタイプ。
  # 有効な値: "ActiveMQ", "RabbitMQ"
  engine_type = "ActiveMQ"

  # engine_version (必須)
  # ブローカーエンジンのバージョン。
  # ActiveMQの例: "5.17.6", "5.16.7"
  # RabbitMQの例: "3.11.20", "3.10.25"
  engine_version = "5.17.6"

  # data (必須)
  # ブローカー設定の内容。
  # ActiveMQの場合: XML形式（Apache ActiveMQの設定スキーマに準拠）
  # RabbitMQの場合: Cuttlefish形式（key = value 形式）
  # 詳細はAWS公式ドキュメントを参照:
  #   https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-configuration-parameters.html
  data = <<DATA
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
  <plugins>
    <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
    <statisticsBrokerPlugin/>
    <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
  </plugins>
</broker>
DATA

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # authentication_strategy (オプション)
  # 設定に関連付けられた認証戦略。
  # 有効な値: "simple", "ldap"
  # "ldap"はRabbitMQエンジンタイプではサポートされていない。
  # 指定しない場合、デフォルトは"simple"。
  # authentication_strategy = "simple"

  # description (オプション)
  # 設定の説明。
  # 設定の用途や目的を記述するために使用する。
  description = "Example Configuration"

  # region (オプション)
  # このリソースが管理されるリージョン。
  # プロバイダー設定のリージョンがデフォルト値となる。
  # region = "ap-northeast-1"

  # tags (オプション)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルのdefault_tags設定がある場合、同じキーのタグは上書きされる。
  tags = {
    Environment = "development"
  }
}

#---------------------------------------------------------------
# RabbitMQ設定の例
#---------------------------------------------------------------
# RabbitMQエンジン用の設定例。Cuttlefish形式を使用する。
#
# resource "aws_mq_configuration" "rabbitmq_example" {
#   name           = "rabbitmq-configuration"
#   engine_type    = "RabbitMQ"
#   engine_version = "3.11.20"
#   description    = "RabbitMQ Configuration Example"
#
#   # RabbitMQの設定はCuttlefish形式（key = value形式）で記述
#   # consumer_timeout: メッセージ配信確認のタイムアウト（ミリ秒）
#   # デフォルトは30分（1800000ミリ秒）
#   data = <<DATA
# # Default RabbitMQ delivery acknowledgement timeout is 30 minutes in milliseconds
# consumer_timeout = 1800000
# DATA
#
#   tags = {
#     Environment = "development"
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、他のリソースから参照可能。
# テンプレートには含めないが、output等で参照する際に使用する。
#
# arn             - 設定のARN
# id              - Amazon MQが生成する設定の一意のID
# latest_revision - 設定の最新リビジョン番号
# tags_all        - プロバイダーのdefault_tagsから継承されたタグを含む、リソースに割り当てられたタグのマップ
#---------------------------------------------------------------
