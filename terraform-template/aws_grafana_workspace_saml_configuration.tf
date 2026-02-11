#---------------------------------------------------------------
# Amazon Managed Grafana Workspace SAML Configuration
#---------------------------------------------------------------
#
# Amazon Managed GrafanaワークスペースのSAML認証設定をプロビジョニングするリソースです。
# SAML 2.0を使用した既存のIDプロバイダーとの統合により、IAM認証の代わりに
# シングルサインオン（SSO）を実装できます。Azure AD、CyberArk、Okta、OneLogin、
# Ping Identityなどのサードパーティ製IDプロバイダーに対応しています。
#
# AWS公式ドキュメント:
#   - Use SAML with your Amazon Managed Grafana workspace: https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SAML.html
#   - SamlConfiguration API: https://docs.aws.amazon.com/grafana/latest/APIReference/API_SamlConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_saml_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_workspace_saml_configuration" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # workspace_id (Required)
  # 設定内容: SAML設定を適用するAmazon Managed Grafanaワークスペースのidを指定します。
  # 設定可能な値: 有効なGrafanaワークスペースID（例: g-1234567890）
  # 注意: ワークスペース作成時にauthentication_providersに"SAML"を含める必要があります。
  workspace_id = aws_grafana_workspace.example.id

  # editor_role_values (Required)
  # 設定内容: IDプロバイダー側のどのロールをGrafanaの「Editor」ロールにマッピングするかを指定します。
  # 設定可能な値: IDプロバイダーで定義されているロール名の配列
  # 関連機能: ロールマッピング
  #   SAML assertionに含まれるロール情報を元に、Grafanaワークスペース内での
  #   権限レベルを決定します。Editorロールはダッシュボードの編集や作成が可能です。
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SAML.html
  editor_role_values = ["editor", "developer"]

  #-------------------------------------------------------------
  # IDプロバイダーメタデータ設定
  #-------------------------------------------------------------

  # idp_metadata_url (Optional)
  # 設定内容: IDプロバイダーのメタデータURLを指定します。
  # 設定可能な値: IDプロバイダーが提供するSAMLメタデータのURL
  # 注意: idp_metadata_xmlとは排他的です（どちらか一方のみを指定）。
  #       両方指定すると設定エラーになります。
  # 関連機能: IDプロバイダー統合
  #   メタデータには、IDプロバイダーのエンティティID、SSOサービスURL、
  #   署名証明書などの情報が含まれます。
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SAML.html
  idp_metadata_url = "https://my_idp_metadata.url"

  # idp_metadata_xml (Optional)
  # 設定内容: IDプロバイダーのメタデータXMLを直接指定します。
  # 設定可能な値: IDプロバイダーが提供するSAMLメタデータのXML文字列
  # 注意: idp_metadata_urlとは排他的です（どちらか一方のみを指定）。
  #       URLでの参照ができない場合や、メタデータを直接埋め込みたい場合に使用します。
  idp_metadata_xml = null

  #-------------------------------------------------------------
  # ロールマッピング設定
  #-------------------------------------------------------------

  # admin_role_values (Optional)
  # 設定内容: IDプロバイダー側のどのロールをGrafanaの「Admin」ロールにマッピングするかを指定します。
  # 設定可能な値: IDプロバイダーで定義されているロール名の配列
  # 省略時: Adminロールを持つユーザーは作成されません。
  # 関連機能: ロールマッピング
  #   Adminロールはワークスペースの設定変更、ユーザー管理、データソース管理など
  #   最高レベルの権限を持ちます。
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SAML.html
  admin_role_values = ["admin", "grafana-admin"]

  #-------------------------------------------------------------
  # Assertionマッピング設定
  #-------------------------------------------------------------

  # role_assertion (Optional)
  # 設定内容: SAML assertion内のどの属性をユーザーロール判定に使用するかを指定します。
  # 設定可能な値: SAML assertionに含まれる属性名（例: "Role", "roles"）
  # 省略時: デフォルトの属性名が使用されます。
  # 関連機能: Assertion属性マッピング
  #   IDプロバイダーから送信されるSAML assertionには、ユーザー情報が
  #   さまざまな属性として含まれています。この設定により、どの属性を
  #   ロール判定に使うかをカスタマイズできます。
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SAML.html
  role_assertion = null

  # email_assertion (Optional)
  # 設定内容: SAML assertion内のどの属性をユーザーのメールアドレスとして使用するかを指定します。
  # 設定可能な値: SAML assertionに含まれる属性名（例: "mail", "email"）
  # 省略時: IDプロバイダーから提供されるデフォルトのメール属性が使用されます。
  # 関連機能: Assertion属性マッピング
  #   ユーザーのメールアドレスは通知やユーザー識別に使用されます。
  email_assertion = null

  # login_assertion (Optional)
  # 設定内容: SAML assertion内のどの属性をユーザーのログイン名として使用するかを指定します。
  # 設定可能な値: SAML assertionに含まれる属性名（例: "username", "login"）
  # 省略時: IDプロバイダーから提供されるデフォルトのログイン名属性が使用されます。
  # 関連機能: Assertion属性マッピング
  #   ログイン名はGrafana UI内でのユーザー識別子として表示されます。
  login_assertion = null

  # name_assertion (Optional)
  # 設定内容: SAML assertion内のどの属性をユーザーの表示名（フルネーム）として使用するかを指定します。
  # 設定可能な値: SAML assertionに含まれる属性名（例: "displayName", "name"）
  # 省略時: IDプロバイダーから提供されるデフォルトの名前属性が使用されます。
  # 関連機能: Assertion属性マッピング
  #   ユーザーの表示名は、Grafana UI内でユーザーを識別しやすくするために使用されます。
  name_assertion = null

  # groups_assertion (Optional)
  # 設定内容: SAML assertion内のどの属性をユーザーのグループ情報として使用するかを指定します。
  # 設定可能な値: SAML assertionに含まれる属性名（例: "groups", "memberOf"）
  # 省略時: グループマッピングは実行されません。
  # 関連機能: グループマッピング
  #   IDプロバイダーで定義されたグループをGrafanaのチームにマッピングし、
  #   グループ単位でのアクセス制御を実装できます。
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SAML.html
  groups_assertion = null

  # org_assertion (Optional)
  # 設定内容: SAML assertion内のどの属性をユーザーの組織情報として使用するかを指定します。
  # 設定可能な値: SAML assertionに含まれる属性名（例: "organization", "org"）
  # 省略時: 組織マッピングは実行されません。
  # 関連機能: 組織マッピング
  #   複数の組織を持つIDプロバイダーの場合、ユーザーが所属する組織情報を
  #   Grafanaに連携できます。
  org_assertion = null

  #-------------------------------------------------------------
  # セッション設定
  #-------------------------------------------------------------

  # login_validity_duration (Optional)
  # 設定内容: SAMLユーザーのログインセッションの有効期間を秒単位で指定します。
  # 設定可能な値: 正の整数（秒）
  # 省略時: デフォルトのセッション期間が適用されます。
  # 関連機能: セッション管理
  #   指定した期間が経過すると、ユーザーは再度サインインが必要になります。
  #   セキュリティ要件に応じて適切な値を設定してください。
  #   - https://docs.aws.amazon.com/grafana/latest/APIReference/API_SamlConfiguration.html
  login_validity_duration = null

  #-------------------------------------------------------------
  # アクセス制御設定
  #-------------------------------------------------------------

  # allowed_organizations (Optional)
  # 設定内容: ワークスペースへのアクセスを許可する組織のリストを指定します。
  # 設定可能な値: 組織名の配列（SAML assertionに含まれる組織名）
  # 省略時: すべての組織がアクセス可能です。
  # 関連機能: 組織ベースのアクセス制御
  #   複数の組織を持つIDプロバイダーの場合、特定の組織に所属するユーザーのみに
  #   ワークスペースへのアクセスを制限できます。
  #   - https://docs.aws.amazon.com/grafana/latest/userguide/authentication-in-AMG-SAML.html
  allowed_organizations = []

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: SAML設定の作成タイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます。
    create = null

    # delete (Optional)
    # 設定内容: SAML設定の削除タイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（通常はworkspace_idと同じ）
#
# - status: SAML設定のステータス
#          設定の有効/無効状態を示します。
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_grafana_workspace_saml_configuration" "example" {
#   editor_role_values = ["editor"]
#   idp_metadata_url   = "https://my_idp_metadata.url"
#   workspace_id       = aws_grafana_workspace.example.id
# }
#
# resource "aws_grafana_workspace" "example" {
#   account_access_type      = "CURRENT_ACCOUNT"
#   authentication_providers = ["SAML"]
#   permission_type          = "SERVICE_MANAGED"
#   role_arn                 = aws_iam_role.assume.arn
# }
#---------------------------------------------------------------
