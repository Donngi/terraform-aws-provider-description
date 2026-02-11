# ============================================================================
# Amazon ECR Pull Through Cache Rule
# ============================================================================
# プルスルーキャッシュルールは、外部コンテナレジストリ(ECR Public、Docker Hub、
# Quay、GitHub Container Registry等)からイメージをプルする際に、自動的にECRプライベート
# レジストリにキャッシュする機能を提供します。これにより、アップストリームレジストリ
# からのダウンロード回数を削減し、レイテンシを改善できます。
#
# 主な利点:
# - アップストリームレジストリへのアクセス回数削減
# - イメージプル時のレイテンシ改善
# - レート制限回避(特にDocker Hubなど)
# - クロスリージョン/クロスアカウントのECR間でのイメージ同期
#
# AWS Documentation:
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule
# ============================================================================

# ----------------------------------------------------------------------------
# Example 1: ECR Public からのプルスルーキャッシュ
# ----------------------------------------------------------------------------
# ECR PublicからイメージをキャッシュするためのルールをROOTプレフィックスで作成
# 全てのリポジトリに適用される汎用的な設定
resource "aws_ecr_pull_through_cache_rule" "ecr_public_root" {
  # ----------------------------------------------------------------------------
  # ecr_repository_prefix - リポジトリプレフィックス (必須)
  # ----------------------------------------------------------------------------
  # アップストリームレジストリからのイメージをキャッシュする際に使用するプレフィックス
  #
  # - ROOTを指定すると、全てのリポジトリに適用される汎用的なルールになります
  # - カスタムプレフィックス(例: "ecr-public")を指定すると、特定のプレフィックスに
  #   マッチするリポジトリにのみ適用されます
  # - 一度作成すると変更できません(Forces new resource)
  #
  # 推奨事項:
  # - 特定のアップストリーム用には明示的なプレフィックスを使用
  # - ROOTは慎重に使用(全リポジトリに影響)
  ecr_repository_prefix = "ROOT"

  # ----------------------------------------------------------------------------
  # upstream_registry_url - アップストリームレジストリURL (必須)
  # ----------------------------------------------------------------------------
  # キャッシュ元となるアップストリームレジストリのURL
  #
  # サポートされているレジストリ:
  # - public.ecr.aws (Amazon ECR Public)
  # - registry.k8s.io (Kubernetes)
  # - quay.io (Quay)
  # - registry-1.docker.io (Docker Hub)
  # - ghcr.io (GitHub Container Registry)
  # - *.azurecr.io (Azure Container Registry)
  # - registry.gitlab.com (GitLab Container Registry)
  # - プライベートECRレジストリ (クロスアカウント/クロスリージョン)
  #
  # 一度作成すると変更できません(Forces new resource)
  upstream_registry_url = "public.ecr.aws"

  # credential_arn は ECR Public では不要(パブリックアクセス可能なため)
  # custom_role_arn は同一アカウント内のECRでは不要
}

# ----------------------------------------------------------------------------
# Example 2: Docker Hub からの認証付きプルスルーキャッシュ
# ----------------------------------------------------------------------------
# Docker Hubは認証が必要なため、Secrets Managerに保存された認証情報を使用
resource "aws_ecr_pull_through_cache_rule" "docker_hub" {
  ecr_repository_prefix = "docker-hub"
  upstream_registry_url = "registry-1.docker.io"

  # ----------------------------------------------------------------------------
  # credential_arn - 認証情報のARN (オプション)
  # ----------------------------------------------------------------------------
  # アップストリームレジストリに対する認証に使用するSecrets ManagerシークレットのARN
  #
  # 必要なレジストリ:
  # - Docker Hub (レート制限回避のため推奨)
  # - Quay (プライベートリポジトリアクセス時)
  # - GitHub Container Registry (プライベートリポジトリアクセス時)
  # - Azure Container Registry
  # - GitLab Container Registry (プライベートリポジトリアクセス時)
  #
  # シークレットの形式:
  # {
  #   "username": "your-username",
  #   "password": "your-password-or-token"
  # }
  #
  # 注意: ECR Publicやパブリックアクセス可能なレジストリでは不要
  credential_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:ecr-pullthroughcache/dockerhub-abc123"

  # 依存関係の例(Secrets Managerシークレットを同時に作成する場合)
  # depends_on = [aws_secretsmanager_secret_version.docker_hub_credentials]
}

