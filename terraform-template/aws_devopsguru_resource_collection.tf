#---------------------------------------------------------------
# AWS DevOps Guru Resource Collection
#---------------------------------------------------------------
#
# Amazon DevOps Guruのリソースコレクションをプロビジョニングするリソースです。
# DevOps Guruは機械学習を使用してアプリケーションの運用パフォーマンスと
# 可用性を向上させるサービスで、リソースコレクションは分析対象のAWSリソースを
# 定義します。
#
# 重要: 1つのアカウントで有効にできるリソースコレクションのタイプは1つだけです
# （全アカウントリソース、CloudFormation、またはタグ）。
# 永続的な差分を避けるため、このリソースは1回だけ定義してください。
#
# AWS公式ドキュメント:
#   - DevOps Guru概要: https://docs.aws.amazon.com/devops-guru/latest/userguide/welcome.html
#   - リソースコレクション: https://docs.aws.amazon.com/devops-guru/latest/APIReference/API_ResourceCollection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devopsguru_resource_collection
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_devopsguru_resource_collection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: リソースコレクションのタイプを指定します。
  # 設定可能な値:
  #   - "AWS_CLOUD_FORMATION": 特定のCloudFormationスタックを分析対象とする
  #   - "AWS_SERVICE": 全アカウントリソースを分析対象とする（cloudformationブロックでstack_names = ["*"]を指定）
  #   - "AWS_TAGS": 特定のタグでフィルタされたリソースを分析対象とする
  # 注意: 1つのアカウントで有効にできるタイプは1つだけです
  type = "AWS_CLOUD_FORMATION"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # CloudFormationスタック設定
  #-------------------------------------------------------------
  # type = "AWS_CLOUD_FORMATION" または "AWS_SERVICE" の場合に使用します。
  # DevOps Guruは最大1000個のCloudFormationスタックを分析できます。

  # cloudformation (Optional)
  # 設定内容: 分析対象のCloudFormationスタックのコレクションを指定します。
  # 注意: type = "AWS_SERVICE"（全アカウントリソース）の場合は stack_names = ["*"] を指定
  cloudformation {
    # stack_names (Required)
    # 設定内容: CloudFormationスタック名の配列を指定します。
    # 設定可能な値:
    #   - スタック名のリスト（例: ["ExampleStack1", "ExampleStack2"]）
    #   - ワイルドカード ["*"]（type = "AWS_SERVICE" の場合、全アカウントリソースを対象）
    # 注意: DevOps Guruはこれらのスタックで定義されたリソースを分析します
    stack_names = ["ExampleStack"]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------
  # type = "AWS_TAGS" の場合に使用します。
  # タグを使用してDevOps Guruの分析対象リソースをフィルタリングできます。

  # tags (Optional)
  # 設定内容: リソースコレクション内のリソースをフィルタするためのタグを指定します。
  # 注意: type = "AWS_TAGS" の場合に使用
  # tags {
  #   # app_boundary_key (Required)
  #   # 設定内容: DevOps Guruが分析するリソースを識別するためのAWSタグキーを指定します。
  #   # 設定可能な値: "DevOps-Guru-"プレフィックスで始まる文字列
  #   # 注意:
  #   #   - プレフィックスは大文字小文字を問わず指定できますが、
  #   #     関連するタグはタグキーで同じ大文字小文字を使用する必要があります
  #   #   - このキーでタグ付けされた全リソースがDevOps Guruのアプリケーションと分析境界を構成します
  #   app_boundary_key = "DevOps-Guru-Example"
  #
  #   # tag_values (Required)
  #   # 設定内容: タグ値の配列を指定します。
  #   # 設定可能な値:
  #   #   - 特定のタグ値のリスト（例: ["Value1", "Value2"]）
  #   #   - ワイルドカード ["*"]（app_boundary_keyでタグ付けされた全リソースを対象）
  #   # 注意: 対応するタグ値に関係なく全リソースを分析する場合は ["*"] を使用
  #   tag_values = ["Example-Value"]
  # }
}

#---------------------------------------------------------------
# resource "aws_devopsguru_resource_collection" "all_resources" {
#   type = "AWS_SERVICE"
#   cloudformation {
#     stack_names = ["*"]
#   }
# }

#---------------------------------------------------------------
# resource "aws_devopsguru_resource_collection" "tagged_resources" {
#   type = "AWS_TAGS"
#   tags {
#     app_boundary_key = "DevOps-Guru-MyApp"
#     tag_values       = ["production", "staging"]
#   }
# }

#---------------------------------------------------------------
# resource "aws_devopsguru_resource_collection" "all_tagged_resources" {
#   type = "AWS_TAGS"
#   tags {
#     app_boundary_key = "DevOps-Guru-MyApp"
#     tag_values       = ["*"]
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースコレクションのタイプ（typeと同じ値）
#---------------------------------------------------------------
