#---------------------------------------------------------------
# AWS Elastic Beanstalk Application
#---------------------------------------------------------------
#
# AWS Elastic Beanstalk アプリケーションをプロビジョニングするリソースです。
# アプリケーションは、環境、バージョン、および構成を含む Elastic Beanstalk 
# コンポーネントの論理コレクションです。
#
# AWS公式ドキュメント:
#   - Elastic Beanstalk アプリケーション: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications.html
#   - アプリケーションバージョンのライフサイクル: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications-lifecycle.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elastic_beanstalk_application" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Elastic Beanstalk アプリケーションの名前を指定します。
  # 設定可能な値: 1-100文字の文字列（英数字、ハイフン、アンダースコアのみ使用可能）
  # 注意: この名前はアカウント内で一意である必要があります。
  # 関連機能: Elastic Beanstalk アプリケーション
  #   環境、バージョン、および構成を含む Elastic Beanstalk コンポーネントの論理コレクション。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications.html
  name = "my-application"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: アプリケーションの説明を指定します。
  # 設定可能な値: 最大200文字の文字列
  # 省略時: 説明なし
  # 用途: アプリケーションの目的や用途を文書化するために使用
  description = "My Elastic Beanstalk Application"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  #       https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # アプリケーションバージョンライフサイクル設定
  #-------------------------------------------------------------

  # appversion_lifecycle (Optional, Max items: 1)
  # 設定内容: アプリケーションバージョンのライフサイクルポリシーを設定します。
  # 用途: 古いアプリケーションバージョンを自動的に削除し、ストレージコストを削減
  # 関連機能: アプリケーションバージョンのライフサイクル管理
  #   アプリケーションバージョンの最大数や最大保持期間を設定し、
  #   条件に合致する古いバージョンを自動削除します。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications-lifecycle.html
  appversion_lifecycle {
    # service_role (Required)
    # 設定内容: アプリケーションバージョンの削除を実行するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 注意: このロールには以下の権限が必要です:
    #   - elasticbeanstalk:DeleteApplicationVersion
    #   - s3:DeleteObject (delete_source_from_s3がtrueの場合)
    # 関連機能: Elastic Beanstalk サービスロール
    #   Elastic Beanstalkがユーザーに代わってAWSリソースにアクセスするためのロール。
    #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/AWSHowTo.iam.managed-policies.html
    service_role = "arn:aws:iam::123456789012:role/aws-elasticbeanstalk-service-role"

    # delete_source_from_s3 (Optional)
    # 設定内容: アプリケーションバージョン削除時にS3のソースバンドルも削除するかを指定します。
    # 設定可能な値:
    #   - true: アプリケーションバージョンとともにS3のソースバンドルも削除
    #   - false (デフォルト): アプリケーションバージョンのみ削除し、S3のソースバンドルは保持
    # 注意: trueに設定する場合、service_roleにs3:DeleteObject権限が必要です。
    delete_source_from_s3 = false

    # max_age_in_days (Optional)
    # 設定内容: アプリケーションバージョンを保持する最大日数を指定します。
    # 設定可能な値: 1-1000日
    # 省略時: 日数による削除は行われません
    # 注意: max_countと併用可能。いずれかの条件を満たすと削除されます。
    # 用途: 一定期間経過した古いバージョンを自動的にクリーンアップ
    max_age_in_days = 90

    # max_count (Optional)
    # 設定内容: 保持するアプリケーションバージョンの最大数を指定します。
    # 設定可能な値: 1-1000
    # 省略時: 数による削除は行われません
    # 注意: max_age_in_daysと併用可能。いずれかの条件を満たすと削除されます。
    #       この数を超えた場合、最も古いバージョンから順に削除されます。
    # 用途: バージョン数の上限を設定し、ストレージ使用量を制御
    max_count = 100
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アプリケーションのAmazon Resource Name (ARN)
#        形式: arn:aws:elasticbeanstalk:region:account-id:application/application-name
#        例: arn:aws:elasticbeanstalk:us-east-1:123456789012:application/my-application
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
