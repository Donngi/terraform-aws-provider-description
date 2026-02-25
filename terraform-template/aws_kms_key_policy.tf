#---------------------------------------------------------------
# AWS KMS Key Policy
#---------------------------------------------------------------
#
# AWS KMS キーにキーポリシーをアタッチするリソースです。
# キーポリシーはKMSキーへのアクセス制御の主要な仕組みであり、
# すべてのKMSキーには必ずキーポリシーが必要です。
# このリソースで管理されているキーポリシーを削除すると、
# AWSはキーにデフォルトのキーポリシーを適用します。
#
# AWS公式ドキュメント:
#   - KMSキーポリシー: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
#   - PutKeyPolicy API: https://docs.aws.amazon.com/kms/latest/APIReference/API_PutKeyPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_key_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # key_id (Required)
  # 設定内容: キーポリシーをアタッチするKMSキーのIDまたはARNを指定します。
  # 設定可能な値:
  #   - KMSキーのID（例: 1234abcd-12ab-34cd-56ef-1234567890ab）
  #   - KMSキーのARN（例: arn:aws:kms:ap-northeast-1:123456789012:key/...）
  #   - エイリアス名（例: alias/MyKeyAlias）
  #   - エイリアスARN（例: arn:aws:kms:ap-northeast-1:123456789012:alias/...）
  key_id = aws_kms_key.example.id

  # policy (Required)
  # 設定内容: KMSキーにアタッチする有効なキーポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なキーポリシーJSON文字列
  # 注意: キーポリシーは呼び出し元プリンシパルが後続のPutKeyPolicyリクエストを
  #       実行できるように許可する必要があります。
  #       aws_iam_policy_documentデータソースを使用してポリシーを構築できます。
  #       すべてのKMSキーにはキーポリシーが必要です。このリソースが削除された場合、
  #       AWSはKMSキーにデフォルトのキーポリシーを適用し、キー所有者アカウントの
  #       すべてのプリンシパルに無制限のアクセスを付与します。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-policy-example"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # bypass_policy_lockout_safety_check (Optional)
  # 設定内容: キーポリシーのロックアウト安全チェックをバイパスするかどうかを指定します。
  # 設定可能な値:
  #   - false (デフォルト): 安全チェックを実行します（推奨）
  #   - true: 安全チェックをバイパスします。KMSキーが管理不能になるリスクが高まります
  # 省略時: false（安全チェックを実行）
  # 注意: このフラグをtrueに設定すると、KMSキーが管理不能になるリスクが大幅に増加します。
  #       この値はむやみにtrueに設定しないでください。
  #       このリソースがtrueに設定されている状態で削除された場合、警告が表示され
  #       リソースはstateから削除されます。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam
  bypass_policy_lockout_safety_check = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: KMSキーのID（key_idと同じ値）
#---------------------------------------------------------------
