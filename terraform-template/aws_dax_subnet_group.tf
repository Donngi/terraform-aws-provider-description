#---------------------------------------------------------------
# AWS DAX Subnet Group
#---------------------------------------------------------------
#
# Amazon DynamoDB Accelerator (DAX) のサブネットグループをプロビジョニングするリソースです。
# サブネットグループは、DAXクラスターのノードがデプロイされるVPCサブネットのコレクションです。
# DAXクラスターを作成する前に、少なくとも1つのサブネットグループを作成する必要があります。
#
# 複数のサブネットを指定することで、異なるアベイラビリティゾーンにノードを分散させ、
# 耐障害性と高可用性を確保できます。
#
# AWS公式ドキュメント:
#   - DAXクラスターコンポーネント: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html
#   - DAXクラスターの作成（コンソール）: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.create-cluster.console.html
#   - DAXクラスターの作成（CLI）: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.create-cluster.cli.html
#   - DAXとIPv6: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.create-cluster.DAX_and_IPV6.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dax_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dax_subnet_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サブネットグループの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  name = "example-dax-subnet-group"

  # subnet_ids (Required)
  # 設定内容: サブネットグループに含めるVPCサブネットIDのリストを指定します。
  # 設定可能な値: 有効なVPCサブネットIDのセット
  # 注意:
  #   - 複数のサブネットを指定する場合は、異なるアベイラビリティゾーンから選択することを推奨
  #   - マルチノードDAXクラスターの場合は、複数のサブネットを指定して耐障害性を確保
  #   - IPv6対応のサブネットグループを作成する場合は、IPv6またはデュアルスタックサブネットを使用
  # 関連機能: DAXとIPv6
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.create-cluster.DAX_and_IPV6.html
  subnet_ids = [
    "subnet-xxxxxxxxxxxxxxxxx",
    "subnet-yyyyyyyyyyyyyyyyy",
  ]

  # description (Optional)
  # 設定内容: サブネットグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "DAX subnet group for example application"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブネットグループの名前
#
# - vpc_id: サブネットグループが属するVPCのID
#---------------------------------------------------------------
