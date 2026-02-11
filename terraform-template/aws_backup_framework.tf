#---------------------------------------------------------------
# AWS Backup Framework
#---------------------------------------------------------------
#
# AWS Backup Audit Manager のフレームワークをプロビジョニングするリソースです。
# フレームワークは、バックアップの実践を評価し、ポリシーに準拠しているかを
# 確認するためのコントロールのコレクションです。各アカウント・リージョンで
# 最大15のフレームワークをデプロイできます。
#
# AWS公式ドキュメント:
#   - AWS Backup Audit Manager: https://docs.aws.amazon.com/aws-backup/latest/devguide/aws-backup-audit-manager.html
#   - 監査フレームワークの操作: https://docs.aws.amazon.com/aws-backup/latest/devguide/working-with-audit-frameworks.html
#   - コントロールの選択: https://docs.aws.amazon.com/aws-backup/latest/devguide/choosing-controls.html
#   - コントロールと修復: https://docs.aws.amazon.com/aws-backup/latest/devguide/controls-and-remediation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_framework
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 注意: フレームワークのDeployment StatusをCOMPLETEDにするには、
#       AWS Configのリソーストラッキングを有効にして、バックアップリソースの
#       構成変更を追跡できるようにする必要があります。
#
#---------------------------------------------------------------

