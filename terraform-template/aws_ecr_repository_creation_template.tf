#---------------------------------------------------------------
# ECR Repository Creation Template
#---------------------------------------------------------------
#
# Provides an Elastic Container Registry (ECR) Repository Creation Template
# that defines default settings for repositories automatically created by
# Amazon ECR during pull through cache, create on push, or replication actions.
#
# Repository creation templates allow you to specify configurations such as
# encryption, tag immutability, lifecycle policies, repository policies, and
# resource tags that will be automatically applied to new repositories created
# by ECR on your behalf.
#
# AWS公式ドキュメント:
#   - Repository Creation Templates Overview: https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-creation-templates.html
#   - Creating a Repository Creation Template: https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-creation-templates-create.html
#   - CreateRepositoryCreationTemplate API: https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_CreateRepositoryCreationTemplate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_creation_template
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecr_repository_creation_template" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) リポジトリ名のプレフィックスを指定します。
  # このプレフィックスに一致するリポジトリが作成される際に、このテンプレートの設定が適用されます。
  # 例: "prod" を指定すると "prod/" で始まる全てのリポジトリに適用されます。
  # 特殊値: "ROOT" を指定すると、他のテンプレートに一致しない全てのリポジトリに適用されます。
  # 注意: プレフィックスの末尾には常に "/" が自動的に追加されます。
  # Forces new resource: この値を変更すると新しいリソースが作成されます。
  prefix = "example"

  # (Required) このテンプレートを適用する機能を指定します。
  # 有効な値: "CREATE_ON_PUSH", "PULL_THROUGH_CACHE", "REPLICATION"
  # 1つ以上の値を指定する必要があります。
  # - CREATE_ON_PUSH: イメージプッシュ時にリポジトリが存在しない場合に作成
  # - PULL_THROUGH_CACHE: プルスルーキャッシュルールで初めて使用する際に作成
  # - REPLICATION: レプリケーション時に作成
  applied_for = ["PULL_THROUGH_CACHE"]

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) このテンプレートの説明文です。
  # テンプレートの目的や用途を記述するために使用します。
  description = null

  # (Optional) リポジトリ作成時に使用するカスタムIAMロールのARNです。
  # リポジトリタグやKMS暗号化を使用する場合は必須です。
  # このロールはECRがリポジトリを作成・設定する際に引き受けます。
  # 例: "arn:aws:iam::123456789012:role/ecr-repository-creation-role"
  custom_role_arn = null

  # (Optional) 作成されるリポジトリのイメージタグ可変性設定です。
  # 有効な値:
  # - "MUTABLE" (デフォルト): タグを上書き可能。プルスルーキャッシュには推奨。
  # - "IMMUTABLE": 全てのタグが不変となり、上書きできません。
  # - "IMMUTABLE_WITH_EXCLUSION": 基本は不変だが、除外フィルターで指定したタグは可変。
  # - "MUTABLE_WITH_EXCLUSION": 基本は可変だが、除外フィルターで指定したタグは不変。
  # プルスルーキャッシュで使用する場合は、ECRがキャッシュを更新できるよう
  # MUTABLEの使用が推奨されます。
  image_tag_mutability = null

  # (Optional) 作成されるリポジトリに適用するライフサイクルポリシーです。
  # JSON形式の文字列でポリシーを定義します。
  # ライフサイクルポリシーは、イメージの有効期限を設定し、
  # 古いイメージや未使用のイメージを自動的にクリーンアップするために使用します。
  # 各ルールには、優先度、説明、選択条件（タグステータス、カウントタイプ等）、
  # アクション（expire等）を指定します。
  # aws_ecr_lifecycle_policy_document データソースの使用を検討してください。
  # 参考: https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html
  lifecycle_policy = null

  # (Optional) AWS リージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # このリソースが管理されるリージョンを明示的に指定する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) 作成されるリポジトリに適用するリポジトリポリシーです。
  # JSON形式の文字列でポリシードキュメントを定義します。
  # リソースベースのアクセス許可を使用して、リポジトリへのアクセスを制御します。
  # どのIAMユーザーやロールがリポジトリにアクセスでき、
  # どのアクションを実行できるかを指定できます。
  # デフォルトでは、リポジトリを作成したAWSアカウントのみがアクセス可能です。
  # aws_iam_policy_document データソースの使用を検討してください。
  # 参考: https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policies.html
  repository_policy = null

  # (Optional) 作成されるリポジトリに割り当てるタグのマップです。
  # タグは、リポジトリを分類・整理するために使用するメタデータです。
  # 各タグはキーと値のペアで構成されます。
  # 例: { Environment = "production", Team = "platform" }
  # 注意: リポジトリタグを使用する場合は custom_role_arn の指定が必須です。
  resource_tags = null

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # (Optional) 作成されるリポジトリの暗号化設定です。
  # ECRリポジトリのイメージを暗号化する方法を指定します。
  # 最大1ブロックまで指定可能です。
  encryption_configuration {
    # (Optional) 暗号化タイプを指定します。
    # 有効な値:
    # - "AES256" (デフォルト): Amazon S3マネージド暗号化キーによるサーバー側暗号化
    # - "KMS": AWS KMSキーによるサーバー側暗号化
    # - "KMS_DSSE": AWS KMSによる二重層サーバー側暗号化（AWS GovCloud (US)リージョンのみ）
    # KMSを使用する場合、デフォルトのAWSマネージドキーか、
    # 独自に作成したKMSキーを使用できます。
    # クロスリージョンレプリケーションでKMSを使用する場合は追加の権限が必要です。
    # 参考: https://docs.aws.amazon.com/AmazonECR/latest/userguide/encryption-at-rest.html
    encryption_type = "AES256"

    # (Optional) KMS暗号化キーのARNです。
    # encryption_type が "KMS" または "KMS_DSSE" の場合に使用します。
    # 指定しない場合は、ECRのデフォルトAWSマネージドキーが使用されます。
    # 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    # Computed: この値が指定されていない場合、AWSによって自動的に設定されます。
    kms_key = null
  }

  # (Optional) イメージタグ可変性の除外フィルター設定です。
  # image_tag_mutability が "IMMUTABLE_WITH_EXCLUSION" または
  # "MUTABLE_WITH_EXCLUSION" の場合にのみ適用されます。
  # デフォルトのタグ可変性設定を上書きできるイメージタグを指定するフィルターを定義します。
  # 最大5ブロックまで指定可能です。
  #
  # 使用例:
  # - IMMUTABLE_WITH_EXCLUSION: 基本的にタグは不変だが、特定のタグ（例: latest, dev-*）は可変
  # - MUTABLE_WITH_EXCLUSION: 基本的にタグは可変だが、特定のタグ（例: v*）は不変
  image_tag_mutability_exclusion_filter {
    # (Required) イメージタグを除外するために使用するフィルターパターンです。
    # 英字、数字、特殊文字（._*-）のみを含む必要があります。
    # 最大128文字まで、最大2つのワイルドカード（*）を含むことができます。
    # 例:
    # - "latest" - latestタグに一致
    # - "dev-*" - dev-で始まる全てのタグに一致
    # - "v*.*.*" - セマンティックバージョニング形式のタグに一致
    # パターン: ^[0-9a-zA-Z._*-]{1,128}$
    filter = "latest"

    # (Required) 使用するフィルタータイプです。
    # 有効な値: "WILDCARD"
    # 現在はWILDCARDタイプのみがサポートされています。
    filter_type = "WILDCARD"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - id
#     リソースのID。prefixと同じ値です。
#
# - registry_id
#     このリポジトリ作成テンプレートが適用されるレジストリIDです。
#     通常、AWSアカウントIDと同じ値になります。
#
#---------------------------------------------------------------
