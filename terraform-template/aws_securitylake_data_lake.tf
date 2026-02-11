#---------------------------------------------------------------
# AWS Security Lake Data Lake
#---------------------------------------------------------------
#
# Amazon Security Lakeのデータレイクをプロビジョニングするリソースです。
# Security Lakeは、AWS環境、SaaSプロバイダー、オンプレミス、サードパーティソースから
# セキュリティデータを自動的に一元化し、Apache Parquet形式およびOpen Cybersecurity
# Schema Framework (OCSF) に変換してS3バケットに格納するマネージドサービスです。
#
# NOTE: aws_securitylake_data_lakeは他のSecurity Lakeリソースより先に作成する
#       必要があります。depends_onを使用してください。
#
# AWS公式ドキュメント:
#   - Security Lake概要: https://docs.aws.amazon.com/security-lake/latest/userguide/what-is-security-lake.html
#   - Security Lakeの概念: https://docs.aws.amazon.com/security-lake/latest/userguide/service-concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securitylake_data_lake
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securitylake_data_lake" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # meta_store_manager_role_arn (Required)
  # 設定内容: AWS Glueテーブルの作成・更新に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このテーブルにはAWSログソースおよびカスタムソースの取り込み・正規化により
  #       生成されたパーティションが含まれます。
  meta_store_manager_role_arn = "arn:aws:iam::123456789012:role/AmazonSecurityLakeMetaStoreManagerV2"

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
  # データレイク構成設定
  #-------------------------------------------------------------

  # configuration (Required)
  # 設定内容: データレイクのリージョン別構成を定義するブロックです。
  # ロールアップリージョンにデータを提供するリージョンを指定します。
  # 複数のconfigurationブロックを指定して、複数リージョンを構成できます。
  configuration {
    # region (Required)
    # 設定内容: Security Lakeが自動的に有効化されるAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード
    region = "ap-northeast-1"

    #-----------------------------------------------------------
    # 暗号化設定
    #-----------------------------------------------------------

    # encryption_configuration (Optional)
    # 設定内容: Security Lakeオブジェクトの暗号化設定を指定します。
    # 省略時: S3マネージド暗号化が使用されます。
    encryption_configuration = [
      {
        # kms_key_id (Optional)
        # 設定内容: Security LakeオブジェクトのKMS暗号化キーIDを指定します。
        # 設定可能な値:
        #   - "S3_MANAGED_KEY": S3マネージドキーを使用
        #   - KMSキーのARN: カスタマーマネージドキーを使用
        # 省略時: S3マネージドキーが使用されます。
        kms_key_id = "S3_MANAGED_KEY"
      }
    ]

    #-----------------------------------------------------------
    # ライフサイクル設定
    #-----------------------------------------------------------

    # lifecycle_configuration (Optional)
    # 設定内容: Security Lakeオブジェクトのライフサイクル管理を設定します。
    # データの有効期限やストレージクラスの移行を制御します。
    lifecycle_configuration {

      # expiration (Optional)
      # 設定内容: データの有効期限設定を指定します。
      expiration {
        # days (Optional)
        # 設定内容: Security Lakeオブジェクトのデータが期限切れになるまでの日数を指定します。
        # 設定可能な値: 正の整数
        days = 365
      }

      # transition (Optional)
      # 設定内容: データのストレージクラス移行設定を指定します。
      # 複数のtransitionブロックを指定して、段階的な移行を構成できます。
      transition {
        # days (Optional)
        # 設定内容: 別のS3ストレージクラスにデータを移行するまでの日数を指定します。
        # 設定可能な値: 正の整数
        days = 30

        # storage_class (Optional)
        # 設定内容: 移行先のS3ストレージクラスを指定します。
        # 設定可能な値: ワークロードのデータアクセス頻度、耐障害性、コスト要件に
        #   基づいて選択可能なストレージクラス
        #   - "STANDARD_IA": 低頻度アクセス
        #   - "ONEZONE_IA": 単一AZ低頻度アクセス
        #   - "INTELLIGENT_TIERING": インテリジェント階層化
        #   - "GLACIER": Glacier
        #   - "DEEP_ARCHIVE": Glacier Deep Archive
        #   等のS3ストレージクラス
        storage_class = "STANDARD_IA"
      }
    }

    #-----------------------------------------------------------
    # レプリケーション設定
    #-----------------------------------------------------------

    # replication_configuration (Optional)
    # 設定内容: Security LakeオブジェクトのS3バケット間レプリケーション設定を指定します。
    # リージョン間でのデータの自動非同期コピーを有効にします。
    replication_configuration {
      # regions (Optional)
      # 設定内容: レプリケーション先のAWSリージョンを指定します。
      # 設定可能な値: 有効なAWSリージョンコードのセット
      # 注意: 同一アカウントまたは異なるアカウントのS3バケットにレプリケーション可能。
      #       同一リージョンまたは異なるリージョンの宛先バケットを指定できます。
      regions = ["us-east-1"]

      # role_arn (Optional)
      # 設定内容: レプリケーション設定に使用するIAMロールのARNを指定します。
      # 設定可能な値: Security Lakeが管理する有効なIAMロールARN
      # 注意: Security Lakeが管理するIAMロールを使用して、レプリケーション設定の
      #       正確性を確保します。
      role_arn = "arn:aws:iam::123456789012:role/AmazonSecurityLakeReplicationRole"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを設定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30s", "2h45m"）。有効な時間単位は "s"(秒), "m"(分), "h"(時)
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30s", "2h45m"）。有効な時間単位は "s"(秒), "m"(分), "h"(時)
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30s", "2h45m"）。有効な時間単位は "s"(秒), "m"(分), "h"(時)
    # 注意: 削除操作のタイムアウトは、destroy操作前に変更がstateに保存される場合にのみ適用されます。
    delete = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-security-lake"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データレイクのAmazon Resource Name (ARN)
#
# - id: データレイクのID
#
# - s3_bucket_arn: Security Lake用Amazon S3バケットのARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
