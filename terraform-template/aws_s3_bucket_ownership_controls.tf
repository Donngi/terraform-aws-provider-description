#---------------------------------------------------------------
# Amazon S3 Bucket Ownership Controls
#---------------------------------------------------------------
#
# Amazon S3バケットのオブジェクト所有権設定（Object Ownership）を
# プロビジョニングするリソースです。バケットにアップロードされるオブジェクトの
# 所有権を制御し、ACL（アクセス制御リスト）の有効/無効を切り替えます。
#
# 注意: このリソースはS3ディレクトリバケットには使用できません。
#
# AWS公式ドキュメント:
#   - オブジェクト所有権の概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
#   - 既存バケットへの設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-ownership-existing-bucket.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_ownership_controls
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_ownership_controls" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: オブジェクト所有権設定を関連付けるS3バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  bucket = "example-bucket"

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
  # オブジェクト所有権ルール設定
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: オブジェクト所有権の制御ルールを定義する設定ブロックです。
  # 注意: このブロックは必須で、1つのみ指定可能です。
  rule {

    # object_ownership (Required)
    # 設定内容: バケットにアップロードされるオブジェクトの所有権ポリシーを指定します。
    # 設定可能な値:
    #   - "BucketOwnerEnforced": ACLを無効化し、バケット所有者がすべてのオブジェクトを
    #                            自動的に所有・フルコントロールします。アクセス管理はポリシーのみ。
    #                            新規バケットのデフォルト設定。
    #   - "BucketOwnerPreferred": ACLを有効化。"bucket-owner-full-control" キャンドACL付きで
    #                             アップロードされたオブジェクトはバケット所有者に所有権が移転します。
    #   - "ObjectWriter": ACLを有効化。オブジェクトをアップロードしたアカウントが所有権を持ちます。
    # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
    object_ownership = "BucketOwnerEnforced"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: S3バケット名。
#---------------------------------------------------------------
