#---------------------------------------------------------------
# AWS Glue Resource Policy
#---------------------------------------------------------------
#
# AWS Glue Data Catalogに対するリソースベースのアクセス制御ポリシーを
# プロビジョニングするリソースです。リソースポリシーは1リージョンにつき
# 1つのみ設定可能で、クロスアカウントアクセスや同一アカウント内の
# きめ細かいアクセス制御に使用します。
#
# AWS公式ドキュメント:
#   - Glue リソースベースポリシー: https://docs.aws.amazon.com/glue/latest/dg/security_iam_service-with-iam.html
#   - クロスアカウントアクセス: https://docs.aws.amazon.com/glue/latest/dg/cross-account-access.html
#   - リソースベースポリシー例: https://docs.aws.amazon.com/glue/latest/dg/security_iam_resource-based-policy-examples.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_resource_policy" "example" {
  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: AWS Glue Data Catalogに適用するIAMリソースベースポリシーのJSON文字列を指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列。aws_iam_policy_documentデータソースの
  #              jsonoutputを使用することを推奨します。
  # 注意: ポリシーのサイズ上限は10KBです。ポリシードキュメントは
  #       アタッチ先カタログに属するリソースのARNのみを含む必要があります。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/security_iam_resource-based-policy-examples.html
  policy = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # ハイブリッドアクセス設定
  #-------------------------------------------------------------

  # enable_hybrid (Optional)
  # 設定内容: クロスアカウントアクセスの付与にAWS GlueとAWS Lake Formationの
  #           両方の方法を使用するハイブリッドモードを有効にするかを指定します。
  # 設定可能な値:
  #   - "TRUE": ハイブリッドモードを有効化。AWS RAMリソース共有を使用した
  #             既存のクロスアカウント付与がある場合にglue:PutResourcePolicy API使用時に必須。
  #   - "FALSE": ハイブリッドモードを無効化
  # 省略時: ハイブリッドモードは無効
  # 注意: Terraformはこのフィールドの差分検出（drift detection）を実行しません。
  #       読み取り時に返されないフィールドのため、適用後の変更はTerraformで検出されません。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/hybrid-cross-account.html
  enable_hybrid = "FALSE"

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
# - id: リソースポリシーのID（通常はアカウントIDとリージョンの組み合わせ）
#---------------------------------------------------------------
