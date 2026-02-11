#---------------------------------------------------------------
# AWS Glue Data Catalog Encryption Settings
#---------------------------------------------------------------
#
# AWS Glue Data Catalogの暗号化設定を管理するリソース。
# Data Catalogのメタデータ（データベース、テーブル、パーティション等）の
# 保管時暗号化と、接続パスワードの暗号化を構成できます。
#
# AWS公式ドキュメント:
#   - Encrypting your Data Catalog: https://docs.aws.amazon.com/glue/latest/dg/encrypt-glue-data-catalog.html
#   - DataCatalogEncryptionSettings API: https://docs.aws.amazon.com/glue/latest/webapi/API_DataCatalogEncryptionSettings.html
#   - Setting up encryption in AWS Glue: https://docs.aws.amazon.com/glue/latest/dg/set-up-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_data_catalog_encryption_settings
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_data_catalog_encryption_settings" "example" {
  # catalog_id - (Optional) Data Catalogの暗号化設定を行うCatalog ID。
  # 指定しない場合は、デフォルトでAWSアカウントIDが使用されます。
  # クロスアカウント設定や特定のCatalogを指定する場合に使用します。
  catalog_id = "123456789012"

  # region - (Optional) このリソースが管理されるAWSリージョン。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # マルチリージョン構成や特定リージョンでのリソース管理に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-west-2"

  # data_catalog_encryption_settings - (Required) Data Catalogの暗号化設定。
  # 接続パスワードの暗号化と保管時暗号化の両方を構成します。
  data_catalog_encryption_settings {
    # connection_password_encryption - (Required) 接続パスワード保護の設定。
    # 有効にすると、CreateConnectionやUpdateConnection時にData Catalogが
    # 顧客提供のKMSキーを使用してパスワードを暗号化し、
    # 接続プロパティのENCRYPTED_PASSWORDフィールドに保存します。
    # Catalog全体の暗号化またはパスワードのみの暗号化を選択できます。
    connection_password_encryption {
      # return_connection_password_encrypted - (Required) パスワード暗号化の有効化フラグ。
      # trueに設定すると、GetConnectionおよびGetConnectionsのレスポンスで
      # パスワードが暗号化されたまま返されます。
      # この暗号化はCatalog暗号化とは独立して機能します。
      return_connection_password_encrypted = true

      # aws_kms_key_id - (Optional) 接続パスワードの暗号化に使用するKMSキーのARN。
      # 接続パスワード保護が有効な場合、CreateConnectionおよびUpdateConnectionを
      # 呼び出すユーザーは、パスワードをData Catalogに保存する前に暗号化するため、
      # 指定されたKMSキーに対して最低限kms:Encrypt権限が必要です。
      aws_kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    }

    # encryption_at_rest - (Required) Data Catalogの保管時暗号化設定。
    # Data Catalogに保存されるメタデータ（データベース、テーブル、パーティション、
    # テーブルバージョン、カラム統計、ユーザー定義関数、Data Catalogビュー等）の
    # 暗号化方式を指定します。
    encryption_at_rest {
      # catalog_encryption_mode - (Required) Data Catalogデータの暗号化モード。
      # 有効な値:
      #   - DISABLED: 暗号化を無効化
      #   - SSE-KMS: AWS KMSを使用した暗号化（AWSマネージドキーまたはカスタマーマネージドキー）
      #   - SSE-KMS-WITH-SERVICE-ROLE: サービスロールを使用したKMS暗号化
      #     （KMS操作をIAMロールに委譲する場合）
      # 注意: 暗号化を有効にすると、新規作成されるオブジェクトのみが暗号化されます。
      #      既存の暗号化されていないオブジェクトは暗号化されません。
      catalog_encryption_mode = "SSE-KMS"

      # sse_aws_kms_key_id - (Optional) 保管時暗号化に使用するKMSキーのARN。
      # catalog_encryption_modeがSSE-KMSまたはSSE-KMS-WITH-SERVICE-ROLEの場合に指定します。
      # カスタマーマネージドキーを使用する場合、対称キーのみサポートされます。
      # 指定しない場合、AWSマネージドキー（aws/glue）が使用されます。
      sse_aws_kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"

      # catalog_encryption_service_role - (Optional) 暗号化されたData Catalogデータに
      # アクセスするために使用するIAMロールのARN。
      # catalog_encryption_modeがSSE-KMS-WITH-SERVICE-ROLEの場合に必要です。
      # このロールは、KMS操作（Encrypt、Decrypt、GenerateDataKey等）を実行する権限を持つ必要があります。
      catalog_encryption_service_role = "arn:aws:iam::123456789012:role/GlueCatalogEncryptionRole"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed）。
# Terraformコードには記述できません。
#
# id - Data Catalogの暗号化設定が適用されるCatalog ID。
#      catalog_idが指定されている場合はその値、
#      指定されていない場合はAWSアカウントIDが設定されます。
