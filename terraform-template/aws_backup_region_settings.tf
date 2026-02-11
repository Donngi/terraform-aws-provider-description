#---------------------------------------------------------------
# AWS Backup Region Settings
#---------------------------------------------------------------
#
# AWS Backupのリージョン設定を管理するリソースです。
# リージョン単位でどのAWSサービスをAWS Backupで保護するか（オプトイン設定）、
# およびどのサービスでフルマネージメントを有効にするかを設定します。
#
# AWS公式ドキュメント:
#   - AWS Backup概要: https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html
#   - サービスのオプトイン設定: https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html
#   - 機能の利用可能性: https://docs.aws.amazon.com/aws-backup/latest/devguide/backup-feature-availability.html
#   - フルマネージメント: https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html#full-management
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_region_settings" "example" {
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
  # サービスオプトイン設定
  #-------------------------------------------------------------

  # resource_type_opt_in_preference (Required)
  # 設定内容: リージョンにおける各AWSサービスのオプトイン設定を指定します。
  # 設定可能な値: サービス名をキー、true/falseを値とするマップ
  #   - true: AWS Backupでそのサービスのリソースを保護対象にする
  #   - false: AWS Backupでそのサービスのリソースを保護対象から除外する
  # 関連機能: AWS Backup サービスオプトイン
  #   サービスがオプトインされている場合、AWS Backupはオンデマンドまたは
  #   スケジュールされたバックアッププランにリソースが含まれている場合に
  #   そのサービスのリソースを保護しようとします。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html
  # 注意: サポートされるサービス一覧は以下を参照
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/backup-feature-availability.html
  resource_type_opt_in_preference = {
    # データベース関連
    "Aurora"      = true  # Amazon Aurora
    "DocumentDB"  = true  # Amazon DocumentDB
    "DynamoDB"    = true  # Amazon DynamoDB
    "DSQL"        = true  # Amazon Aurora DSQL
    "Neptune"     = true  # Amazon Neptune
    "RDS"         = true  # Amazon RDS
    "Redshift"    = true  # Amazon Redshift

    # ストレージ関連
    "EBS"             = true  # Amazon EBS ボリューム
    "EFS"             = true  # Amazon EFS ファイルシステム
    "FSx"             = true  # Amazon FSx ファイルシステム
    "S3"              = true  # Amazon S3 バケット
    "Storage Gateway" = true  # AWS Storage Gateway

    # コンピューティング関連
    "EC2"                    = true  # Amazon EC2 インスタンス
    "SAP HANA on Amazon EC2" = true  # SAP HANA on Amazon EC2
    "VirtualMachine"         = true  # VMware仮想マシン（Backup Gateway経由）

    # その他
    "CloudFormation"      = true   # AWS CloudFormation スタック
    "Redshift Serverless" = false  # Amazon Redshift Serverless
    "Timestream"          = true   # Amazon Timestream
  }

  #-------------------------------------------------------------
  # フルマネージメント設定
  #-------------------------------------------------------------

  # resource_type_management_preference (Optional)
  # 設定内容: リージョンにおける各AWSサービスのフルマネージメント設定を指定します。
  # 設定可能な値: サービス名をキー、true/falseを値とするマップ
  #   - true: AWS Backupのフルマネージメントを有効化
  #   - false: フルマネージメントを無効化
  # 関連機能: AWS Backup フルマネージメント
  #   フルマネージメントを有効にすると以下の利点があります:
  #   - 独立した暗号化: バックアップはソースリソースとは別のKMSキーで暗号化
  #   - awsbackup ARN: バックアップARNが arn:aws:backup で始まり、アクセスポリシーを分離可能
  #   - 一元化された請求: AWS Backupの料金が「Backup」として請求書に表示
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html#full-management
  # 注意: フルマネージメントをサポートするサービス一覧は以下を参照
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/backup-feature-availability.html#features-by-resource
  resource_type_management_preference = {
    "CloudFormation" = true   # AWS CloudFormation スタック
    "DSQL"           = true   # Amazon Aurora DSQL
    "DynamoDB"       = true   # Amazon DynamoDB（advanced featuresを有効化）
    "EFS"            = true   # Amazon EFS ファイルシステム
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSリージョン名
#---------------------------------------------------------------
