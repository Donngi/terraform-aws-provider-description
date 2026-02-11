#---------------------------------------------------------------
# AWS Backup Logically Air Gapped Vault
#---------------------------------------------------------------
#
# AWS Backupのロジカリーエアギャップドボールト（論理的に隔離されたボールト）を
# プロビジョニングするリソースです。
#
# ロジカリーエアギャップドボールトは、標準のバックアップボールト以上の
# セキュリティ機能を備えた特殊なボールトです。主な特徴:
# - AWSが所有するキーまたはカスタマー管理のKMSキーによる暗号化
# - コンプライアンスモードのVault Lockが自動的に有効
# - AWS RAMを通じて他のアカウントとの共有が可能
# - インシデント発生時の迅速なリカバリに対応
#
# AWS公式ドキュメント:
#   - Logically air-gapped vault: https://docs.aws.amazon.com/aws-backup/latest/devguide/logicallyairgappedvault.html
#   - AWS Backup概要: https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_logically_air_gapped_vault
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_logically_air_gapped_vault" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ロジカリーエアギャップドボールトの名前を指定します。
  # 設定可能な値: 一意のボールト名（文字列）
  # 注意: 作成後は変更できません（変更すると再作成が必要）
  name = "lag-example-vault"

  #-------------------------------------------------------------
  # 保持期間設定
  #-------------------------------------------------------------

  # max_retention_days (Required)
  # 設定内容: ボールトがリカバリポイントを保持する最大日数を指定します。
  # 設定可能な値: 7以上の整数（日数）
  # 関連機能: AWS Backup Vault Lock
  #   ロジカリーエアギャップドボールトはコンプライアンスモードの
  #   Vault Lockが自動的に適用され、指定した保持期間内は
  #   リカバリポイントの削除が防止されます。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/vault-lock.html
  max_retention_days = 365

  # min_retention_days (Required)
  # 設定内容: ボールトがリカバリポイントを保持する最小日数を指定します。
  # 設定可能な値: 7以上の整数（日数）、max_retention_days以下である必要あり
  # 関連機能: AWS Backup Vault Lock
  #   最小保持期間により、指定した日数より前にリカバリポイントが
  #   削除されることを防止します。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/vault-lock.html
  min_retention_days = 7

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
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_key_arn (Optional)
  # 設定内容: ボールト内のバックアップを暗号化するために使用する
  #           AWS KMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN（対称カスタマー管理キーのみ対応）
  # 省略時: AWSが所有するキー（AWS owned key）で暗号化
  # 関連機能: AWS Backup 暗号化
  #   カスタマー管理キー（CMK）を使用することで、暗号化キーの完全な
  #   制御が可能になります。キーポリシーでアクセス制御を管理し、
  #   AWS KMSの自動キーローテーションもサポートされます。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/encryption.html
  # 注意: CMKは中央のキーボールトアカウントから共有することも可能です。
  #       キーの削除やアクセス権限の喪失により、バックアップへの
  #       アクセスが不可能になる可能性があるため注意が必要です。
  encryption_key_arn = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/organize-resources.html
  tags = {
    Name        = "lag-example-vault"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位を含む文字列（例: "30s", "5m", "2h45m"）
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: デフォルトのタイムアウト時間を使用
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ロジカリーエアギャップドボールトの名前
#
# - arn: ロジカリーエアギャップドボールトのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# 注意: MCPドキュメントにはrecovery_points属性（ボールト内のリカバリポイント数）
#       が記載されていますが、Provider 6.28.0のスキーマには含まれていません。
#---------------------------------------------------------------
