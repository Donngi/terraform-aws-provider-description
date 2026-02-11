#---------------------------------------------------------------
# Amazon S3 Bucket Public Access Block
#---------------------------------------------------------------
#
# S3バケットレベルのPublic Access Block設定を管理するリソースです。
# パブリックアクセスのブロック設定により、バケットとオブジェクトへの
# 意図しないパブリックアクセスを防止できます。
#
# AWS公式ドキュメント:
#   - S3 Block Public Access: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
#   - バケットのBlock Public Access設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/configuring-block-public-access-bucket.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: Public Access Block設定を適用するS3バケットを指定します。
  # 設定可能な値: S3バケット名またはバケットのID
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/configuring-block-public-access-bucket.html
  bucket = "my-example-bucket"

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
  # Public Access Block設定
  #-------------------------------------------------------------

  # block_public_acls (Optional)
  # 設定内容: Amazon S3がこのバケットのパブリックACLをブロックするかを指定します。
  # 設定可能な値:
  #   - true: パブリックACLをブロック
  #   - false (デフォルト): パブリックACLをブロックしない
  # 動作詳細:
  #   trueに設定すると以下の動作になります:
  #   - パブリックアクセスを許可する指定のACLを含むPUT Bucket ACLおよびPUT Object ACL呼び出しは失敗します
  #   - オブジェクトACLを含むPUT Object呼び出しは失敗します
  # 注意: この設定を有効にしても、既存のポリシーやACLには影響しません
  # 関連機能: Amazon S3 Block Public Access - BlockPublicAcls
  #   パブリックアクセスを許可するACLの設定をブロックする機能。
  #   新しいパブリックACLの適用や、既存のバケットやオブジェクトへの
  #   パブリックACL付与を防止します。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_acls = true

  # block_public_policy (Optional)
  # 設定内容: Amazon S3がこのバケットのパブリックバケットポリシーをブロックするかを指定します。
  # 設定可能な値:
  #   - true: パブリックバケットポリシーをブロック
  #   - false (デフォルト): パブリックバケットポリシーをブロックしない
  # 動作詳細:
  #   trueに設定すると以下の動作になります:
  #   - パブリックアクセスを許可する指定のバケットポリシーを含むPUT Bucket policy呼び出しをAmazon S3が拒否します
  # 注意: この設定を有効にしても、既存のバケットポリシーには影響しません
  # 関連機能: Amazon S3 Block Public Access - BlockPublicPolicy
  #   パブリックアクセスを許可するバケットポリシーの適用をブロックする機能。
  #   新しいパブリックバケットポリシーの設定を防止します。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_policy = true

  # ignore_public_acls (Optional)
  # 設定内容: Amazon S3がこのバケットのパブリックACLを無視するかを指定します。
  # 設定可能な値:
  #   - true: パブリックACLを無視
  #   - false (デフォルト): パブリックACLを無視しない
  # 動作詳細:
  #   trueに設定すると以下の動作になります:
  #   - このバケットおよびバケット内のオブジェクトのパブリックACLをAmazon S3が無視します
  # 注意: この設定を有効にしても、既存のACLの永続性には影響せず、新しいパブリックACLの設定も防ぎません
  # 関連機能: Amazon S3 Block Public Access - IgnorePublicAcls
  #   既存のパブリックACLを無視する機能。
  #   パブリックACLが設定されていても、Amazon S3はそれらを無視し、
  #   実質的にパブリックアクセスを無効化します。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  ignore_public_acls = true

  # restrict_public_buckets (Optional)
  # 設定内容: Amazon S3がこのバケットのパブリックバケットポリシーを制限するかを指定します。
  # 設定可能な値:
  #   - true: パブリックバケットポリシーを制限
  #   - false (デフォルト): パブリックバケットポリシーを制限しない
  # 動作詳細:
  #   trueに設定すると以下の動作になります:
  #   - バケットにパブリックポリシーがある場合、バケット所有者とAWSサービスのみがこのバケットにアクセスできます
  # 注意: この設定を有効にしても、以前に保存されたバケットポリシーには影響しませんが、
  #       特定のアカウントへの非パブリック委任を含む、パブリックバケットポリシー内の
  #       パブリックおよびクロスアカウントアクセスはブロックされます
  # 関連機能: Amazon S3 Block Public Access - RestrictPublicBuckets
  #   パブリックポリシーが設定されたバケットへのアクセスを制限する機能。
  #   パブリックポリシーを持つバケットへのアクセスを、
  #   バケット所有者のアカウント内の認証ユーザーとAWSサービスプリンシパルのみに制限します。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  restrict_public_buckets = true

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy時にPublic Access Block設定を削除しないかを指定します。
  # 設定可能な値:
  #   - true: destroy時に設定を削除せず、Terraform stateから削除のみ
  #   - false (デフォルト): destroy時に設定を削除
  # 用途: 関連するバケットの削除前にPublic Access Block設定の削除を防ぎたい場合に使用
  # 注意: trueに設定すると、AWS Providerはterraform destroyを実行しても
  #       Public Access Block設定を削除しません。この設定は意図的な未管理リソースとなり、
  #       Terraformによって管理されず、AWSアカウント内に残ります。
  skip_destroy = false
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 設定が適用されているS3バケットの名前
#---------------------------------------------------------------
