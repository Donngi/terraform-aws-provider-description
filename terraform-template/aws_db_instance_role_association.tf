#---------------------------------------------------------------
# AWS RDS DB Instance Role Association
#---------------------------------------------------------------
#
# RDS DBインスタンスとIAMロールの関連付けを管理するリソースです。
# このリソースにより、DBインスタンスがS3などのAWSサービスと連携するために
# 必要なIAMロールを関連付けることができます。
#
# 主なユースケース:
#   - Amazon RDS OracleとAmazon S3の統合
#   - Amazon RDS PostgreSQLへのS3データインポート
#
# 注意: Enhanced Monitoring用のIAMロールについては、aws_db_instanceリソースの
#       monitoring_role_arn引数を使用してください。
#
# AWS公式ドキュメント:
#   - Amazon RDS OracleとS3の統合: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/oracle-s3-integration.html
#   - Amazon S3からRDS PostgreSQLへのデータインポート: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PostgreSQL.S3Import.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance_role_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_instance_role_association" "example" {
  #-------------------------------------------------------------
  # DBインスタンス設定
  #-------------------------------------------------------------

  # db_instance_identifier (Required)
  # 設定内容: IAMロールを関連付けるDBインスタンスの識別子を指定します。
  # 設定可能な値: 有効なRDS DBインスタンス識別子
  # 用途: S3統合などの機能を利用するDBインスタンスを特定します。
  # 関連機能: Amazon RDS DBインスタンス
  #   DBインスタンスはAmazon RDSの基本的なビルディングブロックで、
  #   クラウド上の分離されたデータベース環境です。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.html
  db_instance_identifier = "my-database-instance"

  #-------------------------------------------------------------
  # 機能名設定
  #-------------------------------------------------------------

  # feature_name (Required)
  # 設定内容: 関連付ける機能の名前を指定します。
  # 設定可能な値: DBエンジンに依存する機能名
  #   - S3_INTEGRATION: S3との統合（Oracle、PostgreSQL）
  #   - LAMBDA_INTEGRATION: Lambda関数の呼び出し（PostgreSQL）
  #   - SageMaker: SageMakerとの統合（PostgreSQL）
  #   - Comprehend: Amazon Comprehendとの統合（PostgreSQL）
  # 用途: DBインスタンスが利用する特定のAWS統合機能を指定します。
  # 関連機能: RDS Feature Integration
  #   利用可能な機能名は、AWS CLI の describe-db-engine-versions コマンドで
  #   SupportedFeatureNames リストとして確認できます。
  #   - https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-engine-versions.html
  feature_name = "S3_INTEGRATION"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: DBインスタンスに関連付けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 用途: DBインスタンスが指定した機能を使用する際に必要な権限を付与します。
  #       例えば、S3_INTEGRATION機能の場合、S3バケットへのアクセス権限を持つ
  #       IAMロールを指定する必要があります。
  # 関連機能: IAM Roles for Amazon RDS
  #   IAMロールにより、DBインスタンスが他のAWSサービスにアクセスする際の
  #   認証・認可を管理できます。信頼ポリシーでrds.amazonaws.comを
  #   プリンシパルとして許可する必要があります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAM.html
  role_arn = "arn:aws:iam::123456789012:role/rds-s3-integration-role"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: 関連付けの作成・削除にかかる時間を調整できます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時の最大待機時間を指定します。
    # 設定可能な値: 時間を示す文字列（例: "10m", "30m"）
    # デフォルト: 10m（10分）
    # 用途: IAMロールの関連付けが完了するまでの待機時間を設定します。
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時の最大待機時間を指定します。
    # 設定可能な値: 時間を示す文字列（例: "10m", "30m"）
    # デフォルト: 10m（10分）
    # 用途: IAMロールの関連付け解除が完了するまでの待機時間を設定します。
    delete = "10m"
  }

  #-------------------------------------------------------------
  # ライフサイクル設定（参考）
  #-------------------------------------------------------------
  # DBインスタンス識別子が既知の文字列値の場合、インスタンスが置換されたときに
  # このリソースも再作成されるようにするには、以下のライフサイクルブロックを
  # 使用できます（Terraform 1.2以降が必要）。
  #
  # lifecycle {
  #   replace_triggered_by = [
  #     aws_db_instance.example.id
  #   ]
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DBインスタンス識別子とIAMロールARNをカンマ（,）で区切った値
#---------------------------------------------------------------
