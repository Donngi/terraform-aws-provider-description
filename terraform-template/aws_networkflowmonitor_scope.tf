#---------------------------------------------------------------
# Network Flow Monitor Scope
#---------------------------------------------------------------
#
# Amazon CloudWatch Network Flow Monitorのスコープを管理する。
# スコープは、ネットワークパフォーマンスを監視する対象のアカウントや
# リージョンを定義する。Network Flow Monitorは、EC2インスタンスや
# EKSノードにインストールされたエージェントからTCP接続のメトリクスを
# 収集し、パケットロスやレイテンシなどのネットワークパフォーマンス
# データをリアルタイムで可視化する。
#
# AWS公式ドキュメント:
#   - Using Network Flow Monitor: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-NetworkFlowMonitor.html
#   - Components and features: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-NetworkFlowMonitor-components.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkflowmonitor_scope
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkflowmonitor_scope" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # region (任意)
  # スコープを管理するAWSリージョン。
  # 指定しない場合はプロバイダー設定のリージョンが使用される。
  # 例: "us-east-1", "ap-northeast-1"
  region = null

  #---------------------------------------------------------------
  # ターゲット設定
  #---------------------------------------------------------------

  # target (必須)
  # 監視対象を定義するブロック。複数指定可能。
  # 現在はリージョンとアカウントIDのペアを指定する。
  target {
    # region (必須)
    # 監視対象のAWSリージョン。
    # スコープ内でネットワークフローを監視するリージョンを指定する。
    # 例: "us-east-1", "ap-northeast-1", "eu-west-1"
    region = null # Required

    # target_identifier (必須)
    # 監視対象を識別する情報。
    target_identifier {
      # target_type (必須)
      # ターゲットの種類。現在は "ACCOUNT" のみサポート。
      # 将来的に他のターゲットタイプが追加される可能性がある。
      # 有効な値: "ACCOUNT"
      target_type = "ACCOUNT" # Required

      # target_id (必須)
      # ターゲットの識別子。
      target_id {
        # account_id (必須)
        # 監視対象のAWSアカウントID。
        # 12桁のAWSアカウントIDを指定する。
        # 例: "123456789012"
        # data.aws_caller_identity.current.account_id を使用して
        # 現在のアカウントIDを動的に取得することも可能。
        account_id = null # Required
      }
    }
  }

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (任意)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはここで指定した値で上書きされる。
  # タグはリソースの識別、コスト管理、アクセス制御などに使用できる。
  tags = {
    Name        = "example-scope"
    Environment = "dev"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts (任意)
  # 操作のタイムアウト時間を設定する。
  # 値は "30s"（30秒）、"5m"（5分）、"2h45m"（2時間45分）のような
  # 期間文字列として指定する。
  timeouts {
    # create (任意)
    # リソース作成時のタイムアウト。
    # デフォルト値はプロバイダーにより設定される。
    create = null

    # update (任意)
    # リソース更新時のタイムアウト。
    # デフォルト値はプロバイダーにより設定される。
    update = null

    # delete (任意)
    # リソース削除時のタイムアウト。
    # デフォルト値はプロバイダーにより設定される。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、
# 他のリソースから参照可能。設定ファイルで直接指定することはできない。
#
# scope_arn
#   スコープのAmazon Resource Name (ARN)。
#   例: "arn:aws:networkflowmonitor:us-east-1:123456789012:scope/scope-12345678"
#
# scope_id
#   スコープの一意識別子。Network Flow Monitorによって自動生成される。
#   例: "scope-12345678"
#
# tags_all
#   リソースに割り当てられた全てのタグ（プロバイダーレベルの
#   default_tags で設定されたタグを含む）。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 現在のアカウントを監視対象にする基本的な構成
#
# data "aws_caller_identity" "current" {}
#
# resource "aws_networkflowmonitor_scope" "example" {
#   target {
#     region = "us-east-1"
#     target_identifier {
#       target_type = "ACCOUNT"
#       target_id {
#         account_id = data.aws_caller_identity.current.account_id
#       }
#     }
#   }
#
#   tags = {
#     Name = "example-scope"
#   }
# }

# 例2: 複数のリージョンを監視対象にする構成
#
# data "aws_caller_identity" "current" {}
#
# resource "aws_networkflowmonitor_scope" "multi_region" {
#   target {
#     region = "us-east-1"
#     target_identifier {
#       target_type = "ACCOUNT"
#       target_id {
#         account_id = data.aws_caller_identity.current.account_id
#       }
#     }
#   }
#
#   target {
#     region = "us-west-2"
#     target_identifier {
#       target_type = "ACCOUNT"
#       target_id {
#         account_id = data.aws_caller_identity.current.account_id
#       }
#     }
#   }
#
#   tags = {
#     Name        = "multi-region-scope"
#     Environment = "production"
#   }
# }
