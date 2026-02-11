#==============================================================================
# AWS Directory Service Shared Directory Accepter
#==============================================================================
# このテンプレートは aws_directory_service_shared_directory_accepter リソースの
# 全プロパティを網羅した設定例です。
#
# Resource: aws_directory_service_shared_directory_accepter
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-22)の情報に基づいています
# - 最新の仕様は公式ドキュメントで確認してください
# - このリソースは、ディレクトリオーナーアカウントから共有されたディレクトリを
#   コンシューマーアカウントで受け入れるために使用します
# - リソースを破棄すると、コンシューマーアカウントから共有ディレクトリが削除されます
#   （オーナーアカウントのディレクトリは影響を受けません）
#
# 公式ドキュメント:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_shared_directory_accepter
# - AWS API: https://docs.aws.amazon.com/directoryservice/latest/devguide/API_AcceptSharedDirectory.html
# - AWS Admin Guide: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/step3_accept_invite.html
#==============================================================================

resource "aws_directory_service_shared_directory_accepter" "example" {
  #----------------------------------------------------------------------------
  # 必須パラメータ (Required Parameters)
  #----------------------------------------------------------------------------

  # shared_directory_id - (Required) 共有ディレクトリの識別子
  # ディレクトリコンシューマーアカウントに保存されているディレクトリの識別子。
  # この値は、ディレクトリオーナーアカウントの共有ディレクトリに対応します。
  # aws_directory_service_shared_directory リソースで作成された
  # shared_directory_id を指定します。
  #
  # Type: string
  # Example: "d-9067example"
  shared_directory_id = "d-9067example"

  #----------------------------------------------------------------------------
  # オプションパラメータ (Optional Parameters)
  #----------------------------------------------------------------------------

  # region - (Optional) このリソースが管理されるAWSリージョン
  # 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # クロスリージョンでディレクトリを共有する場合に使用します。
  #
  # Type: string
  # Example: "us-west-2"
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #----------------------------------------------------------------------------
  # Computed Attributes (読み取り専用)
  #----------------------------------------------------------------------------
  # 以下の属性は Terraform によって自動的に計算され、参照可能です:
  #
  # - id: 共有ディレクトリの識別子
  # - method: ディレクトリの共有に使用された方法 (ORGANIZATIONS または HANDSHAKE)
  # - notes: ディレクトリオーナーからディレクトリコンシューマーに送信されたメッセージ
  #          共有招待を承認するか拒否するかの判断に役立つ情報が含まれます
  # - owner_account_id: ディレクトリオーナーのAWSアカウント識別子
  # - owner_directory_id: ディレクトリオーナーの視点からのManaged Microsoft ADディレクトリの識別子

  #----------------------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #----------------------------------------------------------------------------
  # リソース操作のタイムアウト時間を設定します。
  # 指定しない場合、デフォルトのタイムアウト値が使用されます。

  timeouts {
    # create - (Optional) リソース作成のタイムアウト時間
    # ディレクトリ共有の受け入れ処理に要する最大時間を指定します。
    # Format: "60m" (60分), "1h" (1時間) など
    # Default: デフォルトタイムアウトが適用されます
    create = "60m"

    # delete - (Optional) リソース削除のタイムアウト時間
    # 共有ディレクトリの削除処理に要する最大時間を指定します。
    # Format: "60m" (60分), "1h" (1時間) など
    # Default: デフォルトタイムアウトが適用されます
    delete = "60m"
  }
}

#==============================================================================
# 使用例 (Example Usage)
#==============================================================================
# 以下は、ディレクトリオーナーアカウントとコンシューマーアカウントでの
# 完全な共有ディレクトリのセットアップ例です。

# ディレクトリオーナーアカウント側の設定:
#
# resource "aws_directory_service_shared_directory" "example" {
#   directory_id = aws_directory_service_directory.example.id
#   notes        = "Shared directory for production workloads"
#
#   target {
#     id = data.aws_caller_identity.receiver.account_id
#   }
# }

# ディレクトリコンシューマーアカウント側の設定 (別プロバイダー使用):
#
# resource "aws_directory_service_shared_directory_accepter" "example" {
#   provider = awsalternate
#
#   shared_directory_id = aws_directory_service_shared_directory.example.shared_directory_id
# }

#==============================================================================
# 注意事項とベストプラクティス
#==============================================================================
# 1. プロバイダー設定
#    - このリソースは通常、ディレクトリコンシューマーアカウントの別プロバイダーを使用します
#    - オーナーアカウントとは異なる AWS 認証情報を持つプロバイダーを設定してください
#
# 2. 共有方法 (Share Method)
#    - ORGANIZATIONS: 同じAWS Organizations内のアカウントとの共有
#    - HANDSHAKE: 任意のAWSアカウントとの共有（明示的な承認が必要）
#
# 3. リソースのライフサイクル
#    - リソースを削除すると、コンシューマーアカウントから共有ディレクトリが削除されます
#    - オーナーアカウントのディレクトリは影響を受けません
#    - 共有を完全に解除するには、オーナー側でも aws_directory_service_shared_directory を削除します
#
# 4. 依存関係
#    - aws_directory_service_shared_directory リソースが先に作成されている必要があります
#    - shared_directory_id は共有リクエストが作成された後に利用可能になります
#
# 5. セキュリティ考慮事項
#    - 共有ディレクトリの受け入れ前に、オーナーアカウントと共有の目的を確認してください
#    - notes 属性を確認して、共有の意図を理解してください
#
# 6. リージョン設定
#    - クロスリージョン共有の場合、region パラメータを明示的に指定してください
#    - 共有元と共有先のリージョンが異なる場合の動作を確認してください
#==============================================================================
