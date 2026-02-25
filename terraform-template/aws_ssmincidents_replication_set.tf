#---------------------------------------------------------------
# AWS Systems Manager Incident Manager レプリケーションセット
#---------------------------------------------------------------
#
# AWS Systems Manager Incident Manager のレプリケーションセットを管理するリソース。
# レプリケーションセットは、インシデントデータを複数のAWSリージョンに複製して
# 高可用性と耐障害性を提供する。Incident Managerを使用するには
# レプリケーションセットを事前に作成する必要がある。
#
# AWS公式ドキュメント:
#   - AWS Systems Manager Incident Manager 概要: https://docs.aws.amazon.com/incident-manager/latest/userguide/what-is-incident-manager.html
#   - レプリケーションセット: https://docs.aws.amazon.com/incident-manager/latest/userguide/getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_replication_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。

#---------------------------------------
# レプリケーションセット設定
#---------------------------------------
resource "aws_ssmincidents_replication_set" "example" {

  #---------------------------------------
  # レプリケーション先リージョン設定（推奨）
  #---------------------------------------
  # 設定内容: レプリケーション対象リージョンの一覧（1つ以上必須）
  regions {
    # 設定内容: レプリケーション対象のAWSリージョン名
    # 設定可能な値: 有効なAWSリージョン名（例: "us-east-1", "ap-northeast-1"）
    name = "us-east-1"

    # 設定内容: データ暗号化に使用するKMSキーのARN
    # 設定可能な値: KMSキーのARN文字列
    # 省略時: AWSマネージドキーで暗号化される
    # kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
  }

  # 設定内容: 追加のレプリケーション先リージョン（複数指定可能）
  # regions {
  #   name        = "ap-northeast-1"
  #   kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/example-key-id"
  # }

  #---------------------------------------
  # レプリケーション先リージョン設定（非推奨）
  #---------------------------------------
  # 設定内容: regionsブロックの旧バージョン。regionsブロックの使用を推奨
  # region {
  #   name        = "us-east-1"
  #   kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
  # }

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグのマップ
  # 省略時: タグなし
  tags = {
    Name = "example-replication-set"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  # timeouts {
  #   # 設定内容: リソース作成のタイムアウト時間
  #   # 省略時: プロバイダーデフォルト値
  #   create = "30m"
  #
  #   # 設定内容: リソース更新のタイムアウト時間
  #   # 省略時: プロバイダーデフォルト値
  #   update = "30m"
  #
  #   # 設定内容: リソース削除のタイムアウト時間
  #   # 省略時: プロバイダーデフォルト値
  #   delete = "30m"
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# id                - レプリケーションセットのARN
# arn               - レプリケーションセットのARN
# created_by        - レプリケーションセットを作成したプリンシパルのARN
# deletion_protected - 削除保護が有効かどうか（bool）
# last_modified_by  - 最後にレプリケーションセットを変更したプリンシパルのARN
# status            - レプリケーションセットの現在のステータス
# tags_all          - リソースに付与された全タグ（プロバイダーデフォルトタグを含む）
# regions[].status         - 当該リージョンのレプリケーションステータス
# regions[].status_message - 当該リージョンのステータスに関するメッセージ
