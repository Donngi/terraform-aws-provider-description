#---------------------------------------------------------------
# AWS Lake Formation Resource
#---------------------------------------------------------------
#
# AWS Lake Formationリソース（例: S3バケット）をData Catalogで管理されるリソースとして
# 登録するリソースです。つまり、S3パスをデータレイクに追加します。
#
# Lake Formationは、データレイクのセットアップ、セキュリティ管理、ガバナンスを
# 簡素化するサービスです。S3パスを登録することで、Lake Formationのきめ細かい
# アクセス制御とデータカタログ機能を活用できます。
#
# AWS公式ドキュメント:
#   - Lake Formation 概要: https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html
#   - Lake Formation でのリソース登録: https://docs.aws.amazon.com/lake-formation/latest/dg/register-data-lake.html
#   - Lake Formation API リファレンス: https://docs.aws.amazon.com/lake-formation/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_resource
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_resource" "example" {
  #-------------------------------------------------------------
  # リソース識別設定
  #-------------------------------------------------------------

  # arn (Required)
  # 設定内容: Lake Formationで管理するリソースのAmazon Resource Name (ARN) を指定します。
  # 設定可能な値: S3バケットまたはS3パスのARN
  # 用途: データレイクに登録するS3リソースを指定
  # 関連機能: Lake Formation リソース登録
  #   S3バケットやパスをLake Formationのデータカタログに登録することで、
  #   きめ細かいアクセス制御、データ検出、ガバナンスが可能になります。
  #   - https://docs.aws.amazon.com/lake-formation/latest/dg/register-data-lake.html
  arn = "arn:aws:s3:::my-data-lake-bucket/data/"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: リソースへの読み取り/書き込みアクセス権を持つIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 用途: カスタムIAMロールを使用してLake Formationがリソースにアクセスする場合に指定
  # 注意: use_service_linked_roleと排他的（どちらか一方のみ指定可能）
  # 関連機能: Lake Formation IAMロール
  #   Lake Formationがデータレイクリソースにアクセスするために使用するIAMロールを指定。
  #   カスタムロールまたはサービスリンクロールを選択可能。
  #   - https://docs.aws.amazon.com/lake-formation/latest/dg/registration-role.html
  role_arn = null

  # use_service_linked_role (Optional)
  # 設定内容: AWS Identity and Access Management (IAM) サービスリンクロールを指定して
  #           このロールをData Catalogに登録するかを指定します。
  # 設定可能な値:
  #   - true: AWSLakeFormationDataAccessServiceLinkedRole を使用
  #   - false (デフォルト): カスタムIAMロールを使用 (role_arnで指定)
  # 省略時: false (カスタムロールを使用)
  # 注意: role_arnと排他的（どちらか一方のみ指定可能）
  # 関連機能: Lake Formation サービスリンクロール
  #   AWSが管理するサービスリンクロールを使用することで、IAMロール管理を簡素化。
  #   初回登録時に自動的にロールとインラインポリシーが作成されます。
  #   - https://docs.aws.amazon.com/lake-formation/latest/dg/service-linked-roles.html
  use_service_linked_role = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ハイブリッドアクセス設定
  #-------------------------------------------------------------

  # hybrid_access_enabled (Optional)
  # 設定内容: AWS Lake Formationハイブリッドアクセス許可モードを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ハイブリッドアクセスモードを有効化
  #   - false (デフォルト): ハイブリッドアクセスモードを無効化
  # 省略時: false
  # 関連機能: Lake Formation ハイブリッドアクセスモード
  #   Lake Formationの権限とIAMおよびS3バケットポリシーの両方を使用して
  #   データアクセスを制御できるモード。段階的な移行に有用。
  #   - https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
  hybrid_access_enabled = false

  #-------------------------------------------------------------
  # 特権アクセス設定
  #-------------------------------------------------------------

  # with_privileged_access (Optional)
  # 設定内容: 呼び出し元プリンシパルに、登録されたデータロケーションで
  #           サポートされているすべてのLake Formation操作を実行する権限を
  #           付与するかを指定します。
  # 設定可能な値:
  #   - true: すべてのLake Formation操作の権限を付与
  #   - false (デフォルト): 標準権限のみ
  # 省略時: false
  # 用途: データレイク管理者が登録リソースに対して完全な制御を必要とする場合に使用
  # 関連機能: Lake Formation 権限管理
  #   特権アクセスを有効にすると、データロケーションに対するすべての操作
  #   （読み取り、書き込み、削除など）を実行できます。
  #   - https://docs.aws.amazon.com/lake-formation/latest/dg/security-data-access.html
  with_privileged_access = false
}

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# AWS は、IAMロールを使用してS3ロケーション登録を行った後、
# サービスリンクロールに更新することをサポートしていません。
# つまり、role_arn を指定した後に use_service_linked_role = true に
# 変更することはできません。
#
# 変更が必要な場合は、リソースを削除して再作成する必要があります。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - last_modified: リソースが最後に変更された日時
#   RFC 3339形式で返されます。
#   参考: https://tools.ietf.org/html/rfc3339#section-5.8
#---------------------------------------------------------------
