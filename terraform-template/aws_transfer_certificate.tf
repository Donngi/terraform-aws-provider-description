#---------------------------------------------------------------
# AWS Transfer Family AS2 Certificate
#---------------------------------------------------------------
#
# AWS Transfer FamilyのAS2プロトコル用の署名・暗号化証明書をインポートする
# リソースです。ローカルプロファイルおよびパートナープロファイルの作成に使用
# する証明書を管理します。インポート後、Transfer FamilyはCloudWatchメトリクス
# 「DaysUntilExpiry」を自動的に作成し、証明書の有効期限までの日数を追跡します。
#
# AWS公式ドキュメント:
#   - ImportCertificate APIリファレンス: https://docs.aws.amazon.com/transfer/latest/APIReference/API_ImportCertificate.html
#   - AS2証明書管理: https://docs.aws.amazon.com/transfer/latest/userguide/tutorials-transfer.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_certificate" "example" {
  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate (Required)
  # 設定内容: インポートする証明書のPEM形式の内容を指定します。
  # 設定可能な値: PEM形式の証明書文字列（1〜16384文字）
  # 注意: 証明書とそのチェーンをこのパラメータにまとめて指定できます。
  #       その場合はcertificate_chainパラメータを使用しないでください。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_ImportCertificate.html
  certificate = file("${path.module}/example.crt")

  # certificate_chain (Optional)
  # 設定内容: インポートする証明書のチェーンを構成する中間CA証明書のPEM形式の内容を指定します。
  # 設定可能な値: PEM形式の証明書チェーン文字列（1〜2097152文字）
  # 省略時: チェーン証明書なしで証明書のみがインポートされます。
  # 注意: certificateパラメータに証明書とチェーンをまとめて指定した場合は使用しないでください。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_ImportCertificate.html
  certificate_chain = file("${path.module}/ca.crt")

  # private_key (Optional)
  # 設定内容: インポートする証明書に関連付けられた秘密鍵のPEM形式の内容を指定します。
  # 設定可能な値: PEM形式の秘密鍵文字列（1〜16384文字）
  # 省略時: 秘密鍵なしで証明書がインポートされます（パートナー証明書の場合など）。
  # 注意: 秘密鍵はSensitiveとしてマークされ、Terraformのstate/planでマスクされます。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_ImportCertificate.html
  private_key = file("${path.module}/example.key")

  #-------------------------------------------------------------
  # 用途設定
  #-------------------------------------------------------------

  # usage (Required)
  # 設定内容: 証明書の使用目的を指定します。
  # 設定可能な値:
  #   - "SIGNING":    AS2メッセージの署名に使用
  #   - "ENCRYPTION": AS2メッセージの暗号化に使用
  #   - "TLS":        HTTPS経由のAS2通信のセキュリティ確保に使用
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_ImportCertificate.html
  usage = "SIGNING"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 証明書を識別するための短い説明文を指定します。
  # 設定可能な値: 1〜200文字の文字列
  # 省略時: 説明なしで証明書が作成されます。
  # 注意: CloudWatchメトリクス「DaysUntilExpiry」のディメンションとして使用されます。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_ImportCertificate.html
  description = "example-as2-signing-certificate"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグ）
  # 省略時: タグなしでリソースが作成されます。
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-as2-signing-certificate"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn:            証明書のAmazon Resource Name (ARN)
# - certificate_id: AS2証明書の一意識別子（形式: cert-XXXXXXXXXXXXXXXXX）
# - active_date:    証明書がアクティブになる日付
# - inactive_date:  証明書が無効になる日付
# - tags_all:       プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#                   リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
