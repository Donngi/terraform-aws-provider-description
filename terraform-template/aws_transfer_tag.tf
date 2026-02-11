#---------------------------------------------------------------
# AWS Transfer Family Tag
#---------------------------------------------------------------
#
# AWS Transfer Family リソースに対する個別のタグをプロビジョニングするリソースです。
# このリソースは、Transfer Familyリソースが Terraform 外で作成された場合
# （例: AWS Management Console を使用しないサーバー）や、タグキーに `aws:`
# プレフィックスが含まれる場合にのみ使用すべきです。
#
# 注意事項:
# - このタグ管理リソースは、親リソースを管理するTerraformリソースと
#   組み合わせて使用しないでください。
# - 例: aws_transfer_server と aws_transfer_tag を同じサーバーのタグ管理に
#   使用すると、永続的な差分が発生します。aws_transfer_server リソースが
#   aws_transfer_tag リソースによって追加されたタグを削除しようとします。
# - このタグ管理リソースは、プロバイダーの ignore_tags 設定を使用しません。
#
# AWS公式ドキュメント:
#   - Transfer Family タグベースポリシー: https://docs.aws.amazon.com/transfer/latest/userguide/security_iam_tag-based-policy-examples.html
#   - Transfer Family Tag API: https://docs.aws.amazon.com/transfer/latest/APIReference/API_Tag.html
#   - Transfer Family TagResource API: https://docs.aws.amazon.com/transfer/latest/APIReference/API_TagResource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_tag
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_tag" "example" {
  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # key (Required)
  # 設定内容: タグの名前（キー）を指定します。
  # 設定可能な値: 0～128文字の文字列
  # 用途: Transfer Familyリソースの検索、グループ化、アクセス制御に使用
  # 関連機能: AWS Transfer Family タグ
  #   タグはメタデータとしてサーバー、ユーザー、ロールに適用できます。
  #   IAMポリシーでタグ条件キーを使用することで、タグに基づいた
  #   きめ細かく動的なアクセス制御が可能になります。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_Tag.html
  # 例: "transfer:route53HostedZoneId", "transfer:customHostname", "Environment", "stage"
  key = "transfer:route53HostedZoneId"

  # value (Required)
  # 設定内容: タグの値を指定します。
  # 設定可能な値: 0～256文字の文字列
  # 用途: タグキーに対応する値として、リソースの分類や設定値を指定
  # 関連機能: AWS Transfer Family タグ
  #   各タグはキーと値のペアで構成され、キーに対して1つ以上の値を
  #   割り当てることができます。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_Tag.html
  # 例: "/hostedzone/MyHostedZoneId", "example.com", "production", "prod"
  value = "/hostedzone/Z1234567890ABC"

  #-------------------------------------------------------------
  # リソース識別設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: タグを付与するTransfer FamilyリソースのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なTransfer FamilyリソースのARN
  # 対象リソース: サーバー、ユーザー、ロール等のTransfer Familyリソース
  # 関連機能: Transfer Family リソースタグ付け
  #   ARNを使用してタグを特定のリソースにアタッチします。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_TagResource.html
  # 例: "arn:aws:transfer:us-east-1:123456789012:server/s-1234567890abcdef0"
  resource_arn = "arn:aws:transfer:ap-northeast-1:123456789012:server/s-1234567890abcdef0"

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
  # リソース識別子（オプション）
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: Transfer Familyリソース識別子とキーをカンマ (`,`) で区切った形式の識別子。
  # 省略時: Terraformが自動的に生成します。
  # 注意: 通常は明示的に設定する必要はありません。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Transfer Familyリソース識別子とキーをカンマ (`,`) で区切った形式。
#       例: "arn:aws:transfer:us-east-1:123456789012:server/s-abc123,MyTagKey"
#---------------------------------------------------------------
