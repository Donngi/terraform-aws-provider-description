#---------------------------------------------------------------
# AWS Backup Restore Testing Selection
#---------------------------------------------------------------
#
# AWS Backupのリストアテスト選択をプロビジョニングするリソースです。
# リストアテスト選択は、リストアテスト計画の一部として、どのリソースを
# リストアテストの対象とするかを定義します。
#
# AWS公式ドキュメント:
#   - AWS Backup リストアテスト概要: https://docs.aws.amazon.com/aws-backup/latest/devguide/restore-testing.html
#   - リストアテスト推論メタデータ: https://docs.aws.amazon.com/aws-backup/latest/devguide/restore-testing-inferred-metadata.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_restore_testing_selection
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_restore_testing_selection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リストアテスト選択の名前を指定します。
  # 設定可能な値: 文字列
  name = "ec2_selection"

  # restore_testing_plan_name (Required)
  # 設定内容: 関連付けるリストアテスト計画の名前を指定します。
  # 設定可能な値: 既存のリストアテスト計画名
  restore_testing_plan_name = "example_restore_testing_plan"

  # protected_resource_type (Required)
  # 設定内容: 保護対象リソースのタイプを指定します。
  # 設定可能な値:
  #   - "EC2": Amazon EC2インスタンス
  #   - "EBS": Amazon EBSボリューム
  #   - "EFS": Amazon EFSファイルシステム
  #   - "DynamoDB": Amazon DynamoDBテーブル
  #   - "RDS": Amazon RDSインスタンス
  #   - "Aurora": Amazon Auroraクラスター
  #   - "S3": Amazon S3バケット
  #   - "FSx": Amazon FSxファイルシステム
  #   - "DocumentDB": Amazon DocumentDBクラスター
  #   - "Neptune": Amazon Neptuneクラスター
  protected_resource_type = "EC2"

  # iam_role_arn (Required)
  # 設定内容: リストア操作を実行するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このロールにはバックアップからのリストアに必要な権限が付与されている必要があります。
  iam_role_arn = "arn:aws:iam::123456789012:role/AWSBackupRestoreRole"

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
  # 保護対象リソース設定
  #-------------------------------------------------------------

  # protected_resource_arns (Optional)
  # 設定内容: リストアテストの対象となる保護対象リソースのARNを指定します。
  # 設定可能な値:
  #   - 特定のリソースARNのリスト
  #   - ["*"]: 指定されたリソースタイプの全リソースを対象
  # 注意: protected_resource_conditionsと組み合わせて使用可能
  protected_resource_arns = ["*"]

  # protected_resource_conditions (Optional)
  # 設定内容: リソースタグに基づいて保護対象リソースをフィルタリングする条件を指定します。
  # 用途: タグベースでリストアテスト対象を絞り込む場合に使用
  protected_resource_conditions {

    # string_equals (Optional)
    # 設定内容: 指定した値と完全一致するタグを持つリソースのみを対象とします（完全一致フィルタ）。
    string_equals {
      # key (Required)
      # 設定内容: フィルタリングに使用するタグキーを指定します。
      # 設定可能な値:
      #   - "aws:ResourceTag/{タグ名}" の形式で指定
      #   - 最小長: 1、最大長: 128
      #   - 使用可能文字: 文字、空白、数字、+ - = . _ : /
      key = "aws:ResourceTag/backup"

      # value (Required)
      # 設定内容: フィルタリングに使用するタグ値を指定します。
      # 設定可能な値: 最大長256の文字列
      value = "true"
    }

    # string_not_equals (Optional)
    # 設定内容: 指定した値と一致しないタグを持つリソースのみを対象とします（否定一致フィルタ）。
    string_not_equals {
      # key (Required)
      # 設定内容: フィルタリングに使用するタグキーを指定します。
      # 設定可能な値:
      #   - "aws:ResourceTag/{タグ名}" の形式で指定
      #   - 最小長: 1、最大長: 128
      #   - 使用可能文字: 文字、空白、数字、+ - = . _ : /
      key = "aws:ResourceTag/Environment"

      # value (Required)
      # 設定内容: 除外対象となるタグ値を指定します。
      # 設定可能な値: 最大長256の文字列
      value = "development"
    }
  }

  #-------------------------------------------------------------
  # リストアメタデータ設定
  #-------------------------------------------------------------

  # restore_metadata_overrides (Optional)
  # 設定内容: リストア時に上書きするメタデータキーと値のマップを指定します。
  # 用途: AWS Backupが推論したデフォルトのリストアメタデータを上書きする場合に使用
  # 設定可能な値: リソースタイプごとに異なるキーが利用可能
  #   - EC2: instanceType, subnetId, securityGroupIds, iamInstanceProfileName, requireImdsV2
  #   - RDS: dbInstanceClass, dbSubnetGroupName, vpcSecurityGroupIds, multiAz など
  #   - EBS: availabilityZone, volumeType, iops, kmsKeyId など
  #   - S3: encryptionType, kmsKey など
  # 参考: https://docs.aws.amazon.com/aws-backup/latest/devguide/restore-testing-inferred-metadata.html
  restore_metadata_overrides = {
    instanceType = "t3.micro"
    subnetId     = "subnet-12345678"
  }

  #-------------------------------------------------------------
  # 検証設定
  #-------------------------------------------------------------

  # validation_window_hours (Optional)
  # 設定内容: リストアされたデータに対して検証スクリプトを実行できる時間（時間単位）を指定します。
  # 設定可能な値: 1〜168（時間）
  # 省略時: AWS Backupのデフォルト値を使用
  # 関連機能: リストアテスト検証
  #   リストア後、指定した時間内に検証スクリプトを実行してデータの整合性を確認できます。
  validation_window_hours = 24
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは設定した引数に加えて、以下の属性をエクスポートします:
#
# (このリソースには追加のcomputed only属性はありません)
#---------------------------------------------------------------
