#---------------------------------------------------------------
# AWS RDS Aurora クラスターカスタムエンドポイント
#---------------------------------------------------------------
#
# Amazon Aurora DBクラスターのカスタムエンドポイントをプロビジョニングするリソースです。
# カスタムエンドポイントは、クラスター内の特定のDBインスタンスセットへの接続を
# 提供するDNSエイリアスです。異なるキャパシティや設定を持つインスタンスを
# グループ化して、ワークロードに応じた接続先を使い分けることができます。
#
# AWS公式ドキュメント:
#   - Aurora カスタムエンドポイント概要: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Endpoints.Custom.html
#   - カスタムエンドポイントの作成: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-custom-endpoint-creating.html
#   - カスタムエンドポイントの考慮事項: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Endpoints.Custom.Considerations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_identifier (Required, Forces new resource)
  # 設定内容: カスタムエンドポイントを関連付けるAuroraクラスターの識別子を指定します。
  # 設定可能な値: 既存のAurora DBクラスターの識別子文字列
  cluster_identifier = "aurora-cluster-demo"

  # cluster_endpoint_identifier (Required, Forces new resource)
  # 設定内容: 新しいエンドポイントに使用する識別子を指定します。
  # 設定可能な値: 1-63文字の英数字またはハイフン。先頭は英文字、末尾はハイフン不可。
  #   この値は小文字として保存されます。
  # 注意: 同一AWSリージョン内でカスタムエンドポイント名は再利用できません。
  cluster_endpoint_identifier = "my-custom-endpoint"

  # custom_endpoint_type (Required)
  # 設定内容: エンドポイントのタイプを指定します。
  # 設定可能な値:
  #   - "READER": Auroraレプリカインスタンスのみを対象とするエンドポイント
  #   - "ANY": プライマリインスタンスとAuroraレプリカの両方を対象とするエンドポイント
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Endpoints.Custom.Considerations.html
  custom_endpoint_type = "READER"

  #-------------------------------------------------------------
  # メンバーシップ設定
  #-------------------------------------------------------------

  # static_members (Optional)
  # 設定内容: カスタムエンドポイントグループに含めるDBインスタンス識別子のリストを指定します。
  # 設定可能な値: DBインスタンス識別子の文字列セット
  # 省略時: エンドポイントは全てのAuroraレプリカと関連付けられます。
  # 注意: excluded_membersと排他的（どちらか一方のみ指定可能）。
  #   static_membersを指定した場合、リストにないインスタンスが追加されても
  #   自動的にはエンドポイントに追加されません（静的メンバーシップ）。
  static_members = [
    "db-instance-identifier-1",
    "db-instance-identifier-2",
  ]

  # excluded_members (Optional)
  # 設定内容: カスタムエンドポイントグループから除外するDBインスタンス識別子のリストを指定します。
  # 設定可能な値: DBインスタンス識別子の文字列セット
  # 省略時: 除外するインスタンスはありません。
  # 注意: static_membersと排他的（どちらか一方のみ指定可能）。
  #   static_membersリストが空の場合にのみ適用されます。
  #   excluded_membersに含まれないインスタンスは全て接続可能になります（動的除外メンバーシップ）。
  excluded_members = []

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-custom-endpoint"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターカスタムエンドポイントのAmazon Resource Name (ARN)
#
# - endpoint: AuroraクラスターのカスタムエンドポイントDNS名
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
