#---------------------------------------------------------------
# Oracle Database@AWS (ODB) ネットワーク
#---------------------------------------------------------------
#
# Oracle Database@AWS（ODB@AWS）用のプライベート分離ネットワークを
# プロビジョニングします。ODBネットワークは、AWS Availability Zone内で
# OCIインフラストラクチャをホストするネットワーク環境を提供し、
# Oracle Exadata DatabaseサービスやAutonomous Databaseへの
# 接続基盤となります。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS の仕組み: https://docs.aws.amazon.com/odb/latest/UserGuide/how-it-works.html
#   - Oracle Database@AWS 入門: https://docs.aws.amazon.com/odb/latest/UserGuide/getting-started.html
#   - OdbNetwork API リファレンス: https://docs.aws.amazon.com/odb/latest/APIReference/API_OdbNetwork.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_network
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_network" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # display_name (必須・変更時は再作成)
  # ODBネットワークのユーザーフレンドリーな表示名を指定します。
  # この値を変更すると、Terraformは新しいリソースを作成します。
  display_name = "odb-my-network"

  # availability_zone_id (必須・変更時は再作成)
  # ODBネットワークを配置するAWSアベイラビリティゾーンのIDを指定します。
  # 例: "use1-az6", "usw2-az1"
  # この値を変更すると、Terraformは新しいリソースを作成します。
  availability_zone_id = "use1-az6"

  # client_subnet_cidr (必須・変更時は再作成)
  # ODBネットワークのクライアントサブネットのCIDR表記を指定します。
  # Exadata VMクラスターおよびAutonomous VMクラスターが使用します。
  # 制約:
  #   - backup_subnet_cidrと重複してはいけない
  #   - 接続されたVPCのCIDR範囲と重複してはいけない
  #   - 以下のOCI予約済みCIDR範囲は使用不可:
  #     - 100.106.0.0/16 および 100.107.0.0/16
  #     - 169.254.0.0/16
  #     - 224.0.0.0 - 239.255.255.255
  #     - 240.0.0.0 - 255.255.255.255
  client_subnet_cidr = "10.2.0.0/24"

  # backup_subnet_cidr (必須・変更時は再作成)
  # ODBネットワークのバックアップサブネットのCIDR範囲を指定します。
  # データベースバックアップ用のネットワーク通信に使用されます。
  # 制約:
  #   - client_subnet_cidrと重複してはいけない
  #   - 接続されたVPCのCIDR範囲と重複してはいけない
  #   - 以下のOCI予約済みCIDR範囲は使用不可:
  #     - 100.106.0.0/16 および 100.107.0.0/16
  #     - 169.254.0.0/16
  #     - 224.0.0.0 - 239.255.255.255
  #     - 240.0.0.0 - 255.255.255.255
  backup_subnet_cidr = "10.2.1.0/24"

  # s3_access (必須)
  # ODBネットワークからのAmazon S3アクセス設定を指定します。
  # 有効な値: "ENABLED" | "DISABLED"
  # ENABLEDにすると、ODBネットワークからS3バケットへの
  # 直接アクセスが可能になります（Amazon VPC Lattice経由）。
  s3_access = "DISABLED"

  # zero_etl_access (必須)
  # ODBネットワークからのZero-ETLアクセス設定を指定します。
  # 有効な値: "ENABLED" | "DISABLED"
  # Zero-ETL統合は、Oracle DatabaseからAmazon Redshiftへの
  # データ連携を可能にするフルマネージドソリューションです。
  # ENABLEDにすると、AWS管理サービスからODBネットワークへの
  # インバウンド接続が許可されます。
  zero_etl_access = "DISABLED"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # availability_zone (オプション・変更時は再作成)
  # ODBネットワークが配置されるアベイラビリティゾーンの名前を指定します。
  # 例: "us-east-1a", "us-west-2b"
  # availability_zone_idと正しくマッピングされていることを確認してください。
  # この値を変更すると、Terraformは新しいリソースを作成します。
  # availability_zone = "us-east-1a"

  # custom_domain_name (オプション・変更時は再作成)
  # ネットワークが配置されるカスタムドメインの名前を指定します。
  # 注意: custom_domain_nameとdefault_dns_prefixは同時に指定できません。
  # custom_domain_name = "example.com"

  # default_dns_prefix (オプション・変更時は再作成)
  # ネットワークリソースのデフォルトDNSプレフィックスを指定します。
  # 注意: custom_domain_nameとdefault_dns_prefixは同時に指定できません。
  # この値を変更すると、Terraformは新しいリソースを作成します。
  # default_dns_prefix = "odb-prefix"

  # s3_policy_document (オプション)
  # ODBネットワークからのAmazon S3アクセス用のエンドポイントポリシーを指定します。
  # 標準的なAmazon S3エンドポイントポリシー構文を使用して、
  # バケット名、AWSアカウント、またはAWS Organizationsに基づく
  # 認可ポリシーを定義できます。
  # s3_policy_document = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Effect    = "Allow"
  #       Principal = "*"
  #       Action    = "s3:*"
  #       Resource  = [
  #         "arn:aws:s3:::my-bucket",
  #         "arn:aws:s3:::my-bucket/*"
  #       ]
  #     }
  #   ]
  # })

  # delete_associated_resources (オプション)
  # trueに設定すると、関連するOCIリソースも削除します。
  # デフォルト: false
  # 警告: この設定を有効にすると、ODBネットワークの削除時に
  # 関連するOCIリソースも同時に削除されます。
  # delete_associated_resources = false

  # region (オプション)
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # Oracle Database@AWSがサポートするリージョン:
  #   - US East (N. Virginia) - us-east-1
  #   - US West (Oregon) - us-west-2
  #   - Asia Pacific (Tokyo) - ap-northeast-1
  #   - US East (Ohio) - us-east-2
  #   - Europe (Frankfurt) - eu-central-1
  # region = "us-east-1"

  # tags (オプション)
  # ODBネットワークに割り当てるタグのマップを指定します。
  # プロバイダーレベルでdefault_tags設定ブロックが設定されている場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたタグを上書きします。
  # tags = {
  #   Environment = "production"
  #   Project     = "oracle-migration"
  #   Team        = "database"
  # }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # 作成・更新・削除操作のタイムアウト値を設定します。
  # 値は "30s"（秒）、"2h45m"（時間と分）などの形式で指定します。
  # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
  #
  # timeouts {
  #   # リソース作成時のタイムアウト
  #   create = "60m"
  #
  #   # リソース更新時のタイムアウト
  #   update = "60m"
  #
  #   # リソース削除時のタイムアウト
  #   # 注意: 削除操作のタイムアウト設定は、destroy操作の前に
  #   # 変更がstateに保存される場合にのみ適用されます。
  #   delete = "60m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、
