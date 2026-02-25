#---------------------------------------------------------------
# Amazon Neptune サブネットグループ
#---------------------------------------------------------------
#
# Neptune DB インスタンスまたはクラスターが使用するサブネットの集合を
# 定義するサブネットグループをプロビジョニングするリソースです。
# Neptune クラスターを特定の VPC サブネット内に配置する際に使用します。
#
# AWS公式ドキュメント:
#   - Amazon Neptune サブネットグループ: https://docs.aws.amazon.com/neptune/latest/userguide/manage-console-vpc.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_subnet_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # subnet_ids (Required)
  # 設定内容: サブネットグループに含めるサブネット ID のセットを指定します。
  # 設定可能な値: 有効なサブネット ID のセット（異なる AZ のサブネットを複数指定推奨）
  # 注意: マルチ AZ 構成にするため、異なるアベイラビリティゾーンのサブネットを
  #       複数指定することを推奨します。
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # name (Optional, Forces new resource)
  # 設定内容: サブネットグループの名前を指定します。
  # 設定可能な値: 最大255文字の英数字、ハイフン、アンダースコア、ピリオド
  # 省略時: Terraform が name_prefix を使用して名前を自動生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "example-neptune-subnet-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: 指定したプレフィックスで始まる一意な名前を生成します。
  # 設定可能な値: 文字列プレフィックス（最大255文字）
  # 省略時: name が使用されます。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # description (Optional)
  # 設定内容: サブネットグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Neptune subnet group for example cluster"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-neptune-subnet-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブネットグループの名前（name と同値）
# - arn: サブネットグループの ARN
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
