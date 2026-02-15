#---------------------------------------
# AWS Amplify ドメイン関連付け
#---------------------------------------
# AWS AmplifyアプリケーションにカスタムドメインとSSL/TLS証明書を関連付けるリソース
# HTTPSアクセスの有効化やサブドメインの設定を管理
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_domain_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
#
# NOTE:
# - ドメイン検証にはDNSレコードの追加が必要です
# - サブドメインは最低1つ必要です
# - カスタム証明書を使用する場合はACMでus-east-1リージョンに証明書を作成してください

#-------
# リソース定義
#-------
resource "aws_amplify_domain_association" "example" {

  #-------
  # 基本設定
  #-------

  # 設定内容: AmplifyアプリケーションのID
  # 設定可能な値: 既存のAmplifyアプリのID文字列
  app_id = "d123456789abcd"

  # 設定内容: カスタムドメイン名
  # 設定可能な値: DNSに登録可能なドメイン名（例: example.com）
  domain_name = "example.com"

  #-------
  # サブドメイン設定
  #-------

  # 設定内容: サブドメインとブランチの関連付け設定
  # 設定可能な値: 1つ以上のサブドメイン定義ブロック
  sub_domain {
    # 設定内容: 関連付けるブランチ名
    # 設定可能な値: Amplifyアプリに存在するブランチ名
    branch_name = "main"

    # 設定内容: サブドメインのプレフィックス
    # 設定可能な値: サブドメインのプレフィックス文字列（空文字列でルートドメイン）
    prefix = "www"
  }

  #-------
  # SSL/TLS証明書設定
  #-------

  # 設定内容: SSL/TLS証明書の設定
  # 設定可能な値: 証明書タイプとARNを含むブロック
  # 省略時: Amplifyが自動管理する証明書を使用
  # certificate_settings {
  #   # 設定内容: 証明書のタイプ
  #   # 設定可能な値: AMPLIFY_MANAGED（Amplify管理）、CUSTOM（カスタム証明書）
  #   type = "AMPLIFY_MANAGED"

  #   # 設定内容: カスタム証明書のARN
  #   # 設定可能な値: ACMで管理される証明書のARN
  #   # 省略時: typeがAMPLIFY_MANAGEDの場合は不要
  #   # custom_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  # }

  #-------
  # 自動化設定
  #-------

  # 設定内容: ブランチ作成時のサブドメイン自動作成
  # 設定可能な値: true（有効）、false（無効）
  # 省略時: false
  enable_auto_sub_domain = false

  # 設定内容: ドメイン検証の完了を待機するかどうか
  # 設定可能な値: true（待機する）、false（待機しない）
  # 省略時: true
  wait_for_verification = true

  #-------
  # リージョン設定
  #-------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# リソース作成後に参照可能な属性:
#
# - arn
#   ドメイン関連付けのARN
#
# - certificate_verification_dns_record
#   証明書検証用のDNSレコード（スペース区切り形式: <record> CNAME <target>）
#
# - id
#   リソース識別子（app_id/domain_name形式）
#
# - sub_domain[].dns_record
#   サブドメインのDNSレコード（スペース区切り形式: <prefix> CNAME <target>）
#
# - sub_domain[].verified
#   サブドメインの検証ステータス（true/false）
#
# - certificate_settings[].certificate_verification_dns_record
#   証明書設定における検証用DNSレコード
