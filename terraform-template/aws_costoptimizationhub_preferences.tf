# ================================================================================
# Terraform AWS Resource Template: aws_costoptimizationhub_preferences
# ================================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/costoptimizationhub_preferences
# ================================================================================

# AWS Cost Optimization Hub Preferencesの管理
# Cost Optimization Hubの設定を管理するためのリソース
# アカウントレベルのプリファレンスを設定し、コスト最適化の推奨事項の表示方法をカスタマイズします
resource "aws_costoptimizationhub_preferences" "example" {
  # ================================================================================
  # メンバーアカウントの割引可視性設定
  # ================================================================================

  # member_account_discount_visibility - (オプション) メンバーアカウントが「割引後」の節約見積もりを確認できるかどうかをカスタマイズ
  # タイプ: string
  # 有効な値:
  #   - "All"  - すべてのメンバーアカウントが割引後の節約見積もりを確認可能（デフォルト）
  #   - "None" - メンバーアカウントは割引後の節約見積もりを確認不可
  # デフォルト: "All"
  # AWS公式ドキュメント:
  # - https://docs.aws.amazon.com/cost-management/latest/userguide/coh-preferences.html
  # - https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_CostOptimizationHub_UpdatePreferences.html
  member_account_discount_visibility = "All"

  # ================================================================================
  # 節約見積もりモード設定
  # ================================================================================

  # savings_estimation_mode - (オプション) 月間推定節約額の計算方法をカスタマイズ
  # タイプ: string
  # 有効な値:
  #   - "BeforeDiscounts" - AWSの公開（オンデマンド）価格を使用し、割引を適用せずに節約額を見積もり（デフォルト）
  #   - "AfterDiscounts"  - リザーブドインスタンスやSavings Plansなど、すべてのAWS割引を考慮して節約額を見積もり
  # デフォルト: "BeforeDiscounts"
  #
  # 重要な注意事項:
  # - 請求移管（billing transfer）を請求元アカウントとして使用している場合、
  #   "AfterDiscounts"機能は無効化され、有効にすることができません
  # - 請求元アカウントは、最適化の決定を行う前に、未使用のコミットメントを考慮するために
  #   リザーブドインスタンスとSavings Plansのインベントリに対して
  #   ライトサイジング推奨事項を検証する必要があります
  #
  # AWS公式ドキュメント:
  # - https://docs.aws.amazon.com/cost-management/latest/userguide/coh-preferences.html
  # - https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_CostOptimizationHub_UpdatePreferences.html
  savings_estimation_mode = "BeforeDiscounts"

  # ================================================================================
  # 補足情報
  # ================================================================================
  #
  # このリソースについて:
  # - アカウント全体のプリファレンスを管理するため、リソースIDは12桁のAWSアカウントIDになります
  # - プリファレンスの変更はCost Optimization Hubダッシュボードに24時間以内に反映されます
  # - このリソースはCost Optimization Hubの設定のみを管理します
  #   (コミットメント設定は別途preferred_commitment APIで管理可能)
  #
  # 関連するAWSサービス:
  # - AWS Cost Optimization Hub
  # - AWS Cost Explorer
  # - AWS Compute Optimizer
  #
  # AWS公式ドキュメント:
  # - Cost Optimization Hub概要: https://docs.aws.amazon.com/cost-management/latest/userguide/what-is-cost-optimization-hub.html
  # - プリファレンスのカスタマイズ: https://docs.aws.amazon.com/cost-management/latest/userguide/coh-preferences.html
  # - API Reference (GetPreferences): https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_CostOptimizationHub_GetPreferences.html
  # - API Reference (UpdatePreferences): https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_CostOptimizationHub_UpdatePreferences.html
}
