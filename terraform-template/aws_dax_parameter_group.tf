#---------------------------------------------------------------
# AWS DAX Parameter Group
#---------------------------------------------------------------
#
# Amazon DynamoDB Accelerator (DAX) クラスターのパラメータグループを作成するための
# リソースです。パラメータグループを使用して、DAXクラスターのランタイム設定
# （キャッシュTTLなど）を管理します。
#
# AWS公式ドキュメント:
#   - DAXクラスターコンポーネント: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html
#   - DAXクラスター管理: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.cluster-management.html
#   - DAXクラスターのデプロイ: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/dax-deploy-cluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dax_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2025-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dax_parameter_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: パラメータグループの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: この値はクラスター作成時にパラメータグループを指定するために使用されます。
  name = "example-dax-params"

  # description (Optional, ForceNew)
  # 設定内容: パラメータグループの説明を指定します。
  # 設定可能な値: 文字列
  # 注意: この属性を変更すると、リソースが再作成されます（ForceNew）。
  description = "DAX parameter group for caching configuration"

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 注意: 通常はTerraformが自動生成するため、明示的な指定は不要です。
  #       値はパラメータグループ名（name）と同じになります。
  id = null

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
  # parameters ブロック (Optional, 複数指定可能)
  #-------------------------------------------------------------
  # DAXクラスターのランタイムパラメータを定義します。
  # 主なパラメータ:
  #   - query-ttl-millis: クエリキャッシュのTTL（ミリ秒）
  #   - record-ttl-millis: アイテムキャッシュのTTL（ミリ秒）
  #
  # TTLのデフォルト値は5分（300000ミリ秒）です。
  # 1ミリ秒以上の任意の値を設定できます。
  #
  # 注意: 実行中のDAXクラスターが使用しているパラメータグループは変更できません。

  # クエリキャッシュTTL設定
  parameters {
    # name (Required)
    # 設定内容: パラメータ名を指定します。
    # 設定可能な値:
    #   - "query-ttl-millis": QueryおよびScanリクエストの結果キャッシュのTTL
    #   - "record-ttl-millis": GetItem、BatchGetItem、Queryで取得したアイテムキャッシュのTTL
    name = "query-ttl-millis"

    # value (Required)
    # 設定内容: パラメータの値を指定します。
    # 設定可能な値: 1以上の整数（ミリ秒単位）
    # 例: "300000" = 5分（デフォルト）、"100000" = 100秒
    value = "100000"
  }

  # アイテムキャッシュTTL設定
  parameters {
    name  = "record-ttl-millis"
    value = "100000"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: パラメータグループの名前
#       （nameと同じ値が設定されます）
#---------------------------------------------------------------
