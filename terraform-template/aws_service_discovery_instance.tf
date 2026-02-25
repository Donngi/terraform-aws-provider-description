#---------------------------------------------------------------
# AWS Cloud Map Service Discovery Instance
#---------------------------------------------------------------
#
# AWS Cloud Map のサービスディスカバリーインスタンスをプロビジョニングするリソースです。
# サービスに対してリソース（EC2インスタンス、IPアドレス、カスタム属性等）を登録し、
# DiscoverInstances API または DNS クエリによるサービス検出を可能にします。
#
# AWS公式ドキュメント:
#   - インスタンス登録: https://docs.aws.amazon.com/cloud-map/latest/dg/registering-instances.html
#   - RegisterInstance API: https://docs.aws.amazon.com/cloud-map/latest/api/API_RegisterInstance.html
#   - サービスインスタンス概要: https://docs.aws.amazon.com/cloud-map/latest/dg/working-with-instances.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/service_discovery_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_service_discovery_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_id (Required, Forces new resource)
  # 設定内容: インスタンスに関連付ける識別子を指定します。
  # 設定可能な値: 最大 64 文字の文字列
  # 注意: 同じサービス内で一意である必要があります。
  #       EC2 インスタンス ID を指定する場合、対象インスタンスが存在するアカウントと
  #       リージョンで一意な識別子として使用できます。
  instance_id = "example-instance-id"

  # service_id (Required, Forces new resource)
  # 設定内容: インスタンスを登録するサービスの ID を指定します。
  # 設定可能な値: 有効な AWS Cloud Map サービス ID
  # 参考: https://docs.aws.amazon.com/cloud-map/latest/dg/working-with-services.html
  service_id = aws_service_discovery_service.example.id

  #-------------------------------------------------------------
  # インスタンス属性設定
  #-------------------------------------------------------------

  # attributes (Required)
  # 設定内容: インスタンスの属性マップを指定します。サービス設定に応じた属性を定義します。
  # 設定可能な値: 以下の予約済みキーおよびカスタム属性のマップ
  #
  #   AWS_ALIAS_DNS_NAME:
  #     ELB ロードバランサーへのエイリアスレコードを作成する場合に指定。
  #     サービスの RoutingPolicy は WEIGHTED である必要があります。
  #
  #   AWS_EC2_INSTANCE_ID:
  #     HTTP 名前空間専用。EC2 インスタンス ID を指定します。
  #     指定した場合、AWS_INSTANCE_IPV4 は自動的にプライマリプライベート IPv4 で補完されます。
  #     この属性と同時に指定できるのは AWS_INIT_HEALTH_STATUS のみです。
  #
  #   AWS_INIT_HEALTH_STATUS:
  #     カスタムヘルスチェックの初期ステータスを指定します。
  #     設定可能な値: "HEALTHY"（デフォルト）または "UNHEALTHY"
  #
  #   AWS_INSTANCE_CNAME:
  #     サービスが CNAME レコードを含む場合に Route 53 が返すドメイン名。
  #
  #   AWS_INSTANCE_IPV4:
  #     サービスが A レコードを含む場合に Route 53 が返す IPv4 アドレス。
  #     SRV レコードの場合、AWS_INSTANCE_IPV4 か AWS_INSTANCE_IPV6 のいずれかが必須。
  #
  #   AWS_INSTANCE_IPV6:
  #     サービスが AAAA レコードを含む場合に Route 53 が返す IPv6 アドレス。
  #     SRV レコードの場合、AWS_INSTANCE_IPV4 か AWS_INSTANCE_IPV6 のいずれかが必須。
  #
  #   AWS_INSTANCE_PORT:
  #     SRV レコードまたは Route 53 ヘルスチェックのポート番号。
  #
  #   カスタム属性:
  #     最大 30 個まで追加可能。キー最大 255 文字、値最大 1,024 文字。
  #     全属性の合計サイズは 5,000 文字以内。
  #
  # 注意: 名前空間がパブリック DNS クエリで検出可能な場合、機密情報を含めないこと。
  # 参考: https://docs.aws.amazon.com/cloud-map/latest/api/API_RegisterInstance.html#API_RegisterInstance_RequestSyntax
  attributes = {
    AWS_INSTANCE_IPV4 = "172.18.0.1"
    custom_attribute  = "custom_value"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: インスタンスの ID（instance_id と同じ値）
#---------------------------------------------------------------
