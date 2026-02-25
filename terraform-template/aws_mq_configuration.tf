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
#   - Amazon MQ概要: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/
#   - ブローカー設定パラメーター: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-configuration-parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
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
  name = "example-mq-configuration"

  # engine_type (Required)
  # 設定内容: ブローカーエンジンのタイプを指定します。
  # 設定可能な値:
  #   - "ActiveMQ": Apache ActiveMQエンジン
  #   - "RabbitMQ": RabbitMQエンジン
  engine_type = "ActiveMQ"

  # engine_version (Required)
  # 設定内容: ブローカーエンジンのバージョンを指定します。
  # 設定可能な値: エンジンタイプに対応するバージョン文字列
  #   - ActiveMQ例: "5.17.6", "5.18.3"
  #   - RabbitMQ例: "3.11.20", "3.13.2"
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html
  engine_version = "5.17.6"

  # data (Required)
  # 設定内容: ブローカーの設定データを指定します。
  #   - ActiveMQ: XML形式のブローカー設定
  #   - RabbitMQ: Cuttlefish形式の設定
  # 設定可能な値: 設定内容を表す文字列（ヒアドキュメント推奨）
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-configuration-parameters.html
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
  # 認証設定
  #-------------------------------------------------------------

  # authentication_strategy (Optional)
  # 設定内容: 設定に関連付ける認証戦略を指定します。
  # 設定可能な値:
  #   - "simple": シンプル認証（ユーザー名とパスワード）
  #   - "ldap": LDAP認証
  # 省略時: エンジンタイプに基づくデフォルト値が使用されます
  # 注意: "ldap" はRabbitMQエンジンタイプではサポートされていません
  authentication_strategy = "simple"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example MQ configuration"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
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
