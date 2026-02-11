#---------------------------------------------------------------
# Amazon Macie Member
#---------------------------------------------------------------
#
# Amazon Macieメンバーアカウントを管理するリソースです。
# Macieは、機密データを自動的に検出、分類、保護するフルマネージドサービスで、
# 複数のアカウントで構成される組織において、管理者アカウントがメンバーアカウント
# を招待・管理する際に使用します。
#
# AWS公式ドキュメント:
#   - Amazon Macie概要: https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html
#   - メンバーアカウント管理: https://docs.aws.amazon.com/macie/latest/user/macie-accounts.html
#   - Macie API Reference (Members): https://docs.aws.amazon.com/macie/latest/APIReference/members-id.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_member
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_macie2_member" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: メンバーアカウントとして追加するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 注意: このアカウントは既にMacieを有効化している必要があります。
  #       管理者アカウントと同じAWSリージョンでMacieが有効になっている必要があります。
  account_id = "123456789012"

  # email (Required)
  # 設定内容: メンバーアカウントに関連付けられたメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス形式の文字列
  # 注意: このメールアドレスは招待通知の送信先として使用されます。
  #       アカウントのルートユーザーに関連付けられたメールアドレスを指定することが推奨されます。
  email = "member-account@example.com"

  #-------------------------------------------------------------
  # 招待設定 (オプション)
  #-------------------------------------------------------------

  # invite (Optional)
  # 設定内容: メンバーアカウントに招待を送信するかどうかを指定します。
  # 設定可能な値:
  #   - true: 招待を送信
  #   - false: 招待を送信しない
  # 省略時: false（招待は送信されません）
  # 注意: trueに設定すると、メンバーアカウントに管理者アカウントとの関連付け招待が送信されます。
  #       メンバーアカウント側で招待を承認する必要があります。
  #       AWS Organizations統合を使用している場合は、招待は不要です。
  invite = true

  # invitation_message (Optional)
  # 設定内容: 招待に含めるカスタムメッセージを指定します。
  # 設定可能な値: 任意の文字列（最大1000文字）
  # 省略時: 標準の招待メッセージのみが送信されます
  # 注意: Amazon Macieは、このメッセージを招待の標準コンテンツに追加します。
  #       invite = trueの場合にのみ有効です。
  invitation_message = "Please accept this invitation to join our Macie administrator account for security monitoring."

  # invitation_disable_email_notification (Optional)
  # 設定内容: 招待時にルートユーザーへのメール通知を無効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: メール通知を送信しない
  #   - false: メール通知を送信する（デフォルト）
  # 省略時: false（メール通知が送信されます）
  # 注意: trueに設定すると、各アカウントのルートユーザーへのメール通知が無効になります。
  #       ただし、AWS Personal Health Dashboardのアラートは引き続き受信されます。
  #       invite = trueの場合にのみ有効です。
  invitation_disable_email_notification = false

  #-------------------------------------------------------------
  # ステータス設定 (オプション)
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: アカウントのステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED": Amazon Macieを有効化し、すべてのMacie活動を開始します
  #   - "PAUSED": Macieの活動を一時停止します（データは保持されますが新規スキャンは停止）
  # 省略時: 現在のステータスが維持されます
  # 注意: PAUSEDステータスでは、既存の検出結果は保持されますが、新規のデータ検出やスキャンは実行されません。
  #       ステータスをENABLEDに戻すことで、Macieの活動を再開できます。
  # 関連機能: Macie活動の一時停止
  #   - https://docs.aws.amazon.com/macie/latest/user/macie-suspend-resume.html
  status = "ENABLED"

  #-------------------------------------------------------------
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Macieはリージョナルサービスです。メンバーアカウントも同じリージョンでMacieを有効化する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定 (オプション)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-macie-member"
    Environment = "production"
    Department  = "security"
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (オプション)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新時のタイムアウト時間を指定します。
  # 注意: 特定の操作に時間がかかる場合に、デフォルトのタイムアウト値を上書きできます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間
    # 設定可能な値: Go言語のtime.Duration形式（例: "60m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間
    # 設定可能な値: Go言語のtime.Duration形式（例: "60m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "60m"
  }

  #-------------------------------------------------------------
  # 依存関係設定
  #-------------------------------------------------------------

  # 注意: このリソースを使用する前に、管理者アカウントでMacieを有効化する必要があります。
  # aws_macie2_accountリソースへの依存関係を明示的に設定することを推奨します。
  # 例:
  # depends_on = [aws_macie2_account.admin]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Macieメンバーの一意識別子（ID）
#       アカウントIDと同じ値になります
#
# - arn: アカウントのAmazon Resource Name (ARN)
#       形式: arn:aws:macie2:region:account-id:member/member-account-id
#
# - relationship_status: アカウントと管理者アカウント間の関係の現在のステータス
#       可能な値:
#         - "Enabled": 関係が確立され、有効
#         - "Paused": 関係は有効だが一時停止中
#         - "Invited": 招待が送信されたが、まだ承認されていない
#         - "Created": アカウントが追加されたが、招待は送信されていない
#         - "Removed": 関係が削除された
#         - "Resigned": メンバーアカウントが関係から離脱した
#         - "EmailVerificationInProgress": メールアドレスの検証中
#         - "EmailVerificationFailed": メールアドレスの検証に失敗
#
# - administrator_account_id: 管理者アカウントのAWSアカウントID
#       このメンバーアカウントを管理している管理者アカウントのIDです
#
#---------------------------------------------------------------
