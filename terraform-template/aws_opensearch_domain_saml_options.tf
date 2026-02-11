#---------------------------------------------------------------
# Amazon OpenSearch Service SAML認証設定
#---------------------------------------------------------------
#
# Amazon OpenSearch ServiceドメインのSAML認証オプションを管理するリソースです。
# SAML認証を使用することで、既存のIDプロバイダー（Okta、Keycloak、ADFS、
# Auth0、AWS IAM Identity Center等）を使用してOpenSearch Dashboardsへの
# シングルサインオン（SSO）を提供できます。
#
# AWS公式ドキュメント:
#   - OpenSearch DashboardsのSAML認証: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/saml.html
#   - SAMLOptionsInput API: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_SAMLOptionsInput.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_saml_options
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_domain_saml_options" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: SAML認証オプションを設定するOpenSearch Serviceドメインの名前を指定します。
  # 設定可能な値: 既存のOpenSearch Serviceドメイン名
  # 注意: このリソースはSAML認証を構成するのみで、OpenSearch Serviceドメイン自体の
  #       作成は行いません。事前にドメインを作成し、きめ細かいアクセス制御を
  #       有効化する必要があります。
  domain_name = "example-domain"

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
  # SAML認証オプション
  #-------------------------------------------------------------

  # saml_options (Optional)
  # 設定内容: OpenSearch ServiceドメインのSAML認証オプションを指定します。
  # 注意: ドメインは一度に1つの認証方法のみをサポートします。Amazon Cognito認証が
  #       有効な場合は、SAML認証を有効化する前に無効化する必要があります。
  saml_options {

    # enabled (Optional)
    # 設定内容: ドメインでSAML認証を有効化するかどうかを指定します。
    # 設定可能な値:
    #   - true: SAML認証を有効化
    #   - false (デフォルト): SAML認証を無効化
    # 注意: SAML認証はブラウザを介したOpenSearch Dashboardsへのアクセス専用です。
    #       SAML資格情報では、OpenSearchまたはDashboards APIへの直接HTTP
    #       リクエストを実行できません。
    enabled = true

    # master_backend_role (Optional)
    # 設定内容: SAML IdPからのバックエンドロールで、クラスタへのフル権限を
    #           受け取るロールを指定します。新しいマスターユーザーと同等の権限を持ちます。
    # 設定可能な値: 1-256文字の文字列
    # 省略時: 指定なし
    # 関連機能: きめ細かいアクセス制御のマスターユーザー
    #   マスターバックエンドロールを持つユーザーは、OpenSearch Dashboards内で
    #   フル権限を持ちます。外部IDプロバイダーでは、バックエンドロールは通常
    #   「ロール」または「グループ」と呼ばれます。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
    # 注意: SAMLアサーションの内容は、このフィールドに指定した文字列と正確に一致する
    #       必要があります。一部のIDプロバイダーはユーザー名の前にプレフィックスを
    #       追加するため、アサーション内の実際の文字列を使用してください。
    master_backend_role = "admins"

    # master_user_name (Optional, Sensitive)
    # 設定内容: SAML IdPからのユーザー名で、クラスタへのフル権限を受け取るユーザーを
    #           指定します。新しいマスターユーザーと同等の権限を持ちます。
    # 設定可能な値: 1-64文字の文字列
    # 省略時: 指定なし
    # 関連機能: きめ細かいアクセス制御のマスターユーザー
    #   マスターユーザー名を持つユーザーは、OpenSearch Dashboards内でフル権限を持ちます。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
    # 注意: この値は機密情報として扱われ、Terraformのステート内で暗号化されます。
    #       SAMLアサーションの内容と正確に一致する必要があります。
    master_user_name = null

    # roles_key (Optional)
    # 設定内容: バックエンドロールに使用するSAMLアサーションの要素を指定します。
    # 設定可能な値: 文字列
    # 省略時: "roles" (デフォルト)
    # 関連機能: SAMLアサーションマッピング
    #   IDプロバイダーは、ユーザーがログインした後、ユーザー名とバックエンドロールを
    #   含むSAMLアサーションを返します。この設定により、アサーション内のどの要素を
    #   バックエンドロールとして使用するかを指定できます。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/saml.html
    roles_key = "roles"

    # session_timeout_minutes (Optional)
    # 設定内容: ユーザーがログイン後、セッションが非アクティブになるまでの期間を
    #           分単位で指定します。
    # 設定可能な値: 1-1440（分）
    # 省略時: 60（分）
    # 参考: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_SAMLOptionsInput.html
    session_timeout_minutes = 60

    # subject_key (Optional)
    # 設定内容: ユーザー名に使用するSAMLアサーションの要素を指定します。
    # 設定可能な値: 文字列
    # 省略時: "NameID" (デフォルト)
    # 関連機能: SAMLアサーションマッピング
    #   この設定により、SAMLアサーション内のどの要素をユーザー名として使用するかを
    #   指定できます。多くの場合、デフォルト値の"NameID"が適切です。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/saml.html
    subject_key = "NameID"

    #-----------------------------------------------------------
    # IDプロバイダー設定
    #-----------------------------------------------------------

    # idp (Optional)
    # 設定内容: SAMLアイデンティティプロバイダーからの情報を指定します。
    # 注意: IDプロバイダーを構成した後、OpenSearch Serviceで使用するために
    #       IdPメタデータファイルを生成する必要があります。
    idp {

      # entity_id (Required)
      # 設定内容: SAMLアイデンティティプロバイダーにおけるアプリケーションの
      #           一意のエンティティIDを指定します。
      # 設定可能な値: 文字列
      # 関連機能: SAMLエンティティID
      #   多くのIDプロバイダーでは、これは「issuer」とも呼ばれます。
      #   IdPメタデータファイル内のentityID属性の値と一致する必要があります。
      #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/saml.html
      entity_id = "https://example.com"

      # metadata_content (Required)
      # 設定内容: SAMLアプリケーションのメタデータをXML形式で指定します。
      # 設定可能な値: XML形式の文字列
      # 関連機能: IdPメタデータ
      #   IDプロバイダーを構成後、IdPメタデータファイルが生成されます。
      #   このXMLファイルには、TLS証明書、シングルサインオンエンドポイント、
      #   IDプロバイダーのエンティティIDなどの情報が含まれます。
      #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/saml.html
      # 注意: ファイルから読み込む場合は file() 関数を使用できます。
      metadata_content = file("./saml-metadata.xml")
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトをカスタマイズします。
  timeouts {

    # update (Optional)
    # 設定内容: SAML設定の更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    update = null

    # delete (Optional)
    # 設定内容: SAML設定の削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: SAMLオプションが関連付けられているドメインの名前
#---------------------------------------------------------------
