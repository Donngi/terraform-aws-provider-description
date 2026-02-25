#---------------------------------------------------------------
# AWS RAM リソース共有 プリンシパル関連付け
#---------------------------------------------------------------
#
# AWS Resource Access Manager (RAM) のリソース共有にプリンシパルを
# 関連付けるリソースです。プリンシパルはAWSアカウントID、AWS Organizations
# の組織ARN、または組織ユニットARNを指定できます。
#
# RAM Sharing with AWS Organizationsが有効な場合の動作:
#   - 同一組織内のAWSアカウント・組織・組織ユニットへの共有では
#     招待なしで自動的にリソースが利用可能になります。
#   - 組織外のAWSアカウントへの共有では招待が送信され、
#     受諾が必要です（aws_ram_resource_share_accepterを使用）。
#
# RAM Sharing with AWS Organizationsが無効な場合の動作:
#   - 組織・組織ユニットのARNは使用不可。
#   - AWSアカウントIDへの共有では招待が送信され、受諾が必要です。
#
# AWS公式ドキュメント:
#   - RAM プリンシパル概念: https://docs.aws.amazon.com/ram/latest/APIReference/API_Principal.html
#   - RAM リソース共有の管理: https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_principal_association" "example" {
  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principal (Required, Forces new resource)
  # 設定内容: リソース共有に関連付けるプリンシパルを指定します。
  # 設定可能な値:
  #   - AWSアカウントID（例: "111111111111"）
  #   - AWS Organizations 組織ARN（例: "arn:aws:organizations::123456789012:organization/o-xxxxxxxxxx"）
  #   - AWS Organizations 組織ユニットARN（例: "arn:aws:organizations::123456789012:ou/o-xxxxxxxxxx/ou-xxxx-xxxxxxxx"）
  # 注意: 組織・組織ユニットのARNを使用するにはRAM Sharing with AWS Organizationsの有効化が必要
  # 参考: https://docs.aws.amazon.com/ram/latest/APIReference/API_Principal.html
  principal = "111111111111"

  #-------------------------------------------------------------
  # リソース共有設定
  #-------------------------------------------------------------

  # resource_share_arn (Required, Forces new resource)
  # 設定内容: プリンシパルを関連付けるリソース共有のARNを指定します。
  # 設定可能な値: 有効なRAMリソース共有のARN
  # 参考: https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
  resource_share_arn = "arn:aws:ram:ap-northeast-1:123456789012:resource-share/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソース共有ARNとプリンシパルをカンマで結合した文字列
#       （例: arn:aws:ram:...:resource-share/xxx,111111111111）
#---------------------------------------------------------------
