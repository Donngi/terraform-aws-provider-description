#---------------------------------------------------------------
# Amazon Verified Permissions Identity Source
#---------------------------------------------------------------
#
# Amazon Verified Permissions のポリシーストアに紐づくアイデンティティソースを
# 管理するリソース。Cognito ユーザープールまたは OpenID Connect プロバイダーを
# 認証ソースとして設定でき、トークンのクレームをポリシー評価のプリンシパルや
# グループにマッピングすることができる。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedpermissions_identity_source
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#
# Attributes Reference:
#   id                    - アイデンティティソースの識別子
#   policy_store_id       - 関連付けられたポリシーストア ID
#   principal_entity_type - プリンシパルのエンティティタイプ
#   region                - リソースが管理されるリージョン
#-------

resource "aws_verifiedpermissions_identity_source" "example" {

  #-------
  # 基本設定
  #-------

  # 設定内容: アイデンティティソースを関連付けるポリシーストアの ID
  # 設定可能な値: 既存のポリシーストア ID 文字列
  # 省略時: 必須項目のため省略不可
  policy_store_id = "example-policy-store-id"

  # 設定内容: プリンシパルのエンティティタイプ名
  # 設定可能な値: 任意の文字列（例: "MyCorp::User"）
  # 省略時: プロバイダーが自動設定
  principal_entity_type = "MyCorp::User"

  # 設定内容: リソースを管理する AWS リージョン
  # 設定可能な値: 有効な AWS リージョンコード（例: "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

  #-------
  # アイデンティティソース設定（Cognito または OIDC のいずれか一方を指定）
  #-------

  configuration {

    #-------
    # Cognito ユーザープール設定（OIDC を使用する場合は削除）
    #-------

    cognito_user_pool_configuration {

      # 設定内容: Cognito ユーザープールの ARN
      # 設定可能な値: 有効な Cognito ユーザープール ARN
      # 省略時: 必須項目のため省略不可
      user_pool_arn = "arn:aws:cognito-idp:ap-northeast-1:123456789012:userpool/ap-northeast-1_example"

      # 設定内容: 認証を許可するクライアント ID のリスト
      # 設定可能な値: Cognito アプリクライアント ID の文字列リスト
      # 省略時: プロバイダーが自動設定（全クライアントを許可）
      client_ids = ["example-client-id-1", "example-client-id-2"]

      # 設定内容: グループエンティティの設定（オプション）
      # 省略時: グループエンティティマッピングを行わない
      group_configuration {
        # 設定内容: Cognito グループを表す Verified Permissions エンティティタイプ名
        # 設定可能な値: 任意の文字列（例: "MyCorp::Group"）
        # 省略時: 必須項目のため省略不可
        group_entity_type = "MyCorp::Group"
      }
    }

    #-------
    # OpenID Connect 設定（Cognito を使用する場合は削除）
    #-------

    # open_id_connect_configuration {

    #   # 設定内容: OIDC プロバイダーの発行者 URL
    #   # 設定可能な値: 有効な HTTPS URL 文字列
    #   # 省略時: 必須項目のため省略不可
    #   issuer = "https://example.auth0.com/"

    #   # 設定内容: エンティティ ID のプレフィックス文字列
    #   # 設定可能な値: 任意の文字列
    #   # 省略時: プレフィックスなし
    #   entity_id_prefix = "https://example.auth0.com/"

    #   # 設定内容: グループエンティティの設定（オプション）
    #   group_configuration {
    #     # 設定内容: グループ情報を含む JWT クレーム名
    #     # 設定可能な値: 任意の文字列（例: "groups"）
    #     # 省略時: 必須項目のため省略不可
    #     group_claim = "groups"

    #     # 設定内容: グループを表す Verified Permissions エンティティタイプ名
    #     # 設定可能な値: 任意の文字列（例: "MyCorp::Group"）
    #     # 省略時: 必須項目のため省略不可
    #     group_entity_type = "MyCorp::Group"
    #   }

    #   # 設定内容: トークン選択設定（アクセストークンまたは ID トークンのいずれか一方）
    #   token_selection {

    #     # 設定内容: アクセストークンのみを使用する場合の設定
    #     access_token_only {
    #       # 設定内容: 許可するオーディエンスのリスト
    #       # 設定可能な値: 文字列リスト
    #       # 省略時: オーディエンス検証なし
    #       audiences = ["https://myapi.example.com/"]

    #       # 設定内容: プリンシパル ID として使用するクレーム名
    #       # 設定可能な値: 任意のクレーム名文字列（例: "sub"）
    #       # 省略時: デフォルトのクレームを使用
    #       principal_id_claim = "sub"
    #     }

    #     # 設定内容: ID トークンのみを使用する場合の設定
    #     identity_token_only {
    #       # 設定内容: 許可するクライアント ID のリスト
    #       # 設定可能な値: 文字列リスト
    #       # 省略時: クライアント ID 検証なし
    #       client_ids = ["example-client-id"]

    #       # 設定内容: プリンシパル ID として使用するクレーム名
    #       # 設定可能な値: 任意のクレーム名文字列（例: "sub"）
    #       # 省略時: デフォルトのクレームを使用
    #       principal_id_claim = "sub"
    #     }
    #   }
    # }
  }
}
