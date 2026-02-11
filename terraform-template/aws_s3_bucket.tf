#---------------------------------------------------------------
# AWS S3 Bucket
#---------------------------------------------------------------
#
# Amazon S3の汎用バケットをプロビジョニングするリソースです。
# S3バケットは、オブジェクトを格納するための基本的なコンテナであり、
# データの保存、管理、保護のための様々な設定オプションを提供します。
#
# AWS公式ドキュメント:
#   - Amazon S3バケット: https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingBucket.html
#   - バケットの命名規則: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
#   - バケットプロパティの表示: https://docs.aws.amazon.com/AmazonS3/latest/userguide/view-bucket-properties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Optional, Forces new resource)
  # 設定内容: バケットの名前を指定します。
  # 設定可能な値: 3-63文字の文字列。小文字、数字、ハイフン(-)、ピリオド(.)のみ使用可能
  # 省略時: Terraformがランダムな一意の名前を生成します
  # 注意: bucket_prefixと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = "my-tf-test-bucket"

  # bucket_prefix (Optional, Forces new resource)
  # 設定内容: バケット名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します
  # 注意: bucketと排他的（どちらか一方のみ指定可能）。37文字以下である必要があります
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket_prefix = null

  # id (Optional, Computed)
  # 設定内容: バケットの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: バケット名が自動的に使用されます
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
  id = null

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
  # オブジェクト削除設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: バケット削除時に全てのオブジェクト（ロックされたオブジェクトを含む）を
  #           自動的に削除するかを指定します。
  # 設定可能な値:
  #   - true: destroy時にバケット内の全オブジェクトを削除してからバケットを削除
  #   - false (デフォルト): バケット内にオブジェクトがある場合は削除に失敗
  # 注意: この設定を有効にした後、terraform applyを実行する必要があります。
  #       削除されたオブジェクトは復元できません。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html
  force_destroy = false

  #-------------------------------------------------------------
  # オブジェクトロック設定
  #-------------------------------------------------------------

  # object_lock_enabled (Optional, Forces new resource)
  # 設定内容: このバケットでObject Lock設定を有効にするかを指定します。
  # 設定可能な値:
  #   - true: Object Lockを有効化
  #   - false: Object Lockを無効化
  # 関連機能: S3 Object Lock
  #   オブジェクトが固定期間または無期限に削除または上書きされることを防ぎます。
  #   WORM（Write-Once-Read-Many）モデルを使用し、規制要件を満たすために使用できます。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html
  # 注意: Object Lockを有効にすると、バケットのバージョニングも自動的に有効になります。
  #       一度有効にすると無効化できません。
  object_lock_enabled = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   ABAC（属性ベースのアクセス制御）を有効にするには、まずバケットでABACを
  #   有効にし、タグを使用してアクセス制御ポリシーを作成します。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/buckets-tagging-enable-abac.html
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #           リソースに割り当てられた全てのタグのマップ。
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケットの名前
#
# - arn: バケットのAmazon Resource Name (ARN)
#        フォーマット: arn:aws:s3:::bucketname
#
# - bucket_domain_name: バケットのドメイン名
#        フォーマット: bucketname.s3.amazonaws.com
#
# - bucket_region: このバケットが存在するAWSリージョン
#
# - bucket_regional_domain_name: リージョン固有のバケットドメイン名
#        リージョン名を含むバケットドメイン名。CloudFrontでS3オリジンを作成する際に
#        リージョン固有のエンドポイントを指定することで、CloudFrontからS3への
#        リダイレクト問題を防ぐことができます。
#        参考: https://docs.aws.amazon.com/general/latest/gr/s3.html#s3_region
#
# - hosted_zone_id: このバケットのリージョンに対するRoute 53 Hosted Zone ID
#        参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_website_region_endpoints
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられた全てのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 非推奨の属性・ブロック（別リソースへの移行を推奨）
#---------------------------------------------------------------
# 以下の属性とブロックは非推奨となっており、将来のバージョンで削除されます:
#
# - acceleration_status: aws_s3_bucket_accelerate_configuration リソースを使用
# - acl: aws_s3_bucket_acl リソースを使用
# - cors_rule: aws_s3_bucket_cors_configuration リソースを使用
# - grant: aws_s3_bucket_acl リソースを使用
# - lifecycle_rule: aws_s3_bucket_lifecycle_configuration リソースを使用
# - logging: aws_s3_bucket_logging リソースを使用
# - object_lock_configuration: aws_s3_bucket_object_lock_configuration リソースを使用
# - policy: aws_s3_bucket_policy リソースを使用
# - replication_configuration: aws_s3_bucket_replication_configuration リソースを使用
# - request_payer: aws_s3_bucket_request_payment_configuration リソースを使用
# - server_side_encryption_configuration: aws_s3_bucket_server_side_encryption_configuration リソースを使用
# - versioning: aws_s3_bucket_versioning リソースを使用
# - website: aws_s3_bucket_website_configuration リソースを使用
#
# - website_endpoint (読み取り専用): aws_s3_bucket_website_configuration リソースを使用
# - website_domain (読み取り専用): aws_s3_bucket_website_configuration リソースを使用
#---------------------------------------------------------------
