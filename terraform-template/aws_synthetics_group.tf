#---------------------------------------------------------------
# CloudWatch Synthetics Group
#---------------------------------------------------------------
#
# Amazon CloudWatch Syntheticsのグループリソースをプロビジョニングします。
# グループを使用することで、複数のCanary（異なるリージョンのものを含む）
# を関連付け、一元管理、自動化、集約された実行結果や統計情報の確認が可能です。
#
# グループはグローバルリソースとして全AWSリージョンにレプリケートされ、
# 1つのグループに最大10個のCanaryを関連付けることができます。
# 1つのCanaryは最大10個のグループに所属できます。
#
# AWS公式ドキュメント:
#   - グループの概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Groups.html
#   - CreateGroup API: https://docs.aws.amazon.com/AmazonSynthetics/latest/APIReference/API_CreateGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_synthetics_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Syntheticsグループの名前を指定します。
  # 設定可能な値: 文字列（アカウント内で一意である必要があります）
  # 関連機能: CloudWatch Synthetics グループ
  #   グループを使用することで、複数のCanaryを論理的にグループ化し、
  #   管理や監視を容易にします。グループごとに集約された実行結果や
  #   統計情報を確認できます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Groups.html
  name = "example-group"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で定義されたリージョンが使用されます
  # 関連機能: CloudWatch Synthetics グループのリージョン管理
  #   グループ自体はグローバルリソースとして全リージョンにレプリケートされますが、
  #   管理リージョンを明示的に指定することで、リソースの管理場所を制御できます。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: グループに関連付けるキー・バリュー形式のタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   タグを使用することで、リソースの整理、分類、コスト追跡が可能になります。
  #   プロバイダーレベルでdefault_tagsが設定されている場合、
  #   ここで指定したタグは同じキーのdefault_tagsを上書きします。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Groups.html
  tags = {
    Name        = "example-synthetics-group"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 高度な設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: Terraformリソースの識別子を明示的に指定します。
  # 省略時: グループ作成後にgroup_idと同じ値が自動設定されます
  # 注意: この属性は通常、明示的に指定する必要はありません
  id = null

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられる全てのタグを明示的に指定します。
  # 省略時: プロバイダーのdefault_tagsと個別のtagsがマージされた結果が自動設定されます
  # 注意: この属性は通常、明示的に指定する必要はありません
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: グループのAmazon Resource Name (ARN)
#        他のリソースからの参照や、IAMポリシーでの権限設定に使用します。
#
# - group_id: グループの一意な識別子
#             APIリクエストやグループの特定に使用します。
#---------------------------------------------------------------

#---------------------------------------------------------------
# グループ作成後、aws_synthetics_group_associationリソースを使用して
# Canaryをグループに関連付けることができます:
#
# resource "aws_synthetics_canary" "example" {
#   name                 = "example-canary"
#   artifact_s3_location = "s3://bucket-name/prefix"
#   execution_role_arn   = aws_iam_role.canary.arn
#   handler              = "pageLoadBlueprint.handler"
#   runtime_version      = "syn-nodejs-puppeteer-7.0"
#   schedule {
#     expression = "rate(5 minutes)"
#   }
#---------------------------------------------------------------
