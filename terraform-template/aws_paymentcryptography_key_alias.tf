#---------------------------------------------------------------
# AWS Payment Cryptography Key Alias
#---------------------------------------------------------------
#
# AWS Payment Cryptography のキーエイリアスをプロビジョニングするリソースです。
# エイリアスはキーのARNの代わりにアプリケーションコードで使用できるフレンドリーな名前です。
# エイリアスを使用することで、コードを変更せずに関連付けるキーを切り替えられます。
# 各エイリアスはアカウントとリージョン内で一意ですが、同一エイリアス名を複数の
# リージョンで使用することで、マルチリージョンアプリケーションの管理が容易になります。
#
# AWS公式ドキュメント:
#   - エイリアスの概要: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/alias-about.html
#   - エイリアスの使用: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/alias-using.html
#   - CreateAlias APIリファレンス: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_CreateAlias.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/paymentcryptography_key_alias
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_paymentcryptography_key_alias" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # alias_name (Required)
  # 設定内容: キーエイリアスの名前を指定します。
  # 設定可能な値: "alias/" で始まる文字列。英数字、スラッシュ、アンダースコア、ハイフンのみ使用可能
  # 注意: 個人情報・機密情報・センシティブな情報を含めないこと。
  #       CloudTrail ログや他の出力にプレーンテキストで表示される可能性があります。
  #       エイリアス名はアカウントおよびリージョン内で一意である必要があります。
  # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_Alias.html
  alias_name = "alias/my-payment-key"

  #-------------------------------------------------------------
  # キー関連付け設定
  #-------------------------------------------------------------

  # key_arn (Optional)
  # 設定内容: エイリアスに関連付けるキーの ARN を指定します。
  # 設定可能な値: 有効な AWS Payment Cryptography キーの ARN
  # 省略時: キーと関連付けられていないエイリアスが作成されます
  # 注意: 1 つのエイリアスに関連付けられるキーは同時に 1 つのみです。
  #       キーの関連付けを変更するには UpdateAlias 操作を使用します。
  #       1 つのキーには複数のエイリアスを関連付けることができます。
  # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-managealias.html
  key_arn = "arn:aws:payment-cryptography:ap-northeast-1:123456789012:key/kwapwa6qaifllw2m"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: キーエイリアスの識別子（alias_name と同一）
#---------------------------------------------------------------
