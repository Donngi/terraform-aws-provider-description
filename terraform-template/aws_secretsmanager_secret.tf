#---------------------------------------------------------------
# AWS Secrets Manager Secret
#---------------------------------------------------------------
#
# AWS Secrets Manager のシークレットメタデータを管理するリソースです。
# このリソースはシークレットのメタデータ(名前、説明、暗号化キー、レプリケーション設定など)を管理します。
# シークレットの実際の値の管理には aws_secretsmanager_secret_version リソースを、
# ローテーション設定には aws_secretsmanager_secret_rotation リソースを使用します。
#
# AWS Secrets Managerは以下の機能を提供します:
#   - シークレットの暗号化保存: KMS統合による暗号化
#   - 自動ローテーション: Lambda関数またはマネージドローテーションによる自動更新
#   - マルチリージョンレプリケーション: 複数リージョンへのシークレット複製
#   - きめ細かなアクセス制御: IAMポリシーによる柔軟な権限管理
#
# AWS公式ドキュメント:
#   - Secrets Manager 概要: https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
#   - シークレットの作成と管理: https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_create-basic-secret.html
#   - シークレットのローテーション: https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
#   - Secrets Manager API リファレンス: https://docs.aws.amazon.com/secretsmanager/latest/apireference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_secretsmanager_secret" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Computed)
  # 設定内容: シークレットの名前を指定します。
  # 設定可能な値: 大文字、小文字、数字、および以下の文字を含む文字列: /_+=.@-
  # 注意: name_prefixとは同時に使用できません
  # 関連機能: AWS Secrets Manager シークレット名
  #   シークレットを一意に識別する名前。同一リージョン内で一意である必要があります。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_create-basic-secret.html
  name = "example-secret"

  # name_prefix (Optional, Computed)
  # 設定内容: 指定されたプレフィックスで始まる一意の名前を自動生成します。
  # 設定可能な値: 文字列プレフィックス
  # 注意: nameとは同時に使用できません
  # 用途: 複数のシークレットを動的に作成する場合や、名前の一意性を自動保証したい場合に有効
  # 関連機能: Terraform リソース命名
  #   Terraformがランダムな文字列を追加して一意の名前を生成します。
  name_prefix = null

  # description (Optional)
  # 設定内容: シークレットの説明を指定します。
  # 設定可能な値: 任意の文字列 (最大2048文字)
  # 用途: シークレットの目的や用途を記述し、管理を容易にします
  # 関連機能: AWS Secrets Manager メタデータ
  #   シークレットの用途をチームメンバーに明確に伝えるための説明文。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_update-secret.html
  description = "Example secret for demonstration purposes"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: シークレット値の暗号化に使用するAWS KMSキーのARNまたはIDを指定します。
  # 設定可能な値:
  #   - KMSキーのARN (フルARN形式)
  #   - KMSキーのID (UUID形式)
  #   - 別アカウントのキーを参照する場合はARNのみ使用可能
  # 省略時: AWSアカウントのデフォルトKMSキー (aws/secretsmanager) を使用
  #   デフォルトキーが存在しない場合は自動的に作成されます
  # 関連機能: AWS KMS 暗号化
  #   カスタマーマネージドキーを使用することで、より細かい暗号化制御とアクセス管理が可能。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/security-encryption.html
  kms_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: AWSリージョナルエンドポイント
  #   シークレットを特定のリージョンに配置し、レイテンシとデータ主権要件を管理。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # リソースポリシー
  #-------------------------------------------------------------

  # policy (Optional, Computed)
  # 設定内容: シークレットへのアクセスを制御するリソースベースのポリシーを指定します。
  # 設定可能な値: 有効なJSON形式のIAMポリシードキュメント
  # 注意:
  #   - policyをnullまたは空文字列に設定してもポリシーは削除されません
  #     (aws_secretsmanager_secret_policyリソースで設定された可能性があるため)
  #   - ポリシーを削除するには "{}" (空のJSONドキュメント) を設定します
  # 関連機能: AWS IAM リソースベースポリシー
  #   他のAWSアカウントやサービスにシークレットへのアクセス権限を付与可能。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_resource-based-policies.html
  #   - Terraform IAMポリシードキュメントガイド: https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # recovery_window_in_days (Optional)
  # 設定内容: シークレットを削除する前にAWS Secrets Managerが待機する日数を指定します。
  # 設定可能な値:
  #   - 0: 即座に削除 (復旧不可能)
  #   - 7～30: 指定された日数後に削除 (復旧可能期間)
  # デフォルト値: 30日
  # 注意: 削除されたシークレットは復旧ウィンドウ内であれば復元可能です
  # 関連機能: AWS Secrets Manager シークレット削除保護
  #   誤削除を防ぐための復旧期間。期間中はシークレット名を再利用できません。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_delete-restore-secret.html
  recovery_window_in_days = 30

  #-------------------------------------------------------------
  # レプリケーション設定
  #-------------------------------------------------------------

  # replica (Optional)
  # 設定内容: シークレットのレプリケーション設定を定義します。
  # 用途: マルチリージョン環境でシークレットを複製し、可用性を向上させる
  # 関連機能: AWS Secrets Manager レプリケーション
  #   プライマリシークレットを複数のリージョンに自動的に複製します。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/create-manage-multi-region-secrets.html
  replica {
    # region (Required)
    # 設定内容: シークレットをレプリケートする先のリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード
    # 注意: プライマリリージョンとは異なるリージョンを指定する必要があります
    region = "us-west-2"

    # kms_key_id (Optional, Computed)
    # 設定内容: レプリカリージョン内でシークレットを暗号化するために使用するKMSキーのARN、キーID、またはエイリアスを指定します。
    # 設定可能な値: レプリカリージョン内のKMSキーのARN、ID、またはエイリアス
    # 省略時: レプリカリージョンのデフォルトKMSキー (aws/secretsmanager) を使用
    #   デフォルトキーが存在しない場合は自動的に作成されます
    # 注意: 各リージョンのKMSキーはそのリージョン固有のものである必要があります
    kms_key_id = null
  }

  # force_overwrite_replica_secret (Optional)
  # 設定内容: レプリカリージョンに同名のシークレットが存在する場合に上書きするかどうかを指定します。
  # 設定可能な値:
  #   - true: 既存のシークレットを上書き
  #   - false: エラーを返す (デフォルト)
  # 注意: trueに設定すると既存のシークレットが完全に置き換えられます
  # 関連機能: AWS Secrets Manager レプリケーション競合解決
  #   既存のシークレットとの名前衝突を処理します。
  force_overwrite_replica_secret = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ (最大50タグ)
  # 用途: コスト配分、リソース管理、アクセス制御などに使用
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/managing-secrets.html
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-secret"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。シークレットのARNと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: シークレットのAmazon Resource Name (ARN)
#
# - arn: シークレットのAmazon Resource Name (ARN)
#
# - replica: レプリカの属性
#   各レプリカには以下の属性が含まれます:
#   - last_accessed_date: リージョンでシークレットに最後にアクセスした日付
#   - status: ステータス。"InProgress"、"Failed"、または "InSync" のいずれか
#   - status_message: "Replication succeeded" や "Secret with this name already exists in this region" などのメッセージ
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
#
# # シンプルなシークレット
# resource "aws_secretsmanager_secret" "simple" {
#   name        = "my-simple-secret"
#   description = "Simple secret without replication"
# }
#---------------------------------------------------------------
