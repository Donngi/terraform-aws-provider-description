#---------------------------------------------------------------
# AWS QuickSight Template Alias
#---------------------------------------------------------------
#
# Amazon QuickSight のテンプレートエイリアスをプロビジョニングするリソースです。
# テンプレートエイリアスは特定のテンプレートバージョンへの参照であり、
# エイリアス名を使ってテンプレートのバージョンを管理・参照できます。
#
# AWS公式ドキュメント:
#   - テンプレートエイリアス操作: https://docs.aws.amazon.com/quicksight/latest/developerguide/template-alias-operations.html
#   - CreateTemplateAlias API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateTemplateAlias.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_template_alias
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_template_alias" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # alias_name (Required, Forces new resource)
  # 設定内容: テンプレートエイリアスの表示名を指定します。
  # 設定可能な値: 最大2048文字の文字列。英数字、ハイフン、および予約値 "$LATEST"、"$PUBLISHED" が使用可能
  # 注意: "$LATEST" は最新バージョン、"$PUBLISHED" は公開済みバージョンを指す予約名です。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_TemplateAlias.html
  alias_name = "example-alias"

  # template_id (Required, Forces new resource)
  # 設定内容: エイリアスを作成する対象のテンプレートIDを指定します。
  # 設定可能な値: 有効なQuickSightテンプレートID文字列
  # 参考: https://docs.aws.amazon.com/quicksight/latest/developerguide/template-alias-operations.html
  template_id = "example-template-id"

  # template_version_number (Required)
  # 設定内容: エイリアスが指す対象のテンプレートバージョン番号を指定します。
  # 設定可能な値: 1以上の整数
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateTemplateAlias.html
  template_version_number = 1

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: テンプレートエイリアスを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用します。
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テンプレートエイリアスのAmazon Resource Name (ARN)
#
# - id: AWSアカウントID、テンプレートID、エイリアス名をカンマで結合した文字列
#---------------------------------------------------------------
