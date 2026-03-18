#---------------------------------------------------------------
# AWS Resource Access Manager (RAM) Resource Share Associations Exclusive
#---------------------------------------------------------------
#
# AWS RAM Resource Share の関連付け (プリンシパルおよびリソース) を
# 排他的に管理するためのリソースです。
#
# このリソースは Resource Share に対するプリンシパルとリソースの関連付けの
# 排他的な所有権を持ちます。明示的に設定されていないプリンシパルやリソースは
# 自動的に削除されます。
#
# 重要な注意事項:
#   - このリソースを削除すると、設定済みのすべてのプリンシパルとリソースの
#     関連付けが Resource Share から解除されます
#   - 同一の Resource Share に対して aws_ram_principal_association や
#     aws_ram_resource_association と併用することはできません
#     (併用すると永続的なドリフトと競合が発生します)
#
# AWS公式ドキュメント:
#   - RAM 概要: https://docs.aws.amazon.com/ram/latest/userguide/what-is.html
#   - リソース共有の管理: https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
#   - 共有可能なリソース: https://docs.aws.amazon.com/ram/latest/userguide/shareable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_associations_exclusive
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_resource_share_associations_exclusive" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_share_arn (Required)
  # 設定内容: 関連付けを管理する対象の Resource Share の ARN を指定します。
  # 設定可能な値: 有効な RAM Resource Share の ARN 文字列
  # 注意: この値を変更すると、リソースが再作成されます (ForceNew)
  # 関連機能: RAM Resource Share
  #   先に aws_ram_resource_share リソースで Resource Share を作成しておく必要があります。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing-create.html
  resource_share_arn = aws_ram_resource_share.example.arn

  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principals (Optional)
  # 設定内容: Resource Share に関連付けるプリンシパルのセットを指定します。
  # 設定可能な値:
  #   - AWSアカウントID (12桁の数字, 例: "123456789012")
  #   - AWS Organizations 組織 ARN (例: "arn:aws:organizations::123456789012:organization/o-exampleorgid")
  #   - AWS Organizations OU ARN (例: "arn:aws:organizations::123456789012:ou/o-exampleorgid/ou-examplerootid-exampleouid")
  #   - IAM ロール ARN (例: "arn:aws:iam::123456789012:role/example-role")
  #   - IAM ユーザー ARN (例: "arn:aws:iam::123456789012:user/example-user")
  #   - サービスプリンシパル (例: "ec2.amazonaws.com")
  # 省略時: プリンシパルの関連付けは行われません
  # 注意: ここに設定されていないプリンシパルは自動的に Resource Share から削除されます
  principals = [
    "111111111111",
    "222222222222",
  ]

  #-------------------------------------------------------------
  # リソース設定
  #-------------------------------------------------------------

  # resource_arns (Optional)
  # 設定内容: Resource Share に関連付けるリソースの ARN のセットを指定します。
  # 設定可能な値: 共有可能な AWS リソースの ARN のセット
  # 省略時: リソースの関連付けは行われません
  # 注意: ここに設定されていないリソースは自動的に Resource Share から削除されます
  # 関連機能: RAM 共有可能リソース
  #   Subnet、Transit Gateway、License Configuration など、多数のリソースタイプが共有可能。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/shareable.html
  resource_arns = [
    "arn:aws:ec2:ap-northeast-1:123456789012:subnet/subnet-example",
  ]

  #-------------------------------------------------------------
  # サービスプリンシパル制限設定
  #-------------------------------------------------------------

  # sources (Optional)
  # 設定内容: サービスプリンシパルがリソースにアクセスできるソースアカウントを制限する
  #           AWS アカウント ID のセットを指定します。
  # 設定可能な値: AWS アカウント ID (12桁) のセット
  # 省略時: ソースアカウントの制限は行われません
  # 注意:
  #   - principals にサービスプリンシパルのみが含まれている場合にのみ指定可能
  #   - 指定すると、サービスが共有リソースにアクセスできるソースアカウントを制限します
  # sources = [
  #   "111111111111",
  #   "222222222222",
  # ]
  sources = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは設定した引数がそのまま属性として参照可能です:
# - resource_share_arn: Resource Share の ARN
# - principals: 関連付けられたプリンシパルのセット
# - resource_arns: 関連付けられたリソース ARN のセット
# - sources: ソースアカウント制限のセット
# - region: リソースが管理されているリージョン
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_ram_resource_share: Resource Share 本体を作成します
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share
#
# - aws_ram_principal_association: プリンシパルを個別に関連付けます
#   (このリソースとの併用不可)
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association
#
# - aws_ram_resource_association: リソースを個別に関連付けます
#   (このリソースとの併用不可)
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association
#---------------------------------------------------------------
