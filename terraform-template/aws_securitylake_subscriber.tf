#---------------------------------------------------------------
# AWS Security Lake Subscriber
#---------------------------------------------------------------
#
# Amazon Security Lakeのサブスクライバーをプロビジョニングするリソースです。
# サブスクライバーは、Security Lakeに収集されたログやイベントデータへの
# アクセスを管理するためのエンティティです。データアクセス（S3）または
# クエリアクセス（LAKEFORMATION）の2種類のアクセスタイプを設定できます。
#
# AWS公式ドキュメント:
#   - Security Lakeサブスクライバー管理: https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-management.html
#   - データアクセスサブスクライバー: https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-data-access.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securitylake_subscriber
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securitylake_subscriber" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # subscriber_name (Optional)
  # 設定内容: Security Lakeサブスクライバーの名前を指定します。
  # 設定可能な値: 文字列
  subscriber_name = "example-subscriber"

  # subscriber_description (Optional)
  # 設定内容: サブスクライバーアカウントの説明を指定します。
  # 設定可能な値: 文字列
  subscriber_description = "Example Security Lake subscriber"

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
  # アクセスタイプ設定
  #-------------------------------------------------------------

  # access_type (Optional)
  # 設定内容: サブスクライバーのアクセスタイプを指定します。
  # 設定可能な値:
  #   - "S3": データアクセス。S3バケット内のオブジェクトに直接アクセスし、
  #           HTTPSエンドポイントまたはSQSキューで新しいオブジェクトの通知を受け取ります。
  #   - "LAKEFORMATION": クエリアクセス。AWS Lake Formationテーブルに対して
  #           Amazon Athena等のサービスで直接クエリを実行できます。
  # 関連機能: Security Lakeサブスクライバーアクセス
  #   データアクセスとクエリアクセスの2種類を提供。用途に応じて選択します。
  #   - https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-management.html
  access_type = "S3"

  #-------------------------------------------------------------
  # ソース設定
  #-------------------------------------------------------------

  # source (Required)
  # 設定内容: サブスクライバーが受信するログおよびイベントのソースを指定します。
  # 注意: 1つのサブスクライバーあたり最大10ソースまで設定可能
  # 関連機能: Security Lakeソース管理
  #   AWSネイティブサービスのログソースおよびカスタムソースを設定できます。
  #   - https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-management.html

  # --- AWSログソースの例 ---
  source {

    # aws_log_source_resource (Optional)
    # 設定内容: AWSネイティブサービスのログソースを指定します。
    aws_log_source_resource {

      # source_name (Required)
      # 設定内容: AWSソースの名前を指定します。
      # 設定可能な値:
      #   - "ROUTE53": Amazon Route 53 Resolver クエリログ
      #   - "VPC_FLOW": Amazon VPC フローログ
      #   - "SH_FINDINGS": AWS Security Hub の検出結果
      #   - "CLOUD_TRAIL_MGMT": AWS CloudTrail 管理イベント
      #   - "LAMBDA_EXECUTION": AWS Lambda 実行ログ
      #   - "S3_DATA": Amazon S3 データイベント
      #   - "EKS_AUDIT": Amazon EKS 監査ログ
      #   - "WAF": AWS WAF ログ
      source_name = "ROUTE53"

      # source_version (Optional)
      # 設定内容: AWSソースのバージョンを指定します。
      # 設定可能な値: バージョン文字列（例: "1.0", "2.0"）
      # 省略時: 自動的に決定されます
      source_version = "2.0"
    }
  }

  # --- カスタムログソースの例 ---
  # source {
  #
  #   # custom_log_source_resource (Optional)
  #   # 設定内容: サードパーティのカスタムログソースを指定します。
  #   custom_log_source_resource {
  #
  #     # source_name (Required)
  #     # 設定内容: カスタムソースの名前を指定します。
  #     # 設定可能な値: リージョン内で一意の文字列
  #     source_name = "my-custom-source"
  #
  #     # source_version (Optional)
  #     # 設定内容: カスタムソースのバージョンを指定します。
  #     # 設定可能な値: リージョン内で一意のバージョン文字列
  #     # 省略時: 自動的に決定されます
  #     source_version = "1.0"
  #   }
  # }

  #-------------------------------------------------------------
  # サブスクライバーID設定
  #-------------------------------------------------------------

  # subscriber_identity (Required)
  # 設定内容: データにアクセスするためのAWS IDを指定します。
  subscriber_identity {

    # external_id (Required)
    # 設定内容: サブスクライバーの外部IDを指定します。
    # 設定可能な値: 文字列。クロスアカウントアクセス時のセキュリティ強化に使用されます。
    external_id = "example-external-id"

    # principal (Required)
    # 設定内容: サブスクライバーのプリンシパル（AWSアカウントID）を指定します。
    # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
    principal = "123456789012"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-subscriber"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトをカスタマイズします。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウトを指定します。
    # 設定可能な値: 期間文字列（例: "30s", "5m", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウトを指定します。
    # 設定可能な値: 期間文字列（例: "30s", "5m", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウトを指定します。
    # 設定可能な値: 期間文字列（例: "30s", "5m", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Security Lakeサブスクライバーの Amazon Resource Name (ARN)
#
# - id: サブスクライバーのサブスクライバーID
#
# - resource_share_arn: AWS RAMリソース共有を一意に定義するARN。
#                       RAMリソース共有の招待を承認する前に、
#                       リソース共有に関する詳細を確認できます。
#
# - resource_share_name: リソース共有の名前
#
# - role_arn: サブスクライバーのロールを指定するARN
#
# - s3_bucket_arn: Security Lake用Amazon S3バケットのARN
#
# - subscriber_endpoint: 例外メッセージが送信されるサブスクライバーエンドポイント
#
# - subscriber_status: サブスクライバーのステータス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
