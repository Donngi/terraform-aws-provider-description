#---------------------------------------------------------------
# Amazon SES Receipt Filter (受信フィルター)
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) の受信フィルターをプロビジョニングするリソースです。
# 受信フィルターは、特定のIPアドレスまたはCIDRブロックからのメール受信を
# 許可またはブロックするIPベースのフィルタリング機能です。
#
# 主な機能:
#   - 特定のIPアドレスやCIDRブロックからのメールをブロック
#   - 特定のIPアドレスやCIDRブロックからのメールを許可（他をブロック）
#   - スパムや不正なメール送信元のブロック
#
# 注意事項:
#   - 受信フィルターはアカウントレベルで適用されます
#   - SESのメール受信は特定のリージョン（us-east-1、us-west-2、eu-west-1）でのみサポート
#   - フィルターはすべての受信メールに対して評価されます
#
# AWS公式ドキュメント:
#   - SES受信フィルターの概要: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-ip-filters.html
#   - SES受信フィルターの作成: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-ip-filters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_filter
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_receipt_filter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: 受信フィルターの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列（最大64文字）
  # 注意: この属性を変更すると、リソースが再作成されます（Forces new resource）
  # 関連機能: SES受信フィルター識別子
  #   複数の受信フィルターを管理する際に各フィルターを識別するための一意の名前。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-ip-filters.html
  name = "block-spam-sender"

  #-------------------------------------------------------------
  # IPアドレス / CIDRブロック設定
  #-------------------------------------------------------------

  # cidr (Required, Forces new resource)
  # 設定内容: フィルタリング対象のIPアドレスまたはCIDRブロックを指定します。
  # 設定可能な値:
  #   - 単一IPアドレス: "10.0.0.1"
  #   - CIDRブロック: "10.0.0.0/8"
  # 注意: IPv4アドレスまたはCIDRブロックのみサポート（IPv6は非対応）
  # 注意: この属性を変更すると、リソースが再作成されます（Forces new resource）
  # 関連機能: IP受信フィルタリング
  #   指定したIPアドレス範囲からのメールに対してポリシーを適用します。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-ip-filters.html
  cidr = "10.0.0.0/8"

  #-------------------------------------------------------------
  # フィルタリングポリシー設定
  #-------------------------------------------------------------

  # policy (Required, Forces new resource)
  # 設定内容: 指定したIPアドレス/CIDRブロックからのメールに対する処理ポリシーを指定します。
  # 設定可能な値:
  #   - "Block": 指定したIPアドレス/CIDRブロックからのメールを拒否
  #   - "Allow": 指定したIPアドレス/CIDRブロックからのメールを許可
  # 注意: この属性を変更すると、リソースが再作成されます（Forces new resource）
  # 用途:
  #   Block - スパム送信元や不正なIPアドレスからのメールを遮断する場合に使用
  #   Allow - ホワイトリストとして特定のIPからのメールを明示的に許可する場合に使用
  # 関連機能: SES受信フィルターポリシー
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-ip-filters.html
  policy = "Block"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: SESメール受信をサポートするAWSリージョンコード
  #   （例: us-east-1, us-west-2, eu-west-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: SESのメール受信機能は一部のリージョンでのみ利用可能です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SES受信フィルターのAmazon Resource Name (ARN)
#        形式: arn:aws:ses:region:account-id:receipt-filter/filter-name
#
# - id: SES受信フィルターの名前（nameと同じ値）
#---------------------------------------------------------------
