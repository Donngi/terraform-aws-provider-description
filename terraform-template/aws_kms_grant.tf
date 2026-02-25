#---------------------------------------------------------------
# AWS KMS Grant
#---------------------------------------------------------------
#
# AWS KMSのカスタマーマスターキー（CMK）に対してリソースベースの
# アクセス制御メカニズムを提供するリソースです。
# グラントを使用することで、IAMプリンシパルに対してKMSキーの特定の
# 暗号化操作を実行する権限を柔軟に委任できます。
#
# AWS公式ドキュメント:
#   - AWS KMS グラント: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html
#   - グラントの作成: https://docs.aws.amazon.com/kms/latest/developerguide/create-grant-overview.html
#   - グラントへのアクセス制御: https://docs.aws.amazon.com/kms/latest/developerguide/grant-authorization.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_grant" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # key_id (Required, Forces new resource)
  # 設定内容: グラントを適用するKMSキーの一意識別子を指定します。
  # 設定可能な値: キーID、キーARN。別アカウントのキーを指定する場合はキーARNが必要
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html
  key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # grantee_principal (Required, Forces new resource)
  # 設定内容: グラントが許可する操作を実行する権限を与えるプリンシパルをARN形式で指定します。
  # 設定可能な値: IAMユーザー、IAMロール、AWSサービス等のARN
  # 注意: IAMプリンシパルに関する結果整合性の問題により、Terraformのstateが
  #       AWSの実際の状態を常に反映しない場合があります。
  grantee_principal = "arn:aws:iam::123456789012:role/example-role"

  # operations (Required, Forces new resource)
  # 設定内容: グラントが許可する操作のリストを指定します。
  # 設定可能な値:
  #   - "Decrypt": データの復号
  #   - "Encrypt": データの暗号化
  #   - "GenerateDataKey": データキーの生成
  #   - "GenerateDataKeyWithoutPlaintext": 平文なしのデータキー生成
  #   - "ReEncryptFrom": 指定キーからの再暗号化
  #   - "ReEncryptTo": 指定キーへの再暗号化
  #   - "Sign": データへの署名
  #   - "Verify": 署名の検証
  #   - "GetPublicKey": 公開鍵の取得
  #   - "CreateGrant": グラントの作成（制限あり）
  #   - "RetireGrant": グラントの廃止
  #   - "DescribeKey": キー情報の取得
  #   - "GenerateDataKeyPair": データキーペアの生成
  #   - "GenerateDataKeyPairWithoutPlaintext": 平文なしのデータキーペア生成
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]

  #-------------------------------------------------------------
  # 識別設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: グラントを識別するためのフレンドリーな名前を指定します。
  # 設定可能な値: 英数字、ハイフン、スラッシュ、アンダースコア、コロンを含む文字列（最大256文字）
  # 省略時: 名前なしでグラントが作成されます。
  # 注意: 重複するグラントの作成防止に使用できます。
  name = "my-grant"

  #-------------------------------------------------------------
  # 廃止設定
  #-------------------------------------------------------------

  # retiring_principal (Optional, Forces new resource)
  # 設定内容: RetireGrant操作でグラントを廃止する権限を付与するプリンシパルをARN形式で指定します。
  # 設定可能な値: IAMユーザー、IAMロール、AWSサービス等のARN
  # 省略時: retiring_principalは設定されません。
  # 注意: IAMプリンシパルに関する結果整合性の問題により、Terraformのstateが
  #       AWSの実際の状態を常に反映しない場合があります。
  retiring_principal = null

  # retire_on_delete (Optional)
  # 設定内容: Terraform destroy時にグラントを削除する際にRevokeGrantの代わりに
  #           RetireGrantを使用するかを指定します。
  # 設定可能な値:
  #   - true: destroy時にRetireGrantでグラントを廃止
  #   - false (デフォルト): destroy時にRevokeGrantでグラントを取り消し
  # 省略時: false
  retire_on_delete = false

  #-------------------------------------------------------------
  # グラントトークン設定
  #-------------------------------------------------------------

  # grant_creation_tokens (Optional, Forces new resource)
  # 設定内容: グラント作成時に使用するグラントトークンのリストを指定します。
  # 設定可能な値: 有効なグラントトークン文字列のセット
  # 省略時: グラントトークンを使用せずにグラントを作成します。
  # 関連機能: KMS グラントトークン
  #   新しいグラントの権限を即時に使用するためにグラントトークンを利用します。
  #   KMSは結果整合性モデルに従うため、通常は新しいグラントが有効になるまで
  #   短時間の遅延が発生します。グラントトークンを使用することで即時に権限を行使できます。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/grants.html#grant_token
  grant_creation_tokens = null

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
  # 暗号化コンテキスト制約設定
  #-------------------------------------------------------------

  # constraints (Optional, Forces new resource)
  # 設定内容: グラントが許可する特定の操作を、指定した暗号化コンテキストが
  #           存在する場合にのみ許可するための制約設定ブロックです。
  # 関連機能: KMS 暗号化コンテキスト
  #   暗号化コンテキストとはKMS暗号化操作にオプションで指定できるキーと値のペアのセットです。
  #   暗号化コンテキストに含める情報は秘密情報ではないため、
  #   暗号文やログに平文で表示される場合があります。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/encrypt_context.html
  constraints {

    # encryption_context_equals (Optional)
    # 設定内容: 後続の暗号化操作リクエストの暗号化コンテキストと完全一致する必要がある
    #           キーと値のペアのマップを指定します。
    # 設定可能な値: 文字列のキーバリューマップ
    # 省略時: 暗号化コンテキストの完全一致制約は設定されません。
    # 注意: encryption_context_subsetと排他的（どちらか一方のみ指定可能）
    encryption_context_equals = {
      Department = "Finance"
    }

    # encryption_context_subset (Optional)
    # 設定内容: 後続の暗号化操作リクエストの暗号化コンテキストに含まれている必要がある
    #           キーと値のペアのマップを指定します（追加ペアは許可）。
    # 設定可能な値: 文字列のキーバリューマップ
    # 省略時: 暗号化コンテキストのサブセット制約は設定されません。
    # 注意: encryption_context_equalsと排他的（どちらか一方のみ指定可能）
    encryption_context_subset = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - grant_id: グラントの一意識別子
#
# - grant_token: 作成されたグラントのグラントトークン。新しいグラントの権限を
#               即時に使用する際に利用します。機密情報としてstateに保存されます。
#               参考: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html#grant_token
#---------------------------------------------------------------
