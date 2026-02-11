#---------------------------------------------------------------
# Amazon Managed Grafana License Association
#---------------------------------------------------------------
#
# Amazon Managed Grafana ワークスペースに Grafana Enterprise ライセンスを
# 関連付けるためのリソースです。ワークスペースをアップグレードして
# Enterprise プラグインへのアクセスや Grafana Labs のコンサルティング・
# サポートサービスを利用可能にします。
#
# AWS公式ドキュメント:
#   - AssociateLicense API: https://docs.aws.amazon.com/grafana/latest/APIReference/API_AssociateLicense.html
#   - Managing Enterprise plugins: https://docs.aws.amazon.com/grafana/latest/userguide/AMG-workspace-manage-enterprise.html
#   - Amazon Managed Grafana Pricing: https://aws.amazon.com/grafana/pricing/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_license_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_license_association" "example" {

  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # ライセンスのタイプ
  # ワークスペースに関連付けるライセンスの種類を指定します。
  #
  # 有効な値:
  #   - ENTERPRISE: Grafana Enterprise ライセンス（有料）
  #   - ENTERPRISE_FREE_TRIAL: Enterprise の無料トライアル
  #
  # 注意:
  #   - Amazon Managed Grafana は現在 Enterprise 無料トライアルを
  #     サポートしていません
  #   - ENTERPRISE を指定する場合は grafana_token が必要です
  #   - 追加料金が発生します（アクティブユーザーあたり月額$45）
  license_type = "ENTERPRISE"

  # ワークスペースID
  # ライセンスを関連付ける Amazon Managed Grafana ワークスペースの ID を
  # 指定します。
  #
  # フォーマット: g-[0-9a-f]{10}
  # 例: g-1234567890
  #
  # 注意:
  #   - aws_grafana_workspace リソースから取得する場合は
  #     aws_grafana_workspace.example.id を使用します
  workspace_id = aws_grafana_workspace.example.id

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # Grafana Labs トークン
  # AWS アカウントを Grafana Labs アカウントと紐付けるためのトークンです。
  #
  # 要件:
  #   - 長さ: 1〜36文字
  #   - license_type が ENTERPRISE の場合は必須
  #   - Grafana Labs から取得する有効なトークンを使用
  #
  # 詳細:
  #   アカウントのリンク方法については以下を参照:
  #   https://docs.aws.amazon.com/grafana/latest/userguide/upgrade-to-Grafana-Enterprise.html#AMG-workspace-register-enterprise
  # grafana_token = "your-grafana-labs-token"

  # リソースID
  # Terraform で管理するためのリソース識別子です。
  # 通常は自動生成されるため、明示的な指定は不要です。
  #
  # 注意:
  #   - computed 属性でもあるため、未指定の場合は自動的に設定されます
  #   - インポート時に既存のリソース ID を指定する場合に使用します
  # id = "workspace-id"

  # リージョン
  # このリソースが管理される AWS リージョンを指定します。
  #
  # デフォルト:
  #   プロバイダー設定で指定されたリージョンが使用されます
  #
  # 用途:
  #   - 複数リージョンでリソースを管理する場合
  #   - プロバイダーのデフォルトリージョンと異なるリージョンで
  #     リソースを作成する場合
  #
  # 参考:
  #   - Regional endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # リソース操作のタイムアウト設定
  # API呼び出しが完了するまでの最大待機時間を指定します。
  # timeouts {
  #   # 作成操作のタイムアウト
  #   # ライセンスの関連付けが完了するまでの待機時間
  #   # デフォルト: 10分
  #   create = "10m"
  #
  #   # 削除操作のタイムアウト
  #   # ライセンスの関連付け解除が完了するまでの待機時間
  #   # デフォルト: 10分
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の computed-only 属性をエクスポートします:
#
# - free_trial_expiration
#     無料トライアルの有効期限（Unix タイムスタンプ）
#     license_type が ENTERPRISE_FREE_TRIAL の場合のみ設定されます
#     例: output "trial_expiration" {
#            value = aws_grafana_license_association.example.free_trial_expiration
#          }
#
# - license_expiration
#     Enterprise ライセンスの有効期限（Unix タイムスタンプ）
#     license_type が ENTERPRISE の場合のみ設定されます
#     例: output "license_expiration" {
#            value = aws_grafana_license_association.example.license_expiration
#          }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Examples
#---------------------------------------------------------------
#
# 基本的な構成例:
#
# resource "aws_grafana_license_association" "example" {
#   license_type = "ENTERPRISE_FREE_TRIAL"
#   workspace_id = aws_grafana_workspace.example.id
# }
#
# resource "aws_grafana_workspace" "example" {
#   account_access_type      = "CURRENT_ACCOUNT"
#   authentication_providers = ["SAML"]
#   permission_type          = "SERVICE_MANAGED"
#   role_arn                 = aws_iam_role.assume.arn
# }
#
# resource "aws_iam_role" "assume" {
#   name = "grafana-assume"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "grafana.amazonaws.com"
#         }
#       },
#     ]
#   })
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Important Notes
#---------------------------------------------------------------
#
# 1. ライセンスタイプ:
#    - ENTERPRISE_FREE_TRIAL は現在サポートされていません
#    - ENTERPRISE を使用する場合は Grafana Labs トークンが必要です
#
# 2. 料金:
#    - Enterprise プラグインアクセスには追加料金がかかります
#    - アクティブユーザーあたり月額 $45（2026年1月時点）
#    - 詳細は https://aws.amazon.com/grafana/pricing/ を参照
#
# 3. リソースの削除:
#    - このリソースを削除すると、ワークスペースから Enterprise
#      ライセンスの関連付けが解除されます
#    - Enterprise プラグインへのアクセスは即座に失われます
#
# 4. ワークスペースとの関連:
#    - このリソースは aws_grafana_workspace と併せて使用します
#    - ワークスペースが存在しない場合はエラーになります
#
# 5. トークンの取得:
#    - Grafana Labs トークンは Grafana Labs のアカウントから取得します
#    - トークンの取得方法は AWS ドキュメントを参照してください
#
#---------------------------------------------------------------