# 他のリソースから参照できます。
#
# - id
#     ODBネットワークリソースの一意識別子
#
# - arn
#     ODBネットワークリソースのAmazon Resource Name (ARN)
#
# - status
#     ネットワークリソースのステータス
#     例: AVAILABLE, CREATING, UPDATING, DELETING, FAILED
#
# - status_reason
#     ODBネットワークの現在のステータスに関する追加情報
#
# - created_at
#     ODBネットワークが作成された日時
#
# - percent_progress
#     ODBネットワーク上の現在の操作の進捗率（パーセンテージ）
#
# - peered_cidrs
#     ODBネットワークへのアクセスが許可されている
#     ピアリングされたVPCからのCIDR範囲のリスト
#
# - oci_network_anchor_id
#     ODBネットワークのOCIネットワークアンカーの一意識別子
#
# - oci_network_anchor_url
#     ODBネットワークのOCIネットワークアンカーのURL
#
# - oci_resource_anchor_name
#     ODBネットワークのOCIリソースアンカーの名前
#
# - oci_vcn_id
#     ODBネットワークのOCI VCNのOracle Cloud ID (OCID)
#
# - oci_vcn_url
#     ODBネットワークのOCI VCNのURL
#
# - oci_dns_forwarding_configs
#     ociPrivateZoneドメインのDNSクエリを転送するための
#     OCI内のDNSリゾルバーエンドポイント情報
#     各要素には以下が含まれます:
#       - domain_name: ドメイン名
#       - oci_dns_listener_ip: OCIのDNSリスナーIPアドレス
#
# - managed_services
#     ODBネットワークの管理サービス設定
#     以下の情報が含まれます:
#       - managed_s3_backup_access: 管理対象S3バックアップアクセス情報
#       - managed_service_ipv4_cidrs: 管理サービスのIPv4 CIDR
#       - resource_gateway_arn: リソースゲートウェイARN
#       - s3_access: S3アクセス情報
#       - service_network_arn: サービスネットワークARN
#       - service_network_endpoint: サービスネットワークエンドポイント
#       - zero_etl_access: Zero-ETLアクセス情報
#
# - tags_all
#     リソースに割り当てられたすべてのタグのマップ
#     プロバイダーのdefault_tagsで設定されたタグを含みます
#---------------------------------------------------------------
