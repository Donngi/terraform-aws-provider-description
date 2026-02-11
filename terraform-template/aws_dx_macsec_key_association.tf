#---------------------------------------------------------------
# AWS Direct Connect MACsec Key Association
#---------------------------------------------------------------
#
# AWS Direct Connect の専用接続に対して MAC Security (MACsec) シークレットキーを
# 関連付けるリソースです。MACsecは IEEE 802.1AE 標準に基づくレイヤー2の暗号化を提供し、
# データセンターと AWS Direct Connect ロケーション間のデータの機密性、整合性、
# 送信元の認証を保証します。
#
# 重要な注意事項:
#   - このリソースを作成すると、Direct Connect によって管理される
#     aws_secretsmanager_secret リソースも自動的に作成されます
#   - ckn と cak を含むすべての引数は、Terraform の state にプレーンテキストで保存されます
#   - secret_arn は既存の MACsec キーの参照にのみ使用可能です
#
# AWS公式ドキュメント:
#   - MACsec 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/MACsec.html
#   - MACsec の開始: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-macsec-dedicated.html
#   - MACsec キーの関連付け: https://docs.aws.amazon.com/directconnect/latest/UserGuide/associate-key-connection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_macsec_key_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_macsec_key_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: MACsec キーを関連付ける Direct Connect 専用接続の ID を指定します。
  # 設定可能な値: 有効な Direct Connect 接続 ID (例: dxcon-xxxxxxxx)
  # 注意: 接続は専用接続であり、AVAILABLE 状態である必要があります
  # 関連機能: AWS Direct Connect 専用接続
  #   MACsec は専用接続および Link Aggregation Group (LAG) でサポートされています。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/MACsec.html
  connection_id = "dxcon-xxxxxxxx"

  #-------------------------------------------------------------
  # MACsec キー設定 (CKN/CAK 方式)
  #-------------------------------------------------------------
  # ckn と cak を使用して新しい MACsec キーを作成する方式です。
  # secret_arn とは相互排他的です。

  # ckn (Optional, Computed)
  # 設定内容: 専用接続に関連付ける MAC Security (MACsec) CKN (Connectivity Key Name) を指定します。
  # 設定可能な値: 64文字の16進数文字列 (0-9, A-F)
  # 用途: 新しい MACsec キーを作成する場合に cak と組み合わせて使用
  # 注意: cak を使用する場合は必須です
  # 関連機能: MACsec CKN (Connectivity Association Key Name)
  #   CKN は MACsec セッションを識別するために使用されます。
  #   オンプレミスルーターの CKN と一致する必要があります。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/MACsec.html
  ckn = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"

  # cak (Optional)
  # 設定内容: 専用接続に関連付ける MAC Security (MACsec) CAK (Connectivity Association Key) を指定します。
  # 設定可能な値: 64文字の16進数文字列 (0-9, A-F)
  # 用途: 新しい MACsec キーを作成する場合に ckn と組み合わせて使用
  # 注意: ckn を使用する場合は必須です。機密情報としてステートに保存されます
  # 関連機能: MACsec CAK (Connectivity Association Key)
  #   CAK は MACsec セッションの暗号化キーを生成するために使用される共有シークレットです。
  #   オンプレミスルーターの CAK と一致する必要があります。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/MACsec.html
  cak = "abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789"

  #-------------------------------------------------------------
  # MACsec キー設定 (既存シークレット参照方式)
  #-------------------------------------------------------------
  # 既存の Secrets Manager シークレットを参照する方式です。
  # ckn/cak とは相互排他的です。

  # secret_arn (Optional, Computed)
  # 設定内容: 専用接続に関連付ける MAC Security (MACsec) シークレットキーの ARN を指定します。
  # 設定可能な値: 有効な Secrets Manager シークレット ARN
  # 用途: 既存の MACsec キーを参照する場合に使用
  # 注意: ckn/cak とは相互排他的です。Direct Connect で以前作成された MACsec キーの参照にのみ使用可能
  #       aws_dx_macsec_key_association 外で作成された Secrets Manager シークレットは関連付けできません
  # 関連機能: AWS Secrets Manager
  #   Direct Connect は Secrets Manager を使用して MACsec キーを安全に保存・管理します。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_how-services-use-secrets_directconnect.html
  secret_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID。Terraform によって自動生成されます
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null
}

#---------------------------------------------------------------
# 代替構成例: 既存の Secrets Manager シークレットを使用
#---------------------------------------------------------------
# data "aws_dx_connection" "example" {
#   name = "tf-dx-connection"
# }
#
# data "aws_secretsmanager_secret" "example" {
#   name = "directconnect!prod/us-east-1/directconnect/0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
# }
#
# resource "aws_dx_macsec_key_association" "with_existing_secret" {
#   connection_id = data.aws_dx_connection.example.id
#   secret_arn    = data.aws_secretsmanager_secret.example.arn
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: MAC Security (MACsec) シークレットキーリソースの ID
#
# - ckn: 接続に関連付けられた CKN
#   (CKN/CAK 方式で作成した場合は入力値、secret_arn 方式の場合は computed)
#
# - secret_arn: MACsec キーに関連付けられた Secrets Manager シークレットの ARN
#   (CKN/CAK 方式で作成した場合は自動生成、secret_arn 方式の場合は入力値)
#
# - start_on: MAC Security (MACsec) シークレットキーが有効になる日時 (UTC 形式)
#
# - state: MAC Security (MACsec) シークレットキーの状態
#   設定可能な値:
#   - associating: キーの関連付け処理中
#   - associated: キーが正常に関連付けられ、使用可能
#   - disassociating: キーの関連付け解除処理中
#   - disassociated: キーの関連付けが解除された
#   詳細: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_MacSecKey.html#DX-Type-MacSecKey-state
#---------------------------------------------------------------
