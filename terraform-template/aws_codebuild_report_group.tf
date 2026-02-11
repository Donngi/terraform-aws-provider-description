#---------------------------------------------------------------
# AWS CodeBuild Report Group
#---------------------------------------------------------------
#
# AWS CodeBuildのレポートグループをプロビジョニングするリソースです。
# レポートグループは、テストレポートを格納し、エクスポート設定や権限などの
# 共有設定を含むコンテナです。1つのビルドプロジェクトは最大5つのレポートグループを
# 持つことができ、複数のビルドプロジェクト間でレポートグループを共有できます。
#
# AWS公式ドキュメント:
#   - レポートグループの概要: https://docs.aws.amazon.com/codebuild/latest/userguide/test-report-group.html
#   - レポートグループの作成: https://docs.aws.amazon.com/codebuild/latest/userguide/report-group-create.html
#   - ReportGroup API リファレンス: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ReportGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_report_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codebuild_report_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: レポートグループの名前を指定します。
  # 設定可能な値: レポートグループの識別に使用する任意の文字列
  # 注意: buildspecファイル経由で作成する場合、存在しない名前を指定すると
  #       "project-name-new-group-name" という形式で新しいレポートグループが作成されます
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/test-report-group-naming.html
  name = "my-test-report-group"

  # type (Required)
  # 設定内容: レポートグループのタイプを指定します。
  # 設定可能な値:
  #   - "TEST": テストレポートを含むレポートグループ
  #   - "CODE_COVERAGE": コードカバレッジレポートを含むレポートグループ
  # 参考: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ReportGroup.html
  type = "TEST"

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
  # 削除設定
  #-------------------------------------------------------------

  # delete_reports (Optional)
  # 設定内容: レポートグループを削除する前に、所属するレポートを削除するかを指定します。
  # 設定可能な値:
  #   - true: レポートグループ削除時に所属する全レポートを自動削除
  #   - false (デフォルト): レポートグループ内にレポートが存在する場合は削除前に手動削除が必要
  # 省略時: false
  delete_reports = false

  #-------------------------------------------------------------
  # エクスポート設定
  #-------------------------------------------------------------

  # export_config (Required)
  # 設定内容: このレポートグループの生データのエクスポート先情報を指定します。
  # 注意: このブロックは必須です（min_items: 1）
  export_config {
    # type (Required)
    # 設定内容: エクスポート設定のタイプを指定します。
    # 設定可能な値:
    #   - "S3": Amazon S3バケットへエクスポート
    #   - "NO_EXPORT": エクスポートしない
    # 注意: "S3"を指定する場合は、s3_destinationブロックも必須
    type = "S3"

    # s3_destination (Optional)
    # 設定内容: レポートのエクスポート先となるS3バケットの情報を指定します。
    # 注意: export_config.typeが"S3"の場合は必須
    #       max_items: 1（最大1つのs3_destinationブロックのみ指定可能）
    s3_destination {
      # bucket (Required)
      # 設定内容: レポートの生データをエクスポートするS3バケット名を指定します。
      # 設定可能な値: 既存のS3バケット名
      # 注意: CodeBuildサービスロールに対して、このバケットへのアップロード権限が必要
      bucket = "my-codebuild-reports-bucket"

      # encryption_key (Required)
      # 設定内容: レポートの暗号化されたデータの暗号化キーを指定します。
      # 設定可能な値: KMSキーのARN
      # 注意: CodeBuildサービスロールに対して、このKMSキーの使用権限が必要
      encryption_key = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

      # encryption_disabled (Optional)
      # 設定内容: レポートの暗号化を無効にするかを指定します。
      # 設定可能な値:
      #   - true: 暗号化を無効化
      #   - false (デフォルト): 暗号化を有効化
      # 省略時: false（暗号化が有効）
      # 注意: encryption_disabledをtrueに設定した場合でも、encryption_keyは必須パラメータとして指定が必要
      encryption_disabled = false

      # packaging (Optional)
      # 設定内容: ビルド出力アーティファクトのパッケージングタイプを指定します。
      # 設定可能な値:
      #   - "NONE" (デフォルト): パッケージングしない
      #   - "ZIP": ZIP形式でパッケージング
      # 省略時: "NONE"
      packaging = "NONE"

      # path (Optional)
      # 設定内容: エクスポートされたレポートの生データ結果のパスを指定します。
      # 設定可能な値: S3バケット内のパス（例: "/reports/build-results"）
      # 省略時: バケットのルートパスを使用
      path = "/test-reports"
    }
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-test-report-group"
    Environment = "production"
    Project     = "my-project"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: レポートグループのARN
#
# - arn: レポートグループのAmazon Resource Name (ARN)
#
# - created: このレポートグループが作成された日時
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
