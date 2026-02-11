#---------------------------------------------------------------
# Elasticsearch Domain SAML Options
#---------------------------------------------------------------
#
# Elasticsearch DomainのSAML認証オプションを管理するリソース。
# SAML (Security Assertion Markup Language) を使用してOpenSearch Dashboards
# (旧Elasticsearch Kibana) へのシングルサインオン (SSO) 認証を構成できます。
#
# AWS公式ドキュメント:
#   - SAML authentication for OpenSearch Dashboards: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/saml.html
#   - SAMLOptionsInput API Reference: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_SAMLOptionsInput.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain_saml_options
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticsearch_domain_saml_options" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Elasticsearch Domainの名前
  # SAML認証オプションを適用する対象のドメインを指定
  domain_name = "example-domain"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リソースが管理されるAWSリージョン
  # 指定しない場合はプロバイダー設定のリージョンが使用される
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # SAML認証設定
  #---------------------------------------------------------------

  saml_options {
    # SAML認証の有効化フラグ (デフォルト: false)
    # true に設定するとドメインでSAML認証が有効になる
    enabled = true

    # SAML IdP (Identity Provider) からのバックエンドロール
    # このロールはクラスターへのフル権限を持つマスターユーザーと同等の権限を受け取る
    # ロールベースでのアクセス制御を行う場合に使用
    # 最小長: 1文字、最大長: 256文字
    master_backend_role = null

    # SAML IdP からのユーザー名
    # このユーザーはクラスターへのフル権限を持つマスターユーザーと同等の権限を受け取る
    # ユーザーベースでのアクセス制御を行う場合に使用
    # 最小長: 1文字、最大長: 64文字
    # センシティブな値として扱われる
    master_user_name = null

    # バックエンドロールに使用するSAMLアサーション要素
    # デフォルト: "roles"
    # IdPからのSAMLレスポンスでロール情報を含む属性名を指定
    roles_key = null

    # ユーザーログイン後のセッション継続時間（分）
    # デフォルト: 60分
    # 最小値: 1分、最大値: 1440分（24時間）
    session_timeout_minutes = null

    # ユーザー名に使用するカスタムSAML属性
    # デフォルト: 空文字列 ("")
    # 空文字列の場合、ElasticsearchはSAML SubjectのNameID要素を使用する
    # カスタム属性を使用する場合は属性名を指定
    subject_key = null

    #---------------------------------------------------------------
    # Identity Provider (IdP) 設定
    #---------------------------------------------------------------

    idp {
      # SAML Identity ProviderにおけるアプリケーションのユニークなEntity ID
      # IdP側で設定したEntity IDと一致させる必要がある
      entity_id = "https://example.com"

      # SAML アプリケーションのメタデータ (XML形式)
      # IdPから取得したメタデータXMLファイルの内容を指定
      # file() 関数を使用してファイルから読み込むことが推奨される
      # 例: file("./saml-metadata.xml")
      metadata_content = "<EntityDescriptor>...</EntityDescriptor>"
    }
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 更新操作のタイムアウト時間
    # デフォルト値が適用される
    # 例: "60m"
    update = null

    # 削除操作のタイムアウト時間
    # デフォルト値が適用される
    # 例: "60m"
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id: SAML オプションが関連付けられているドメインの名前
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 基本的な使用例:
#
# resource "aws_elasticsearch_domain" "example" {
#   domain_name           = "example"
#   elasticsearch_version = "7.10"
#
#   cluster_config {
#     instance_type = "r5.large.elasticsearch"
#   }
# }
#
# resource "aws_elasticsearch_domain_saml_options" "example" {
#   domain_name = aws_elasticsearch_domain.example.domain_name
#
#   saml_options {
#     enabled = true
#
#     idp {
#       entity_id        = "https://example.com"
#       metadata_content = file("./saml-metadata.xml")
#     }
#
#     master_backend_role      = "admin"
#     roles_key                = "Role"
#     session_timeout_minutes  = 120
#     subject_key              = "NameID"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
#
# 1. ドメインは一度に1つの認証方法のみをサポートします
#    (SAML または Cognito のいずれか)
#
# 2. SAML認証を有効にする前に、ドメインアクセスポリシーを更新して
#    SAMLユーザーがドメインにアクセスできるようにする必要があります
#
# 3. IdPメタデータファイルのサイズ制限に注意してください
#
# 4. Service Control Policies (SCP) は非IAMアイデンティティには適用されません
#
# 5. ログインフローは SP-initiated (Service Provider開始) または
#    IdP-initiated (Identity Provider開始) のいずれかを選択できます
#
# 6. Network Load Balancer (NLB) を使用している場合は互換性を確認してください
#
# 7. VPC内のプライベートドメインでもSAML認証は使用可能です
#    (ブラウザがIdPとクラスター両方と通信できる必要があります)
#
#---------------------------------------------------------------
