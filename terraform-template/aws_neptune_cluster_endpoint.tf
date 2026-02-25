#---------------------------------------------------------------
# AWS Neptune Cluster Endpoint
#---------------------------------------------------------------
#
# Amazon Neptune クラスターカスタムエンドポイントリソースです。
# Neptune クラスターのカスタムエンドポイントを定義し、特定のインスタンスセットに
# トラフィックをルーティングするためのエンドポイントを管理します。
#
# カスタムエンドポイントは static_members または excluded_members を使用して
# 対象インスタンスを指定します。両方を同時に設定することはできません。
#
# AWS公式ドキュメント:
#   - Neptune ユーザーガイド: https://docs.aws.amazon.com/neptune/latest/userguide/
#   - Neptune カスタムエンドポイント: https://docs.aws.amazon.com/neptune/latest/userguide/cluster-endpoint-custom.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_endpoint" "example" {
  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: このカスタムエンドポイントを関連付ける Neptune クラスターの識別子を指定します。
  cluster_identifier = "my-neptune-cluster"

  # cluster_endpoint_identifier (Required)
  # 設定内容: カスタムエンドポイントの識別子を指定します。
  cluster_endpoint_identifier = "my-custom-endpoint"

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # endpoint_type (Required)
  # 設定内容: カスタムエンドポイントのタイプを指定します。
  # 設定可能な値:
  #   - "READER": 読み取り専用エンドポイント
  #   - "WRITER": 書き込みエンドポイント
  #   - "ANY": 読み書き両方に対応するエンドポイント
  endpoint_type = "READER"

  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # static_members (Optional)
  # 設定内容: このエンドポイントに常に含まれるクラスターインスタンスのリストを指定します。
  # 省略時: excluded_members の指定に基づいてインスタンスが選択されます。
  # 注意: excluded_members と排他的。同時に設定することはできません。
  static_members = []

  # excluded_members (Optional)
  # 設定内容: このエンドポイントから除外するクラスターインスタンスのリストを指定します。
  # 省略時: excluded_members による除外は行われません。
  # 注意: static_members と排他的。同時に設定することはできません。
  excluded_members = []

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: カスタムエンドポイントに割り当てるタグのマップを指定します。
  # プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  # 一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-neptune-custom-endpoint"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Neptune クラスターカスタムエンドポイントの ARN
#
# - endpoint: カスタムエンドポイントの DNS アドレス
#
# - id: Neptune クラスターカスタムエンドポイントの識別子
#
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
