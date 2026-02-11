#---------------------------------------------------------------
# AWS RDS Automated Backups Replication
#---------------------------------------------------------------
#
# RDSの自動バックアップを異なるAWSリージョンにクロスリージョンレプリケーション
# するためのリソースです。このリソースを使用することで、災害復旧（DR）戦略の
# 一環として、自動バックアップを別リージョンに複製できます。
#
# 重要: このリソースは、レプリケーション先のリージョンで作成する必要があります。
#
# AWS公式ドキュメント:
#   - 自動バックアップの別リージョンへのレプリケーション: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReplicateBackups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance_automated_backups_replication
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_instance_automated_backups_replication" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # source_db_instance_arn (Required, Forces new resource)
  # 設定内容: レプリケーション元のDBインスタンスのARNを指定します。
  # 設定可能な値: 有効なRDS DBインスタンスのARN
  # 形式: arn:aws:rds:{リージョン}:{アカウントID}:db:{DB識別子}
  # 注意: リソース作成後の変更はできません（Forces new resource）
  source_db_instance_arn = "arn:aws:rds:us-west-2:123456789012:db:mydatabase"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # retention_period (Optional, Forces new resource)
  # 設定内容: レプリケートされた自動バックアップの保持期間（日数）を指定します。
  # 設定可能な値: 正の整数（日数）
  # 省略時: 7（日間）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  retention_period = 14

  # kms_key_id (Optional, Forces new resource)
  # 設定内容: レプリケートされた自動バックアップの暗号化に使用するKMSキー識別子を指定します。
  # 設定可能な値: レプリケーション先リージョンにおけるKMS暗号化キーのARN
  # 形式: arn:aws:kms:{リージョン}:{アカウントID}:key/{キーID}
  # 省略時: null（デフォルトのKMSキーを使用）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 例: "arn:aws:kms:us-east-1:123456789012:key/AKIAIOSFODNN7EXAMPLE"
  kms_key_id = null

  # pre_signed_url (Optional, Forces new resource)
  # 設定内容: ソースDBインスタンスのリージョンで呼び出される
  #          StartDBInstanceAutomatedBackupsReplication アクションのための
  #          Signature Version 4署名付きリクエストを含むURLを指定します。
  # 設定可能な値: Signature Version 4で署名されたURL文字列
  # 省略時: null（AWSが自動的に処理）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 参考:
  #   - Signature Version 4: https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html
  #   - StartDBInstanceAutomatedBackupsReplication API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartDBInstanceAutomatedBackupsReplication.html
  pre_signed_url = null

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
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: レプリケートされた自動バックアップのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------
