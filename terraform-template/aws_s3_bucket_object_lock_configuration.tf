#---------------------------------------------------------------
# Amazon S3 Bucket Object Lock Configuration
#---------------------------------------------------------------
#
# Amazon S3バケットのObject Lock設定をプロビジョニングするリソースです。
# Object Lockを有効にすることで、オブジェクトの上書きや削除を防止するWORM（Write Once Read Many）
# モデルを実現し、規制要件への準拠やランサムウェア対策に役立ちます。
#
# 注意事項:
# - 新規バケットおよび既存バケットの両方でObject Lockを有効化できます
# - 既存バケットでObject Lockを有効化する場合は、先にバージョニングを有効化する必要があります
# - このリソースはS3ディレクトリバケットでは使用できません
# - token引数およびexpected_bucket_owner引数は非推奨です
#
# AWS公式ドキュメント:
#   - Object Lock: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_object_lock_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: Object Lock設定を適用するS3バケットの名前を指定します。
  # 設定可能な値: 既存のS3バケット名
  bucket = "my-bucket-name"

  # object_lock_enabled (Optional, Forces new resource)
  # 設定内容: バケットのObject Lock設定が有効かどうかを指定します。
  # 設定可能な値: "Enabled"
  # 省略時: "Enabled" が適用されます
  object_lock_enabled = "Enabled"

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
  # 非推奨設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional, Forces new resource, 非推奨)
  # 設定内容: バケットの期待される所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: バケット所有者の検証を行いません
  # 注意: このパラメータは非推奨（Deprecated）です
  expected_bucket_owner = null

  # token (Optional, 非推奨, Sensitive)
  # 設定内容: この引数は非推奨であり、Object Lockの有効化には不要になりました。
  # 省略時: トークンは使用されません
  # 注意: このパラメータは非推奨（Deprecated）です
  token = null

  #-------------------------------------------------------------
  # Object Lockルール設定
  #-------------------------------------------------------------

  # rule (Optional, 最大1ブロック)
  # 設定内容: バケットに新しく配置されるオブジェクトのデフォルトObject Lock保持設定を定義するブロックです。
  rule {
    # default_retention (Required, 最大1ブロック)
    # 設定内容: 新しいオブジェクトに適用するデフォルトの保持設定を指定するブロックです。
    default_retention {
      # mode (Required)
      # 設定内容: 新しいオブジェクトに適用するデフォルトのObject Lock保持モードを指定します。
      # 設定可能な値:
      #   "COMPLIANCE" - コンプライアンスモード: ルート含む全ユーザーが保持期間内のオブジェクトを削除・変更不可
      #   "GOVERNANCE" - ガバナンスモード: 特別な権限を持つユーザーは保持設定を変更できる
      mode = "COMPLIANCE"

      # days (Optional, yearsが未指定の場合は必須)
      # 設定内容: デフォルト保持期間を日数で指定します。
      # 設定可能な値: 正の整数
      # 省略時: yearsを指定する場合は省略可能（daysまたはyearsのいずれか一方が必須）
      days = 5

      # years (Optional, daysが未指定の場合は必須)
      # 設定内容: デフォルト保持期間を年数で指定します。
      # 設定可能な値: 正の整数
      # 省略時: daysを指定する場合は省略可能（daysまたはyearsのいずれか一方が必須）
      # years = 1
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: bucketの値、またはexpected_bucket_ownerが指定されている場合は
#        bucketとexpected_bucket_ownerをカンマ（,）で連結した値
#---------------------------------------------------------------
