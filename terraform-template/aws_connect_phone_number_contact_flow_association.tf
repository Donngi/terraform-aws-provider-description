################################################################################
# Amazon Connect 電話番号コンタクトフロー関連付け
################################################################################
# Amazon Connect の電話番号に特定のコンタクトフローを関連付けるリソース。
# 着信時に実行されるコンタクトフロー（IVR、ルーティングロジック等）を
# 電話番号と紐付けて、発信者の対応フローを制御します。
#
# 主な用途:
# - 電話番号ごとの着信時コンタクトフロー設定
# - 複数番号への異なるフロー割り当て
# - コールセンターのルーティング制御
#
# 注意事項:
# - 電話番号は事前にAmazon Connectインスタンスに登録が必要
# - コンタクトフローも同一インスタンス内に存在する必要がある
# - 1つの電話番号には1つのコンタクトフローのみ関連付け可能
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_phone_number_contact_flow_association
# AWS ドキュメント: https://docs.aws.amazon.com/connect/latest/adminguide/contact-flows.html
# NOTE: このテンプレートは参考例です。環境に応じて適切な値に置き換えてください。

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_connect_phone_number_contact_flow_association" "example" {
  # インスタンス識別子
  # 設定内容: Amazon Connect インスタンスのID
  # 形式: UUID形式（xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx）
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # 電話番号識別子
  # 設定内容: 関連付ける電話番号のID
  # 形式: UUID形式
  # 補足: aws_connect_phone_numberリソースで取得した電話番号のID
  phone_number_id = "pppppppp-nnnn-nnnn-nnnn-111111111111"

  # コンタクトフロー識別子
  # 設定内容: 電話番号に関連付けるコンタクトフローのID
  # 形式: UUID形式
  # 補足: aws_connect_contact_flowリソースで作成したフローのID
  contact_flow_id = "cccccccc-ffff-llll-oooo-111111111111"

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # リージョン指定（オプション）
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-west-2"
}

################################################################################
# Attributes Reference
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - instance_id       : Amazon Connect インスタンスID
# - phone_number_id   : 電話番号ID
# - contact_flow_id   : コンタクトフローID
# - region            : リソースが管理されているリージョン
