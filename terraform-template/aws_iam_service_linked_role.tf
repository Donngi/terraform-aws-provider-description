#---------------------------------------------------------------
# AWS IAM Service-Linked Role
#---------------------------------------------------------------
#
# IAMサービスリンクロールをプロビジョニングするリソースです。
# サービスリンクロールは、AWSサービスに直接リンクされた固有のIAMロールです。
# サービスがユーザーに代わってAWSリソースを呼び出すために必要な権限が
# 事前定義されており、AWSサービスによって自動的に作成・管理されます。
#
# AWS公式ドキュメント:
#   - IAMサービスリンクロールの使用: https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html
#   - サービスリンクロールをサポートするAWSサービス一覧: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_service_linked_role" "example" {
  #-------------------------------------------------------------
  # サービス設定
  #-------------------------------------------------------------

  # aws_service_name (Required, Forces new resource)
  # 設定内容: このロールをリンクさせるAWSサービスのDNS名を指定します。
  # 設定可能な値: AWSサービスのDNS名（例: elasticbeanstalk.amazonaws.com、
  #   ec2.amazonaws.com、autoscaling.amazonaws.com など）
  # 参考: サポートされるサービスの一覧は https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html を参照してください。
  aws_service_name = "elasticbeanstalk.amazonaws.com"

  # custom_suffix (Optional, Forces new resource)
  # 設定内容: ロール名に追加するカスタムサフィックスを指定します。
  # 設定可能な値: 英数字およびアンダースコアからなる文字列
  # 省略時: サフィックスなし（デフォルトのロール名が使用されます）
  # 注意: 全てのAWSサービスがカスタムサフィックスをサポートしているわけではありません。
  #       カスタムサフィックスを使用することで、同一サービスに対して複数のサービスリンクロールを作成できます。
  custom_suffix = null

  #-------------------------------------------------------------
  # ロール情報設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: IAMサービスリンクロールの説明文を指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明文なし
  description = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name      = "example-service-linked-role"
    ManagedBy = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: IAMサービスリンクロールのAmazon Resource Name (ARN)
# - create_date: IAMロールの作成日時
# - name: IAMロールの名前
# - path: IAMロールのパス
# - unique_id: ロールを識別する安定した一意の文字列
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む、
#             リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
