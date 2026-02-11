#---------------------------------------------------------------
# VPC IPAM スコープ
#---------------------------------------------------------------
#
# Amazon VPC IP Address Management (IPAM) のスコープを作成します。
# スコープは IPAM 内の最上位コンテナであり、単一ネットワークの IP スペースを表します。
# IPAM 作成時にはプライベートとパブリックの2つのデフォルトスコープが作成されますが、
# このリソースを使用して追加のプライベートスコープを作成できます。
# 追加のスコープは、同じIPアドレス空間を使用する複数の独立したネットワークを
# IPアドレスの重複や競合なしに管理する場合に有効です。
#
# AWS公式ドキュメント:
#   - Create additional scopes: https://docs.aws.amazon.com/vpc/latest/ipam/add-scope-ipam.html
#   - IpamScope API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_IpamScope.html
#   - CreateIpamScope API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateIpamScope.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_scope
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipam_scope" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # IPAMのID
  # このスコープを作成する対象のIPAMのIDを指定します。
  # Type: string
  ipam_id = "ipam-12345678901234567"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # スコープの説明
  # このスコープの用途や目的を説明する任意のテキストです。
  # 管理を容易にするために、わかりやすい説明を設定することを推奨します。
  # Type: string
  # Default: null
  description = "Additional private scope for isolated network"

  # リソースID
  # Terraformによって管理されるリソースの識別子です。
  # 通常は明示的に指定する必要はなく、Terraformが自動的に管理します。
  # Type: string
  # Default: computed
  # id = null

  # リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンが使用されます。
  # Type: string
  # Default: プロバイダー設定のリージョン
  # region = "us-east-1"

  # タグ
  # リソースに付与するキーと値のペアです。
  # リソースの識別、分類、コスト配分などに使用できます。
  # プロバイダーのdefault_tags設定と同じキーを指定した場合、
  # このタグの値が優先されます。
  # Type: map(string)
  # Default: {}
  tags = {
    Name        = "example-ipam-scope"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # 全タグ（プロバイダーのデフォルトタグを含む）
  # プロバイダーのdefault_tags設定で定義されたタグと、
  # このリソースのtagsで指定したタグを統合したものです。
  # 通常は明示的に指定する必要はなく、Terraformが自動的に管理します。
  # Type: map(string)
  # Default: computed
  # tags_all = {}

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 作成タイムアウト
    # スコープの作成処理がタイムアウトするまでの時間を指定します。
    # Type: string (duration format: "10m", "1h" など)
    # Default: null (デフォルトのタイムアウト値が適用されます)
    # create = "10m"

    # 更新タイムアウト
    # スコープの更新処理がタイムアウトするまでの時間を指定します。
    # Type: string (duration format: "10m", "1h" など)
    # Default: null (デフォルトのタイムアウト値が適用されます)
    # update = "10m"

    # 削除タイムアウト
    # スコープの削除処理がタイムアウトするまでの時間を指定します。
    # スコープ内にプールが存在する場合は、先にプールを削除する必要があります。
    # Type: string (duration format: "10m", "1h" など)
    # Default: null (デフォルトのタイムアウト値が適用されます)
    # delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースが作成された後、以下の属性を参照できます:
#
# - arn
#     Type: string
#     スコープのAmazon Resource Name (ARN)です。
#     例: arn:aws:ec2::123456789012:ipam-scope/ipam-scope-12345678901234567
#
# - ipam_arn
#     Type: string
#     このスコープが属するIPAMのARNです。
#     例: arn:aws:ec2::123456789012:ipam/ipam-12345678901234567
#
# - ipam_scope_type
#     Type: string
#     スコープのタイプです。"private"または"public"のいずれかです。
#     デフォルトスコープ以外に作成できるのはprivateスコープのみです。
#
# - is_default
#     Type: bool
#     このスコープがデフォルトスコープかどうかを示すフラグです。
#     IPAM作成時に自動生成されるプライベートおよびパブリックスコープの場合はtrue、
#     追加で作成されたスコープの場合はfalseになります。
#
# - pool_count
#     Type: number
#     このスコープ内に存在するプールの数です。
#     スコープを削除する前に、すべてのプールを削除する必要があります。
#
#---------------------------------------------------------------
