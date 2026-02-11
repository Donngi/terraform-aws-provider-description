#---------------------------------------------------------------
# AWS Cloud Control API Resource
#---------------------------------------------------------------
#
# AWS Cloud Control APIを通じてCloudFormationリソースタイプを管理するリソースです。
# Cloud Control APIは、AWSリソースに対する統一されたCRUD操作を提供し、
# CloudFormationリソースタイプスキーマに基づいてリソースを作成・更新・削除できます。
#
# AWS公式ドキュメント:
#   - Cloud Control API概要: https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/what-is-cloudcontrolapi.html
#   - Cloud Control APIの仕組み: https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/how-it-works.html
#   - リソースタイプの使用: https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/resource-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudcontrolapi_resource
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudcontrolapi_resource" "example" {
  #-------------------------------------------------------------
  # リソースタイプ設定
  #-------------------------------------------------------------

  # type_name (Required)
  # 設定内容: CloudFormationリソースタイプ名を指定します。
  # 設定可能な値: AWS::サービス::リソース形式の文字列
  # 例:
  #   - "AWS::EC2::VPC"
  #   - "AWS::ECS::Cluster"
  #   - "AWS::S3::Bucket"
  #   - "AWS::Lambda::Function"
  # 参考: https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/resource-types.html
  type_name = "AWS::ECS::Cluster"

  #-------------------------------------------------------------
  # リソース状態設定
  #-------------------------------------------------------------

  # desired_state (Required)
  # 設定内容: CloudFormationリソースタイプスキーマに一致するJSON文字列で、
  #           目的のリソース設定を指定します。
  # 設定可能な値: リソースタイプに応じたプロパティを含むJSON文字列
  # 関連機能: jsonencode関数
  #   Terraformの設定式をJSONに変換するために使用します。
  #   - https://www.terraform.io/docs/language/functions/jsonencode.html
  # 注意: JSON形式はCloudFormationリソースタイプスキーマに準拠する必要があります。
  desired_state = jsonencode({
    ClusterName = "example-cluster"
    Tags = [
      {
        Key   = "Environment"
        Value = "production"
      }
    ]
  })

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
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: 操作時に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: Cloud Control API操作に必要な権限を持つロールを指定することで、
  #       特定の権限でリソース操作を実行できます。
  # 参考: https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/resource-operations.html
  role_arn = null

  #-------------------------------------------------------------
  # スキーマ設定
  #-------------------------------------------------------------

  # schema (Optional, Sensitive)
  # 設定内容: CloudFormationリソースタイプスキーマのJSON文字列を指定します。
  #           プラン時の検証に使用されます。
  # 設定可能な値: 有効なCloudFormationリソースタイプスキーマJSON
  # 省略時: 自動的に取得されます
  # 関連機能: aws_cloudformation_type データソース
  #   大規模環境で同じtype_nameを使用する複数リソースがある場合、
  #   DescribeType API操作のスロットリングを軽減するため、
  #   aws_cloudformation_typeデータソースでスキーマを一度取得し、
  #   この引数で指定することを推奨します。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_type
  # 注意: この値は大きなプラン差分を防ぐためsensitiveとしてマークされています。
  schema = null

  #-------------------------------------------------------------
  # バージョン設定
  #-------------------------------------------------------------

  # type_version_id (Optional)
  # 設定内容: CloudFormationリソースタイプのバージョン識別子を指定します。
  # 設定可能な値: 有効なバージョンID文字列
  # 省略時: 最新のデフォルトバージョンが使用されます
  # 用途: 特定バージョンのリソースタイプを使用したい場合に指定します。
  type_version_id = null

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的に生成します
  # 注意: 通常はTerraformによって自動管理されるため、明示的な設定は不要です。
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h", "2h30m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h", "2h30m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h", "2h30m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#
# - properties: 現在の設定に一致するCloudFormationリソースタイプスキーマの
#               JSON文字列。jsondecode()関数を使用して基盤となる属性を参照できます。
#               例: jsondecode(aws_cloudcontrolapi_resource.example.properties)["ClusterArn"]
#               - https://www.terraform.io/docs/language/functions/jsondecode.html
#---------------------------------------------------------------
