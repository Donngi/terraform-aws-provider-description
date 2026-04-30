#---------------------------------------------------------------
# AWS MQ ブローカー設定
#---------------------------------------------------------------
#
# Amazon MQのブローカー設定をプロビジョニングするリソースです。
# ActiveMQおよびRabbitMQブローカーの設定を作成・管理します。
# 設定はブローカーの動作パラメーターを定義し、
# ブローカーに適用して挙動をカスタマイズするために使用されます。
#
# AWS公式ドキュメント:
#   - Amazon MQ概要: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/welcome.html
#   - ActiveMQ設定: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/configuration-managing.html
#   - RabbitMQ設定: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/rabbitmq-broker-configuration-parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_configuration
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mq_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 設定の名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: 名前にはスペースを含めることはできません。
  name = "example-mq-configuration"

  # description (Optional)
  # 設定内容: 設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example MQ configuration"

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine_type (Required)
  # 設定内容: ブローカーエンジンのタイプを指定します。
  # 設定可能な値:
  #   - "ActiveMQ": Apache ActiveMQエンジン
  #   - "RabbitMQ": RabbitMQエンジン
  # 関連機能: Amazon MQ ブローカーエンジン
  #   Amazon MQはActiveMQとRabbitMQの2種類のメッセージブローカーエンジンを提供。
  #   - https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/working-with-brokers.html
  engine_type = "ActiveMQ"

  # engine_version (Required)
  # 設定内容: ブローカーエンジンのバージョンを指定します。
  # 設定可能な値: エンジンタイプに対応するサポート対象バージョン文字列
  #   - ActiveMQ例: "5.17.6", "5.18.4"
  #   - RabbitMQ例: "3.11.28", "3.13.2"
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html
  engine_version = "5.17.6"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication_strategy (Optional)
  # 設定内容: 設定に関連付ける認証戦略を指定します。
  # 設定可能な値:
  #   - "simple": シンプル認証（ユーザー名とパスワード）
  #   - "ldap": LDAP認証
  # 省略時: エンジンタイプに基づくデフォルト値が使用されます。
  # 注意: "ldap" はRabbitMQエンジンタイプではサポートされていません。
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/security-authentication-authorization.html
  authentication_strategy = "simple"

  #-------------------------------------------------------------
  # 設定データ
  #-------------------------------------------------------------

  # data (Required)
  # 設定内容: ブローカーの設定データを指定します。
  #   - ActiveMQ: XML形式のブローカー設定
  #   - RabbitMQ: Cuttlefish形式の設定
  # 設定可能な値: 設定内容を表す文字列（ヒアドキュメント推奨）
  # 関連機能: Amazon MQ ブローカー設定パラメーター
  #   ActiveMQの場合はactivemq.xmlの内容、RabbitMQの場合はrabbitmq.confの内容を指定。
  #   - https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-configuration-parameters.html
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
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy時に設定の削除をスキップするかを指定します。
  # 設定可能な値:
  #   - true: destroy時にAmazon MQ上の設定を削除せず、Terraform stateからのみ削除
  #   - false (デフォルト): destroy時に設定を削除
  # 用途: 既存ブローカーが参照している設定を誤って削除しないよう保護したい場合に使用。
  skip_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-tagging.html
  tags = {
    Name        = "example-mq-configuration"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 設定のAmazon Resource Name (ARN)
#
# - id: Amazon MQが設定のために生成する一意のID
#
# - latest_revision: 設定の最新リビジョン番号
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