# ----------------------------------------------------------------------------
# Example 3: GitHub Container Registry からのプルスルーキャッシュ
# ----------------------------------------------------------------------------
resource "aws_ecr_pull_through_cache_rule" "github" {
  ecr_repository_prefix = "ghcr"
  upstream_registry_url = "ghcr.io"

  # GitHub Container Registryの認証情報
  # Personal Access Token (PAT) を使用
  credential_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:ecr-pullthroughcache/github-xyz789"
}

# ----------------------------------------------------------------------------
# Example 4: Kubernetes レジストリからのプルスルーキャッシュ
# ----------------------------------------------------------------------------
# Kubernetes公式イメージをキャッシュ(認証不要)
resource "aws_ecr_pull_through_cache_rule" "kubernetes" {
  ecr_repository_prefix = "k8s"
  upstream_registry_url = "registry.k8s.io"

  # Kubernetes レジストリは認証不要(パブリック)
}

# ----------------------------------------------------------------------------
# Example 5: クロスアカウントECRからのプルスルーキャッシュ
# ----------------------------------------------------------------------------
# 別のAWSアカウントのプライベートECRレジストリからイメージをキャッシュ
resource "aws_ecr_pull_through_cache_rule" "cross_account_ecr" {
  ecr_repository_prefix = "cross-account-ecr"
  upstream_registry_url = "123456789012.dkr.ecr.us-west-2.amazonaws.com"

  # ----------------------------------------------------------------------------
  # custom_role_arn - カスタムIAMロールARN (オプション)
  # ----------------------------------------------------------------------------
  # プルスルーキャッシュルールに関連付けるIAMロールのARN
  #
  # 必須条件:
  # - アップストリームレジストリがクロスアカウントのECRプライベートレジストリの場合
  #
  # このロールには以下の権限が必要:
  # - アップストリームECRレジストリへのecr:BatchGetImageとecr:GetDownloadUrlForLayer
  # - 信頼ポリシーでECRサービスを許可
  #
  # 詳細: https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-private.html
  custom_role_arn = "arn:aws:iam::987654321098:role/ECRPullThroughCacheRole"

  # クロスアカウントECRでは通常credential_arnは不要
  # (IAMロールベースの認証を使用)
}

# ----------------------------------------------------------------------------
# Example 6: クロスリージョンECRからのプルスルーキャッシュ
# ----------------------------------------------------------------------------
# 同一アカウント内の別リージョンのECRレジストリからイメージをキャッシュ
resource "aws_ecr_pull_through_cache_rule" "cross_region_ecr" {
  ecr_repository_prefix = "us-west-2-ecr"
  upstream_registry_url = "123456789012.dkr.ecr.us-west-2.amazonaws.com"

  # ----------------------------------------------------------------------------
  # upstream_repository_prefix - アップストリームリポジトリプレフィックス (オプション)
  # ----------------------------------------------------------------------------
  # アップストリームレジストリがECRプライベートレジストリの場合に使用
  #
  # - 指定しない場合、デフォルトで "ROOT" が設定され、全てのアップストリーム
  #   リポジトリとマッチします
  # - カスタムプレフィックスを指定すると、そのプレフィックスにマッチする
  #   アップストリームリポジトリのみがキャッシュされます
  # - 一度作成すると変更できません(Forces new resource)
  #
  # 詳細: https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-private-wildcards.html
  upstream_repository_prefix = "production"

  # 同一アカウント内のクロスリージョンではcustom_role_arnは通常不要
}

# ----------------------------------------------------------------------------
# Example 7: Quayからのプルスルーキャッシュ
# ----------------------------------------------------------------------------
resource "aws_ecr_pull_through_cache_rule" "quay" {
  ecr_repository_prefix = "quay"
  upstream_registry_url = "quay.io"

  # Quayの認証情報(プライベートリポジトリアクセス時)
  credential_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:ecr-pullthroughcache/quay-def456"
}

# ----------------------------------------------------------------------------
# Example 8: リージョン指定付きプルスルーキャッシュ
# ----------------------------------------------------------------------------
# 特定のリージョンにプルスルーキャッシュルールを作成
resource "aws_ecr_pull_through_cache_rule" "regional" {
  ecr_repository_prefix = "ecr-public"
  upstream_registry_url = "public.ecr.aws"

  # ----------------------------------------------------------------------------
  # region - リージョン (オプション)
  # ----------------------------------------------------------------------------
  # このリソースを管理するリージョン
  #
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - 特定のリージョンでのみプルスルーキャッシュを有効化したい場合に使用
  #
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "ap-northeast-1"
}

