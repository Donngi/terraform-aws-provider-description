#---------------------------------------------------------------
# AWS Secrets Manager Tag
#---------------------------------------------------------------
#
# AWS Secrets Manager のシークレットに対して個別のタグを管理するリソースです。
# このリソースは、Terraform外で作成されたシークレット（例: RDSなどの
# AWSサービスが管理するサービスリンクシークレット）にタグを付与する場合に
# 使用します。
#
# 注意: aws_secretsmanager_secret リソースと組み合わせて同一シークレットの
#       タグを管理すると、永続的な差分が発生します。同一構成内で親リソースを
#       作成する場合は、親リソースの lifecycle ブロックに
#       ignore_changes = [tags] を追加してください。
#
# 注意: このリソースはプロバイダーの ignore_tags 設定を使用しません。
#
# AWS公式ドキュメント:
#   - Secrets Manager シークレットのタグ付け: https://docs.aws.amazon.com/secretsmanager/latest/userguide/managing-secrets_tagging.html
#   - サービスリンクシークレット: https://docs.aws.amazon.com/secretsmanager/latest/userguide/service-linked-secrets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_tag
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_secretsmanager_tag" "example" {
  #-------------------------------------------------------------
  # シークレット指定
  #-------------------------------------------------------------

  # secret_id (Required)
  # 設定内容: タグを付与するAWS Secrets Managerシークレットの識別子を指定します。
  # 設定可能な値: シークレットのARNまたはフレンドリーネーム
  # 注意: Terraform外で作成されたシークレット（サービスリンクシークレット等）を
  #       対象とすることを推奨。aws_secretsmanager_secret リソースで管理する
  #       シークレットに対して使用する場合は、親リソースの lifecycle ブロックに
  #       ignore_changes = [tags] を追加してください。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/userguide/service-linked-secrets.html
  secret_id = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:my-secret-AbCdEf"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # key (Required)
  # 設定内容: タグのキー名を指定します。
  # 設定可能な値: 1〜128文字の文字列。キーは大文字小文字が区別されます。
  # 注意: "aws:" で始まるキーは予約されており使用できません。
  #       同一シークレット内でタグキーは一意である必要があります。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/userguide/managing-secrets_tagging.html
  key = "Environment"

  # value (Required)
  # 設定内容: タグの値を指定します。
  # 設定可能な値: 0〜256文字の文字列。値は大文字小文字が区別されます。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/userguide/managing-secrets_tagging.html
  value = "production"

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
# - id: AWS Secrets Managerシークレットの識別子とタグキーを
#        カンマ（,）で区切った文字列
#---------------------------------------------------------------
