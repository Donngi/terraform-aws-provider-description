#---------------------------------------------------------------
# QuickSight Template Alias
#---------------------------------------------------------------
#
# Amazon QuickSightテンプレートの特定バージョンへのエイリアスを作成します。
# テンプレートエイリアスを使用することで、テンプレートの特定バージョンを
# 識別しやすい名前で参照できます。
#
# AWS公式ドキュメント:
#   - Template alias operations: https://docs.aws.amazon.com/quicksight/latest/developerguide/template-alias-operations.html
#   - CreateTemplateAlias API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateTemplateAlias.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_template_alias
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_template_alias" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # テンプレートエイリアスの表示名
  # - エイリアスを識別するための名前を指定します
  # - この値を変更すると、リソースが再作成されます (Forces new resource)
  # - 特殊値として "$LATEST" や "$PUBLISHED" を使用できます
  # - 例: "production"、"latest"、"v1.0"
  alias_name = "example-alias"

  # テンプレートID
  # - エイリアスを作成するテンプレートのIDを指定します
  # - この値を変更すると、リソースが再作成されます (Forces new resource)
  # - ListTemplates APIで利用可能なテンプレートIDを取得できます
  # - 通常、aws_quicksight_template.example.template_id のように参照します
  template_id = "template-id"

  # テンプレートバージョン番号
  # - このエイリアスが参照するテンプレートのバージョン番号を指定します
  # - エイリアスを更新することで、異なるバージョンを参照させることができます
  # - バージョン番号は1から始まる整数値です
  # - この値は更新可能です（リソースの再作成は不要）
  template_version_number = 1

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # AWSアカウントID
  # - テンプレートエイリアスを作成するAWSアカウントのIDを指定します
  # - 指定しない場合、Terraform AWSプロバイダーの設定から自動的に決定されます
  # - この値を変更すると、リソースが再作成されます (Forces new resource)
  # - クロスアカウント操作を行う場合に明示的に指定します
  # aws_account_id = "123456789012"

  # リージョン
  # - このリソースが管理されるAWSリージョンを指定します
  # - 指定しない場合、プロバイダー設定で指定されたリージョンが使用されます
  # - 利用可能なリージョンについては、AWSリージョナルエンドポイントのドキュメントを参照してください
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - arn: テンプレートエイリアスのAmazon Resource Name (ARN)
# - id: AWSアカウントID、テンプレートID、エイリアス名をカンマ区切りで結合した文字列
#
# これらの属性は他のリソースやデータソースで参照できます:
# 例: aws_quicksight_template_alias.example.arn
#---------------------------------------------------------------
