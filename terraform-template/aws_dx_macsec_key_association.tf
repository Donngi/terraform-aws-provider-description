#-----------------------------------------------------------------------
# AWS Direct Connect - MACSec Key Association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_macsec_key_association
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_macsec_key_association
# Generated: 2026-02-14
#
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマに基づいて生成されています。
#       実際の使用時は、必要な属性のみコメントを外して使用してください。
#-----------------------------------------------------------------------
# Direct Connect接続にMAC Security (MACsec) 暗号化キーを関連付けるリソース。
# Layer 2レベルでのデータ機密性・完全性・送信元認証を提供します。
# ドキュメント: https://docs.aws.amazon.com/directconnect/latest/UserGuide/MACsec.html
#
# 主な機能:
# - CKN/CAKペアまたはSecrets Manager ARNによるMACsecキー関連付け
# - 専用接続(Dedicated Connection)およびLAG(Link Aggregation Group)への対応
# - 256ビットMACsec暗号化による通信保護
# - Direct Connect管理下のSecrets Managerシークレット自動作成
#
# 注意事項:
# - 専用接続のみサポート（ホスト接続は不可）
# - 接続状態がAVAILABLEである必要がある
# - 一度関連付けたキーは変更不可（削除→新規作成が必要）
# - cknとcakはプレーンテキストでstateファイルに保存される
# - secret_arnは既存のMACSec key専用（外部作成のSecrets Managerシークレットは使用不可）
# - cak/cknとsecret_arnは排他的（同時使用不可）
# - このリソース作成時にaws_secretsmanager_secretも自動作成されるがDirect Connect管理下のため変更不可
#
# ユースケース:
# - オンプレミスとAWS間の暗号化通信
# - コンプライアンス要件によるLayer 2暗号化
# - 高速かつ低レイテンシな暗号化接続
# - 機密性の高いワークロード転送
#
# 関連リソース:
# - aws_dx_connection (Direct Connect専用接続)
# - aws_dx_lag (Link Aggregation Group)
# - aws_secretsmanager_secret (MACsecキー格納用、Direct Connect管理)
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# MACSec Key Association - CKN/CAKペア方式
#-----------------------------------------------------------------------
resource "aws_dx_macsec_key_association" "ckn_cak" {
  #-----------------------------------------------------------------------
  # 必須設定
  #-----------------------------------------------------------------------

  # 設定内容: Direct Connect接続ID
  # 備考: 専用接続のみサポート、状態がAVAILABLEである必要がある
  connection_id = "dxcon-xxxxxxxx"

  #-----------------------------------------------------------------------
  # MACSec認証情報 - CKN/CAKペア
  #-----------------------------------------------------------------------

  # 設定内容: Connectivity Association Key Name（64文字の16進数文字列）
  # 設定可能な値: 0-9, A-F（大文字）の64文字
  # 備考: cakとセットで必須、secret_arnとは排他的
  ckn = "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF"

  # 設定内容: Connectivity Association Key（64文字の16進数文字列）
  # 設定可能な値: 0-9, A-F（大文字）の64文字
  # 備考: cknとセットで必須、secret_arnとは排他的、sensitive変数として管理推奨
  cak = "ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789"

  #-----------------------------------------------------------------------
  # リージョン設定（オプション）
  #-----------------------------------------------------------------------

  # 設定内容: リソース管理リージョン
  # 省略時: プロバイダーに設定されたリージョンを使用
  region = "us-east-1"
}

#-----------------------------------------------------------------------
# MACSec Key Association - Secrets Manager ARN方式
#-----------------------------------------------------------------------
resource "aws_dx_macsec_key_association" "secret_arn" {
  #-----------------------------------------------------------------------
  # 必須設定
  #-----------------------------------------------------------------------

  # 設定内容: Direct Connect接続ID
  connection_id = "dxcon-xxxxxxxx"

  #-----------------------------------------------------------------------
  # MACSec認証情報 - Secrets Manager ARN
  #-----------------------------------------------------------------------

  # 設定内容: Direct Connect管理のMACSec秘密鍵ARN
  # 設定可能な値: arn:aws:secretsmanager:region:account-id:secret:directconnect!env/region/directconnect/ckn
  # 備考: Direct Connectが作成したシークレットのみ有効、ckn/cakとは排他的
  secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:directconnect!prod/us-east-1/directconnect/0123456789ABCDEF-xxxxxx"
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# 以下の属性を参照可能:
#
# - id          : MACSec秘密鍵リソースのID
# - start_on    : MACSec秘密鍵が有効化された日時（UTC形式）
# - state       : MACSec秘密鍵の状態
#                 associating/associated/disassociating/disassociated
# - ckn         : Connectivity Association Key Name（computed）
# - secret_arn  : Secrets ManagerのARN（computed）
#
# 参照例:
#   state = aws_dx_macsec_key_association.ckn_cak.state
#   arn   = aws_dx_macsec_key_association.ckn_cak.secret_arn
#-----------------------------------------------------------------------
