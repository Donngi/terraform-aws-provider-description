#---------------------------------------------------------------
# AWS AppSync Type
#---------------------------------------------------------------
#
# AWS AppSyncのGraphQL APIにカスタム型（Type）を定義するリソースです。
# GraphQL APIのスキーマに含まれる型（Query, Mutation, Subscription、
# カスタムオブジェクト型など）を個別に管理できます。
#
# AWS公式ドキュメント:
#   - AppSync概要: https://docs.aws.amazon.com/appsync/latest/devguide/what-is-appsync.html
#   - GraphQL スキーマ: https://docs.aws.amazon.com/appsync/latest/devguide/designing-your-schema.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_type
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_type" "example" {
  #-------------------------------------------------------------
  # GraphQL API設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: 型を追加するGraphQL APIのIDを指定します。
  # 設定可能な値: 有効なAppSync GraphQL API ID
  # 注意: aws_appsync_graphql_apiリソースのidを参照することが一般的です。
  api_id = aws_appsync_graphql_api.example.id

  #-------------------------------------------------------------
  # フォーマット設定
  #-------------------------------------------------------------

  # format (Required)
  # 設定内容: 型定義のフォーマットを指定します。
  # 設定可能な値:
  #   - "SDL": Schema Definition Language形式。GraphQL標準のスキーマ記法
  #   - "JSON": JSON形式。プログラマティックな型定義に適用
  # 参考: SDLはGraphQLの標準的なスキーマ定義言語で、人間が読みやすい形式です。
  format = "SDL"

  #-------------------------------------------------------------
  # 型定義設定
  #-------------------------------------------------------------

  # definition (Required)
  # 設定内容: 型の定義を指定します。
  # 設定可能な値: formatで指定した形式に従った型定義文字列
  # 注意: formatが"SDL"の場合はGraphQL SDL形式、"JSON"の場合はJSON形式で記述
  #
  # SDL形式の例:
  #   type Post {
  #     id: ID!
  #     title: String!
  #     content: String
  #   }
  #
  # Mutation型の例:
  #   type Mutation {
  #     putPost(id: ID!, title: String!): Post
  #   }
  definition = <<EOF
type Mutation {
  putPost(id: ID!, title: String!): Post
}
EOF

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: "api-id:format:name" 形式の文字列
  # 省略時: Terraformが自動的に生成します（api_id:format:nameの形式）
  # 注意: 通常は指定する必要はありません。インポート時などに使用されます。
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 型のAmazon Resource Name (ARN)
#
# - description: 型の説明（GraphQLスキーマで定義された場合）
#
# - id: 型の識別子。フォーマット: "api-id:format:name"
#
# - name: 型の名前（定義から自動的に抽出されます）
#---------------------------------------------------------------
