#---------------------------------------------------------------
# Amazon S3 Access Point
#---------------------------------------------------------------
#
# S3バケットに対するアクセスポイントを管理するリソースです。
# アクセスポイントはバケットへのアクセスを簡素化し、
# アプリケーションごとや用途ごとに異なるアクセス制御を定義できます。
# S3 on OutpostsバケットへのVPC経由アクセスや、
# ディレクトリバケット（Express One Zone）にも対応しています。
#
# 注意: アクセスポイントリソースのインラインポリシーとスタンドアロンの
#       aws_s3control_access_point_policy リソースを同時に使用しないでください。
#       ポリシーの競合が発生し、アクセスポイントのリソースポリシーが上書きされます。
#
# AWS公式ドキュメント:
#   - S3アクセスポイント概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points.html
#   - アクセスポイントの作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-access-points.html
#   - ディレクトリバケットのアクセスポイント: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-directory-buckets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_access_point
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_access_point" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: アクセスポイントを関連付けるS3バケットの名前またはARNを指定します。
  # 設定可能な値:
  #   - AWS Partition S3汎用バケット名（例: "my-bucket"）
  #   - S3 on OutpostsバケットのARN（例: "arn:aws:s3-outposts:..."）
  #   - S3ディレクトリバケット名（例: "example--zoneId--x-s3"）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points.html
  bucket = "my-example-bucket"

  # name (Required)
  # 設定内容: このアクセスポイントに割り当てる名前を指定します。
  # 設定可能な値: 3〜50文字の英小文字・数字・ハイフンの組み合わせ
  #   - 英小文字または数字で始まり、英小文字または数字で終わること
  #   - ハイフンを連続使用不可、プレフィックス "xn--" で始まること不可
  #   - ディレクトリバケット用アクセスポイントの場合は別の命名規則が適用されます
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-access-points.html#access-points-names
  name = "my-access-point"

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: アクセスポイントを作成するバケットの所有者AWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（例: "123456789012"）
  # 省略時: Terraform AWSプロバイダーが自動的に判別したアカウントIDを使用
  account_id = null

  # bucket_account_id (Optional)
  # 設定内容: アクセスポイントに関連付けるS3バケットのAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（例: "123456789012"）
  # 省略時: Terraform AWSプロバイダーが自動的に判別したアカウントIDを使用
  # 用途: クロスアカウント構成でバケット所有者のアカウントを明示的に指定する場合に使用
  bucket_account_id = null

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
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: このアクセスポイントに適用するリソースポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメント（JSON文字列）
  # 省略時: ポリシーなし
  # 注意: policy を削除または null/空文字列に設定しても、aws_s3control_access_point_policy
  #       によって設定されたポリシーは削除されません。
  #       ポリシーを削除するには "{}" （空のJSONドキュメント）を設定してください。
  # 注意: aws_s3control_access_point_policy リソースとの同時使用は非推奨
  policy = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値が文字列のマップ（例: { "Environment" = "production" }）
  # 省略時: タグなし
  # 注意: プロバイダーレベルで default_tags が設定されている場合、
  #       同じキーのタグはプロバイダーレベルの設定で上書きされます。
  tags = {
    # "Environment" = "production"
    # "ManagedBy"   = "terraform"
  }

  #-------------------------------------------------------------
  # Public Access Block設定
  #-------------------------------------------------------------

  # public_access_block_configuration (Optional)
  # 設定内容: このアクセスポイントに適用するPublicAccessBlock設定を定義します。
  # 省略時: 設定なし（バケットレベルの設定が適用されます）
  # 関連機能: Amazon S3 Block Public Access
  #   アクセスポイントレベルでパブリックアクセスをブロックする設定。
  #   バケットレベルのBlock Public Access設定と組み合わせて使用します。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
  public_access_block_configuration {
    # block_public_acls (Optional)
    # 設定内容: このアクセスポイントに対してパブリックACLをブロックするかを指定します。
    # 設定可能な値:
    #   - true: パブリックACLをブロック（trueの場合、パブリックACLを含むPUT Bucket ACL・PUT Object ACL呼び出しが失敗）
    #   - false: パブリックACLをブロックしない
    # 省略時: デフォルト動作（trueと同等）
    # 注意: この設定を有効にしても既存のポリシーやACLには影響しません
    block_public_acls = true

    # block_public_policy (Optional)
    # 設定内容: このアクセスポイントに対してパブリックバケットポリシーをブロックするかを指定します。
    # 設定可能な値:
    #   - true: パブリックポリシーをブロック（PUT Bucket policyでパブリックアクセスを許可するポリシーを拒否）
    #   - false: パブリックポリシーをブロックしない
    # 省略時: デフォルト動作（trueと同等）
    # 注意: この設定を有効にしても既存のバケットポリシーには影響しません
    block_public_policy = true

    # ignore_public_acls (Optional)
    # 設定内容: このアクセスポイントに対してパブリックACLを無視するかを指定します。
    # 設定可能な値:
    #   - true: パブリックACLを無視（バケットおよびオブジェクトのパブリックACLをAmazon S3が無視）
    #   - false: パブリックACLを無視しない
    # 省略時: デフォルト動作（trueと同等）
    # 注意: この設定を有効にしても既存のACLの永続性には影響せず、新しいパブリックACLの設定も防ぎません
    ignore_public_acls = true

    # restrict_public_buckets (Optional)
    # 設定内容: このアクセスポイントに対してパブリックバケットポリシーを制限するかを指定します。
    # 設定可能な値:
    #   - true: パブリックバケットポリシーを制限（バケット所有者とAWSサービスのみアクセス可能）
    #   - false: パブリックバケットポリシーを制限しない
    # 省略時: デフォルト動作（trueと同等）
    # 注意: この設定を有効にしても以前に保存されたバケットポリシーには影響しません
    restrict_public_buckets = true
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_configuration (Optional)
  # 設定内容: このアクセスポイントへのアクセスを指定のVPCからのみに制限する設定を定義します。
  # 省略時: VPC制限なし（インターネット経由のアクセスが可能）
  # 用途: S3 on Outpostsバケットに対しては必須
  # 関連機能: Amazon S3 VPCエンドポイント
  #   VPC経由でのみS3へのアクセスを許可することで、
  #   インターネット経由のアクセスを防止しデータの安全性を向上させます。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/privatelink-interface-endpoints.html
  vpc_configuration {
    # vpc_id (Required)
    # 設定内容: このアクセスポイントへの接続を許可するVPCのIDを指定します。
    # 設定可能な値: 有効なVPC ID（例: "vpc-0123456789abcdef0"）
    # 注意: 一度VPC設定を有効にすると、そのアクセスポイントは常にVPN/Direct Connect経由か
    #       VPCエンドポイント経由でのみアクセス可能になります
    vpc_id = "vpc-0123456789abcdef0"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWS Partition S3バケットのアクセスポイントの場合、AWSアカウントIDと
#       アクセスポイント名をコロン（:）で区切った値。S3 on Outpostsの場合はARN。
# - alias: S3アクセスポイントのエイリアス。
# - arn: S3アクセスポイントのARN。
# - domain_name: アクセスポイントのDNSドメイン名。
#                _name_-_account_id_.s3-accesspoint._region_.amazonaws.com 形式。
#                注意: S3アクセスポイントはHTTPSのみサポート（HTTP不可）。
# - endpoints: S3アクセスポイントのVPCエンドポイントのマップ。
# - has_public_access_policy: パブリックアクセスを許可するポリシーが設定されているか。
# - network_origin: アクセスポイントがインターネットからのアクセスを許可するか。
#                   "VPC"（パブリックインターネット不可）または "Internet"（パブリックアクセス可能）。
# - tags_all: プロバイダーのdefault_tagsを含む、リソースに割り当てられた全タグのマップ。
#---------------------------------------------------------------
