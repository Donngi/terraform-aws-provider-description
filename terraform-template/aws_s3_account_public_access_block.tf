#---------------------------------------------------------------
# Amazon S3 アカウントレベル Public Access Block
#---------------------------------------------------------------
#
# AWSアカウント全体のS3パブリックアクセスブロック設定を管理するリソースです。
# バケット単位ではなく、アカウント内の全バケットに対してパブリックアクセスを
# ブロックする設定を一元管理できます。
#
# AWS公式ドキュメント:
#   - S3 Block Public Access: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
#   - アカウントレベルのBlock Public Access設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/configuring-block-public-access-account.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_account_public_access_block" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: パブリックアクセスブロック設定を適用するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: プロバイダーで設定されているアカウントIDを使用
  # 注意: 通常はプロバイダーのアカウントIDが使用されるため省略可
  account_id = null

  #-------------------------------------------------------------
  # Public Access Block設定
  #-------------------------------------------------------------

  # block_public_acls (Optional)
  # 設定内容: Amazon S3がこのアカウント内の全バケットのパブリックACLをブロックするかを指定します。
  # 設定可能な値:
  #   - true: パブリックACLをブロック
  #   - false (デフォルト): パブリックACLをブロックしない
  # 動作詳細:
  #   trueに設定すると以下の動作になります:
  #   - パブリックアクセスを許可する指定のACLを含むPUT Bucket ACLおよびPUT Object ACL呼び出しは失敗します
  #   - オブジェクトACLを含むPUT Object呼び出しは失敗します
  # 注意: この設定を有効にしても、既存のACLには影響しません
  # 関連機能: Amazon S3 Block Public Access - BlockPublicAcls
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_acls = true

  # block_public_policy (Optional)
  # 設定内容: Amazon S3がこのアカウント内の全バケットのパブリックバケットポリシーをブロックするかを指定します。
  # 設定可能な値:
  #   - true: パブリックバケットポリシーをブロック
  #   - false (デフォルト): パブリックバケットポリシーをブロックしない
  # 動作詳細:
  #   trueに設定すると以下の動作になります:
  #   - パブリックアクセスを許可する指定のバケットポリシーを含むPUT Bucket policy呼び出しをAmazon S3が拒否します
  # 注意: この設定を有効にしても、既存のバケットポリシーには影響しません
  # 関連機能: Amazon S3 Block Public Access - BlockPublicPolicy
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  block_public_policy = true

  # ignore_public_acls (Optional)
  # 設定内容: Amazon S3がこのアカウント内の全バケットのパブリックACLを無視するかを指定します。
  # 設定可能な値:
  #   - true: パブリックACLを無視
  #   - false (デフォルト): パブリックACLを無視しない
  # 動作詳細:
  #   trueに設定すると以下の動作になります:
  #   - このアカウントのバケットおよびバケット内のオブジェクトのパブリックACLをAmazon S3が無視します
  # 注意: この設定を有効にしても、既存のACLの永続性には影響せず、新しいパブリックACLの設定も防ぎません
  # 関連機能: Amazon S3 Block Public Access - IgnorePublicAcls
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  ignore_public_acls = true

  # restrict_public_buckets (Optional)
  # 設定内容: Amazon S3がこのアカウント内の全バケットのパブリックバケットポリシーを制限するかを指定します。
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
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  restrict_public_buckets = true
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: パブリックアクセスブロック設定が適用されているAWSアカウントID
#---------------------------------------------------------------
