#---------------------------------------------------------------
# Amazon S3 ディレクトリバケット (S3 Express One Zone)
#---------------------------------------------------------------
#
# Amazon S3 Express One Zone ストレージクラス向けのディレクトリバケットを
# プロビジョニングするリソースです。
# ディレクトリバケットは、レイテンシーの敏感なアプリケーション向けに
# 汎用バケットと比較して最大10倍高速なデータアクセスを提供します。
# 汎用バケットは aws_s3_bucket リソースを使用してください。
#
# バケット名の形式: "[bucket_name]--[az-id]--x-s3"
# 例: "my-bucket--usw2-az1--x-s3"
#
# AWS公式ドキュメント:
#   - S3 Express One Zone概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-express-one-zone.html
#   - ディレクトリバケットの作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-express-working-with-buckets.html
#   - ディレクトリバケットの命名規則: https://docs.aws.amazon.com/AmazonS3/latest/userguide/directory-bucket-naming-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_directory_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_directory_bucket" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: ディレクトリバケットの名前を指定します。
  # 設定可能な値: "[base_name]--[az-id]--x-s3" 形式の文字列
  #   例: "my-bucket--usw2-az1--x-s3"
  #   - base_name: 小文字英数字・ハイフンを含む3〜63文字
  #   - az-id: アベイラビリティゾーンID（例: usw2-az1, use1-az4）
  #   - サフィックス "--x-s3" は固定
  # 注意: AWSアカウントおよびAZをまたいでグローバルに一意である必要があります。
  #       作成後の変更は不可（Forces new resource）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/directory-bucket-naming-rules.html
  bucket = "my-bucket--usw2-az1--x-s3"

  #-------------------------------------------------------------
  # ロケーション設定
  #-------------------------------------------------------------

  # location (Optional, Forces new resource)
  # 設定内容: ディレクトリバケットを配置するロケーションの設定ブロックです。
  # 省略時: プロバイダー設定のリージョン内のデフォルトAZが使用されます
  # 注意: 作成後の変更は不可（Forces new resource）
  location {
    # name (Required, Forces new resource)
    # 設定内容: バケットを配置するアベイラビリティゾーンのIDを指定します。
    # 設定可能な値: 有効なAZのID（例: "usw2-az1", "use1-az4", "apne1-az4"）
    #   バケット名のAZIDサフィックス部分と一致させる必要があります。
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
    name = "usw2-az1"

    # type (Optional, Forces new resource)
    # 設定内容: バケットロケーションのタイプを指定します。
    # 設定可能な値:
    #   - "AvailabilityZone": アベイラビリティゾーン内にバケットを配置（現時点で唯一の選択肢）
    # 省略時: "AvailabilityZone"
    # 注意: 作成後の変更は不可（Forces new resource）
    type = "AvailabilityZone"
  }

  #-------------------------------------------------------------
  # データ冗長性設定
  #-------------------------------------------------------------

  # data_redundancy (Optional, Forces new resource)
  # 設定内容: バケット内データの冗長化方式を指定します。
  # 設定可能な値:
  #   - "SingleAvailabilityZone": 単一AZ内でのデータ冗長化
  #     （S3 Express One Zone の現在サポートされている唯一の選択肢）
  # 省略時: "SingleAvailabilityZone"
  # 注意: 作成後の変更は不可（Forces new resource）
  data_redundancy = "SingleAvailabilityZone"

  #-------------------------------------------------------------
  # バケットタイプ設定
  #-------------------------------------------------------------

  # type (Optional, Forces new resource)
  # 設定内容: バケットのタイプを指定します。
  # 設定可能な値:
  #   - "Directory": ディレクトリバケット（S3 Express One Zone）
  # 省略時: "Directory"
  # 注意: 作成後の変更は不可（Forces new resource）
  type = "Directory"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: バケット削除時に全オブジェクトを強制的に削除するかを指定します。
  #   この設定はバケット destroy 時のみに機能し、true に設定するだけでは削除されません。
  # 設定可能な値:
  #   - true: destroy 時に全オブジェクトを削除してからバケットを削除
  #   - false: オブジェクトが残っている場合は destroy が失敗
  # 省略時: false
  # 注意: true に設定後、次の terraform apply が成功してから destroy を実行する必要があります。
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-directory-bucket"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ディレクトリバケットのARN（例: arn:aws:s3express:us-west-2:123456789012:bucket/my-bucket--usw2-az1--x-s3）
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#
# (非推奨)
# - id: バケット名（deprecated。今後のバージョンで削除予定）
#---------------------------------------------------------------
