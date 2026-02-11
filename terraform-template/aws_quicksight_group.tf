#---------------------------------------------------------------
# Amazon QuickSight グループ
#---------------------------------------------------------------
#
# Amazon QuickSightのユーザーグループを作成します。
# グループはユーザーの集合であり、アクセス管理とセキュリティ管理を
# 簡素化するために使用されます。グループを使用することで、複数のユーザーに
# 対して一括でアクセス権限を設定できます。
#
# AWS公式ドキュメント:
#   - Group API Reference: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_Group.html
#   - CreateGroup: https://docs.aws.amazon.com/quicksight/latest/developerguide/create-group.html
#   - Namespace Operations: https://docs.aws.amazon.com/quicksight/latest/developerguide/namespace-operations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_group" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # グループ名
  # - QuickSightグループの名前を指定します
  # - 最小長: 1文字
  # - パターン: [\u0020-\u00FF]+
  # - 例: "analysts", "data-science-team", "executives"
  group_name = "example-group"


  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # AWSアカウントID
  # - グループを作成するAWSアカウントIDを指定します
  # - 未指定の場合、TerraformプロバイダーのAWSアカウントIDが自動的に使用されます
  # - このパラメータを変更すると、リソースが強制的に再作成されます
  # - 例: "123456789012"
  # aws_account_id = null

  # グループの説明
  # - グループの目的や用途を説明するテキストを指定します
  # - 最小長: 1文字
  # - 最大長: 512文字
  # - 例: "データ分析チーム用のグループ"
  # description = null

  # リソースID
  # - このリソースの識別子を指定します
  # - 通常はTerraformが自動的に生成するため、明示的な指定は不要です
  # - 形式: <aws_account_id>/<namespace>/<group_name>
  # - 例: "123456789012/default/example-group"
  # id = null

  # ネームスペース
  # - QuickSightのネームスペースを指定します
  # - 現在は "default" を設定することが推奨されています
  # - ネームスペースは、ユーザーとグループを論理的に分離するためのコンテナです
  # - マルチテナント環境で、異なる顧客や組織を分離する際に使用されます
  # - 例: "default"
  # namespace = null

  # リージョン
  # - このリソースが管理されるAWSリージョンを指定します
  # - 未指定の場合、プロバイダー設定のリージョンが使用されます
  # - 例: "ap-northeast-1", "us-east-1"
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = null
}


#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースでは、以下の属性が参照可能です（computed）:
#
# - arn
#   - グループのAmazon Resource Name (ARN)
#   - 形式: arn:aws:quicksight:<region>:<account-id>:group/<namespace>/<group-name>
#   - 他のリソースでこのグループを参照する際に使用します
#
# - id
#   - リソースの一意識別子
#   - 形式: <aws_account_id>/<namespace>/<group_name>
#   - Terraformによって自動的に生成されます
