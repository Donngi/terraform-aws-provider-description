#---------------------------------------------------------------
# AWS Direct Connect Connection
#---------------------------------------------------------------
#
# AWS Direct Connectの物理接続を作成します。
# オンプレミス環境とAWS間のプライベート専用ネットワーク接続を確立し、
# インターネット経由よりも高速で安定したデータ転送を実現します。
#
# AWS公式ドキュメント:
#   - Direct Connect connection options: https://docs.aws.amazon.com/directconnect/latest/UserGuide/connection_options.html
#   - AWS Direct Connect Features: https://aws.amazon.com/directconnect/features/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_connection" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # name - (必須) 接続の名前
  # Direct Connect接続を識別するための名前を指定します。
  name = "example-dx-connection"

  # bandwidth - (必須) 接続の帯域幅
  # 専用接続の有効な値: 1Gbps, 10Gbps, 100Gbps, 400Gbps
  # ホスト接続の有効な値: 50Mbps, 100Mbps, 200Mbps, 300Mbps, 400Mbps, 500Mbps, 1Gbps, 2Gbps, 5Gbps, 10Gbps, 25Gbps
  # 大文字小文字が区別されます。
  # 詳細: https://docs.aws.amazon.com/directconnect/latest/UserGuide/dedicated_connection.html
  #       https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted_connection.html
  bandwidth = "1Gbps"

  # location - (必須) 接続が配置されるAWS Direct Connectのロケーション
  # DescribeLocations APIで取得できるlocationCodeを使用します。
  # 例: EqDC2 (Equinix DC2), EqDA2 (Equinix DA2)
  # 詳細: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_DescribeLocations.html
  location = "EqDC2"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # encryption_mode - (オプション) MAC Security (MACsec)暗号化モード
  # MAC Security (MACsec)は専用接続でのみ利用可能です。
  # 有効な値:
  #   - no_encrypt: 暗号化なし
  #   - should_encrypt: 可能であれば暗号化
  #   - must_encrypt: 必ず暗号化
  # encryption_mode = "no_encrypt"

  # provider_name - (オプション) 接続に関連付けられるサービスプロバイダーの名前
  # Direct Connect Partnerを使用する場合に指定します。
  # provider_name = "Example Provider"

  # request_macsec - (オプション) MAC Security (MACsec)のサポート要求
  # 接続でMAC Security (MACsec)をサポートするかどうかを示すブール値。
  # MAC Security (MACsec)は専用接続でのみ利用可能です。
  # デフォルト値: false
  # 注意: request_macsecの値を変更すると、リソースが削除されて再作成されます。
  # 前提条件: https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-mac-sec-getting-started.html#mac-sec-prerequisites
  # request_macsec = false

  # skip_destroy - (オプション) 削除時にリソースを破棄しない設定
  # trueに設定すると、destroy時に接続を削除せず、Terraformステートから削除するのみとなります。
  # 本番環境で誤って接続を削除することを防ぐために使用できます。
  # skip_destroy = false

  # tags - (オプション) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # tags = {
  #   Environment = "production"
  #   Project     = "example"
  # }

  # region - (オプション) このリソースが管理されるリージョン
  # プロバイダー設定で設定されたリージョンがデフォルトとなります。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn - 接続のARN
# - aws_device - 物理接続が終端するDirect Connectエンドポイント
# - has_logical_redundancy - 同じアドレスファミリ(IPv4/IPv6)で
#   セカンダリBGPピアをサポートするかどうかを示すブール値
# - id - 接続のID
# - jumbo_frame_capable - ジャンボフレームが有効化されているかを示すブール値
# - macsec_capable - MAC Security (MACsec)をサポートするかを示すブール値
# - owner_account_id - 接続を所有するAWSアカウントのID
# - partner_name - 接続に関連付けられたAWS Direct Connectサービスプロバイダーの名前
# - port_encryption_status - MAC Security (MACsec)ポートリンクのステータス
# - tags_all - プロバイダーのdefault_tags設定ブロックから継承されたものを含む、
#   リソースに割り当てられたタグのマップ
# - vlan_id - VLAN ID
#
# 出力例:
# output "connection_id" {
#   value = aws_dx_connection.example.id
# }
#
# output "connection_arn" {
#   value = aws_dx_connection.example.arn
# }
