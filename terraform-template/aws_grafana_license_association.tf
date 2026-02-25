#---------------------------------------------------------------
# Amazon Managed Grafana ライセンス関連付け
#---------------------------------------------------------------
#
# Amazon Managed GrafanaワークスペースにGrafana Labsのライセンスを
# 関連付けるリソースです。Enterpriseプランまたは無料トライアルを
# 有効化することで、Grafana Enterpriseの高度な機能（アクセス制御の
# 強化、カスタムブランディング、高度な認証など）を利用できます。
#
# AWS公式ドキュメント:
#   - Amazon Managed Grafana のライセンス: https://docs.aws.amazon.com/grafana/latest/userguide/upgrade-to-grafana-enterprise.html
#   - AssociateLicense API: https://docs.aws.amazon.com/grafana/latest/APIReference/API_AssociateLicense.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_license_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_license_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # workspace_id (Required)
  # 設定内容: ライセンスを関連付けるAmazon Managed Grafanaワークスペースのidを指定します。
  # 設定可能な値: 有効なGrafanaワークスペースID（例: g-1234567890）
  workspace_id = aws_grafana_workspace.example.id

  # license_type (Required)
  # 設定内容: ワークスペースに関連付けるライセンスの種類を指定します。
  # 設定可能な値:
  #   - "ENTERPRISE"            - Grafana Enterprise本番ライセンス（有効期間はlicense_expirationで確認可能）
  #   - "ENTERPRISE_FREE_TRIAL" - Grafana Enterpriseの無料トライアル（有効期間はfree_trial_expirationで確認可能）
  license_type = "ENTERPRISE_FREE_TRIAL"

  #-------------------------------------------------------------
  # Grafana Labsトークン設定
  #-------------------------------------------------------------

  # grafana_token (Optional)
  # 設定内容: AWSアカウントとGrafana Labsアカウントを紐付けるトークンを指定します。
  # 設定可能な値: Grafana Labsが発行するトークン文字列
  # 省略時: トークンなしでライセンスが関連付けられます（ENTERPRISE_FREE_TRIALでは不要な場合があります）。
  grafana_token = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: ライセンス関連付けの作成タイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます。
    create = null

    # delete (Optional)
    # 設定内容: ライセンス関連付けの削除タイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（workspace_idと同じ値）
#
# - free_trial_expiration: 無料トライアルの有効期限
#          license_typeが"ENTERPRISE_FREE_TRIAL"の場合に設定されます。
#          ISO 8601形式の日時文字列（例: 2024-12-31T23:59:59Z）
#
# - license_expiration: Enterpriseライセンスの有効期限
#          license_typeが"ENTERPRISE"の場合に設定されます。
#          ISO 8601形式の日時文字列（例: 2025-12-31T23:59:59Z）
#---------------------------------------------------------------
