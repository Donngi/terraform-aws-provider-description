#---------------------------------------------------------------
# VPC Endpoint Service Private DNS Verification
#---------------------------------------------------------------
#
# VPCエンドポイントサービスのプライベートDNS名検証プロセスを開始する
# リソースです。StartVpcEndpointServicePrivateDnsVerification APIを
# 呼び出すことで検証を開始します。サービスプロバイダーは、このリソースを
# 作成する前にDNSサーバーにTXTレコードを追加する必要があります。
#
# AWS公式ドキュメント:
#   - VPCエンドポイントサービスのDNS名管理: https://docs.aws.amazon.com/vpc/latest/privatelink/manage-dns-names.html
#   - StartVpcEndpointServicePrivateDnsVerification API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_StartVpcEndpointServicePrivateDnsVerification.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service_private_dns_verification
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_service_private_dns_verification" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # service_id (Required)
  # 設定内容: 検証対象のエンドポイントサービスのIDを指定します。
  # 設定可能な値: VPCエンドポイントサービスID（vpce-svc-xxxxxx形式）
  # 関連機能: VPCエンドポイントサービス プライベートDNS検証
  #   サービスプロバイダーがプライベートDNS名ドメインの所有権を証明するための
  #   検証プロセスを開始します。検証が成功するまで、サービスコンシューマーは
  #   プライベートDNS名を使用してサービスにアクセスできません。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/manage-dns-names.html
  # 注意: 検証開始前に、サービスプロバイダーはDNSサーバーにTXTレコードを追加する必要があります。
  service_id = "vpce-svc-1234567890abcdef0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 検証待機設定
  #-------------------------------------------------------------

  # wait_for_verification (Optional)
  # 設定内容: 設定したプライベートDNS名に対してエンドポイントサービスが
  #           Verified（検証済み）ステータスを返すまで待機するかを指定します。
  # 設定可能な値:
  #   - true: 検証が完了するまでTerraformの処理を待機
  #   - false: 検証プロセスを開始後、即座に次の処理に進む
  # 省略時: false（検証完了を待たずに処理を続行）
  # 関連機能: プライベートDNS名検証ステータス
  #   検証プロセスのステータスは以下の3種類:
  #   - pendingVerification: 検証保留中
  #   - verified: 検証完了
  #   - failed: 検証失敗
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrivateDnsNameConfiguration.html
  # 注意: このリソースを削除しても検証プロセスは停止せず、Terraformステートから削除されるのみです。
  wait_for_verification = false

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位の文字列（例: "30s", "5m", "2h45m"）
    #               有効な単位: s（秒）、m（分）、h（時間）
    # 省略時: デフォルトのタイムアウト値を使用
    # 参考: https://pkg.go.dev/time#ParseDuration
    # 注意: wait_for_verification=trueの場合、検証完了まで時間がかかる可能性があるため、
    #       適切なタイムアウト値を設定してください。
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは標準的な読み取り専用属性（id等）をエクスポートします。
# 検証ステータスの確認にはaws_vpc_endpoint_serviceデータソースまたは
# リソースを使用してください。
#---------------------------------------------------------------
