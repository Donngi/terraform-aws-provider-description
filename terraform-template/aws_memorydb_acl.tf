#---------------------------------------------------------------
# Amazon MemoryDB ACL (Access Control List)
#---------------------------------------------------------------
#
# Amazon MemoryDBクラスターへのアクセスを制御するACL（Access Control List）を
# 作成します。ACLはユーザーをグループ化し、MemoryDBクラスターへのアクセス権限を
# 管理するために使用されます。
#
# ACLを使用することで、以下のことが可能になります:
# - 複数のユーザーを1つのACLにグループ化
# - ACLをクラスターに関連付けてアクセス制御を実施
# - ユーザーごとに異なるアクセス権限（コマンド、キー）を設定
#
# AWS公式ドキュメント:
#   - Authenticating users with Access Control Lists (ACLs):
#     https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html
#   - CreateACL API Reference:
#     https://docs.aws.amazon.com/memorydb/latest/APIReference/API_CreateACL.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/memorydb_acl
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_acl" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name - (任意, 変更時は再作成)
  # ACLの名前を指定します。省略した場合、Terraformがランダムな一意の名前を
  # 自動生成します。name_prefixとは同時に指定できません。
  #
  # 命名規則:
  # - 英小文字、数字、ハイフンが使用可能
  # - 先頭は英小文字で始まる必要があります
  #
  # Type: string
  name = null

  # name_prefix - (任意, 変更時は再作成)
  # 指定したプレフィックスで始まる一意の名前を自動生成します。
  # nameとは同時に指定できません。
  #
  # 例: "my-acl-" を指定すると "my-acl-abc123" のような名前が生成されます
  #
  # Type: string
  name_prefix = null

  #---------------------------------------------------------------
  # ユーザー設定
  #---------------------------------------------------------------

  # user_names - (任意)
  # このACLに含めるMemoryDBユーザー名のセットを指定します。
  #
  # 注意事項:
  # - 事前にaws_memorydb_userリソースでユーザーを作成しておく必要があります
  # - 各ユーザーはアクセス文字列（access string）でコマンドやキーへの
  #   アクセス権限が定義されています
  # - "default"ユーザーを含めることも可能です
  # - ACLをクラスターに関連付けると、リストされたユーザーのみが
  #   クラスターにアクセスできます
  #
  # Type: set(string)
  user_names = null

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region - (任意)
  # このリソースを管理するAWSリージョンを指定します。
  # 省略した場合、プロバイダー設定のリージョンが使用されます。
  #
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Type: string
  region = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags - (任意)
  # リソースに割り当てるタグのマップを指定します。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーのタグはここでの設定で上書きされます。
  #
  # Type: map(string)
  tags = null
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
#
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です。
# リソース作成後に他のリソースから参照する際に使用できます。
#
# arn - ACLのAmazon Resource Name (ARN)
#   形式: arn:aws:memorydb:<region>:<account-id>:acl/<acl-name>
#   使用例: aws_memorydb_acl.this.arn
#
# id - ACLの識別子（nameと同じ値）
#   使用例: aws_memorydb_acl.this.id
#
# minimum_engine_version - このACLがサポートする最小エンジンバージョン
#   使用例: aws_memorydb_acl.this.minimum_engine_version
#
# tags_all - プロバイダーのdefault_tagsを含む全てのタグのマップ
#   使用例: aws_memorydb_acl.this.tags_all
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 例1: 基本的なACLの作成
#
# resource "aws_memorydb_acl" "example" {
#   name       = "my-acl"
#   user_names = ["my-user-1", "my-user-2"]
# }
#
#---------------------------------------------------------------
#
# 例2: ユーザーと組み合わせた完全な例
#
# resource "aws_memorydb_user" "admin" {
#   user_name     = "admin-user"
#   access_string = "on ~* &* +@all"
#
#   authentication_mode {
#     type      = "password"
#     passwords = ["your-secure-password-here"]
#   }
# }
#
# resource "aws_memorydb_acl" "example" {
#   name       = "admin-acl"
#   user_names = [aws_memorydb_user.admin.user_name]
#
#   tags = {
#     Environment = "production"
#   }
# }
#
# resource "aws_memorydb_cluster" "example" {
#   acl_name   = aws_memorydb_acl.example.name
#   # ... その他の設定
# }
#
#---------------------------------------------------------------
