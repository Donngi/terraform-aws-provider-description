#---------------------------------------------------------------
# AWS Savings Plans - Savings Plan
#---------------------------------------------------------------
#
# AWS Savings Planをプロビジョニングするリソースです。
# Savings Planは、1年または3年の期間で一定のコンピューティング使用量をコミットすることで、
# オンデマンド料金から最大72%の割引を受けられる料金モデルです。
# Compute、EC2 Instance、Database、SageMaker AIの4種類のプランが提供されています。
#
# 警告: Savings Planは財務上のコミットメントです。アクティブになったプランは
#       キャンセルや削除ができません。queued状態（将来の購入予約）のプランのみ
#       削除可能です。このリソースは慎重に使用してください。
#
# AWS公式ドキュメント:
#   - Savings Plans概要: https://docs.aws.amazon.com/savingsplans/latest/userguide/what-is-savings-plans.html
#   - Savings Planの種類: https://docs.aws.amazon.com/savingsplans/latest/userguide/plan-types.html
#   - Savings Planの購入: https://docs.aws.amazon.com/savingsplans/latest/userguide/purchase-sp-direct.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/savingsplans_savings_plan
#
# Provider Version: 6.37.0
# Generated: 2026-03-20
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_savingsplans_savings_plan" "example" {
  #-------------------------------------------------------------
  # プラン基本設定
  #-------------------------------------------------------------

  # savings_plan_offering_id (Required)
  # 設定内容: Savings PlanオファリングのIDを指定します。
  # 設定可能な値: 有効なSavings PlanオファリングID（UUID形式）
  # 参考: 利用可能なオファリングは以下のCLIコマンドで確認できます
  #   aws savingsplans describe-savings-plans-offerings
  savings_plan_offering_id = "00000000-0000-0000-0000-000000000000"

  # commitment (Required)
  # 設定内容: 時間あたりのコミットメント金額（USD）を指定します。
  # 設定可能な値: 数値文字列（例: "1.0", "5.0", "10.0"）
  # 注意: 実際の使用量に関わらず、コミットした金額が毎時課金されます
  commitment = "1.0"

  #-------------------------------------------------------------
  # 購入スケジュール設定
  #-------------------------------------------------------------

  # purchase_time (Optional)
  # 設定内容: Savings Planを購入する日時をUTC形式で指定します。
  # 設定可能な値: UTC形式の日時文字列（YYYY-MM-DDTHH:MM:SSZ）
  # 省略時: 即時購入されます
  # 注意: 将来の日時を指定した場合、プランはqueued状態になり、
  #       アクティブになる前であれば削除可能です
  purchase_time = "2026-12-01T00:00:00Z"

  #-------------------------------------------------------------
  # 支払い設定
  #-------------------------------------------------------------

  # upfront_payment_amount (Optional)
  # 設定内容: 前払い金額（USD）を指定します。
  # 設定可能な値: 数値文字列（例: "100.0"）
  # 省略時: オファリングの支払いオプションに応じた金額が適用されます
  # 注意: 支払いオプション（All Upfront / Partial Upfront / No Upfront）は
  #       オファリングIDに紐づいて決定されます
  upfront_payment_amount = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-savings-plan"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    # 注意: 削除操作前にstateへの変更が保存される場合にのみ有効です
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - savings_plan_arn: Savings PlanのARN
# - savings_plan_id: Savings PlanのID
# - state: 現在の状態（active, queued, retired等）
# - start / end: 開始・終了日時（RFC3339形式）
# - savings_plan_type: プランの種類（Compute, EC2Instance等）
# - payment_option: 支払いオプション（All/Partial/No Upfront）
# - currency: 通貨（例: USD）
# - recurring_payment_amount: 定期支払い金額
# - term_duration_in_seconds: 期間（秒）
# - ec2_instance_family: EC2インスタンスファミリー
# - region: AWSリージョン
# - description: プランの説明
# - product_types: 対象プロダクトタイプのリスト
# - returnable_until: 返却可能期限
# - offering_id: オファリングID（非推奨）
# - tags_all: 継承タグを含む全タグマップ
#---------------------------------------------------------------
