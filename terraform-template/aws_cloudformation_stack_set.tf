#-------------------------------------------------------------------------------------------------------
# リソース: aws_cloudformation_stack_set
# Provider Version: 6.28.0
# Generated: 2026-02-12
#-------------------------------------------------------------------------------------------------------
# 用途: CloudFormation StackSetの管理
#   - 複数のAWSアカウント・リージョンにわたってCloudFormationテンプレートをデプロイ
#   - SERVICE_MANAGED（AWS Organizations連携）またはSELF_MANAGED（手動）の権限モデルをサポート
#   - スタックセットインスタンス（aws_cloudformation_stack_set_instance）と組み合わせて使用
#
# NOTE: テンプレートパラメータ（Defaultを持つものを含む）は全て明示的に設定するか、lifecycle.ignore_changesで無視する必要がある
# NOTE: NoEchoパラメータは必ずlifecycle.ignore_changesで無視すること
# NOTE: DELEGATED_ADMIN使用時は、IAMユーザー/ロールにorganizations:ListDelegatedAdministrators権限が必要
# NOTE: template_bodyとtemplate_urlは排他的（どちらか一方のみ指定可能）
# NOTE: タグは最大50個まで設定可能
#
# 関連リソース:
#   - aws_cloudformation_stack_set_instance: スタックセットのインスタンス（デプロイ先）
#   - aws_iam_role: 管理者ロール・実行ロールの定義
#   - aws_organizations_organization: SERVICE_MANAGED権限モデル使用時
#
# 公式ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudformation_stack_set
#   https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html
#-------------------------------------------------------------------------------------------------------

