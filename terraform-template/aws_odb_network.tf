#---------------------------------------------------------------
# AWS Oracle Database@AWS ODB Network
#---------------------------------------------------------------
#
# Oracle Database@AWS (ODB@AWS) のODBネットワークをプロビジョニングするリソースです。
# ODBネットワークはAWSアベイラビリティゾーン内でOCIインフラをホストするプライベート
# 隔離ネットワークです。クライアントサブネットとバックアップサブネットのCIDR範囲で
# 構成され、ODB PeeringによりAmazon VPCと接続してOracle Exadataデータベースへの
# アクセスを実現します。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS の概要: https://docs.aws.amazon.com/odb/latest/UserGuide/how-it-works.html
#   - Oracle Database@AWS スタートガイド: https://docs.aws.amazon.com/odb/latest/UserGuide/getting-started.html
#   - OdbNetwork APIリファレンス: https://docs.aws.amazon.com/odb/latest/APIReference/API_OdbNetwork.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_network
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_network" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required, Forces new resource)
  # 設定内容: ODBネットワークのユーザーフレンドリーな表示名を指定します。
  # 設定可能な値: 任意の文字列
  display_name = "odb-my-net"

  #-------------------------------------------------------------
  # ネットワーク配置設定
  #-------------------------------------------------------------

  # availability_zone_id (Required, Forces new resource)
  # 設定内容: ODBネットワークを配置するAWSアベイラビリティゾーンのIDを指定します。
  # 設定可能な値: 有効なAZのID（例: use1-az6）
  # 参考: https://docs.aws.amazon.com/ram/latest/userguide/working-with-az-ids.html
  availability_zone_id = "use1-az6"

  # availability_zone (Optional, Forces new resource)
  # 設定内容: ODBネットワークを配置するアベイラビリティゾーン名を指定します。
  # 設定可能な値: 有効なAZの名前（例: us-east-1a）
  # 省略時: availability_zone_id から自動的に決定されます。
  # 注意: availability_zone_id と整合が取れた値を指定してください。
  availability_zone = null

  #-------------------------------------------------------------
  # サブネットCIDR設定
  #-------------------------------------------------------------

  # client_subnet_cidr (Required, Forces new resource)
  # 設定内容: ODBネットワークのクライアントサブネットのCIDR範囲を指定します。
  # 設定可能な値: 有効なCIDR表記（例: 10.2.0.0/24）
  # 注意:
  #   - バックアップサブネットのCIDR範囲と重複不可
  #   - ODBネットワークに接続するVPCのCIDR範囲と重複不可
  #   - OCIが予約する以下のCIDR範囲は使用不可:
  #     - 100.106.0.0/16 および 100.107.0.0/16
  #     - 169.254.0.0/16
  #     - 224.0.0.0 - 239.255.255.255
  #     - 240.0.0.0 - 255.255.255.255
  client_subnet_cidr = "10.2.0.0/24"

  # backup_subnet_cidr (Required, Forces new resource)
  # 設定内容: ODBネットワークのバックアップサブネットのCIDR範囲を指定します。
  # 設定可能な値: 有効なCIDR表記（例: 10.2.1.0/24）
  # 注意:
  #   - クライアントサブネットのCIDR範囲と重複不可
  #   - ODBネットワークに接続するVPCのCIDR範囲と重複不可
  #   - OCIが予約する以下のCIDR範囲は使用不可:
  #     - 100.106.0.0/16 および 100.107.0.0/16
  #     - 169.254.0.0/16
  #     - 224.0.0.0 - 239.255.255.255
  #     - 240.0.0.0 - 255.255.255.255
  backup_subnet_cidr = "10.2.1.0/24"

  #-------------------------------------------------------------
  # AWSサービス統合設定
  #-------------------------------------------------------------

  # s3_access (Required)
  # 設定内容: ODBネットワークからAmazon S3へのアクセス設定を指定します。
  # 設定可能な値:
  #   - "ENABLED": S3アクセスを有効化。VPC Lattice経由でS3へのネイティブ接続を提供
  #   - "DISABLED": S3アクセスを無効化
  # 参考: https://docs.aws.amazon.com/vpc-lattice/latest/ug/vpc-lattice-oci-s3-access.html
  s3_access = "DISABLED"

  # zero_etl_access (Required)
  # 設定内容: ODBネットワークからZero-ETLアクセスの設定を指定します。
  # 設定可能な値:
  #   - "ENABLED": Zero-ETLアクセスを有効化。Amazon Redshiftへのゼロ-ETL統合をサポート
  #   - "DISABLED": Zero-ETLアクセスを無効化
  # 注意: Zero-ETLはODBネットワークと同一リージョンでのみサポートされ、オプトイン機能です。
  zero_etl_access = "DISABLED"

  # s3_policy_document (Optional)
  # 設定内容: ODBネットワークからのAmazon S3アクセスに対するエンドポイントポリシーを指定します。
  # 設定可能な値: 有効なS3エンドポイントポリシーのJSONドキュメント
  # 省略時: デフォルトのアクセスポリシーが適用されます。
  # 注意: s3_access が "ENABLED" の場合のみ有効です。
  s3_policy_document = null

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # default_dns_prefix (Optional, Forces new resource)
  # 設定内容: ネットワークリソースのデフォルトDNSプレフィックスを指定します。
  # 設定可能な値: 有効なDNSプレフィックス文字列
  # 省略時: 自動的に割り当てられます。
  # 注意: custom_domain_name と同時に指定することはできません。
  default_dns_prefix = null

  # custom_domain_name (Optional)
  # 設定内容: ODBネットワークが配置されるカスタムドメイン名を指定します。
  # 設定可能な値: 有効なカスタムドメイン名文字列
  # 省略時: カスタムドメインは設定されません。
  # 注意: default_dns_prefix と同時に指定することはできません。
  custom_domain_name = null

  #-------------------------------------------------------------
  # リソース削除設定
  #-------------------------------------------------------------

  # delete_associated_resources (Optional)
  # 設定内容: ODBネットワーク削除時に関連するOCIリソースも削除するかどうかを指定します。
  # 設定可能な値:
  #   - true: ODBネットワーク削除時に関連するOCIリソースも削除
  #   - false (デフォルト): 関連するOCIリソースは削除しない
  # 省略時: false（関連OCIリソースを削除しない）
  delete_associated_resources = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
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
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "odb-my-net"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 数値と時間単位のサフィックスで構成される文字列
    #   （例: "30s", "2h45m"。有効な単位: "s"=秒, "m"=分, "h"=時間）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 数値と時間単位のサフィックスで構成される文字列
    #   （例: "30s", "2h45m"。有効な単位: "s"=秒, "m"=分, "h"=時間）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 数値と時間単位のサフィックスで構成される文字列
    #   （例: "30s", "2h45m"。有効な単位: "s"=秒, "m"=分, "h"=時間）
    # 注意: 削除操作のタイムアウトは、destroyが実行される前にstateに保存された場合のみ有効です。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ODBネットワークのAmazon Resource Name (ARN)
# - id: ODBネットワークリソースの一意の識別子
# - status: ネットワークリソースのステータス
# - status_reason: ODBネットワークの現在のステータスに関する追加情報
# - created_at: ODBネットワークが作成された日時
# - percent_progress: 現在の操作の進捗率（パーセント）
# - oci_network_anchor_id: ODBネットワークのOCIネットワークアンカーの一意の識別子
# - oci_network_anchor_url: ODBネットワークのOCIネットワークアンカーのURL
# - oci_resource_anchor_name: ODBネットワークのOCIリソースアンカー名
# - oci_vcn_id: ODBネットワークのOCI VCNのOCID（Oracle Cloud ID）
# - oci_vcn_url: ODBネットワークのOCI VCNのURL
# - oci_dns_forwarding_configs: ociPrivateZoneドメインのDNSクエリ転送用OCIのDNSリゾルバーエンドポイント
# - peered_cidrs: ODBネットワークへのアクセスが許可されたピアリングVPCのCIDR範囲のリスト
# - managed_services: ODBネットワークのマネージドサービス設定
# - tags_all: プロバイダーのdefault_tags設定を含むすべてのタグのマップ
#---------------------------------------------------------------
