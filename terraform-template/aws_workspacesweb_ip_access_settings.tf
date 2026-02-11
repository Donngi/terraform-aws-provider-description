#---------------------------------------------------------------
# AWS WorkSpaces Secure Browser IP Access Settings
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browser の IP アクセス設定をプロビジョニングするリソースです。
# IP アクセス設定は Web ポータルに関連付けると、ユーザーが接続できる IP アドレスを
# 制御する仮想ファイアウォールとして機能します。信頼された IP アドレスのみからの
# アクセスを許可することで、セキュリティを強化できます。
#
# AWS公式ドキュメント:
#   - WorkSpaces Secure Browser IP アクセスコントロール: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/ip-access-controls.html
#   - WorkSpaces Secure Browser 概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/what-is-workspaces-web.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_ip_access_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_ip_access_settings" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required)
  # 設定内容: IP アクセス設定の表示名を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: AWS コンソールや API レスポンスで識別するための名前
  display_name = "example-ip-access-settings"

  # description (Optional)
  # 設定内容: IP アクセス設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 用途: IP アクセス設定の目的や用途を記録するために使用
  description = "Example IP access settings for main office and branch office"

  #-------------------------------------------------------------
  # IP ルール設定
  #-------------------------------------------------------------

  # ip_rule (Required)
  # 設定内容: 許可する IP アドレス範囲のルールを定義します。
  # 複数の ip_rule ブロックを指定可能です。
  # 関連機能: WorkSpaces Secure Browser IP アクセスコントロール
  #   IP アクセス設定は仮想ファイアウォールとして機能し、信頼された IP アドレスを
  #   フィルタリングします。WorkSpaces Secure Browser は認証前にユーザーの IP アドレスを
  #   検出してアクセス可否を判定し、セッション中も継続的に監視します。
  #   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/ip-access-controls.html
  # 注意: IPv4 のみサポート。IPv6 専用ネットワークからの接続はブロックされます。

  # メインオフィスからのアクセスを許可
  ip_rule {
    # ip_range (Required)
    # 設定内容: 許可する IP アドレス範囲を CIDR 表記で指定します。
    # 設定可能な値: 有効な IPv4 CIDR ブロック (例: "10.0.0.0/16", "192.168.1.0/24")
    # 注意: NAT ゲートウェイや VPN のパブリック IP アドレスを指定することも可能
    ip_range = "10.0.0.0/16"

    # description (Optional)
    # 設定内容: IP ルールの説明を指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: 説明なし
    # 用途: このルールがどのネットワークを許可するかを記録
    description = "Main office"
  }

  # ブランチオフィスからのアクセスを許可
  ip_rule {
    ip_range    = "192.168.0.0/24"
    description = "Branch office"
  }

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_managed_key (Optional)
  # 設定内容: カスタマー管理の KMS キーの ARN を指定します。
  # 設定可能な値: 有効な KMS キー ARN
  # 省略時: AWS マネージドキーが使用されます
  # 関連機能: AWS KMS カスタマー管理キー
  #   IP アクセス設定のデータを暗号化するために使用します。
  #   カスタマー管理キーを使用することで、暗号化キーのライフサイクルを制御できます。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#customer-cmk
  # 注意: additional_encryption_context と組み合わせて使用可能
  customer_managed_key = null

  # additional_encryption_context (Optional)
  # 設定内容: 追加の暗号化コンテキストを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: 追加の暗号化コンテキストなし
  # 関連機能: AWS KMS 暗号化コンテキスト
  #   暗号化コンテキストは、暗号化操作に関連付けられる追加の認証データです。
  #   同じ暗号化コンテキストを復号化時に提供する必要があります。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#encrypt_context
  # 注意: customer_managed_key が指定されている場合のみ有効
  additional_encryption_context = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-ip-access-settings"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - ip_access_settings_arn: IP アクセス設定リソースの ARN
#
# - associated_portal_arns: この IP アクセス設定リソースに関連付けられている
#                           Web ポータルの ARN リスト
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
