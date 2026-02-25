#---------------------------------------------------------------
# S3 Control Multi-Region Access Point
#---------------------------------------------------------------
#
# 複数リージョンのS3バケットに対してマルチリージョンアクセスポイントを
# プロビジョニングするリソースです。
# マルチリージョンアクセスポイントは、地理的に分散した複数のS3バケットを
# 単一のグローバルエンドポイントとして公開し、AWS Global Acceleratorを
# 活用してレイテンシを最適化します。
# S3ディレクトリバケットには使用できません。
#
# AWS公式ドキュメント:
#   - マルチリージョンアクセスポイント概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
#   - マルチリージョンアクセスポイントのリクエスト: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointRequests.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_multi_region_access_point
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_multi_region_access_point" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: マルチリージョンアクセスポイントを作成するS3バケット所有者の
  #          AWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーで自動的に決定されるアカウントIDを使用
  account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # マルチリージョンアクセスポイント詳細設定
  #-------------------------------------------------------------

  # details (Required)
  # 設定内容: マルチリージョンアクセスポイントの詳細設定を指定します。
  # 関連機能: マルチリージョンアクセスポイント設定
  #   アクセスポイント名、対象リージョンのバケット一覧、
  #   パブリックアクセスブロック設定を定義するブロックです。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
  details {
    # name (Required)
    # 設定内容: マルチリージョンアクセスポイントの名前を指定します。
    # 設定可能な値: 3-50文字の小文字英数字およびハイフン（先頭・末尾はハイフン不可）
    # 注意: 作成後は変更できません。
    name = "example-mrap"

    #-----------------------------------------------------------
    # パブリックアクセスブロック設定
    #-----------------------------------------------------------

    # public_access_block (Optional)
    # 設定内容: マルチリージョンアクセスポイントへのパブリックアクセスブロック設定を指定します。
    # 関連機能: パブリックアクセスブロック
    #   ACLやバケットポリシーによるパブリックアクセスをブロックするセキュリティ設定です。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
    # 省略時: パブリックアクセスブロックは設定されません
    public_access_block {
      # block_public_acls (Optional)
      # 設定内容: パブリックACLによるアクセスをブロックするかを指定します。
      # 設定可能な値:
      #   - true: パブリックACLのPUT操作をブロックし、既存のパブリックACLを無視する
      #   - false: パブリックACLのブロックを無効化する
      # 省略時: false
      block_public_acls = true

      # block_public_policy (Optional)
      # 設定内容: パブリックバケットポリシーへのアクセスをブロックするかを指定します。
      # 設定可能な値:
      #   - true: アクセスポイントをパブリックにするポリシーの設定をブロックする
      #   - false: パブリックポリシーのブロックを無効化する
      # 省略時: false
      block_public_policy = true

      # ignore_public_acls (Optional)
      # 設定内容: パブリックACLを無視するかを指定します。
      # 設定可能な値:
      #   - true: アクセスポイントおよびバケット内のオブジェクトのパブリックACLを無視する
      #   - false: パブリックACLの無視を無効化する
      # 省略時: false
      ignore_public_acls = true

      # restrict_public_buckets (Optional)
      # 設定内容: パブリックバケットポリシーへのアクセスを制限するかを指定します。
      # 設定可能な値:
      #   - true: パブリックポリシーを持つアクセスポイントへのアクセスをAWSサービスと
      #           認証済みユーザーのみに制限する
      #   - false: パブリックバケットポリシーへのアクセス制限を無効化する
      # 省略時: false
      restrict_public_buckets = true
    }

    #-----------------------------------------------------------
    # リージョン設定
    #-----------------------------------------------------------

    # region (Required, 1-20個)
    # 設定内容: マルチリージョンアクセスポイントに含めるS3バケットのリージョン設定を指定します。
    # 関連機能: マルチリージョンバケット設定
    #   アクセスポイントに関連付けるリージョンとバケットの組み合わせを定義します。
    #   最低1つ、最大20個のリージョンを指定できます。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
    region {
      # bucket (Required)
      # 設定内容: マルチリージョンアクセスポイントに関連付けるS3バケット名を指定します。
      # 設定可能な値: 有効なS3バケット名
      bucket = "example-bucket-primary"

      # bucket_account_id (Optional)
      # 設定内容: バケットを所有するAWSアカウントIDを指定します。
      # 設定可能な値: 12桁のAWSアカウントID
      # 省略時: マルチリージョンアクセスポイントを作成するアカウントIDが自動設定される
      bucket_account_id = null
    }

    region {
      bucket = "example-bucket-secondary"

      bucket_account_id = null
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60m"のようなGoのDuration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "60m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60m"のようなGoのDuration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントIDとアクセスポイント名をコロンで結合した識別子
#       (形式: account_id:access_point_name)
#
# - alias: マルチリージョンアクセスポイントのエイリアス名
#
# - arn: マルチリージョンアクセスポイントのAmazon Resource Name (ARN)
#
# - domain_name: マルチリージョンアクセスポイントのDNSドメイン名
#               (形式: alias.accesspoint.s3-global.amazonaws.com)
#
# - status: マルチリージョンアクセスポイントの現在のステータス
#           (READY / INCONSISTENT_ACROSS_REGIONS / CREATING /
#            PARTIALLY_CREATED / PARTIALLY_DELETED / DELETING)
#---------------------------------------------------------------
