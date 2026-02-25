#---------------------------------------------------------------
# AWS EventBridge Scheduler Schedule Group
#---------------------------------------------------------------
#
# Amazon EventBridge Schedulerのスケジュールグループをプロビジョニングするリソースです。
# スケジュールグループは、共通の目的や環境に属するスケジュールを整理するための
# リソースです。各AWSアカウントにはデフォルトのスケジュールグループが付属しており、
# 最大500のスケジュールグループを作成できます。
#
# AWS公式ドキュメント:
#   - EventBridge Schedulerユーザーガイド: https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html
#   - スケジュールグループの管理: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule-group.html
#   - スケジュールグループの作成: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule-group-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_scheduler_schedule_group" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: スケジュールグループの名前を指定します。
  # 設定可能な値: 1-64文字の英数字、ハイフン、アンダースコア
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/scheduler/latest/APIReference/API_CreateScheduleGroup.html
  name = "my-schedule-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: スケジュールグループ名のプレフィックスを指定します。
  #           Terraformが後ろにランダムなサフィックスを追加して一意の名前を生成します。
  # 設定可能な値: 文字列
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule-group.html
  tags = {
    Name        = "my-schedule-group"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    #           グループを削除すると、EventBridge Schedulerが関連するスケジュールを
    #           すべて削除するまでDELETING状態になります。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule-group-delete.html
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スケジュールグループの名前
# - arn: スケジュールグループのAmazon Resource Name (ARN)
# - creation_date: スケジュールグループが作成された日時
# - last_modification_date: スケジュールグループが最後に変更された日時
# - state: スケジュールグループの状態（ACTIVE または DELETING）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
