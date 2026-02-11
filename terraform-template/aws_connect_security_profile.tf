#================================================
# AWS Connect Security Profile
#================================================
# このテンプレートは2026-01-19に生成されました
# Provider version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については、公式ドキュメントを必ず確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_security_profile
#================================================

resource "aws_connect_security_profile" "example" {
  #================================================
  # 必須パラメータ
  #================================================

  # (Required) Amazon Connectインスタンスの識別子
  # セキュリティプロファイルが作成されるAmazon Connectインスタンスを指定します。
  # 形式: aaaaaaaa-bbbb-cccc-dddd-111111111111
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # (Required) セキュリティプロファイルの名前
  # コンタクトセンター内で一意の名前を指定します。
  # セキュリティプロファイルは、共通の役割（例: Agent、Supervisor）に対応する
  # 権限のグループです。
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/connect-security-profiles.html
  name = "example"

  #================================================
  # オプションパラメータ
  #================================================

  # (Optional) セキュリティプロファイルの説明
  # セキュリティプロファイルの目的や用途を説明するテキスト。
  # 例: "エージェント向けの基本的なアクセス権限を持つプロファイル"
  description = "example description"

  # (Optional) リージョン
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) 権限のリスト
  # セキュリティプロファイルに割り当てる権限の一覧。
  # 権限は、Amazon ConnectダッシュボードやContact Control Panel (CCP)での
  # 特定のタスクへのアクセスを制御します。
  #
  # 一般的な権限の例:
  # - BasicAgentAccess: エージェントとしての基本的なアクセス
  # - OutboundCallAccess: アウトバウンドコールの実行
  # - その他多数の権限が利用可能
  #
  # 利用可能な権限の完全なリストは以下を参照:
  # https://docs.aws.amazon.com/connect/latest/adminguide/security-profile-list.html
  # API参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_ListSecurityProfilePermissions.html
  permissions = [
    "BasicAgentAccess",
    "OutboundCallAccess",
  ]

  # (Optional) タグ
  # セキュリティプロファイルに適用するタグ。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーを持つタグはここで定義したものが優先されます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "Example Security Profile"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # (Optional) すべてのタグ
  # プロバイダーのdefault_tagsから継承されたタグを含む、
  # リソースに割り当てられたすべてのタグのマップ。
  # 通常、このパラメータは明示的に設定する必要はありません。
  tags_all = null

  # (Optional) ID
  # リソースの識別子。通常、Terraformによって自動的に管理されます。
  # 形式: <instance_id>:<security_profile_id>
  # 例: aaaaaaaa-bbbb-cccc-dddd-111111111111:bbbbbbbb-cccc-dddd-eeee-222222222222
  # 注: このパラメータは通常設定する必要はありません
  id = null
}

#================================================
# 出力値（参考）
#================================================
# このリソースは以下の属性を出力します:
#
# - arn: セキュリティプロファイルのAmazon Resource Name (ARN)
# - id: Amazon ConnectインスタンスIDとセキュリティプロファイルIDをコロン(:)で
#       結合した識別子
# - organization_resource_id: セキュリティプロファイルの組織リソース識別子
# - security_profile_id: セキュリティプロファイルの識別子
# - tags_all: プロバイダーのdefault_tagsから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグ
#
# 使用例:
# output "security_profile_arn" {
#   value = aws_connect_security_profile.example.arn
# }