resource "aws_cloudformation_stack_set" "example" {
  #-------------------------------------------------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: スタックセット名（アカウント・リージョン内で一意）
  # 設定可能な値: 英数字とハイフン、先頭は英字、最大128文字
  name = "my-stack-set"

  # 設定内容: スタックセットの説明
  # 省略時: 説明なし
  description = "Multi-account VPC deployment stack set"

  #-------------------------------------------------------------------------------------------------------
  # テンプレート設定
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: CloudFormationテンプレート本体（JSON/YAML形式の文字列）
  # 設定可能な値: 最大51,200バイト
  # 省略時: template_urlを使用する場合は省略可
  # 注意: template_urlと排他的（どちらか一方のみ指定）
  template_body = jsonencode({
    Parameters = {
      VPCCidr = {
        Type        = "String"
        Default     = "10.0.0.0/16"
        Description = "VPC CIDR block"
      }
    }
    Resources = {
      MyVPC = {
        Type = "AWS::EC2::VPC"
        Properties = {
          CidrBlock = { Ref = "VPCCidr" }
          Tags = [
            {
              Key   = "Name"
              Value = "StackSet-VPC"
            }
          ]
        }
      }
    }
  })

  # 設定内容: S3に配置したテンプレートファイルのURL
  # 設定可能な値: S3バケットURL、最大460,800バイト
  # 省略時: template_bodyを使用する場合は省略可
  # 注意: template_bodyと排他的（どちらか一方のみ指定）
  template_url = null

  # 設定内容: テンプレートパラメータの値（キー・バリューマップ）
  # 省略時: パラメータなし
  # 注意: Defaultを持つパラメータも含め、全て明示的に設定するか、lifecycle.ignore_changesで無視すること
  # 注意: NoEchoパラメータは必ずlifecycle.ignore_changesで無視すること
  parameters = {
    VPCCidr = "10.1.0.0/16"
  }

  #-------------------------------------------------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: IAM権限モデルの種類
  # 設定可能な値: SELF_MANAGED（デフォルト、手動管理）、SERVICE_MANAGED（AWS Organizations連携）
  # 省略時: SELF_MANAGED
  permission_model = "SELF_MANAGED"

  # 設定内容: 管理者アカウントのIAMロールARN
  # 省略時: なし
  # 注意: SELF_MANAGED権限モデルの場合は必須
  # 注意: SERVICE_MANAGED権限モデルの場合は指定不可
  administration_role_arn = "arn:aws:iam::123456789012:role/AWSCloudFormationStackSetAdministrationRole"

  # 設定内容: ターゲットアカウントのIAM実行ロール名
  # 設定可能な値: IAMロール名
  # 省略時: SELF_MANAGEDの場合はAWSCloudFormationStackSetExecutionRole
  # 注意: SELF_MANAGED権限モデルでのみ使用
  # 注意: SERVICE_MANAGED権限モデルの場合は指定しないこと
  execution_role_name = "AWSCloudFormationStackSetExecutionRole"

  # 設定内容: 呼び出し元の権限種別
  # 設定可能な値: SELF（デフォルト、管理アカウント）、DELEGATED_ADMIN（委任管理者）
  # 省略時: SELF
  # 注意: DELEGATED_ADMIN使用時はorganizations:ListDelegatedAdministrators権限が必要
  call_as = "SELF"

  #-------------------------------------------------------------------------------------------------------
  # 機能設定
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: テンプレートで必要なIAM機能の宣言
  # 設定可能な値: CAPABILITY_IAM、CAPABILITY_NAMED_IAM、CAPABILITY_AUTO_EXPAND
  # 省略時: 機能宣言なし
  # 注意: IAMリソースを作成する場合は必須
  capabilities = ["CAPABILITY_IAM"]

  #-------------------------------------------------------------------------------------------------------
  # 自動デプロイ設定（SERVICE_MANAGEDモードのみ）
  #-------------------------------------------------------------------------------------------------------
  # auto_deployment {
  #   # 設定内容: 自動デプロイの有効化
  #   # 設定可能な値: true、false
  #   # 省略時: false
  #   # 注意: SERVICE_MANAGED権限モデルでのみ使用可能
  #   enabled = true
  #
  #   # 設定内容: アカウント削除時のスタック保持
  #   # 設定可能な値: true（保持）、false（削除）
  #   # 省略時: false
  #   retain_stacks_on_account_removal = false
  # }

  #-------------------------------------------------------------------------------------------------------
  # 実行管理設定
  #-------------------------------------------------------------------------------------------------------
  # managed_execution {
  #   # 設定内容: 非競合操作の同時実行と競合操作のキューイング
  #   # 設定可能な値: true（有効）、false（無効）
  #   # 省略時: false
  #   # 注意: trueの場合、非競合操作は同時実行され、競合操作はキューに入る
  #   active = false
  # }

  #-------------------------------------------------------------------------------------------------------
  # 操作設定
  #-------------------------------------------------------------------------------------------------------
  # operation_preferences {
  #   # 設定内容: リージョンごとの許容失敗アカウント数
  #   # 設定可能な値: 0以上の整数
  #   # 省略時: なし
  #   # 注意: failure_tolerance_percentageと排他的
  #   # failure_tolerance_count = 1
  #
  #   # 設定内容: リージョンごとの許容失敗アカウント割合（%）
  #   # 設定可能な値: 0〜100
  #   # 省略時: なし
  #   # 注意: failure_tolerance_countと排他的
  #   # failure_tolerance_percentage = 10
  #
  #   # 設定内容: 同時実行する最大アカウント数
  #   # 設定可能な値: 1以上の整数
  #   # 省略時: なし
  #   # 注意: max_concurrent_percentageと排他的
  #   # max_concurrent_count = 5
  #
  #   # 設定内容: 同時実行する最大アカウント割合（%）
  #   # 設定可能な値: 1〜100
  #   # 省略時: なし
  #   # 注意: max_concurrent_countと排他的
  #   # max_concurrent_percentage = 20
  #
  #   # 設定内容: リージョン間デプロイの同時実行モード
  #   # 設定可能な値: SEQUENTIAL（順次）、PARALLEL（並列）
  #   # 省略時: SEQUENTIAL
  #   # region_concurrency_type = "SEQUENTIAL"
  #
  #   # 設定内容: スタック操作を実行するリージョンの順序
  #   # 設定可能な値: リージョンコードのリスト
  #   # 省略時: なし
  #   # region_order = ["us-east-1", "eu-west-1", "ap-northeast-1"]
  # }

  #-------------------------------------------------------------------------------------------------------
  # リソース配置設定
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"

  #-------------------------------------------------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: スタックセットとそこから作成されるスタックに適用するタグ
  # 省略時: タグなし
  # 注意: 最大50個まで設定可能
  # 注意: サポートされているリソースにはタグが伝播される
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "multi-account-vpc"
  }

  #-------------------------------------------------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------------------------------------------------
  # timeouts {
  #   # 設定内容: 更新操作のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトタイムアウト
  #   update = "30m"
  # }

  #-------------------------------------------------------------------------------------------------------
  # ライフサイクル管理
  #-------------------------------------------------------------------------------------------------------
  # lifecycle {
  #   # NoEchoパラメータやDefaultパラメータを持つ場合の設定例
  #   ignore_changes = [
  #     parameters["SensitiveParam"],  # NoEchoパラメータは必ず無視
  #   ]
  # }
}

#-------------------------------------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-------------------------------------------------------------------------------------------------------
# arn              - スタックセットのARN
# id               - スタックセット名（nameと同じ）
# stack_set_id     - スタックセットの一意識別子
# tags_all         - プロバイダーdefault_tags含む全てのタグ

#-------------------------------------------------------------------------------------------------------
# Outputs（出力例）
#-------------------------------------------------------------------------------------------------------
# output "stack_set_arn" {
#   description = "スタックセットのARN"
#   value       = aws_cloudformation_stack_set.example.arn
# }
#
# output "stack_set_id" {
#   description = "スタックセットの一意識別子"
#   value       = aws_cloudformation_stack_set.example.stack_set_id
# }
#
# output "stack_set_name" {
#   description = "スタックセット名（IDと同じ）"
#   value       = aws_cloudformation_stack_set.example.id
# }
#
# output "stack_set_tags_all" {
#   description = "プロバイダーのdefault_tagsを含む全てのタグ"
#   value       = aws_cloudformation_stack_set.example.tags_all
# }
