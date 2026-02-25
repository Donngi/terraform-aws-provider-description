#---------------------------------------------------------------
# AWS KMS Ciphertext
#---------------------------------------------------------------
#
# AWS KMS（Key Management Service）を使用してプレーンテキストを暗号化し、
# 暗号文（ciphertext）を生成するリソースです。
# このリソースはTerraformの状態ファイルに暗号化されたデータを保存し、
# 他のリソースやモジュールで暗号化済みの値を参照できます。
#
# 主なユースケース:
#   - Terraformの設定内でシークレット値をKMSで暗号化して保管
#   - 暗号化済みの値を他のAWSリソース（Lambda環境変数など）に渡す
#   - KMSキーによる機密データの保護と配布
#
# 重要な注意事項:
#   - このリソースはTerraformステートにプレーンテキストとciphertext_blobを保存します。
#     ステートファイルへのアクセス制御を適切に行ってください。
#   - plaintext は sensitive=true ですが、ステートファイルには平文で保存される場合があります。
#   - 暗号化コンテキスト（context）は復号時にも同じ値を指定する必要があります。
#   - このリソースはデータソースとしての用途が主であり、実際の暗号化処理はAWS APIが実施します。
#
# AWS公式ドキュメント:
#   - KMS Encrypt API: https://docs.aws.amazon.com/kms/latest/APIReference/API_Encrypt.html
#   - 暗号化コンテキスト: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#encrypt_context
#   - KMS キーの識別子: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#key-id
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/kms_ciphertext
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_ciphertext" "example" {
  #---------------------------------------------------------------
  # キー設定
  #---------------------------------------------------------------

  # key_id (Required)
  # 設定内容: 暗号化に使用するKMSキーの識別子を指定します。
  # 設定可能な値:
  #   - キーID: "1234abcd-12ab-34cd-56ef-1234567890ab"
  #   - キーARN: "arn:aws:kms:us-east-1:123456789012:key/1234abcd-..."
  #   - エイリアス名: "alias/my-key"
  #   - エイリアスARN: "arn:aws:kms:us-east-1:123456789012:alias/my-key"
  # 用途: このキーを使用してplaintext または plaintext_wo を暗号化します。
  key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"

  #---------------------------------------------------------------
  # 平文データ設定
  #---------------------------------------------------------------

  # plaintext (Optional, Sensitive)
  # 設定内容: 暗号化するプレーンテキストデータを指定します。
  # 設定可能な値: 任意の文字列（バイナリデータはbase64エンコードして指定）
  # 省略時: plaintext_wo を使用するか、どちらも省略（暗号化対象なし）
  #
  # 注意:
  #   - sensitive=true のためTerraformのコンソール出力では秘匿されますが、
  #     ステートファイルには保存されます。ステートファイルの暗号化を推奨します。
  #   - plaintext と plaintext_wo を同時に指定することはできません。
  #   - write-only属性（plaintext_wo）の使用を推奨します。
  plaintext = "my-secret-value"

  # plaintext_wo (Optional, Sensitive, Write-Only)
  # 設定内容: 暗号化するプレーンテキストデータをwrite-only属性として指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: plaintext を使用するか、どちらも省略
  #
  # 注意:
  #   - write-only属性のため、ステートファイルに値が保存されません（セキュリティ向上）。
  #   - plaintext との同時指定は不可。plaintext_wo の使用が推奨されます。
  #   - 値の変更を検知するには plaintext_wo_version を使用してください。
  plaintext_wo = null

  # plaintext_wo_version (Optional)
  # 設定内容: plaintext_wo の変更を追跡するためのバージョン番号を指定します。
  # 設定可能な値: 任意の文字列（バージョンを示す文字列や数値）
  # 省略時: バージョン管理なし（plaintext_wo の変更が検知されない可能性があります）
  #
  # 用途: plaintext_wo はwrite-only属性でステートに保存されないため、
  #   値を変更しても Terraform がその変更を検知できません。
  #   この属性の値を変更することで、意図的に再暗号化をトリガーできます。
  plaintext_wo_version = null

  #---------------------------------------------------------------
  # 暗号化コンテキスト設定
  #---------------------------------------------------------------

  # context (Optional)
  # 設定内容: 暗号化コンテキストとして使用するキーと値のマップを指定します。
  # 設定可能な値: 文字列のキーと値のペア（map(string)）
  # 省略時: 暗号化コンテキストなし
  #
  # 重要:
  #   - 暗号化時に指定したコンテキストは、復号時にも完全に一致するコンテキストが必要です。
  #   - コンテキストはCloudTrailログに記録され、監査に活用できます。
  #   - コンテキストの値は機密情報を含めないようにしてください（ログに記録されます）。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#encrypt_context
  context = {
    Environment = "production"
    Purpose     = "database-password"
  }

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "ap-northeast-1", "us-east-1"）
  # 省略時: プロバイダー設定のリージョン
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - ciphertext_blob
#     KMSによって暗号化されたデータのbase64エンコード文字列
#     他のリソースへの参照: aws_kms_ciphertext.example.ciphertext_blob
#
# - id
#     KMSキーID（key_id と同一）
#
# - region
#     リソースが管理されているAWSリージョン
#
