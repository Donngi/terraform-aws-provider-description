#---------------------------------------------------------------
# AWS Simple Email Service (SES) Configuration Set
#---------------------------------------------------------------
#
# AWS SES Configuration Set リソースです。
# SES Configuration Set は、メール送信時の追跡、評価指標の収集、
# イベントの発行などを設定するためのコンテナです。
#
# 主な機能:
#   - 送信メトリクスの有効化
#   - TLS接続の強制
#   - カスタムリダイレクトドメインの設定
#   - メール送信の有効化/無効化
#
# AWS公式ドキュメント:
#   - SES Configuration Sets 概要: https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
#   - Configuration Set の作成: https://docs.aws.amazon.com/ses/latest/dg/creating-configuration-sets.html
#   - SES API リファレンス: https://docs.aws.amazon.com/ses/latest/APIReference/API_CreateConfigurationSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_configuration_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_configuration_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Configuration Set の名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 制約: 一度作成すると変更できません (変更すると再作成されます)
  # 関連機能: SES Configuration Set 識別子
  #   メール送信時に使用する Configuration Set を識別するための一意の名前。
  #   - https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
  name = "example-configuration-set"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: SES リージョナルエンドポイント
  #   SES はリージョンごとにエンドポイントが異なります。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#ses_region
  region = null

  #-------------------------------------------------------------
  # 送信設定
  #-------------------------------------------------------------

  # sending_enabled (Optional)
  # 設定内容: この Configuration Set を使用したメール送信の有効/無効を指定します。
  # 設定可能な値:
  #   - true: メール送信を有効化 (デフォルト)
  #   - false: メール送信を無効化
  # 省略時: true (送信が有効)
  # 用途: テスト環境での誤送信防止や、一時的なメール送信停止に使用
  # 関連機能: SES 送信制御
  #   Configuration Set レベルでメール送信を制御可能。
  #   - https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
  sending_enabled = true

  #-------------------------------------------------------------
  # 評価指標設定
  #-------------------------------------------------------------

  # reputation_metrics_enabled (Optional)
  # 設定内容: この Configuration Set の評価指標を Amazon CloudWatch に公開するかを指定します。
  # 設定可能な値:
  #   - true: 評価指標を CloudWatch に公開
  #   - false: 評価指標を公開しない (デフォルト)
  # 省略時: false
  # 用途: バウンス率、苦情率などの送信者評価を監視する場合に有効化
  # 関連機能: SES 評価指標
  #   メール配信の健全性を監視し、送信者評価を維持するための指標。
  #   - https://docs.aws.amazon.com/ses/latest/dg/reputation-dashboard-dg.html
  reputation_metrics_enabled = false

  #-------------------------------------------------------------
  # 配信オプション (TLS ポリシー)
  #-------------------------------------------------------------

  # delivery_options (Optional)
  # 設定内容: TLS接続要件を設定するブロックです。
  # 用途: メール配信時のセキュリティレベルを制御
  # 注意: このブロックは1つまで指定可能
  delivery_options {
    # tls_policy (Optional)
    # 設定内容: Transport Layer Security (TLS) の使用ポリシーを指定します。
    # 設定可能な値:
    #   - "Optional": TLS接続が確立できない場合は平文で配信 (デフォルト)
    #   - "Require": TLS接続が必須。確立できない場合は配信しない
    # 省略時: "Optional"
    # 推奨: セキュリティを重視する場合は "Require" を設定
    # 関連機能: SES TLS ポリシー
    #   メール送信時の暗号化を強制し、中間者攻撃から保護。
    #   - https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
    tls_policy = "Optional"
  }

  #-------------------------------------------------------------
  # トラッキングオプション
  #-------------------------------------------------------------

  # tracking_options (Optional)
  # 設定内容: メール受信者を追跡するためのカスタムリダイレクトドメインを設定します。
  # 用途: メール内のリンククリック追跡やメール開封追跡に使用
  # 注意: このブロックは1つまで指定可能
  # 注意: この機能は best effort であり、完全な保証はありません
  tracking_options {
    # custom_redirect_domain (Optional)
    # 設定内容: メール受信者をSESイベント追跡ドメインにリダイレクトするための
    #          カスタムサブドメインを指定します。
    # 設定可能な値: 有効なサブドメイン名 (例: tracking.example.com)
    # 用途: メール内のリンククリック追跡時のブランディング維持
    # 前提条件: 指定したドメインに対してSESのDNS設定が必要
    # 関連機能: SES カスタムリダイレクトドメイン
    #   受信者がメール内のリンクをクリックした際に、独自ドメインを経由して追跡。
    #   - https://docs.aws.amazon.com/ses/latest/dg/configure-custom-open-click-domains.html
    custom_redirect_domain = null
  }

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常は Configuration Set の名前と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SES Configuration Set の Amazon Resource Name (ARN)
#   形式: arn:aws:ses:region:account-id:configuration-set/name
#
# - id: SES Configuration Set の名前
#   通常は name 属性と同じ値
#
# - last_fresh_start: Configuration Set の評価指標が最後にリセットされた
#   日時 (RFC 3339 形式)。評価指標のリセットは "fresh start" と呼ばれます。
#   注意: reputation_metrics_enabled が true の場合のみ有効
#
#---------------------------------------------------------------
#
# 基本的な Configuration Set:
#
# resource "aws_ses_configuration_set" "basic" {
#   name = "my-configuration-set"
# }
#
# TLS接続を必須とする Configuration Set:
#
#---------------------------------------------------------------