# ============================================================================
# Attributes Reference
# ============================================================================
# このリソースは以下の属性をエクスポートします:
#
# - registry_id: リポジトリが作成されたレジストリID(AWSアカウントID)
#
# これらの属性は他のリソースから参照できます:
# aws_ecr_pull_through_cache_rule.example.registry_id
# ============================================================================

# ============================================================================
# Import
# ============================================================================
# 既存のプルスルーキャッシュルールは以下の形式でインポートできます:
#
# terraform import aws_ecr_pull_through_cache_rule.example ecr-repository-prefix
#
# 例:
# terraform import aws_ecr_pull_through_cache_rule.ecr_public_root ROOT
# terraform import aws_ecr_pull_through_cache_rule.docker_hub docker-hub
# ============================================================================

# ============================================================================
# 使用方法とベストプラクティス
# ============================================================================
#
# 1. イメージのプル方法:
#    プルスルーキャッシュルールを作成後、以下の形式でイメージをプル:
#
#    docker pull <registry-id>.dkr.ecr.<region>.amazonaws.com/<repository-prefix>/<upstream-image>
#
#    例(ECR Public):
#    docker pull 123456789012.dkr.ecr.us-east-1.amazonaws.com/ecr-public/amazonlinux:latest
#
#    例(Docker Hub):
#    docker pull 123456789012.dkr.ecr.us-east-1.amazonaws.com/docker-hub/library/nginx:latest
#
# 2. 自動リポジトリ作成:
#    初回のイメージプル時、ECRは自動的にリポジトリを作成します
#    Repository Creation Templateを使用してリポジトリ設定をカスタマイズ可能
#
# 3. レート制限対策:
#    Docker Hubなどのレート制限があるレジストリでは、認証情報を設定することを推奨
#
# 4. セキュリティ考慮事項:
#    - Secrets Managerのシークレットは適切にローテーション
#    - IAMロールには最小権限の原則を適用
#    - VPCエンドポイント経由でのアクセスを検討(ネットワークトラフィック削減)
#
# 5. コスト最適化:
#    - キャッシュされたイメージはECRストレージとして課金対象
#    - ライフサイクルポリシーで古いイメージを自動削除
#    - 頻繁に使用するイメージのみをキャッシュ
#
# 6. マルチリージョン戦略:
#    - プライマリリージョンにイメージをプッシュ
#    - 他のリージョンではプルスルーキャッシュを設定
#    - レイテンシ改善とコスト削減の両立
#
# 7. モニタリング:
#    - CloudWatch Metricsでキャッシュヒット率を監視
#    - CloudTrailでプルスルーキャッシュの使用状況を追跡
#
# ============================================================================
# トラブルシューティング
# ============================================================================
#
# 1. "Repository does not exist" エラー:
#    - リポジトリURIが正しいか確認
#    - 必要なIAM権限(ecr:CreateRepository等)があるか確認
#
# 2. "Requested image not found" エラー:
#    - イメージ名とタグが正しいか確認
#    - アップストリームレジストリでイメージが存在するか確認
#
# 3. "403 Forbidden" (Docker Hub):
#    - Docker Hub Official Imageの場合、"/library/"を含める
#    - 例: docker-hub/library/nginx:latest
#
# 4. クロスアカウントECRアクセスエラー:
#    - custom_role_arnが正しく設定されているか確認
#    - IAMロールの信頼ポリシーとアクセス権限を確認
#    - アップストリームECRのリポジトリポリシーを確認
#
# 詳細: https://docs.aws.amazon.com/AmazonECR/latest/userguide/error-pullthroughcache.html
# ============================================================================

# ============================================================================
# 関連リソース
# ============================================================================
# - aws_ecr_repository: ECRリポジトリの作成と管理
# - aws_ecr_repository_creation_template: リポジトリ作成テンプレート
# - aws_ecr_lifecycle_policy: イメージライフサイクル管理
# - aws_secretsmanager_secret: 認証情報の保存
# - aws_iam_role: カスタムロールの作成(クロスアカウント用)
# ============================================================================
