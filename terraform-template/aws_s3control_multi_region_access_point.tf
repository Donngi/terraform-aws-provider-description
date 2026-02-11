#---------------------------------------------------------------
# AWS S3 Control Multi-Region Access Point
#---------------------------------------------------------------
#
# Amazon S3 Multi-Region Access Pointに関連付けられるリソースを管理します。
# Multi-Region Access Pointsは、複数のAWSリージョンに配置されたS3バケットへの
# アクセスを単一のグローバルエンドポイントを通じて提供し、アプリケーションの
# パフォーマンスとレジリエンスを向上させます。
#
# AWS公式ドキュメント:
#   - Multi-Region Access Points概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
#   - Multi-Region Access Pointsのリクエストルーティング: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointRequestRouting.html
#   - Multi-Region Access Pointsのレプリケーション設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointBucketReplication.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_multi_region_access_point
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_multi_region_access_point" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: Multi-Region Access Pointを作成するバケットの所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーのアカウントIDが自動的に決定されます
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
  account_id = null

  #-------------------------------------------------------------
  # Multi-Region Access Point詳細設定
  #-------------------------------------------------------------

  # details (Required)
  # 設定内容: Multi-Region Access Pointに関する詳細設定を含む設定ブロックです。
  # 注意: このブロックは必須です
  details {
    #-----------------------------------------------------------
    # 名前設定
    #-----------------------------------------------------------

    # name (Required)
    # 設定内容: Multi-Region Access Pointの名前を指定します。
    # 設定可能な値:
    #   - 3-50文字の小文字英数字、ハイフン、アンダースコア
    #   - 先頭と末尾は英数字である必要があります
    # 注意: 作成後に変更する場合はリソースの再作成が必要です
    # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/CreatingMultiRegionAccessPoints.html
    name = "example-mrap"

    #-----------------------------------------------------------
    # パブリックアクセスブロック設定
    #-----------------------------------------------------------

    # public_access_block (Optional)
    # 設定内容: Multi-Region Access Pointに適用するパブリックアクセスブロック設定を指定します。
    # 関連機能: S3 パブリックアクセスブロック
    #   バケットとオブジェクトへのパブリックアクセスを管理する機能です。
    #   アカウント全体またはバケット単位で設定可能で、意図しない公開を防ぎます。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
    public_access_block {
      # block_public_acls (Optional)
      # 設定内容: パブリックACLを使用したバケットとオブジェクトへの新しいアクセス許可をブロックするかを指定します。
      # 設定可能な値:
      #   - true: パブリックACLの設定をブロック
      #   - false (デフォルト): パブリックACLの設定を許可
      # 省略時: false
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
      block_public_acls = true

      # block_public_policy (Optional)
      # 設定内容: パブリックバケットポリシーの設定をブロックするかを指定します。
      # 設定可能な値:
      #   - true: パブリックバケットポリシーの設定をブロック
      #   - false (デフォルト): パブリックバケットポリシーの設定を許可
      # 省略時: false
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
      block_public_policy = true

      # ignore_public_acls (Optional)
      # 設定内容: パブリックACLを無視するかを指定します。
      # 設定可能な値:
      #   - true: パブリックACLを無視し、バケットとオブジェクトをパブリックとして扱わない
      #   - false (デフォルト): パブリックACLを考慮
      # 省略時: false
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
      ignore_public_acls = true

      # restrict_public_buckets (Optional)
      # 設定内容: パブリックバケットポリシーを持つバケットへのパブリックアクセスを制限するかを指定します。
      # 設定可能な値:
      #   - true: パブリックポリシーを持つバケットへのパブリックアクセスを制限
      #   - false (デフォルト): パブリックポリシーを持つバケットへのパブリックアクセスを許可
      # 省略時: false
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
      restrict_public_buckets = true
    }

    #-----------------------------------------------------------
    # リージョン別バケット設定
    #-----------------------------------------------------------

    # region (Required, 最低1つ必要)
    # 設定内容: Multi-Region Access Pointに関連付けるリージョンとバケットを指定します。
    # 注意:
    #   - 最低1つ、最大20個のリージョンブロックを指定可能
    #   - 各リージョンは異なるAWSリージョンに存在する必要があります
    #   - 指定されたバケットは既に存在している必要があります
    # 関連機能: Multi-Region Access Points リージョン設定
    #   複数のリージョンにまたがるバケットを単一のアクセスポイントに統合し、
    #   リクエストは最も近いリージョンに自動的にルーティングされます。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointRequestRouting.html
    region {
      # bucket (Required)
      # 設定内容: Multi-Region Access Pointに関連付けるS3バケットの名前またはARNを指定します。
      # 設定可能な値: 既存のS3バケット名またはARN
      # 注意:
      #   - バケットは作成済みである必要があります
      #   - バケット名のみまたはフルARNを指定可能
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/CreatingMultiRegionAccessPoints.html
      bucket = "example-bucket-us-east-1"

      # bucket_account_id (Optional)
      # 設定内容: バケットを所有するAWSアカウントIDを指定します。
      # 設定可能な値: 12桁のAWSアカウントID
      # 省略時: Multi-Region Access Pointを作成するアカウントIDと同じとみなされます
      # 用途: クロスアカウントでMulti-Region Access Pointを設定する場合に使用
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
      bucket_account_id = null
    }

    # 追加のリージョン設定例（複数リージョンの場合）
    region {
      bucket             = "example-bucket-us-west-2"
      bucket_account_id  = null
    }

    region {
      bucket             = "example-bucket-ap-northeast-1"
      bucket_account_id  = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - alias: Multi-Region Access Pointのエイリアス名
#          このエイリアスはAWSによって自動的に生成されます
#
# - arn: Multi-Region Access PointのAmazon Resource Name (ARN)
#        形式: arn:aws:s3::account-id:accesspoint/multi-region-access-point-alias
#
# - domain_name: S3 Multi-Region Access PointのDNSドメイン名
#                形式: alias.accesspoint.s3-global.amazonaws.com
#                参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointRequests.html
#
# - id: AWSアカウントIDとアクセスポイント名をコロン(:)で区切った文字列
#       形式: account-id:access-point-name
#
# - status: Multi-Region Access Pointの現在のステータス
#           可能な値:
#           - READY: 使用可能な状態
#           - INCONSISTENT_ACROSS_REGIONS: リージョン間で不整合がある状態
#           - CREATING: 作成中
#           - PARTIALLY_CREATED: 部分的に作成された状態
#           - PARTIALLY_DELETED: 部分的に削除された状態
#           - DELETING: 削除中
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# Multi-Region Access Pointは以下の形式でインポート可能です:
#
# terraform import aws_s3control_multi_region_access_point.example account-id:access-point-name
#
# 例:
# terraform import aws_s3control_multi_region_access_point.example 123456789012:example-mrap
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意事項
#---------------------------------------------------------------
#
# 1. S3 Directory Bucketsとの互換性:
#    このリソースはS3 Directory Bucketsでは使用できません。
#
# 2. レプリケーション設定:
#    Multi-Region Access Pointを効果的に使用するには、関連付けられた
#    バケット間でS3 Cross-Region Replication (CRR)を設定することを推奨します。
#    これにより、どのリージョンにルーティングされても、オブジェクトが
#    利用可能になります。
#    参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointBucketReplication.html
#
# 3. バケットのバージョニング:
#    Cross-Region Replicationを使用する場合、すべての関連バケットで
#    バージョニングを有効にする必要があります。
#
# 4. リクエストルーティング:
#    リクエストは自動的に最も近い（低レイテンシーの）リージョンに
#    ルーティングされます。ただし、オブジェクトの存在は考慮されないため、
#    404エラーを防ぐためにはレプリケーション設定が重要です。
#    参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointRequestRouting.html
#
# 5. 作成時間:
#    Multi-Region Access Pointの作成には通常数分かかります。
#    statusがREADYになるまで待つ必要があります。
#
# 6. プライベートアクセス:
#    AWS PrivateLinkを使用してVPCからMulti-Region Access Pointに
#    プライベートにアクセスすることも可能です。
#    参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointsPrivateLink.html
#
#---------------------------------------------------------------
