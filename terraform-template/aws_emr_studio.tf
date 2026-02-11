#---------------------------------------------------------------
# Amazon EMR Studio
#---------------------------------------------------------------
#
# Amazon EMR Studioは、データサイエンティストやエンジニアがJupyterノートブックを
# 使用してEMRクラスター上でデータ処理アプリケーションを開発・実行・デバッグできる
# 統合開発環境（IDE）をプロビジョニングします。
#
# AWS公式ドキュメント:
#   - Amazon EMR Studio の仕組み: https://docs.aws.amazon.com/emr/latest/ManagementGuide/how-emr-studio-works.html
#   - EMR Studio認証モードの選択: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-authentication.html
#   - EMR Studioセキュリティグループの定義: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-security-groups.html
#   - EMR Studioの作成: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-create-studio.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/emr_studio
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emr_studio" "example" {

  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # Amazon EMR Studioの認証モードを指定します。
  # - "SSO": IAM Identity Center認証モード（旧AWS SSO）を使用
  # - "IAM": IAM認証モード（IAM認証またはIAMフェデレーション）を使用
  #
  # IAM Identity Centerモードの利点:
  # - ユーザーとグループの割り当てが容易
  # - Microsoft Active DirectoryおよびSAML 2.0 IDプロバイダーと連携
  # - マルチアカウント環境でのフェデレーション設定が簡素化
  #
  # IAMモードの利点:
  # - 既存のIAM認証・フェデレーション設定を活用可能
  # - OIDC/SAML 2.0互換のIDプロバイダーと連携
  # - 同一AWSアカウントで複数のIDプロバイダーを使用可能
  # - より広範囲のAWSリージョンで利用可能
  auth_mode = "SSO"

  # Amazon EMR Studio Workspaceとノートブックファイルのバックアップ先となる
  # Amazon S3ロケーションを指定します。
  # Studioでは、Workspaceのノートブックファイルを自動的にS3にバックアップします。
  # フォーマット: "s3://bucket-name/path"
  default_s3_location = "s3://example-bucket/emr-studio-backup"

  # Engine Security GroupのIDを指定します。
  # このセキュリティグループは、Workspace Security Groupからのインバウンド
  # ネットワークトラフィックを許可し、EMRクラスターとの通信に使用されます。
  #
  # 必須ルール:
  # - インバウンド: TCP 18888ポートでWorkspace Security Groupからのトラフィックを許可
  #
  # 注意: vpc_idで指定されたVPCと同じVPC内に存在する必要があります。
  engine_security_group_id = "sg-0123456789abcdef0"

  # Amazon EMR Studioのわかりやすい名前を指定します。
  # この名前はAWSコンソールやCLIでStudioを識別する際に使用されます。
  name = "example-studio"

  # Amazon EMR Studioが引き受けるIAMロールのARNを指定します。
  # このサービスロールにより、EMR Studioは他のAWSサービスと連携できます。
  #
  # 必要な権限:
  # - EMRクラスター、S3バケット、セキュリティグループなどへのアクセス
  # - Workspaceの作成・管理に必要なアクション
  service_role = "arn:aws:iam::123456789012:role/EMRStudioServiceRole"

  # Amazon EMR Studioに関連付けるサブネットIDのリストを指定します。
  # Studioユーザーは、指定されたいずれかのサブネット内にWorkspaceを作成できます。
  #
  # 制限事項:
  # - 最大5つまでのサブネットを指定可能
  # - すべてのサブネットはvpc_idで指定されたVPCに属している必要があります
  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0123456789abcdef1",
  ]

  # Amazon EMR Studioに関連付けるAmazon VPCのIDを指定します。
  # このVPC内でStudioのWorkspaceとEMRクラスターが動作します。
  # EMR on EKSを使用する場合は、EKSクラスターワーカーノードのVPCを指定します。
  vpc_id = "vpc-0123456789abcdef0"

  # Workspace Security GroupのIDを指定します。
  # このセキュリティグループは、Workspace内からのアウトバウンド
  # ネットワークトラフィックを制御します。
  #
  # 必須ルール:
  # - アウトバウンド: TCP 18888ポートでEngine Security Groupへのトラフィックを許可
  # - アウトバウンド: HTTPS（TCP 443）でインターネットへのトラフィックを許可
  #   （Gitリポジトリのリンクに必要）
  #
  # 注意:
  # - vpc_idで指定されたVPCと同じVPC内に存在する必要があります
  # - インバウンドトラフィックは許可できません
  workspace_security_group_id = "sg-0123456789abcdef1"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # Amazon EMR Studioの詳細な説明を指定します。
  # この説明は、Studioの目的や用途を明確にするために使用できます。
  description = "EMR Studio for data analytics team"

  # Amazon EMR Studio WorkspaceとノートブックファイルをS3にバックアップする際の
  # 暗号化に使用するAWS KMSキーのARNを指定します。
  # 指定しない場合、S3のデフォルト暗号化設定が使用されます。
  # encryption_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # IDプロバイダー（IdP）の認証エンドポイントを指定します。
  # IAM認証モードを使用し、フェデレーションユーザーがStudioのURLと
  # IdPの認証情報でログインできるようにする場合に指定します。
  # EMR Studioは、ユーザーをこのエンドポイントにリダイレクトして認証情報を入力させます。
  #
  # 一般的なIDプロバイダーの認証URL例:
  # - Okta: https://<your-domain>.okta.com/app/<app-name>/<app-id>/sso/saml
  # - Azure AD: https://login.microsoftonline.com/<tenant-id>/saml2
  # - Auth0: https://<your-domain>.auth0.com/samlp/<client-id>
  # idp_auth_url = "https://example.okta.com/app/example/sso/saml"

  # IDプロバイダー（IdP）がRelayStateパラメータに使用する名前を指定します。
  # IAM認証モードを使用し、フェデレーションユーザーがStudioのURLでログインできるように
  # する場合に指定します。RelayStateパラメータはIdPごとに異なります。
  #
  # 一般的なIDプロバイダーのRelayStateパラメータ名:
  # - Okta: RelayState
  # - Azure AD: RelayState
  # - Auth0: RelayState
  # - PingFederate: TargetResource
  # - PingOne: TargetResource
  # idp_relay_state_parameter_name = "RelayState"

  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 明示的にリージョンを指定する必要がある場合に使用します。
  # region = "us-east-1"

  # EMR Studioに適用するタグのマップを指定します。
  # プロバイダーのdefault_tags設定ブロックがある場合、
  # 同じキーのタグはプロバイダーレベルで定義されたタグを上書きします。
  tags = {
    Environment = "production"
    Team        = "data-analytics"
    Project     = "ml-platform"
  }

  # ユーザーとグループがAmazon EMR Studioにログインする際に引き受けるIAMロールのARNを
  # 指定します。
  # AWS IAM Identity Center（旧AWS SSO）認証モードを使用する場合にのみ指定します。
  #
  # このUser Roleに付与された権限は、セッションポリシーを使用して
  # ユーザーまたはグループごとにスコープダウンできます。
  # これにより、きめ細かなアクセス制御が可能になります。
  # user_role = "arn:aws:iam::123456789012:role/EMRStudioUserRole"

}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 上記の引数に加えて、以下の属性がエクスポートされます:
#
# - arn
#   StudioのAmazon Resource Name (ARN)
#   例: "arn:aws:elasticmapreduce:us-east-1:123456789012:studio/es-XXXXXXXXXXXXX"
#
# - id
#   StudioのID（arnと同じ値）
#
# - tags_all
#   リソースに割り当てられた全てのタグのマップ
#   （プロバイダーのdefault_tags設定ブロックで指定されたタグを含む）
#
# - url
#   Amazon EMR Studioの一意のアクセスURL
#   ユーザーはこのURLを使用してStudioにアクセスします
#   例: "https://<studio-id>.emrstudio-prod.<region>.amazonaws.com"
#
#---------------------------------------------------------------
