#---------------------------------------------------------------
# AWS WAF Regional IP Set
#---------------------------------------------------------------
#
# AWS WAF Regional IPセットをプロビジョニングするリソースです。
# Application Load Balancer (ALB) で使用するWAF Regional用のIPセットを定義し、
# ウェブリクエストの送信元IPアドレスに基づいてトラフィックを許可またはブロックする
# ルールを作成するために使用します。
#
# AWS公式ドキュメント:
#   - IP set管理: https://docs.aws.amazon.com/waf/latest/developerguide/waf-ip-set-managing.html
#   - IPSetDescriptor API: https://docs.aws.amazon.com/waf/latest/APIReference/API_wafRegional_IPSetDescriptor.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_ipset
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_ipset" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: IPセットの名前または説明を指定します。
  # 設定可能な値: 文字列
  # 注意: この値はAWSコンソールやAPIで識別するために使用されます。
  name = "my-ipset"

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
  # IPアドレス設定
  #-------------------------------------------------------------

  # ip_set_descriptor (Optional)
  # 設定内容: IPアドレスの種類とIPアドレス範囲を指定するブロックです。
  # ウェブリクエストの送信元IPアドレスに基づいてトラフィックを制御するために使用します。
  # 関連機能: WAF IP Set
  #   IPセットはIPアドレスとIPアドレス範囲のコレクションで、
  #   ルールステートメントで使用してトラフィックを許可またはブロックします。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/waf-ip-set-managing.html
  # 注意: 複数のip_set_descriptorブロックを指定可能です。

  ip_set_descriptor {
    # type (Required)
    # 設定内容: IPアドレスの種類を指定します。
    # 設定可能な値:
    #   - "IPV4": IPv4アドレス
    #   - "IPV6": IPv6アドレス
    type = "IPV4"

    # value (Required)
    # 設定内容: IPアドレスまたはIPアドレス範囲をCIDR表記で指定します。
    # 設定可能な値:
    #   - IPv4の例: "192.0.2.44/32" (単一アドレス), "192.0.2.0/24" (アドレス範囲)
    #   - IPv6の例: "1111:0000:0000:0000:0000:0000:0000:0111/128" (単一アドレス)
    # 注意: 値の長さは1〜50文字
    value = "192.0.7.0/24"
  }

  # 複数のIPアドレス範囲を指定する例
  ip_set_descriptor {
    type  = "IPV4"
    value = "10.16.16.0/16"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF IPセットのID
#
# - arn: WAF IPセットのAmazon Resource Name (ARN)
#---------------------------------------------------------------
