#---------------------------------------
# Terraform AWS EMR Studio Resource Template
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# 用途: Amazon EMR Studioワークスペース環境の作成・管理
#
# 主な機能:
# - Jupyter NotebookベースのIDE環境提供
# - AWS SSOまたはIAM認証によるアクセス制御
# - S3バックアップとKMS暗号化
# - VPC内でのセキュアなワークスペース実行
# - フェデレーションユーザーのIdP統合
#
# NOTE: auth_modeは作成後変更不可、変更時はリソース再作成が必要
#
# 関連ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_studio
#---------------------------------------

resource "aws_emr_studio" "example" {
  #-----------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------

  # Studioの名前
  # 設定内容: EMR Studioのわかりやすい名前
  # 補足: Studioの識別に使用され、コンソールやAPIで表示される
  name = "example-emr-studio"

  # 認証モード
  # 設定内容: Studioへのアクセス認証方式
  # 設定可能な値: "SSO" | "IAM"
  # 補足: SSOはAWS IAM Identity Center（旧AWS SSO）経由の認証、IAMはIAMユーザー/ロール認証
  auth_mode = "SSO"

  # デフォルトS3ロケーション
  # 設定内容: ワークスペースやノートブックファイルのバックアップ先S3 URI
  # 補足: s3://bucket-name/prefix形式で指定、定期的な自動バックアップに使用される
  default_s3_location = "s3://example-bucket/emr-studio/"

  # サービスロールARN
  # 設定内容: EMR Studioが使用するIAMロールのARN
  # 補足: EMR Studio用の適切な権限（S3、EC2、EMRへのアクセス）が必要
  service_role = "arn:aws:iam::123456789012:role/EMRStudioServiceRole"

  # VPC ID
  # 設定内容: Studioに関連付けるVPCのID
  # 補足: ワークスペースはこのVPC内で実行される
  vpc_id = "vpc-0123456789abcdef0"

  # サブネットID一覧
  # 設定内容: Studioワークスペースで使用可能なサブネットIDのリスト
  # 補足: 最大5つまで指定可能、すべてvpc_idで指定したVPCに属している必要がある
  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0123456789abcdef1"
  ]

  # エンジンセキュリティグループID
  # 設定内容: EMR Studio EngineセキュリティグループのグループID
  # 補足: Workspaceセキュリティグループからのインバウンドトラフィックを許可、vpc_idと同一VPCである必要がある
  engine_security_group_id = "sg-0123456789abcdef0"

  # ワークスペースセキュリティグループID
  # 設定内容: EMR Studio WorkspaceセキュリティグループのグループID
  # 補足: Engineセキュリティグループへのアウトバウンドトラフィックを許可、vpc_idと同一VPCである必要がある
  workspace_security_group_id = "sg-0123456789abcdef1"

  #-----------------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #-----------------------------------------------------------------------

  # Studioの説明
  # 設定内容: Studioの詳細な説明文
  # 補足: 用途や管理者向けの注意事項などを記述
  description = "Data Science team EMR Studio for Spark development"

  # リージョン
  # 設定内容: リソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 補足: 通常はプロバイダー設定に委ねる
  region = "us-east-1"

  #-----------------------------------------------------------------------
  # オプションパラメータ - セキュリティ設定
  #-----------------------------------------------------------------------

  # 暗号化キーARN
  # 設定内容: ワークスペース・ノートブックファイルの暗号化に使用するKMSキーARN
  # 補足: S3バックアップ時の暗号化に使用される
  encryption_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-----------------------------------------------------------------------
  # オプションパラメータ - IAM認証設定
  #-----------------------------------------------------------------------

  # IdP認証URL
  # 設定内容: フェデレーションユーザーのログイン用IdP認証エンドポイントURL
  # 補足: IAM認証モード使用時に、フェデレーションユーザーがStudio URLで直接ログインできるよう設定
  idp_auth_url = "https://idp.example.com/auth"

  # IdP RelayStateパラメータ名
  # 設定内容: IdPが使用するRelayStateパラメータの名前
  # 設定可能な値: "RelayState" | "TargetSource" | その他IdP固有の値
  # 補足: IAM認証モード使用時に、IdP経由のログインフローで使用、IdPによって値が異なる
  idp_relay_state_parameter_name = "RelayState"

  #-----------------------------------------------------------------------
  # オプションパラメータ - ユーザーアクセス設定
  #-----------------------------------------------------------------------

  # ユーザーロールARN
  # 設定内容: ユーザーやグループがStudioログイン時に引き受けるIAMロールのARN
  # 補足: AWS SSO認証モード使用時のみ指定、セッションポリシーでユーザー/グループごとに権限スコープダウン可能
  user_role = "arn:aws:iam::123456789012:role/EMRStudioUserRole"

  #-----------------------------------------------------------------------
  # オプションパラメータ - タグ設定
  #-----------------------------------------------------------------------

  # リソースタグ
  # 設定内容: Studioに付与するタグのキーバリューマップ
  # 補足: コスト配分、リソース管理に使用、プロバイダーのdefault_tagsと統合される
  tags = {
    Environment = "Production"
    Team        = "DataScience"
    ManagedBy   = "Terraform"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference（参照専用属性）
#-----------------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能:
#
# arn - StudioのARN
# 補足: IAMポリシーやリソースベースポリシーでのStudio特定に使用
#
# url - Studioの一意なアクセスURL
# 補足: ユーザーがWebブラウザからStudioにアクセスする際に使用
#
# id - StudioのID（内部識別子）
# 補足: AWS APIやTerraformでのリソース識別に使用
#
# tags_all - プロバイダーdefault_tagsとマージされた全タグのマップ
# 補足: 明示的に指定したtagsとプロバイダーレベルのdefault_tagsを統合
