#---------------------------------------------------------------
# AWS Recycle Bin Retention Rule
#---------------------------------------------------------------
#
# AWS Recycle Bin の保持ルールをプロビジョニングするリソースです。
# 保持ルールは削除されたAWSリソース（EBSスナップショット、EC2イメージ等）を
# 指定した保持期間中にリサイクルビン内に自動的に保持します。
# タグレベルルールとリージョンレベルルールの2種類をサポートします。
#
# AWS公式ドキュメント:
#   - Recycle Bin概要: https://docs.aws.amazon.com/ebs/latest/userguide/recycle-bin.html
#   - 保持ルールの作成: https://docs.aws.amazon.com/ebs/latest/userguide/recycle-bin-create-rule.html
#   - 保持ルールのロック: https://docs.aws.amazon.com/ebs/latest/userguide/recycle-bin-lock.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rbin_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rbin_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_type (Required)
  # 設定内容: 保持ルールで保護するリソースタイプを指定します。
  # 設定可能な値:
  #   - "EBS_SNAPSHOT": Amazon EBSスナップショットを保護対象とする
  #   - "EC2_IMAGE": Amazon EC2 AMI（EBS バックドイメージ）を保護対象とする
  # 注意: リソースタイプは作成後に変更できません。
  resource_type = "EBS_SNAPSHOT"

  # description (Optional)
  # 設定内容: 保持ルールの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  # 注意: 説明に機密情報を含めないよう推奨されています。
  description = "Example retention rule for EBS snapshots"

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
  # 保持期間設定
  #-------------------------------------------------------------

  # retention_period (Required)
  # 設定内容: 保持ルールがリソースを保持する期間を設定するブロックです。
  # 注意: このブロックは必須です。
  retention_period {

    # retention_period_value (Required)
    # 設定内容: 保持期間の値を指定します。
    # 設定可能な値:
    #   - EBSスナップショット・EC2イメージ: 1〜365（日）
    # 注意: retention_period_unit で指定した単位に基づいて期間が計測されます。
    retention_period_value = 10

    # retention_period_unit (Required)
    # 設定内容: 保持期間の単位を指定します。
    # 設定可能な値:
    #   - "DAYS": 日単位（現在サポートされている唯一の値）
    retention_period_unit = "DAYS"
  }

  #-------------------------------------------------------------
  # タグレベルルール設定（resource_tags）
  #-------------------------------------------------------------

  # resource_tags (Optional)
  # 設定内容: タグレベルの保持ルールで保護対象リソースを識別するためのタグを指定するブロックです。
  #           指定したタグキーとタグ値の少なくとも一方が一致するリソースをリサイクルビンに保持します。
  # 注意: resource_tags と exclude_resource_tags は排他的です。
  #       タグレベルルールには resource_tags を、リージョンレベルルールには exclude_resource_tags を使用します。
  #       最大50件まで指定可能です。
  # 参考: https://docs.aws.amazon.com/ebs/latest/userguide/recycle-bin-create-rule.html
  resource_tags {

    # resource_tag_key (Required)
    # 設定内容: 保護対象を識別するタグのキーを指定します。
    # 設定可能な値: 有効なAWSタグキー文字列
    resource_tag_key = "tag_key"

    # resource_tag_value (Optional)
    # 設定内容: 保護対象を識別するタグの値を指定します。
    # 設定可能な値: 有効なAWSタグ値文字列
    # 省略時: タグキーが一致するすべてのリソースが対象となります。
    resource_tag_value = "tag_value"
  }

  #-------------------------------------------------------------
  # リージョンレベルルール設定（exclude_resource_tags）
  #-------------------------------------------------------------

  # exclude_resource_tags (Optional)
  # 設定内容: リージョンレベルの保持ルールで除外（無視）するリソースを識別するためのタグを指定するブロックです。
  #           指定したタグを持つリソースは保持ルールの対象外となります。
  # 注意: exclude_resource_tags は resource_tags を指定しない場合（リージョンレベルルール）にのみ使用します。
  #       タグレベルの保持ルールには使用できません。最大5件まで指定可能です。
  # 参考: https://docs.aws.amazon.com/ebs/latest/userguide/recycle-bin-create-rule.html
  # exclude_resource_tags {

  #   # resource_tag_key (Required)
  #   # 設定内容: 除外対象を識別するタグのキーを指定します。
  #   # 設定可能な値: 有効なAWSタグキー文字列
  #   resource_tag_key = "exclude_tag_key"

  #   # resource_tag_value (Optional)
  #   # 設定内容: 除外対象を識別するタグの値を指定します。
  #   # 設定可能な値: 有効なAWSタグ値文字列
  #   # 省略時: タグキーが一致するすべてのリソースが除外対象となります。
  #   resource_tag_value = "exclude_tag_value"
  # }

  #-------------------------------------------------------------
  # ロック設定
  #-------------------------------------------------------------

  # lock_configuration (Optional)
  # 設定内容: 保持ルールのロック設定ブロックです。
  #           ロックされた保持ルールはロック解除遅延期間中は変更・削除できません。
  # 関連機能: Recycle Bin 保持ルールのロック
  #   ロックはリージョンレベルルールのみサポートします（タグレベルルールや
  #   除外タグを持つリージョンレベルルールはロック不可）。
  #   - https://docs.aws.amazon.com/ebs/latest/userguide/recycle-bin-lock.html
  # lock_configuration {

  #   # unlock_delay (Required)
  #   # 設定内容: ロック解除後に変更・削除が可能になるまでの遅延期間を設定するブロックです。
  #   unlock_delay {

  #     # unlock_delay_value (Required)
  #     # 設定内容: ロック解除遅延期間の値を指定します。
  #     # 設定可能な値: 7〜30（unlock_delay_unit が DAYS の場合）
  #     unlock_delay_value = 7

  #     # unlock_delay_unit (Required)
  #     # 設定内容: ロック解除遅延期間の単位を指定します。
  #     # 設定可能な値:
  #     #   - "DAYS": 日単位（現在サポートされている唯一の値）
  #     unlock_delay_unit = "DAYS"
  #   }
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: 保持ルール自体に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-rbin-rule"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30m" のような時間文字列（例: "30s", "5m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30m" のような時間文字列（例: "30s", "5m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30m" のような時間文字列（例: "30s", "5m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 保持ルールのID
# - arn: 保持ルールのAmazon Resource Name (ARN)
# - status: 保持ルールの状態。"available" または "pending"。
#           "available" 状態の保持ルールのみリソースを保持します。
# - lock_state: 保持ルールのロック状態。"locked"、"pending_unlock"、"unlocked" のいずれか。
# - lock_end_time: ロック解除遅延期間の終了日時。
#                  ロック解除中かつロック解除遅延期間内の保持ルールに対してのみ返されます。
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグマップ。
#---------------------------------------------------------------
