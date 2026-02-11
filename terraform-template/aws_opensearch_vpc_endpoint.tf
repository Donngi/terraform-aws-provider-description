#---------------------------------------------------------------
# Amazon OpenSearch Service VPC Endpoint
#---------------------------------------------------------------
#
# Amazon OpenSearch Service マネージド VPC エンドポイントを作成します。
# VPC エンドポイントにより、VPC 内のリソースから OpenSearch ドメインへの
# プライベート接続を確立できます。
#
# AWS公式ドキュメント:
#   - CreateVpcEndpoint API: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_CreateVpcEndpoint.html
#   - VPC Support: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/opensearch_vpc_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_vpc_endpoint" "example" {
  #---------------------------------------------------------------
  # ドメイン設定
  #---------------------------------------------------------------

  # domain_arn (Required, Forces new resource)
  # 設定内容: VPC エンドポイントを作成する対象の OpenSearch ドメインの ARN を指定します。
  # 設定可能な値: 有効な OpenSearch ドメインの ARN
  # 注意: この値を変更すると、リソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_CreateVpcEndpoint.html
  domain_arn = "arn:aws:es:ap-northeast-1:123456789012:domain/my-domain"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # VPC ネットワーク設定
  #---------------------------------------------------------------

  # vpc_options (Required)
  # 設定内容: VPC エンドポイントのサブネットとセキュリティグループを指定します。
  # 関連機能: VPC Support for Amazon OpenSearch Service
  #   OpenSearch ドメインへの VPC 内からのプライベートアクセスを構成します。
  #   VPC エンドポイントにより、インターネットゲートウェイやNATゲートウェイを
  #   経由せずにドメインにアクセスできます。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html
  vpc_options {
    # subnet_ids (Required)
    # 設定内容: VPC エンドポイントに関連付けるサブネット ID のリストを指定します。
    # 設定可能な値: 有効なサブネット ID のセット
    # 注意: ドメインが複数のアベイラビリティーゾーンを使用する場合は、
    #       ゾーンごとに1つずつ、2つのサブネット ID を指定する必要があります。
    #       単一の AZ を使用する場合は、1つのサブネット ID のみを指定します。
    # 参考: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_CreateVpcEndpoint.html
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # security_group_ids (Optional)
    # 設定内容: VPC エンドポイントに関連付けるセキュリティグループ ID のリストを指定します。
    # 設定可能な値: 有効なセキュリティグループ ID のセット
    # 省略時: OpenSearch Service は VPC のデフォルトセキュリティグループを使用します。
    # 参考: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_CreateVpcEndpoint.html
    security_group_ids = ["sg-12345678"]
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト設定を指定します。
  # 設定可能な値: 各操作（create, update, delete）のタイムアウト時間
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = "60m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    update = "60m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "90m", "2h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    delete = "90m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: エンドポイントの一意の識別子
#
# - endpoint: ドメインへの接続に使用する接続エンドポイント ID
#
# - vpc_options.availability_zones: VPC エンドポイントに関連付けられた
#                                    アベイラビリティーゾーンのセット
#
# - vpc_options.vpc_id: VPC エンドポイントが存在する VPC の ID
#---------------------------------------------------------------
