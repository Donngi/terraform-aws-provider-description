#---------------------------------------------------------------
# AWS KMS Key Policy
#---------------------------------------------------------------
#
# AWS Key Management Service (KMS) キーにキーポリシーをアタッチするリソースです。
# キーポリシーはKMSキーへのアクセスを制御する主要なメカニズムであり、
# すべてのKMSキーには必ず1つのキーポリシーが必要です。
# キーポリシーにより、誰がKMSキーを使用できるか、どのように使用できるかを決定します。
#
# AWS公式ドキュメント:
#   - KMSキーポリシー: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
#   - KMSキーのアクセスと権限: https://docs.aws.amazon.com/kms/latest/developerguide/control-access.html
#   - キーポリシーの変更: https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-modifying.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
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
  # 設定内容: ポリシーをアタッチするKMSキーのIDを指定します。
  # 設定可能な値: KMSキーのID、ARN、またはエイリアスARN
  # 注意: aws_kms_keyリソースのidを参照するのが一般的です
  key_id = aws_kms_key.example.id

  # policy (Required)
  # 設定内容: KMSキーに適用するキーポリシーのJSONドキュメントを指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列。jsonencode()またはaws_iam_policy_documentデータソースを使用可能
  # 関連機能: KMSキーポリシー
  #   キーポリシーはKMSキーへのアクセスを制御する主要なメカニズムです。
  #   すべてのKMSキーには必ず1つのキーポリシーが必要であり、
  #   キーポリシーで明示的に許可されていない限り、ルートユーザーを含むどのプリンシパルも
  #   KMSキーへのアクセス権限を持ちません。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  # 注意: すべてのKMSキーにはキーポリシーが必要です。キーポリシーが指定されない場合、
  #   またはこのリソースが削除された場合、AWSは所有アカウントのすべてのプリンシパルに
  #   すべてのKMS操作への無制限アクセスを許可するデフォルトキーポリシーを適用します。
  #   このデフォルトキーポリシーは、すべてのアクセス制御をIAMポリシーとKMSグラントに委任します。
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Resource = "*"
      },
    ]
    Version = "2012-10-17"
  })

  #-------------------------------------------------------------
  # ポリシーロックアウト安全チェック設定
  #-------------------------------------------------------------

  # bypass_policy_lockout_safety_check (Optional)
  # 設定内容: キーポリシーのロックアウト安全チェックをバイパスするかを指定します。
  # 設定可能な値:
  #   - true: 安全チェックをバイパス。KMSキーが管理不能になるリスクが増加します
  #   - false (デフォルト): 安全チェックを実施。推奨設定
  # 関連機能: KMSキーポリシーのロックアウト防止
  #   安全チェックは、キーポリシーの変更によって誰もKMSキーを管理できなくなる
  #   状況を防止します。通常、このチェックを無効にすべきではありません。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-root-enable-iam
  # 注意: この値をtrueに設定した場合、リソース削除時に警告が表示され、
  #   Terraform stateからのみ削除されます。無差別にtrueに設定しないでください
  bypass_policy_lockout_safety_check = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: KMSキーのID
#---------------------------------------------------------------
