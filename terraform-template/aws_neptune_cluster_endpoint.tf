#---------------------------------------------------------------
# aws_neptune_cluster_endpoint
#---------------------------------------------------------------
#
# Amazon Neptune DBクラスターのカスタムエンドポイントを作成するリソース。
# カスタムエンドポイントを使用することで、特定のDBインスタンスのグループに対して
# 負荷分散されたデータベース接続を提供できる。読み取り/書き込み機能以外の基準で
# 接続を分散させたい場合や、クラスター内の全レプリカを同一に保つことが実用的でない
# 特殊なワークロードに適している。
#
# AWS公式ドキュメント:
#   - Connecting to Amazon Neptune Endpoints: https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-endpoints.html
#   - Working with custom endpoints in Neptune: https://docs.aws.amazon.com/neptune/latest/userguide/feature-custom-endpoint-membership.html
#   - DBClusterEndpoint API Reference: https://docs.aws.amazon.com/neptune/latest/apiref/API_DBClusterEndpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/neptune_cluster_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_endpoint" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # cluster_identifier
  # (必須, Forces new resource) エンドポイントに関連付けるNeptune DBクラスターの識別子。
  # 新しい値を設定すると、リソースが再作成される。
  # 型: string
  cluster_identifier = null # 例: aws_neptune_cluster.example.cluster_identifier

  # cluster_endpoint_identifier
  # (必須, Forces new resource) カスタムエンドポイントの識別子。
  # ユーザーIDとリージョン内で一意である必要がある。クラスター名は含まない。
  # 新しい値を設定すると、リソースが再作成される。
  # 型: string
  cluster_endpoint_identifier = null # 例: "my-custom-endpoint"

  # endpoint_type
  # (必須) エンドポイントのタイプ。以下のいずれかを指定:
  #   - "READER": 読み取り専用のエンドポイント
  #   - "WRITER": 書き込み可能なエンドポイント
  #   - "ANY": 読み取りと書き込みの両方が可能なエンドポイント
  # 型: string
  endpoint_type = null # 例: "READER"

  #---------------------------------------------------------------
  # 任意引数 (Optional Arguments)
  #---------------------------------------------------------------

  # excluded_members
  # (任意) カスタムエンドポイントグループに含めないDBインスタンス識別子のリスト。
  # このリストに含まれないすべての適格なインスタンスは、カスタムエンドポイント経由で
  # 到達可能になる。static_membersが空の場合にのみ関連する。
  # static_membersとexcluded_membersは相互排他的に使用する。
  # 型: set(string)
  # デフォルト: null
  excluded_members = null # 例: ["neptune-instance-1", "neptune-instance-2"]

  # static_members
  # (任意) カスタムエンドポイントグループに含めるDBインスタンス識別子のリスト。
  # 指定したインスタンスのみがこのエンドポイントの対象となる。
  # static_membersとexcluded_membersは相互排他的に使用する。
  # DBインスタンスは複数のカスタムエンドポイントに関連付けることができる。
  # 型: set(string)
  # デフォルト: null
  static_members = null # 例: ["neptune-instance-3", "neptune-instance-4"]

  # region
  # (任意) このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトとして使用される。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  region = null # 例: "ap-northeast-1"

  # tags
  # (任意) Neptuneクラスターエンドポイントに割り当てるタグのマップ。
  # プロバイダーレベルで `default_tags` が設定されている場合、
  # 同じキーを持つタグはプロバイダーレベルの定義を上書きする。
  # 型: map(string)
  # デフォルト: null
  tags = null
  # 例:
  # tags = {
  #   Environment = "production"
  #   Project     = "my-project"
  # }

  # tags_all
  # (任意) リソースに割り当てられたすべてのタグのマップ。
  # プロバイダーの `default_tags` から継承されたタグを含む。
  # 通常、このプロパティは直接設定せず、tagsとdefault_tagsの組み合わせで管理する。
  # 型: map(string)
  # デフォルト: null (tagsとdefault_tagsから自動計算)
  # tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# このリソースは上記の引数に加えて、以下の属性をエクスポートします:
#
# arn
#   Neptune クラスターエンドポイントのAmazon Resource Name (ARN)。
#   型: string
#   例: "arn:aws:rds:ap-northeast-1:123456789012:cluster-endpoint:my-custom-endpoint"
#
# endpoint
#   エンドポイントのDNSアドレス。アプリケーションからの接続に使用する。
#   型: string
#   例: "my-custom-endpoint.cluster-ro-xxxxxxxxxxxx.ap-northeast-1.neptune.amazonaws.com"
#
# id
#   Neptune クラスターエンドポイントの識別子。cluster_endpoint_identifierと同じ値。
#   型: string
#
#---------------------------------------------------------------
