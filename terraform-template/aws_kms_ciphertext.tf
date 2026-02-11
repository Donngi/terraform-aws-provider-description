#---------------------------------------------------------------
# AWS KMS Ciphertext
#---------------------------------------------------------------
#
# KMS暗号化テキストリソース。AWS KMSカスタマーマスターキー（CMK）を使用して
# 平文を暗号文に暗号化します。このリソースが返す値はapply間で安定しています。
# apply毎に変化する暗号文が必要な場合は、aws_kms_ciphertextデータソースを使用してください。
#
# AWS公式ドキュメント:
#   - Encrypt Operation: https://docs.aws.amazon.com/kms/latest/APIReference/API_Encrypt.html
#   - Encryption Context: https://docs.aws.amazon.com/kms/latest/developerguide/encrypt_context.html
#   - Cryptographic Details: https://docs.aws.amazon.com/kms/latest/cryptographic-details/encrypt-operation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_ciphertext
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_ciphertext" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # KMSキーID（必須）
  # 暗号化に使用するカスタマーマスターキー（CMK）のグローバルに一意なキーID。
  # キーID、キーARN、エイリアス名、エイリアスARNのいずれかを指定可能。
  #
  # 例:
  # - Key ID: "1234abcd-12ab-34cd-56ef-1234567890ab"
  # - Key ARN: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # - Alias name: "alias/my-key"
  # - Alias ARN: "arn:aws:kms:us-east-1:123456789012:alias/my-key"
  key_id = "alias/example-key"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # 暗号化する平文データ（plaintext または plaintext_wo のいずれか1つ必須）
  # 暗号化される平文データ。この値はログに表示される可能性があり、
  # Terraformのステートファイルに平文で保存されます。
  #
  # 重要な注意事項:
  # - 全ての引数（平文を含む）はステートファイルに平文で保存されます
  # - 機密データの取り扱いについては以下を参照:
  #   https://www.terraform.io/docs/state/sensitive-data.html
  # - 最大4KBまでの平文データを暗号化可能
  #
  # plaintext_wo を使用する場合は、このパラメータは設定しないでください。
  plaintext = <<-EOF
  {
    "client_id": "e587dbae22222f55da22",
    "client_secret": "8289575d00000ace55e1815ec13673955721b8a5"
  }
  EOF

  # 書き込み専用の平文データ（plaintext または plaintext_wo のいずれか1つ必須）
  # 暗号化される平文データ（書き込み専用）。この値はログに表示される可能性がありますが、
  # Terraformのステートファイルには保存されません。
  #
  # 特徴:
  # - ステートファイルに保存されないため、より高いセキュリティを提供
  # - plaintext_wo_version と組み合わせてリソースの置き換えをトリガー
  # - plaintext と同時に使用することはできません
  #
  # plaintext を使用する場合は、このパラメータは設定しないでください。
  # plaintext_wo = "sensitive-data"

  # 書き込み専用平文のバージョン（plaintext_wo 使用時は必須）
  # plaintext_wo と組み合わせて使用し、リソースの置き換えをトリガーします。
  # 置き換えが必要な場合に、この値を変更してください。
  #
  # 使用例:
  # - バージョン番号: "v1", "v2", "v3"
  # - タイムスタンプ: "2026-01-28T10:00:00Z"
  # - UUID: "550e8400-e29b-41d4-a716-446655440000"
  #
  # plaintext_wo を使用しない場合は、このパラメータは不要です。
  # plaintext_wo_version = "v1"

  # 暗号化コンテキスト（オプション）
  # 暗号化コンテキストを構成するkey-valueペアのマッピング。
  # 暗号化コンテキストは、暗号文に暗号的にバインドされる追加の認証データです。
  #
  # 特徴:
  # - 対称暗号化キーでのみ使用可能
  # - 復号化時に同じ暗号化コンテキストが必要
  # - 暗号化されずにCloudTrailログに平文で記録される
  # - 追加の認証と監査証跡を提供
  # - IAMポリシーやキーポリシーで条件として使用可能
  #
  # ベストプラクティス:
  # - リソースの識別子（ARN、IDなど）を含める
  # - 機密情報は含めない（ログに平文で記録されるため）
  # - 復号化時に同じコンテキストが必要なため、値を保持する
  #
  # 例:
  # context = {
  #   "Department" = "Finance"
  #   "Environment" = "Production"
  #   "Application" = "PayrollSystem"
  # }
  context = null

  # リソース管理リージョン（オプション）
  # このリソースが管理されるAWSリージョン。
  # デフォルトはプロバイダー設定で指定されたリージョンを使用します。
  #
  # 使用例:
  # - マルチリージョン構成で特定のリージョンにリソースを配置
  # - リージョン固有のコンプライアンス要件への対応
  #
  # 例: "us-east-1", "ap-northeast-1", "eu-west-1"
  #
  # 参考:
  # - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  # IDオーバーライド（オプション）
  # Terraformリソース識別子。通常は自動的に設定されますが、
  # 必要に応じて明示的に指定することも可能です。
  #
  # 注意:
  # - 特別な理由がない限り、このパラメータは設定する必要はありません
  # - 自動生成されるIDで十分なケースがほとんどです
  id = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは、上記の引数に加えて以下の属性をエクスポートします:
#
# - ciphertext_blob (string)
#   Base64エンコードされた暗号文。
#   KMS Encryptオペレーションによって生成された暗号化データです。
#   この値を保存して、後で復号化に使用できます。
#
#   使用例:
#   - 暗号化された設定ファイルとして保存
#   - 他のリソースに暗号化されたシークレットとして渡す
#   - AWS Secrets Managerやパラメータストアに保存
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 以下は、KMSキーを作成して平文を暗号化する完全な例です:
#
# resource "aws_kms_key" "oauth_config" {
#   description = "OAuth configuration encryption key"
#   is_enabled  = true
# }
#
# resource "aws_kms_ciphertext" "oauth" {
#   key_id = aws_kms_key.oauth_config.key_id
#
#   plaintext = <<EOF
# {
#   "client_id": "e587dbae22222f55da22",
#   "client_secret": "8289575d00000ace55e1815ec13673955721b8a5"
# }
# EOF
# }
#
# # 暗号化されたデータを他のリソースで使用
# output "encrypted_oauth_config" {
#   value     = aws_kms_ciphertext.oauth.ciphertext_blob
#   sensitive = true
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# セキュリティに関する重要な注意事項
#---------------------------------------------------------------
#
# 1. ステートファイルのセキュリティ
#    - plaintext パラメータを使用する場合、平文データはステートファイルに保存されます
#    - ステートファイルの暗号化とアクセス制御を適切に設定してください
#    - より高いセキュリティが必要な場合は plaintext_wo の使用を検討
#
# 2. 暗号化コンテキストの使用
#    - 暗号化コンテキストは暗号化されず、ログに平文で記録されます
#    - 機密情報を暗号化コンテキストに含めないでください
#    - リソース識別子や環境名など、非機密の認証データのみを使用
#
# 3. KMSキーのアクセス制御
#    - KMSキーポリシーで適切なアクセス制御を設定
#    - 最小権限の原則に従ってアクセスを許可
#    - CloudTrailでKMSキーの使用状況を監視
#
# 4. データサイズの制限
#    - KMS Encryptオペレーションは最大4KBまでの平文を暗号化可能
#    - より大きなデータの暗号化にはAWS Encryption SDKの使用を検討
#
#---------------------------------------------------------------
