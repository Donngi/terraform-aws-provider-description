#---------------------------------------------------------------
# AWS Global Accelerator Cross Account Attachment
#---------------------------------------------------------------
#
# AWS Global Acceleratorのクロスアカウントアタッチメントをプロビジョニングします。
# このリソースは、リソース所有者が他のAWSアカウントまたは特定のアクセラレータARNに
# 対して、自身のアカウント内のリソース（Network Load BalancerやBYOIP IPアドレス範囲など）を
# 共有することを許可するために使用されます。
#
# プリンシパル（AWSアカウント番号またはアクセラレータARN）を指定することで、
# それらのプリンシパルがアタッチメントに含まれるリソースをエンドポイントとして
# 追加できるようになります。
#
# AWS公式ドキュメント:
#   - How cross-account works in Global Accelerator:
#     https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.how-it-works.html
#   - Create a cross-account attachment:
#     https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.create-attachment.html
#   - CreateCrossAccountAttachment API:
#     https://docs.aws.amazon.com/global-accelerator/latest/api/API_CreateCrossAccountAttachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_cross_account_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_cross_account_attachment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # クロスアカウントアタッチメントの名前
  # この名前はアタッチメントの識別に使用されます。
  name = "example-cross-account-attachment"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リソースをアクセラレータに関連付けることを許可するAWSアカウントIDまたはアクセラレータARNのリスト
  # 指定されたプリンシパルは、このアタッチメントに含まれるリソースを自身のアクセラレータの
  # エンドポイントとして追加することができます。
  #
  # 例:
  #   - AWSアカウントID: "123456789012"
  #   - アクセラレータARN: "arn:aws:globalaccelerator::123456789012:accelerator/abc123"
  principals = []

  # タグのマップ（キー・バリュー形式）
  # リソースに割り当てるタグを指定します。
  # provider設定でdefault_tagsブロックが設定されている場合、
  # ここで指定したタグはプロバイダーレベルのタグとマージされます。
  tags = {}

  #---------------------------------------------------------------
  # ネストブロック: resource
  #---------------------------------------------------------------
  # アクセラレータに関連付けるリソースのリスト
  # AWSリソース（Network Load Balancerなど）またはBYOIPで持ち込んだIPアドレス範囲を指定できます。
  # BYOIP IPアドレス範囲を共有する前に、それをプロビジョニングしてアドバタイズする必要があります。

  # 例1: Network Load Balancerをリソースとして指定
  # resource {
  #   endpoint_id = "arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/50dc6c495c0c9188"
  #   region      = "us-west-2"
  # }

  # 例2: BYOIP IPアドレス範囲（CIDR）をリソースとして指定
  # resource {
  #   cidr_block = "203.0.113.0/24"
  # }

  # resource {
  #   # リソースとして指定するIPアドレス範囲（CIDR形式）
  #   # BYOIPプロセスを通じてGlobal Acceleratorに持ち込んだIPアドレス範囲を指定します。
  #   # この属性はcidr_blockまたはendpoint_idのどちらか一方を指定します。
  #   cidr_block = null
  #
  #   # AWSリソースとして指定するエンドポイントのエンドポイントID
  #   # 例: Network Load BalancerのARN
  #   # この属性はcidr_blockまたはendpoint_idのどちらか一方を指定します。
  #   endpoint_id = null
  #
  #   # 共有エンドポイントリソースが配置されているAWSリージョン
  #   # endpoint_idを指定する場合は、このリージョンも併せて指定します。
  #   region = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）:
#
# - arn                 : クロスアカウントアタッチメントのARN
# - id                  : クロスアカウントアタッチメントのID
# - created_time        : クロスアカウントアタッチメントの作成日時
# - last_modified_time  : クロスアカウントアタッチメントの最終更新日時
# - tags_all            : リソースに割り当てられた全てのタグのマップ
#                         （provider default_tagsから継承されたものを含む）
#
#---------------------------------------------------------------
