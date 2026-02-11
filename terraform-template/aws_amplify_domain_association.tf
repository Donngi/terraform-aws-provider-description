#---------------------------------------------------------------
# AWS Amplify Domain Association
#---------------------------------------------------------------
#
# AWS Amplify Hostingにデプロイされたアプリケーションにカスタムドメインを
# 関連付けるためのリソースです。カスタムドメインを設定することで、
# デフォルトの amplifyapp.com ドメインの代わりに独自のドメイン
# （例: www.example.com）でアプリケーションを公開できます。
#
# AWS公式ドキュメント:
#   - Amplify Hostingカスタムドメイン: https://docs.aws.amazon.com/amplify/latest/userguide/custom-domains.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_domain_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_amplify_domain_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # app_id (Required)
  # 設定内容: Amplifyアプリの一意のIDを指定します。
  # 設定可能な値: 有効なAmplifyアプリID
  # 注意: aws_amplify_app リソースの id 属性から取得可能
  app_id = aws_amplify_app.example.id

  # domain_name (Required)
  # 設定内容: 関連付けるカスタムドメイン名を指定します。
  # 設定可能な値: 有効なドメイン名（例: example.com）
  # 注意: ドメインは事前に登録済みである必要があります
  domain_name = "example.com"

  #-------------------------------------------------------------
  # サブドメイン設定
  #-------------------------------------------------------------

  # sub_domain (Required)
  # 設定内容: サブドメインとAmplifyブランチのマッピングを設定します。
  # 注意: 少なくとも1つのsub_domainブロックが必要です。
  #       複数のサブドメインを設定することで、異なるブランチを
  #       異なるサブドメインで公開できます。

  # ルートドメイン（https://example.com）の設定例
  sub_domain {
    # branch_name (Required)
    # 設定内容: このサブドメインに関連付けるAmplifyブランチの名前を指定します。
    # 設定可能な値: 有効なAmplifyブランチ名
    branch_name = aws_amplify_branch.main.branch_name

    # prefix (Required)
    # 設定内容: サブドメインのプレフィックスを指定します。
    # 設定可能な値:
    #   - "" (空文字列): ルートドメイン（example.com）
    #   - "www": www.example.com
    #   - "api": api.example.com
    #   - 任意の文字列: {prefix}.example.com
    prefix = ""
  }

  # www サブドメイン（https://www.example.com）の設定例
  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }

  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_settings (Optional)
  # 設定内容: カスタムドメインに使用するSSL/TLS証明書の設定を指定します。
  # 省略時: Amplifyが自動的にプロビジョニング・管理する証明書を使用
  # 関連機能: SSL/TLS証明書管理
  #   Amplifyマネージド証明書またはACMからインポートしたカスタム証明書を
  #   使用してHTTPS通信を有効化できます。
  certificate_settings {
    # type (Required)
    # 設定内容: 証明書のタイプを指定します。
    # 設定可能な値:
    #   - "AMPLIFY_MANAGED": Amplifyが自動的にプロビジョニング・管理する証明書を使用
    #   - "CUSTOM": AWS Certificate Manager (ACM) のカスタム証明書を使用
    type = "AMPLIFY_MANAGED"

    # custom_certificate_arn (Optional)
    # 設定内容: カスタム証明書のARNを指定します。
    # 設定可能な値: 有効なACM証明書ARN
    # 注意: type が "CUSTOM" の場合は必須
    # 関連機能: AWS Certificate Manager (ACM)
    #   カスタム証明書を使用する場合、事前にACMで証明書を発行または
    #   インポートしておく必要があります。証明書は us-east-1 リージョンに
    #   存在する必要があります。
    #   - https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html
    # custom_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # enable_auto_sub_domain (Optional)
  # 設定内容: ブランチの自動サブドメイン作成を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 新しいブランチが作成されると、自動的にサブドメインが作成される
  #   - false: 自動サブドメイン作成を無効化
  # 省略時: false
  # 関連機能: 自動サブドメイン
  #   フィーチャーブランチごとに自動的にサブドメインを作成し、
  #   プレビュー環境として利用できます。
  #   - https://docs.aws.amazon.com/amplify/latest/userguide/to-set-up-automatic-subdomains-for-a-Route-53-custom-domain.html
  enable_auto_sub_domain = false

  # wait_for_verification (Optional)
  # 設定内容: ドメイン検証の完了を待機するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): ドメインのステータスが PENDING_DEPLOYMENT または
  #                        AVAILABLE になるまで待機
  #   - false: 検証プロセスをスキップ（非同期で処理）
  # 省略時: true
  # 注意: false に設定すると、ドメインの検証が完了する前にリソースの
  #       作成が完了します。DNS設定を手動で行う場合に有用です。
  wait_for_verification = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドメイン関連付けのAmazon Resource Name (ARN)
#
# - certificate_verification_dns_record: 証明書検証用のDNSレコード
#        スペース区切り形式（`<record> CNAME <target>`）で出力されます。
#
# sub_domain ブロックは以下の属性もエクスポートします:
#
# - dns_record: サブドメイン用のDNSレコード
#        スペース区切り形式（` CNAME <target>`）で出力されます。
#
# - verified: サブドメインの検証ステータス（true/false）
#---------------------------------------------------------------
