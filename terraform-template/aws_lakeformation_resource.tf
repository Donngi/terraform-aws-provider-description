#---------------------------------------------------------------
# AWS Lake Formation Resource Registration
#---------------------------------------------------------------
#
# AWS Lake FormationにS3バケットなどのデータレイクリソースを登録するリソースです。
# 登録されたリソースはLake Formationによるアクセス制御の対象となります。
# IAMロールまたはサービスリンクロールを使用してリソースへのアクセスを管理します。
#
# 注意: リソースを登録すると、Lake FormationがそのリソースへのAthenaや
#       Glueなどのサービスからのアクセスを制御するようになります。
#       use_service_linked_roleとrole_arnは排他的です。
#       hybrid_access_enabledはLake Formationとサービスリンクロールの
#       両方によるアクセスを同時に有効にします（Lake Formation V4機能）。
#
# AWS公式ドキュメント:
#   - Lake Formation RegisterResource API: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_RegisterResource.html
#   - データレイクリソースの登録: https://docs.aws.amazon.com/lake-formation/latest/dg/register-resource.html
#   - ハイブリッドアクセスモード: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_resource
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
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
  # 設定内容: Lake Formationに登録するリソースのARNを指定します。
  # 設定可能な値: S3バケットまたはS3プレフィックスのARN文字列
  # 省略時: 省略不可。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/register-resource.html
  arn = "arn:aws:s3:::example-data-lake-bucket"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アクセス制御設定
  #-------------------------------------------------------------

  # use_service_linked_role (Optional)
  # 設定内容: Lake Formationサービスリンクロールを使用してリソースにアクセスするかを指定します。
  # 設定可能な値:
  #   - true: AWSLakeFormationDataAccessRole（サービスリンクロール）を使用
  #   - false: role_arnで指定したIAMロールを使用
  # 省略時: Terraformがデフォルト値を設定します。
  # 注意: use_service_linked_roleをfalseにする場合はrole_arnの指定が必要です。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/service-linked-roles.html
  use_service_linked_role = true

  # role_arn (Optional)
  # 設定内容: リソースへのアクセスに使用するIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN文字列
  # 省略時: use_service_linked_roleがtrueの場合はサービスリンクロールが使用されます。
  # 注意: use_service_linked_roleがfalseの場合に必須です。
  #       サービスリンクロールを使用する場合はnullを設定してください。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/registration-role.html
  role_arn = null

  #-------------------------------------------------------------
  # フェデレーション・ハイブリッドアクセス設定
  #-------------------------------------------------------------

  # with_federation (Optional)
  # 設定内容: 外部リソース（Glue Data Catalogなど）とのフェデレーションを有効にするかを指定します。
  # 設定可能な値:
  #   - true: フェデレーションアクセスを有効化
  #   - false: フェデレーションアクセスを無効化
  # 省略時: Terraformがデフォルト値を設定します。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/federated-catalogs.html
  with_federation = false

  # hybrid_access_enabled (Optional)
  # 設定内容: Lake FormationによるアクセスとIAMベースのアクセスを両方有効にするハイブリッドアクセスモードを指定します。
  # 設定可能な値:
  #   - true: Lake Formationの権限とIAMポリシーの両方でアクセスを制御
  #   - false: Lake Formationの権限のみでアクセスを制御
  # 省略時: Terraformがデフォルト値を設定します。
  # 注意: Lake Formation V4の機能です。既存のIAMベースのアクセスを維持しながら
  #       Lake Formation権限を段階的に導入する際に有用です。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-access-mode.html
  hybrid_access_enabled = false

  # with_privileged_access (Optional)
  # 設定内容: IAMプリンシパルがSuperユーザーとしてこのリソースにアクセスできるかを指定します。
  # 設定可能な値:
  #   - true: IAMプリンシパルへの特権アクセスを許可
  #   - false: 特権アクセスを禁止
  # 省略時: Terraformがデフォルト値を設定します。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/access-control-overview.html
  with_privileged_access = false
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 登録されたリソースのARN（arnと同値）。
# - last_modified: リソースが最後に変更された日時（RFC3339形式）。
#---------------------------------------------------------------
