#---------------------------------------------------------------
# Amazon Detective Organization Configuration
#---------------------------------------------------------------
#
# AWS Organizationsと統合されたAmazon Detective環境において、組織全体の
# 動作グラフ(behavior graph)の自動有効化設定を管理するリソースです。
# Detective委任管理者アカウントで、新規に追加される組織アカウントを
# Detectiveメンバーアカウントとして自動的に有効化する設定を行います。
#
# AWS公式ドキュメント:
#   - Detective Organizations統合: https://docs.aws.amazon.com/detective/latest/userguide/accounts-orgs-transition.html
#   - 新規アカウント自動有効化: https://docs.aws.amazon.com/detective/latest/userguide/accounts-orgs-members-autoenable.html
#   - Detectiveとは: https://docs.aws.amazon.com/detective/latest/userguide/what-is-detective.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/detective_organization_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_detective_organization_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # auto_enable (Required)
  # 設定内容: 組織に追加された新規アカウントを自動的にDetectiveメンバーアカウントとして有効化するかを指定します。
  # 設定可能な値:
  #   - true: 新規アカウントを自動的に有効化
  #   - false: 新規アカウントは手動で有効化する必要がある
  # 動作:
  #   trueに設定すると、組織に作成または追加された全ての新規アカウントが、
  #   Detective委任管理者の動作グラフのメンバーアカウントとして自動追加され、
  #   そのリージョンでDetectiveが有効化されます。
  # 注意:
  #   - 既存の組織アカウントには影響しません（新規追加のみ対象）
  #   - 既存アカウントは手動で有効化する必要があります
  #   - デフォルトでは新規アカウントのステータスは "Not a member" です
  #   - 動作グラフの最大メンバーアカウント数は1,200です
  #   - この制限に達すると新規アカウントは有効化できません
  # 推奨設定:
  #   セキュリティの可視性を最大化するため、通常はtrueを推奨します。
  # 関連機能: Detective自動有効化
  #   - https://docs.aws.amazon.com/detective/latest/userguide/accounts-orgs-members-autoenable.html
  auto_enable = true

  # graph_arn (Required)
  # 設定内容: この組織設定を適用するDetectiveの動作グラフARNを指定します。
  # 設定可能な値: 有効なDetective動作グラフのARN
  # ARN形式: arn:aws:detective:region:account-id:graph:graph-id
  # 注意:
  #   - aws_detective_graphリソースで事前に動作グラフを作成する必要があります
  #   - 委任管理者アカウントで実行する必要があります
  #   - リージョンごとに動作グラフが必要です
  #   - 変更すると既存設定がリセットされる可能性があります
  # 前提条件:
  #   - Detective委任管理者アカウントが設定されていること
  #     (aws_detective_organization_admin_accountリソース経由)
  #   - 動作グラフが作成済みであること
  # 参考: https://docs.aws.amazon.com/detective/latest/userguide/graph-data-structure-overview.html
  graph_arn = aws_detective_graph.example.graph_arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このDetective組織設定を管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - Computed属性のため、指定しなくても値が設定されます
  #   - リージョン変更は新規リソースの作成を引き起こします
  #   - 各リージョンで個別に設定が必要です（グローバル設定ではありません）
  #   - graph_arnのリージョンと一致させる必要があります
  # マルチリージョン展開:
  #   複数リージョンでDetectiveを有効化する場合は、各リージョンで
  #   個別の動作グラフと組織設定を作成する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Detective動作グラフの識別子
#       グラフARNから派生したユニークなIDです
#
# - region: 管理リージョン (Computed)
#           このリソースが管理されているAWSリージョン
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# このリソースは高度なTerraformリソースです。
# Terraformはインポート無しで自動的に管理を開始します。
#
# もし必要であれば、以下のコマンドでインポート可能です:
#
# terraform import aws_detective_organization_configuration.example graph_arn
#
# 例:
# terraform import aws_detective_organization_configuration.example \
#   arn:aws:detective:us-east-1:123456789012:graph:abcdef123456
#---------------------------------------------------------------
