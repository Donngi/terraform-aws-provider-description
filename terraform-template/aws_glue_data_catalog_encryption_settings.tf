#---------------------------------------------------------------
# AWS Glue データカタログ暗号化設定
#---------------------------------------------------------------
#
# AWS Glueデータカタログの暗号化設定を管理するリソースです。
# データカタログに保存されているメタデータの保護として、
# 保管時暗号化（Encryption at Rest）と接続パスワード暗号化を
# 設定することができます。
# AWSアカウントごとに1つのデータカタログが存在するため、
# このリソースは1つのみ作成できます。
#
# AWS公式ドキュメント:
#   - データカタログ暗号化の概要: https://docs.aws.amazon.com/glue/latest/dg/encrypt-glue-data-catalog.html
#   - 接続パスワードの暗号化: https://docs.aws.amazon.com/glue/latest/dg/encrypt-connection-passwords.html
#   - セキュリティ設定: https://docs.aws.amazon.com/glue/latest/dg/security-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_data_catalog_encryption_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_data_catalog_encryption_settings" "example" {
  #-------------------------------------------------------------
  # カタログID設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: 暗号化設定を適用するGlueデータカタログのIDを指定します。
  #           通常はAWSアカウントIDと同一です。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: プロバイダー設定のアカウントIDを使用
  catalog_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # データカタログ暗号化設定
  #-------------------------------------------------------------

  # data_catalog_encryption_settings (Required)
  # 設定内容: データカタログの暗号化設定を定義するブロックです。
  #           接続パスワードの暗号化と保管時暗号化の両方を設定します。
  data_catalog_encryption_settings {

    #-----------------------------------------------------------
    # 接続パスワード暗号化設定
    #-----------------------------------------------------------

    # connection_password_encryption (Required)
    # 設定内容: Glue接続に保存された接続パスワードの暗号化設定を定義するブロックです。
    connection_password_encryption {

      # return_connection_password_encrypted (Required)
      # 設定内容: 接続パスワードをAWS KMSで暗号化して返すかを指定します。
      #           trueの場合、aws_kms_key_idで指定したKMSキーを使って暗号化します。
      # 設定可能な値:
      #   - true: 接続パスワードをKMSで暗号化して保存・返却する
      #   - false: 接続パスワードを暗号化しない
      return_connection_password_encrypted = true

      # aws_kms_key_id (Optional)
      # 設定内容: 接続パスワードの暗号化に使用するKMSキーのARNまたはIDを指定します。
      #           return_connection_password_encrypted が true の場合に有効です。
      # 設定可能な値: 有効なAWS KMSキーのARNまたはキーID
      # 省略時: 接続パスワードの暗号化を行わない
      aws_kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/example-key-id"
    }

    #-----------------------------------------------------------
    # 保管時暗号化設定
    #-----------------------------------------------------------

    # encryption_at_rest (Required)
    # 設定内容: データカタログのメタデータ（データベース定義、テーブル定義等）の
    #           保管時暗号化設定を定義するブロックです。
    encryption_at_rest {

      # catalog_encryption_mode (Required)
      # 設定内容: データカタログの暗号化モードを指定します。
      # 設定可能な値:
      #   - "DISABLED": 暗号化を無効化する
      #   - "SSE-KMS": AWS KMS管理キーを使用してサーバー側暗号化を有効化する
      #   - "SSE-KMS-WITH-SERVICE-ROLE": サービスロールを使用したKMS暗号化を有効化する
      catalog_encryption_mode = "SSE-KMS"

      # sse_aws_kms_key_id (Optional)
      # 設定内容: データカタログの保管時暗号化に使用するKMSキーのARNまたはIDを指定します。
      #           catalog_encryption_mode が "SSE-KMS" または "SSE-KMS-WITH-SERVICE-ROLE" の場合に使用します。
      # 設定可能な値: 有効なAWS KMSキーのARNまたはキーID
      # 省略時: AWSマネージドキー（aws/glue）を使用
      sse_aws_kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/example-key-id"

      # catalog_encryption_service_role (Optional)
      # 設定内容: catalog_encryption_mode が "SSE-KMS-WITH-SERVICE-ROLE" の場合に、
      #           暗号化操作に使用するIAMサービスロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      # 省略時: サービスロールなし（SSE-KMS-WITH-SERVICE-ROLEでは必須）
      catalog_encryption_service_role = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: データカタログのID（catalog_idと同一）
#---------------------------------------------------------------
