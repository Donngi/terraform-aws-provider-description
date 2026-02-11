################################################################################
# Terraform AWS Resource Template: aws_cognito_resource_server
################################################################################
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# ⚠️ 注意事項:
# - このテンプレートは生成時点(2026-01-19)の情報です
# - 最新の仕様は公式ドキュメントを必ず確認してください
# - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_resource_server
# - AWS公式: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-define-resource-servers.html
################################################################################

resource "aws_cognito_resource_server" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # identifier - (Required) リソースサーバーの識別子
  # OAuth 2.0 リソースサーバーを一意に識別するための識別子です。
  # 通常はAPI のURL形式で指定します（例: https://example.com または https://api.example.com）。
  # この識別子は、アクセストークンの aud (audience) クレームに含まれ、
  # カスタムスコープは "identifier/scope_name" の形式で表現されます。
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-define-resource-servers.html
  identifier = "https://api.example.com"

  # name - (Required) リソースサーバーの名前
  # リソースサーバーを識別するための分かりやすい名前です。
  # この名前はCognito コンソールやAPIレスポンスで表示されます。
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-define-resource-servers.html
  name = "Example Resource Server"

  # user_pool_id - (Required) このリソースサーバーが所属するユーザープールのID
  # リソースサーバーを関連付けるCognito ユーザープールのIDを指定します。
  # リソースサーバーは特定のユーザープールに紐づけられます。
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-define-resource-servers.html
  user_pool_id = aws_cognito_user_pool.example.id

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # id - (Optional) リソースのTerraform識別子
  # Terraformがこのリソースを識別するためのIDです。
  # 指定しない場合は自動的に生成されます。
  # 通常は明示的に指定する必要はありません。
  # id = "custom-id"

  # region - (Optional) このリソースが管理されるAWSリージョン
  # このリソースサーバーを作成するAWSリージョンを明示的に指定します。
  # デフォルトではプロバイダー設定で指定されたリージョンが使用されます。
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================================
  # Block Types
  # ============================================================================

  # scope - (Optional) 認可スコープのリスト
  # OAuth 2.0 カスタムスコープを定義します。最大100個まで設定可能です。
  # スコープはアクセストークンに含まれ、API へのアクセス権限を細かく制御できます。
  # 各スコープは "identifier/scope_name" の形式で識別されます。
  #
  # スコープを使用することで:
  # - アプリケーションごとに異なるアクセスレベルを付与
  # - マシン間(M2M)認証でのアクセス制御
  # - テナントごとのマルチテナント構成
  # などが実現できます。
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-define-resource-servers.html
  # https://docs.aws.amazon.com/cognito/latest/developerguide/scope-based-multi-tenancy.html
  scope {
    # scope_name - (Required) スコープの名前
    # カスタムスコープの名前です。1〜256文字で指定します。
    # アクセストークンには "identifier/scope_name" の形式で含まれます。
    # 例: identifier が "https://api.example.com" で scope_name が "read" の場合、
    # 完全なスコープ識別子は "https://api.example.com/read" になります。
    #
    # パターン: [\x21\x23-\x2E\x30-\x5B\x5D-\x7E]+
    #
    # AWS公式ドキュメント:
    # https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_ResourceServerScopeType.html
    scope_name = "read"

    # scope_description - (Required) スコープの説明
    # カスタムスコープの分かりやすい説明です。1〜256文字で指定します。
    # この説明はCognito コンソールやAPIレスポンスで表示され、
    # スコープの目的や権限内容を理解するのに役立ちます。
    #
    # AWS公式ドキュメント:
    # https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_ResourceServerScopeType.html
    scope_description = "Read access to the API"
  }

  # 複数のスコープを定義する例:
  # scope {
  #   scope_name        = "write"
  #   scope_description = "Write access to the API"
  # }
  #
  # scope {
  #   scope_name        = "admin"
  #   scope_description = "Administrative access to the API"
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# これらの属性は作成後にAWSによって自動的に生成され、参照のみ可能です。
#
# - scope_identifiers: 設定されたすべてのスコープのリスト
#   形式: ["identifier/scope_name1", "identifier/scope_name2", ...]
#   例: ["https://api.example.com/read", "https://api.example.com/write"]
#
#   使用例:
#   output "resource_server_scopes" {
#     value = aws_cognito_resource_server.example.scope_identifiers
#   }
#
# AWS公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_resource_server#attribute-reference
################################################################################

################################################################################
# 使用例とベストプラクティス
################################################################################
# 1. 基本的なリソースサーバー設定:
#    - identifier に API の URL を使用
#    - 明確で分かりやすい name を設定
#    - 必要最小限のスコープから開始
#
# 2. スコープ設計のベストプラクティス:
#    - スコープ名は動作を明確に表現 (read, write, delete など)
#    - スコープの粒度を適切に設計（細かすぎず、粗すぎず）
#    - 説明文で権限の範囲を明確に記述
#
# 3. マルチテナント構成:
#    - テナント識別用のカスタムスコープを定義
#    - アプリケーションクライアントごとに異なるスコープを割り当て
#    - https://docs.aws.amazon.com/cognito/latest/developerguide/scope-based-multi-tenancy.html
#
# 4. M2M (Machine-to-Machine) 認証:
#    - client_credentials フローで使用
#    - アプリケーションクライアントに必要なスコープのみを許可
#    - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-define-resource-servers.html
################################################################################
