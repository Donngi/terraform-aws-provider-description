#---------------------------------------------------------------
# AWS LB Trust Store Revocation
#---------------------------------------------------------------
#
# Application Load Balancer (ALB) のトラストストアに証明書失効リスト (CRL) を
# 追加するリソースです。mTLS（相互TLS認証）を使用するALBリスナーで、
# クライアント証明書の失効確認を行うために使用します。
# 失効リストはS3バケットに格納されたCRL形式のファイルを参照します。
#
# AWS公式ドキュメント:
#   - AddTrustStoreRevocations API: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_AddTrustStoreRevocations.html
#   - TrustStoreRevocation: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TrustStoreRevocation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_trust_store_revocation
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_trust_store_revocation" "example" {
  #-------------------------------------------------------------
  # トラストストア設定
  #-------------------------------------------------------------

  # trust_store_arn (Required)
  # 設定内容: 失効リストを追加するトラストストアのARNを指定します。
  # 設定可能な値: 有効なALBトラストストアのARN
  trust_store_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:truststore/my-trust-store/abcdef1234567890"

  #-------------------------------------------------------------
  # 失効リストのS3参照設定
  #-------------------------------------------------------------

  # revocations_s3_bucket (Required)
  # 設定内容: 証明書失効リスト（CRL）ファイルを格納しているS3バケット名を指定します。
  # 設定可能な値: 有効なS3バケット名
  revocations_s3_bucket = "my-revocations-bucket"

  # revocations_s3_key (Required)
  # 設定内容: S3バケット内の証明書失効リスト（CRL）ファイルのオブジェクトキーを指定します。
  # 設定可能な値: 有効なS3オブジェクトキー（パス）
  revocations_s3_key = "crl/my-revocations.crl"

  # revocations_s3_object_version (Optional)
  # 設定内容: S3バケットオブジェクトのバージョンIDを指定します。バージョニングが有効な場合に使用します。
  # 設定可能な値: 有効なS3オブジェクトのバージョンID文字列
  # 省略時: S3バケットオブジェクトの最新バージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RevocationContent.html
  revocations_s3_object_version = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトが適用されます。
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: トラストストアARNとRevocationIdを組み合わせた値
#       フォーマット: {trust_store_arn},{revocation_id}
#
# - revocation_id: AWSが割り当てた失効リストのID（数値）
#---------------------------------------------------------------
