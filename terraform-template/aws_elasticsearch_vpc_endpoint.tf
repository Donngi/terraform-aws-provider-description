#---------------------------------------------------------------
# AWS Elasticsearch VPC Endpoint
#---------------------------------------------------------------
#
# Amazon Elasticsearch Service（OpenSearch Serviceの前身）のVPCエンドポイントを
# プロビジョニングするリソースです。VPCエンドポイントを使用することで、
# VPC内のプライベートサブネットからElasticsearchドメインに安全にアクセスできます。
#
# 注意: Amazon Elasticsearch Serviceは現在「Amazon OpenSearch Service」に
# リブランドされています。新規プロジェクトでは aws_opensearch_vpc_endpoint の
# 使用を推奨します。
#
# AWS公式ドキュメント:
#   - OpenSearch Service VPCサポート: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html
#   - VPCエンドポイント管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc-interface-endpoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_vpc_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticsearch_vpc_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_arn (Required, Forces new resource)
  # 設定内容: VPCエンドポイントを作成する対象のElasticsearchドメインのARNを指定します。
  # 設定可能な値: 有効なElasticsearchドメインのAmazon Resource Name (ARN)
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 関連機能: VPCエンドポイントはドメインごとに作成され、そのドメインへのプライベートアクセスを提供します
  domain_arn = aws_elasticsearch_domain.example.arn

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
  # VPCオプション設定
  #-------------------------------------------------------------

  # vpc_options (Required)
  # 設定内容: VPCエンドポイントのサブネットとセキュリティグループを指定するブロックです。
  # 注意: 少なくとも1つのサブネットIDが必要です。マルチAZ構成の場合は、
  #       異なるアベイラビリティーゾーンのサブネットを指定してください。
  vpc_options {
    # subnet_ids (Required)
    # 設定内容: VPCエンドポイントに関連付けるサブネットIDのリストを指定します。
    # 設定可能な値: VPCサブネットIDの配列
    # 注意: ドメインが複数のアベイラビリティーゾーンを使用している場合は、
    #       各ゾーンに1つずつ、2つのサブネットIDを指定する必要があります。
    #       それ以外の場合は、1つのサブネットIDのみを指定します。
    subnet_ids = [
      aws_subnet.private_a.id,
      aws_subnet.private_c.id,
    ]

    # security_group_ids (Optional)
    # 設定内容: VPCエンドポイントに関連付けるセキュリティグループIDのリストを指定します。
    # 設定可能な値: セキュリティグループIDの配列
    # 省略時: Elasticsearch ServiceはVPCのデフォルトセキュリティグループを使用します
    # 推奨: 明示的にセキュリティグループを指定し、必要最小限のアクセスのみを許可することを推奨
    security_group_ids = [
      aws_security_group.elasticsearch.id,
    ]
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  # VPCエンドポイントの作成・更新・削除には時間がかかる場合があります。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    delete = "90m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCエンドポイントの一意識別子
#
# - endpoint: ドメインに接続するための接続エンドポイントID
#
# - vpc_options[0].availability_zones: VPCエンドポイントが配置された
#                                      アベイラビリティーゾーンのセット
#
# - vpc_options[0].vpc_id: VPCエンドポイントが作成されたVPCのID
#---------------------------------------------------------------
