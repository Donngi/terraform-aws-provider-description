#---------------------------------------------------------------
# KMS Grant
#---------------------------------------------------------------
#
# AWS KMS Grantは、KMSキーへのリソースベースのアクセス制御メカニズムを提供します。
# Grantは、AWSプリンシパルに対して特定のKMSキーを暗号化操作で使用する権限を付与する
# ポリシー手段であり、一時的な権限付与によく使用されます。各Grantは正確に1つのKMSキーへの
# アクセスを許可し、Grant操作のみを許可できます。
#
# Grantを使用することで、IAMポリシーやキーポリシーを変更することなく、きめ細かな
# 権限の委譲が可能になります。AWS サービスが保管時のデータを暗号化する際に
# よく使用されます。
#
# AWS公式ドキュメント:
#   - Grants in AWS KMS: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html
#   - Encryption Context: https://docs.aws.amazon.com/kms/latest/developerguide/encrypt_context.html
#   - GrantConstraints API: https://docs.aws.amazon.com/kms/latest/APIReference/API_GrantConstraints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_grant" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required, Forces new resource) Grantで権限を付与するKMSキーの一意の識別子。
  # キーID、キーのARN、エイリアス名、エイリアスARNを指定できます。
  # 異なるAWSアカウントのKMSキーを指定する場合は、キーのARNを使用する必要があります。
  #
  # 例: "1234abcd-12ab-34cd-56ef-1234567890ab" (Key ID)
  # 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012" (Key ARN)
  # 例: "alias/my-key" (Alias name)
  # 例: "arn:aws:kms:us-east-1:123456789012:alias/my-key" (Alias ARN)
  key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (Required, Forces new resource) Grantで権限を付与されるプリンシパルをARN形式で指定します。
  # IAMユーザー、IAMロール、AWSサービス、フェデレーションユーザー、または引き受けられたロールなど、
  # 任意のAWSプリンシパルを指定できます。Grantee principalは、KMSキーと同じアカウントまたは
  # 異なるアカウントに存在できます。
  #
  # 注意: IAMプリンシパルに関する最終的な整合性の問題により、Terraformの状態が
  # AWSの実際の状態を即座に反映しない場合があります。
  #
  # 例: "arn:aws:iam::123456789012:role/my-role"
  # 例: "arn:aws:iam::123456789012:user/my-user"
  grantee_principal = "arn:aws:iam::123456789012:role/my-role"

  # (Required, Forces new resource) Grantが許可する操作のリスト。
  # 指定可能な値:
  #   - Decrypt: データの復号化
  #   - Encrypt: データの暗号化
  #   - GenerateDataKey: データキーの生成（平文付き）
  #   - GenerateDataKeyWithoutPlaintext: データキーの生成（暗号化のみ）
  #   - ReEncryptFrom: 再暗号化の送信元操作
  #   - ReEncryptTo: 再暗号化の送信先操作
  #   - Sign: デジタル署名の作成（非対称キーのみ）
  #   - Verify: デジタル署名の検証（非対称キーのみ）
  #   - GetPublicKey: 公開鍵の取得（非対称キーのみ）
  #   - CreateGrant: 新しいGrantの作成（Grant管理権限の委譲）
  #   - RetireGrant: Grantの廃止
  #   - DescribeKey: キー情報の取得
  #   - GenerateDataKeyPair: データキーペアの生成（平文付き）
  #   - GenerateDataKeyPairWithoutPlaintext: データキーペアの生成（暗号化のみ）
  #
  # 注意: Grant操作は、Grant内のKMSキーでサポートされている必要があります。
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional, Forces new resource) Grantを識別するためのわかりやすい名前。
  # 重複したGrantの作成を防ぐために使用できます。
  # 最大長: 256文字
  name = "my-grant"

  # (Optional, Forces new resource) RetireGrant操作を使用してGrantを廃止する権限を
  # 付与されるプリンシパルをARN形式で指定します。
  # 指定しない場合、Grantee principalのみがGrantを廃止できます。
  #
  # 注意: IAMプリンシパルに関する最終的な整合性の問題により、Terraformの状態が
  # AWSの実際の状態を即座に反映しない場合があります。
  #
  # 例: "arn:aws:iam::123456789012:role/my-retiring-role"
  # retiring_principal = "arn:aws:iam::123456789012:role/my-retiring-role"

  # (Optional, Forces new resource) Grantを作成する際に使用されるGrantトークンのリスト。
  # Grantトークンは、一意の非秘密文字列で、Grantを表し、Grant権限の即座の使用を可能にします。
  # AWS KMSは最終的な整合性モデルに従うため、新しいGrantが効力を発揮するまでに
  # わずかな遅延が発生する可能性があります。即座に権限を使用する必要がある場合に使用します。
  #
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html#grant_token
  # grant_creation_tokens = ["token1", "token2"]

  # (Optional) このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # リソースを特定のリージョンに明示的に配置する必要がある場合に使用します。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) Terraformがリソースを削除する際にGrantを廃止するかどうかを制御します。
  # trueに設定すると、terraform destroyの実行時にGrantが廃止されます。
  # falseまたは未設定の場合、Grantは取り消されます（revoke）。
  #
  # 廃止（Retire）と取り消し（Revoke）の違い:
  #   - Retire: Grantで指定されたプリンシパルによって実行される
  #   - Revoke: 通常、キー管理者によって実行される
  #
  # デフォルト: false
  # retire_on_delete = true

  # (Optional) Terraformによって使用される内部識別子。
  # 通常、この値を手動で設定する必要はありません。
  # 明示的に設定すると、リソースのインポート時に使用できます。
  # id = "grant-id"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # (Optional, Forces new resource) 暗号化コンテキストに基づいてGrant操作を制限する制約。
  # 暗号化コンテキストは、暗号化データに関する追加のコンテキスト情報を提供する
  # 非秘密のキーと値のペアのセットです。暗号化コンテキストは暗号化的に
  # 暗号文にバインドされ、データを復号化するには同じ暗号化コンテキストが必要です。
  #
  # Grant制約は、対称KMSキーにのみ適用され、暗号化コンテキストをサポートしない
  # 操作（非対称KMSキーや管理操作など）には適用されません。
  #
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/encrypt_context.html
  constraints {
    # (Optional) 後続の暗号化操作リクエストの暗号化コンテキストと完全に一致する必要がある
    # キーと値のペアのリスト。Grantは、リクエストの暗号化コンテキストがこの制約で
    # 指定された暗号化コンテキストと同じ場合にのみ操作を許可します。
    #
    # encryption_context_subsetと競合します（両方を同時に指定できません）。
    #
    # 注意: 制約内の暗号化コンテキストキーは大文字と小文字を区別しませんが、
    # 値は大文字と小文字を区別します。
    #
    # 例: {"Department" = "Finance", "Project" = "Alpha"}
    encryption_context_equals = {
      Department = "Finance"
    }

    # (Optional) 後続の暗号化操作リクエストの暗号化コンテキストに含まれている必要がある
    # キーと値のペアのリスト。Grantは、リクエストの暗号化コンテキストにこの制約で
    # 指定されたキーと値のペアが含まれている場合に暗号化操作を許可しますが、
    # 追加のキーと値のペアを含めることもできます。
    #
    # encryption_context_equalsと競合します（両方を同時に指定できません）。
    #
    # 注意: 制約内の暗号化コンテキストキーは大文字と小文字を区別しませんが、
    # 値は大文字と小文字を区別します。
    #
    # 例: {"Department" = "Finance"}
    # この場合、リクエストには最低限 Department = Finance が含まれている必要がありますが、
    # 他のキーと値のペアも含めることができます。
    # encryption_context_subset = {
    #   Department = "Finance"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは、上記の引数に加えて以下の属性をエクスポートします:
#
# - grant_id: Grantの一意の識別子
# - grant_token: 作成されたGrantのGrantトークン（sensitive）
#              AWS KMSは最終的な整合性モデルに従うため、新しいGrantが
#              システム全体に伝播するまでにわずかな遅延が発生する可能性があります。
#              Grantトークンを使用することで、新しいGrant内の権限を即座に使用できます。
#
# 注意: Grantトークンを含むすべての引数は、プレーンテキストとして
#       rawステートに保存されます。
#
# 参考: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html#grant_token
#---------------------------------------------------------------
