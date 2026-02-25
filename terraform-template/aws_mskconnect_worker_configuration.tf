#---------------------------------------------------------------
# Amazon MSK Connect Worker Configuration
#---------------------------------------------------------------
#
# Amazon MSK Connect のワーカー設定をプロビジョニングするリソースです。
# ワーカー設定は connect-distributed.properties ファイルの内容を定義し、
# コネクターが使用するキーコンバーター・バリューコンバーター等の設定を管理します。
#
# AWS公式ドキュメント:
#   - MSK Connect ワーカー概要: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-workers.html
#   - サポートされているワーカー設定プロパティ: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-supported-worker-config-properties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_worker_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mskconnect_worker_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ワーカー設定の名前を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 注意: 作成後に変更するとリソースが再作成されます。
  name = "example-worker-configuration"

  # description (Optional, Forces new resource)
  # 設定内容: ワーカー設定の概要説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 注意: 作成後に変更するとリソースが再作成されます。
  description = "Example MSK Connect worker configuration"

  #-------------------------------------------------------------
  # プロパティ設定
  #-------------------------------------------------------------

  # properties_file_content (Required, Forces new resource)
  # 設定内容: connect-distributed.properties ファイルの内容を指定します。
  #   MSK Connect ワーカーが使用するコネクター設定プロパティを定義します。
  # 設定可能な値: Base64エンコード形式またはプレーンテキスト形式の文字列
  #   必須プロパティ:
  #     - key.converter: キーのシリアライズ/デシリアライズに使用するコンバータークラス
  #     - value.converter: バリューのシリアライズ/デシリアライズに使用するコンバータークラス
  #   サポートされるプレフィックス付きプロパティ:
  #     - producer.*: Kafka プロデューサー設定
  #     - consumer.*: Kafka コンシューマー設定
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-supported-worker-config-properties.html
  # 注意: 作成後に変更するとリソースが再作成されます。
  properties_file_content = <<-EOT
key.converter=org.apache.kafka.connect.storage.StringConverter
value.converter=org.apache.kafka.connect.storage.StringConverter
EOT

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
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
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-worker-configuration"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間文字列形式（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ワーカー設定のAmazon Resource Name (ARN)
#
# - latest_revision: 最後に正常に作成されたリビジョンのID（数値）
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