resource "aws_backup_framework" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: フレームワークの一意な名前を指定します。
  # 設定可能な値:
  #   - 1〜256文字の文字列
  #   - 英字で始まる必要があります
  #   - 英字、数字、アンダースコアのみ使用可能
  name = "example-backup-framework"

  # description (Optional)
  # 設定内容: フレームワークの説明を指定します。
  # 設定可能な値: 最大1,024文字の文字列
  description = "Example backup compliance framework for monitoring backup practices"

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
  # コントロール設定
  #-------------------------------------------------------------

  # control (Required, 1つ以上必須)
  # 設定内容: フレームワークを構成するコントロールを定義します。
  # 各コントロールはバックアップリソース（バックアッププラン、バックアップ選択、
  # バックアップボールト、リカバリーポイントなど）を評価します。
  # 1アカウント・リージョンあたり最大50コントロールまで使用可能。
  #
  # 利用可能なコントロール名:
  #   - BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN: リソースがバックアッププランに含まれているか評価
  #   - BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK: バックアップ頻度と保持期間を評価
  #   - BACKUP_RECOVERY_POINT_MANUAL_DELETION_DISABLED: リカバリーポイントの手動削除が無効か評価
  #   - BACKUP_RECOVERY_POINT_ENCRYPTED: リカバリーポイントが暗号化されているか評価
  #   - BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK: リカバリーポイントの最小保持期間を評価
  #   - BACKUP_RESOURCES_PROTECTED_BY_CROSS_REGION_COPY: クロスリージョンコピーが設定されているか評価
  #   - BACKUP_RESOURCES_PROTECTED_BY_CROSS_ACCOUNT_COPY: クロスアカウントコピーが設定されているか評価
  #   - BACKUP_RESOURCES_PROTECTED_BY_BACKUP_VAULT_LOCK: Vault Lockで保護されているか評価
  #   - BACKUP_LAST_RECOVERY_POINT_CREATED: 指定時間内にリカバリーポイントが作成されたか評価
  #   - BACKUP_RESTORE_TIME_MEETS_TARGET: リストア時間が目標を満たすか評価
  #   - BACKUP_RESOURCES_PROTECTED_BY_LOGICALLY_AIR_GAPPED_VAULT: 論理的エアギャップボールトで保護されているか評価

  # コントロール1: リソースがバックアッププランに含まれているか
  control {
    # name (Required)
    # 設定内容: コントロールの名前を指定します。
    # 設定可能な値: 1〜256文字の文字列（上記の利用可能なコントロール名を参照）
    name = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN"

    # scope (Optional, 最大1ブロック)
    # 設定内容: コントロールの評価対象スコープを定義します。
    # 3種類のスコープを指定可能:
    #   - 特定のバックアッププラン
    #   - 特定のタグを持つすべてのバックアッププラン
    #   - すべてのバックアッププラン
    scope {
      # compliance_resource_types (Optional)
      # 設定内容: 評価対象のリソースタイプを指定します。
      # 設定可能な値: EBS, EC2, EFS, FSx, RDS, Aurora, S3, DynamoDB, Neptune,
      #              DocumentDB, Redshift, Timestream, CloudFormation,
      #              SAP HANA on Amazon EC2, VirtualMachine など
      compliance_resource_types = [
        "EBS",
        "EC2"
      ]

      # compliance_resource_ids (Optional)
      # 設定内容: 評価対象の特定リソースIDを指定します。
      # 設定可能な値: 最小1、最大100のリソースID
      # compliance_resource_ids = ["arn:aws:ec2:ap-northeast-1:123456789012:volume/vol-1234567890abcdef0"]

      # tags (Optional)
      # 設定内容: 評価対象のリソースをフィルタリングするタグを指定します。
      # 設定可能な値: 最大1つのキーと値のペア
      # tags = {
      #   Environment = "production"
      # }
    }
  }

  # コントロール2: バックアップ頻度と保持期間の評価
  control {
    name = "BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK"

    # input_parameter (Optional)
    # 設定内容: コントロールのパラメータを定義します。
    # 各コントロールで使用可能なパラメータが異なります。

    input_parameter {
      # name (Optional)
      # 設定内容: パラメータの名前を指定します。
      # 設定可能な値: 各コントロールで定義されたパラメータ名
      name = "requiredFrequencyUnit"

      # value (Optional)
      # 設定内容: パラメータの値を指定します。
      # 設定可能な値: パラメータによって異なる
      value = "hours"
    }

    input_parameter {
      name  = "requiredFrequencyValue"
      value = "24"
    }

    input_parameter {
      name  = "requiredRetentionDays"
      value = "35"
    }
  }

  # コントロール3: リカバリーポイントの暗号化
  control {
    name = "BACKUP_RECOVERY_POINT_ENCRYPTED"
    # パラメータなし
  }

  # コントロール4: リカバリーポイントの手動削除無効化
  control {
    name = "BACKUP_RECOVERY_POINT_MANUAL_DELETION_DISABLED"
    # パラメータなし（特定のIAMロールを許可する場合はinput_parameterで指定）
  }

  # コントロール5: リカバリーポイントの最小保持期間
  control {
    name = "BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK"

    input_parameter {
      name  = "requiredRetentionDays"
      value = "35"
    }
  }

  # コントロール6: Vault Lockで保護されているか
  control {
    name = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_VAULT_LOCK"

    input_parameter {
      name  = "minRetentionDays"
      value = "1"
    }

    input_parameter {
      name  = "maxRetentionDays"
      value = "100"
    }

    scope {
      compliance_resource_types = [
        "EBS"
      ]
    }
  }

  # コントロール7: 最後のリカバリーポイントが作成されたか
  control {
    name = "BACKUP_LAST_RECOVERY_POINT_CREATED"

    input_parameter {
      # recoveryPointAgeUnit: hours（1〜744）または days（1〜31）
      name  = "recoveryPointAgeUnit"
      value = "days"
    }

    input_parameter {
      name  = "recoveryPointAgeValue"
      value = "1"
    }

    scope {
      compliance_resource_types = [
        "EBS"
      ]
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30m", "1h"）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30m", "1h"）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30m", "1h"）
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、リソースレベルで定義されたものが優先されます。
  tags = {
    Name        = "example-backup-framework"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: バックアップフレームワークのAmazon Resource Name (ARN)
#
# - creation_time: フレームワークが作成された日時
#   (Unix形式、協定世界時 UTC)
#
# - deployment_status: フレームワークのデプロイメントステータス
#   可能な値: CREATE_IN_PROGRESS | UPDATE_IN_PROGRESS | DELETE_IN_PROGRESS | COMPLETED | FAILED
#
# - id: バックアップフレームワークのID
#
# - status: フレームワークのステータス
#   フレームワークは1つ以上のコントロールで構成されます。
#   各コントロールはバックアッププラン、バックアップ選択、バックアップボールト、
#   リカバリーポイントなどのリソースを管理します。
#   AWS Config のレコーディングを各リソースに対してオン/オフにすることも可能です。
#   詳細: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_DescribeFramework.html#Backup-DescribeFramework-response-FrameworkStatus
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
