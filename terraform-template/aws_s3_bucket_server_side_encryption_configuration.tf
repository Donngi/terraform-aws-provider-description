#---------------------------------------------------------------
# Amazon S3 Bucket Server-Side Encryption Configuration
#---------------------------------------------------------------
#
# Amazon S3バケットのサーバーサイド暗号化（SSE）設定をプロビジョニングするリソースです。
# バケットに保存されるオブジェクトをデフォルトで暗号化することで、
# 保存データのセキュリティを強化します。
#
# 注意事項:
# - このリソースはaws_s3_bucketリソースのserver_side_encryption_configuration引数と
#   競合するため、同時に使用しないでください
# - SSE-KMSを使用する場合はKMSキーのポリシー設定が必要です
# - Bucket Key（bucket_key_enabled = true）を有効にすることでKMSコスト削減が可能です
# - S3ディレクトリバケット（Express One Zone）でも利用可能です
#
# AWS公式ドキュメント:
#   - SSE: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: SSE設定を適用するS3バケットの名前またはARNを指定します。
  # 設定可能な値: 既存のS3バケット名またはARN
  bucket = "my-bucket-name"

  # expected_bucket_owner (Optional)
  # 設定内容: バケットの予期される所有者のAWSアカウントIDを指定します。
  #           指定することでクロスアカウントアクセスのセキュリティ強化が可能です。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 所有者の検証は行われません
  expected_bucket_owner = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化ルール設定
  #-------------------------------------------------------------

  # rule (Required, 1件以上設定必須)
  # 設定内容: バケットに適用するサーバーサイド暗号化ルールを定義するブロックです。
  rule {
    # bucket_key_enabled (Optional)
    # 設定内容: S3バケットキーを有効にするかどうかを指定します。
    #           有効にすることでSSE-KMS使用時のAWS KMSへのリクエスト数を削減し、
    #           コストを最大99%削減できます。
    # 設定可能な値: true / false
    # 省略時: false（バケットキーは無効）
    bucket_key_enabled = true

    # blocked_encryption_types (Optional)
    # 設定内容: バケットへのアップロード時に禁止する暗号化タイプのリストを指定します。
    #           特定の暗号化タイプを強制的に排除したい場合に使用します。
    # 設定可能な値:
    #   "aws:kms"         - AWS KMSマネージドキーによるSSE-KMSを禁止
    #   "aws:kms:dsse"    - デュアルレイヤーSSE-KMSを禁止
    # 省略時: 暗号化タイプの制限なし
    blocked_encryption_types = null

    # apply_server_side_encryption_by_default (Optional, 最大1件)
    # 設定内容: バケットへのオブジェクト保存時にデフォルトで適用する暗号化設定を指定するブロックです。
    apply_server_side_encryption_by_default {
      # sse_algorithm (Required)
      # 設定内容: デフォルトで使用するサーバーサイド暗号化アルゴリズムを指定します。
      # 設定可能な値:
      #   "aws:kms"      - AWS KMSマネージドキーを使用するSSE-KMS
      #   "aws:kms:dsse" - デュアルレイヤーSSE-KMS（二重暗号化）
      #   "AES256"       - Amazon S3マネージドキーを使用するSSE-S3
      sse_algorithm = "aws:kms"

      # kms_master_key_id (Optional)
      # 設定内容: sse_algorithmに "aws:kms" または "aws:kms:dsse" を指定した場合に使用する
      #           KMSキーのIDまたはARNを指定します。
      #           省略するとAWSマネージドキー（aws/s3）が使用されます。
      # 設定可能な値: KMSキーID、キーARN、またはキーエイリアスARN
      # 省略時: AWSマネージドキー（aws/s3）を使用
      kms_master_key_id = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: bucket および expected_bucket_owner（設定されている場合）を
#       カンマ（,）で区切った文字列
#---------------------------------------------------------------
