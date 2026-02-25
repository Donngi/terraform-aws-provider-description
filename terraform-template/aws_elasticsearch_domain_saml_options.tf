#---------------------------------------------------------------
# Amazon Elasticsearch Service ドメイン SAML 認証設定
#---------------------------------------------------------------
#
# AWS Elasticsearch ドメインの SAML 認証オプションを管理するリソースです。
# SAML 2.0 プロトコルを使用して、組織の ID プロバイダー (IdP) と統合し、
# ユーザーが既存の企業認証情報で Elasticsearch クラスターにアクセスできるように
# 設定します。この機能により、セキュアなシングルサインオン (SSO) 環境を
# 実現できます。
#
# AWS公式ドキュメント:
#   - Elasticsearch Service SAML認証: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/saml.html
#   - Kibana用SAML認証: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/kibana-saml.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain_saml_options
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticsearch_domain_saml_options" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: SAML 認証を設定する Elasticsearch ドメインの名前を指定します。
  # 設定可能な値: 既存の Elasticsearch ドメイン名（1-28文字、小文字英数字とハイフンのみ）
  # 注意: ドメインは事前に作成されている必要があります
  domain_name = "example-domain"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # SAML 認証設定
  #-------------------------------------------------------------

  # saml_options (Optional)
  # 設定内容: AWS Elasticsearch ドメインの SAML 認証オプションを定義します。
  # 注意: SAML 認証を無効化する場合は、enabled = false を設定します
  saml_options {
    # enabled (Optional)
    # 設定内容: SAML 認証の有効/無効を制御します。
    # 設定可能な値:
    #   - true: SAML 認証を有効化
    #   - false: SAML 認証を無効化
    # 省略時: false
    # 注意: 有効化する場合は idp ブロックの設定が必須です
    enabled = true

    #-----------------------------------------------------------
    # ID プロバイダー (IdP) 設定
    #-----------------------------------------------------------

    # idp (Optional)
    # 設定内容: SAML ID プロバイダー（IdP）からの情報を指定します。
    # 注意: SAML 認証を有効にする場合は必須です
    idp {
      # entity_id (Required)
      # 設定内容: SAML ID プロバイダーにおけるアプリケーションの一意な Entity ID を指定します。
      # 設定可能な値: URL形式の文字列（例: https://example.com）
      # 注意: IdP 側で設定された Entity ID と正確に一致する必要があります
      entity_id = "https://example.com"

      # metadata_content (Required)
      # 設定内容: SAML アプリケーションのメタデータを XML 形式で指定します。
      # 設定可能な値: SAML メタデータ XML（IdP から取得）
      # 注意: IdP から提供されるメタデータファイルの内容を指定します
      #       file() 関数を使用してファイルから読み込むことができます
      metadata_content = file("./saml-metadata.xml")
    }

    #-----------------------------------------------------------
    # マスターユーザー設定
    #-----------------------------------------------------------

    # master_backend_role (Optional)
    # 設定内容: SAML IdP から提供されるバックエンドロールを指定します。
    #           このロールは Elasticsearch クラスターへの完全な権限を受け取ります。
    # 設定可能な値: IdP から送信されるロール名（文字列）
    # 省略時: マスターバックエンドロールは設定されません
    # 注意: master_user_name と master_backend_role のうち、どちらか一方のみを設定することを推奨
    # 関連機能: ファインアクセスコントロール
    #   マスターロールは Kibana および Elasticsearch API への完全なアクセス権を持ちます
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
    master_backend_role = null

    # master_user_name (Optional)
    # 設定内容: SAML IdP から提供されるユーザー名を指定します。
    #           このユーザーは Elasticsearch クラスターへの完全な権限を受け取ります。
    # 設定可能な値: IdP から送信されるユーザー名（文字列）
    # 省略時: マスターユーザーは設定されません
    # 注意: センシティブな値として扱われます（Terraform 出力時にマスクされます）
    #       master_user_name と master_backend_role のうち、どちらか一方のみを設定することを推奨
    master_user_name = null

    #-----------------------------------------------------------
    # SAML アサーション設定
    #-----------------------------------------------------------

    # roles_key (Optional)
    # 設定内容: バックエンドロールに使用する SAML アサーション要素を指定します。
    # 設定可能な値: SAML アサーション内の属性名（文字列）
    # 省略時: "roles"（デフォルト値）
    # 関連機能: ロールマッピング
    #   IdP が送信する SAML アサーション内の属性名を指定し、
    #   Elasticsearch のロールにマッピングします
    roles_key = "roles"

    # subject_key (Optional)
    # 設定内容: ユーザー名に使用するカスタム SAML 属性を指定します。
    # 設定可能な値: SAML アサーション内の属性名（文字列）
    # 省略時: 空文字列 ("")（Subject の NameID 要素を使用）
    # 注意: 空文字列の場合、SAML 仕様のデフォルト位置である Subject の NameID 要素が使用されます
    # 関連機能: ユーザー識別
    #   SAML アサーション内でユーザーを識別するための属性を指定します
    subject_key = ""

    #-----------------------------------------------------------
    # セッション設定
    #-----------------------------------------------------------

    # session_timeout_minutes (Optional)
    # 設定内容: ユーザーのログイン後のセッション有効時間を分単位で指定します。
    # 設定可能な値: 1～1440（分）
    # 省略時: 60（分）
    # 注意: セッションタイムアウト後、ユーザーは再認証が必要になります
    session_timeout_minutes = 60
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # update (Optional)
    # 設定内容: SAML オプションの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # 省略時: 180m（3時間）
    update = null

    # delete (Optional)
    # 設定内容: SAML オプションの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # 省略時: 180m（3時間）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
#
# このリソースからは以下の属性を参照できます:
#
# - id
#   SAML オプションが関連付けられているドメインの名前
#   参照方法: aws_elasticsearch_domain_saml_options.example.id
#
#---------------------------------------------------------------
