#---------------------------------------------------------------
# AWS SESv2 Configuration Set
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2のコンフィギュレーションセットを
# プロビジョニングするリソースです。コンフィギュレーションセットは、
# メール送信に適用するルールのグループです。これを使用することで、
# 配信オプション、レピュテーション追跡、送信有効化/無効化、抑制リスト、
# トラッキングオプション、VDM（Virtual Deliverability Manager）設定などを
# 一元管理できます。
#
# AWS公式ドキュメント:
#   - コンフィギュレーションセットの概要: https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
#   - コンフィギュレーションセットの作成: https://docs.aws.amazon.com/ses/latest/dg/creating-configuration-sets.html
#   - VDM (Virtual Deliverability Manager): https://docs.aws.amazon.com/ses/latest/dg/vdm.html
#   - CreateConfigurationSet API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateConfigurationSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_configuration_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # configuration_set_name (Required)
  # 設定内容: コンフィギュレーションセットの名前を指定します。
  # 設定可能な値: 一意の文字列（最大64文字、英数字・ハイフン・アンダースコア）
  # 注意: アカウント内で一意である必要があります。
  configuration_set_name = "my-configuration-set"

  #-------------------------------------------------------------
  # 配信オプション設定
  #-------------------------------------------------------------

  # delivery_options (Optional)
  # 設定内容: コンフィギュレーションセットを使用して送信されるメールの配信オプションを設定します。
  delivery_options {
    # max_delivery_seconds (Optional)
    # 設定内容: メール配信を試みる最大時間（秒）を指定します。
    # 設定可能な値: 300〜50400（秒）
    # 省略時: AWSのデフォルト値が適用されます。
    max_delivery_seconds = 300

    # sending_pool_name (Optional)
    # 設定内容: メール送信に使用する専用IPプールの名前を指定します。
    # 設定可能な値: 既存の専用IPプール名
    # 省略時: 共有IPプールが使用されます。
    sending_pool_name = "my-dedicated-ip-pool"

    # tls_policy (Optional)
    # 設定内容: TLSポリシーを指定します。メール転送に際してTLSを必須とするかを制御します。
    # 設定可能な値:
    #   - "REQUIRE": TLS接続が必須です。TLSをサポートしていないサーバーへの配信は試みません。
    #   - "OPTIONAL": 可能であればTLS接続を使用しますが、必須ではありません。
    # 省略時: OPTIONALが適用されます。
    tls_policy = "REQUIRE"
  }

  #-------------------------------------------------------------
  # レピュテーション設定
  #-------------------------------------------------------------

  # reputation_options (Optional)
  # 設定内容: コンフィギュレーションセットのレピュテーション追跡設定を指定します。
  reputation_options {
    # reputation_metrics_enabled (Optional)
    # 設定内容: バウンスや苦情などのレピュテーションメトリクスの追跡を有効にするかを指定します。
    # 設定可能な値:
    #   - true: レピュテーションメトリクスの追跡を有効化
    #   - false: レピュテーションメトリクスの追跡を無効化
    # 省略時: AWSのデフォルト設定が適用されます。
    reputation_metrics_enabled = true
  }

  #-------------------------------------------------------------
  # 送信設定
  #-------------------------------------------------------------

  # sending_options (Optional)
  # 設定内容: このコンフィギュレーションセットを使用したメール送信の有効/無効を制御します。
  sending_options {
    # sending_enabled (Optional)
    # 設定内容: コンフィギュレーションセットを使用したメール送信を有効にするかを指定します。
    # 設定可能な値:
    #   - true: メール送信を有効化
    #   - false: メール送信を無効化（一時停止）
    # 省略時: trueが適用されます（送信有効）。
    sending_enabled = true
  }

  #-------------------------------------------------------------
  # 抑制設定
  #-------------------------------------------------------------

  # suppression_options (Optional)
  # 設定内容: このコンフィギュレーションセットの抑制リスト設定を指定します。
  suppression_options {
    # suppressed_reasons (Optional)
    # 設定内容: メールアドレスをアカウントレベルの抑制リストに追加する理由を指定します。
    # 設定可能な値:
    #   - "BOUNCE": バウンスが原因でアドレスが抑制された場合
    #   - "COMPLAINT": 苦情が原因でアドレスが抑制された場合
    # 省略時: アカウントレベルの抑制設定が適用されます。
    suppressed_reasons = ["BOUNCE", "COMPLAINT"]
  }

  #-------------------------------------------------------------
  # トラッキング設定
  #-------------------------------------------------------------

  # tracking_options (Optional)
  # 設定内容: メール内のリンクのクリックやオープントラッキングのドメイン設定を指定します。
  tracking_options {
    # custom_redirect_domain (Required)
    # 設定内容: オープンおよびクリックトラッキングリンクに使用するカスタムドメインを指定します。
    # 設定可能な値: 有効なドメイン名（SESで検証済みのドメイン）
    custom_redirect_domain = "tracking.example.com"

    # https_policy (Optional)
    # 設定内容: トラッキングリンクにHTTPSを使用するかどうかのポリシーを指定します。
    # 設定可能な値:
    #   - "REQUIRE": トラッキングリンクにHTTPSを強制します。
    #   - "REQUIRE_OPEN_ONLY": オープントラッキングリンクにのみHTTPSを強制します。
    #   - "OPTIONAL": 可能な場合にHTTPSを使用します。
    # 省略時: OPTIONALが適用されます。
    https_policy = "REQUIRE"
  }

  #-------------------------------------------------------------
  # VDM (Virtual Deliverability Manager) 設定
  #-------------------------------------------------------------

  # vdm_options (Optional)
  # 設定内容: Virtual Deliverability Manager (VDM) の設定を指定します。
  #           VDMは配信率の改善とメール送信の問題を診断するための機能です。
  vdm_options {
    # dashboard_options (Optional)
    # 設定内容: VDMダッシュボードのオプション設定を指定します。
    dashboard_options {
      # engagement_metrics (Optional)
      # 設定内容: エンゲージメントメトリクス（オープン率・クリック率等）の収集を有効にするかを指定します。
      # 設定可能な値:
      #   - "ENABLED": エンゲージメントメトリクスの収集を有効化
      #   - "DISABLED": エンゲージメントメトリクスの収集を無効化
      # 省略時: アカウントレベルのVDM設定が適用されます。
      engagement_metrics = "ENABLED"
    }

    # guardian_options (Optional)
    # 設定内容: VDM Guardianのオプション設定を指定します。
    #           Guardianは最適化された共有配信に関する設定です。
    guardian_options {
      # optimized_shared_delivery (Optional)
      # 設定内容: 最適化された共有配信を有効にするかを指定します。
      # 設定可能な値:
      #   - "ENABLED": 最適化された共有配信を有効化
      #   - "DISABLED": 最適化された共有配信を無効化
      # 省略時: アカウントレベルのVDM設定が適用されます。
      optimized_shared_delivery = "ENABLED"
    }
  }

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-configuration-set"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンフィギュレーションセットのAmazon Resource Name (ARN)
#
# - id: コンフィギュレーションセット名（configuration_set_nameと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
