#---------------------------------------------------------------
# AWS Signer Signing Profile Permission
#---------------------------------------------------------------
#
# AWS Signer の署名プロファイルに対してリソースベースのポリシーを付与するための
# Terraform リソースです。
#
# AWS Signer は、コードの整合性と信頼性を保証するためのマネージドコード署名サービスです。
# このリソースを使用することで、特定のプリンシパル（AWSアカウント、IAMロール、IAMユーザー等）
# に対して署名プロファイルへのアクセス権限を個別に設定できます。
#
# 主な特徴:
# - 署名プロファイルへのリソースベースのポリシーステートメントを追加
# - 複数の AWS プリンシパルに対して個別にアクセス制御が可能
# - Lambda 関数の署名検証や ECR イメージ署名など様々な用途に対応
#
# 重要な注意事項:
# 1. 署名プロファイルの特定バージョンへの権限付与
#    profile_version を指定することで、プロファイルの特定バージョンに対してのみ
#    権限を付与できます。省略した場合は最新バージョンが自動設定されます。
#
# 2. statement_id の一意性
#    同一プロファイル内でステートメントIDは一意である必要があります。
#    statement_id と statement_id_prefix は同時指定できません。
#    statement_id_prefix を使用すると、Terraform がユニークなIDを自動生成します。
#
# 3. サポートされるアクション
#    signer:GetSigningProfile、signer:RevokeSignature、
#    signer:StartSigningJob などの Signer API アクションが指定可能です。
#
# AWS公式ドキュメント:
#   - AWS Signer の概要: https://docs.aws.amazon.com/signer/latest/developerguide/Welcome.html
#   - 署名プロファイルのアクセス制御: https://docs.aws.amazon.com/signer/latest/developerguide/signing-profile-access-control.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/signer_signing_profile_permission
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_signer_signing_profile_permission" "example" {
  #-------------------------------------------------------------
  # 対象プロファイル設定
  #-------------------------------------------------------------

  # profile_name (Required)
  # 設定内容: 権限を付与する対象の署名プロファイル名を指定します。
  # 設定可能な値: 既存の AWS Signer 署名プロファイル名（文字列）
  # 省略時: 省略不可（必須項目）
  # 推奨: aws_signer_signing_profile リソースの name 属性を参照することを推奨します。
  profile_name = aws_signer_signing_profile.example.name

  # profile_version (Optional)
  # 設定内容: 権限を付与する署名プロファイルの特定バージョンを指定します。
  # 設定可能な値: 署名プロファイルのバージョン文字列
  # 省略時: 最新バージョンが自動設定されます（computed）
  # 注意: 特定バージョンへの権限付与が不要な場合は省略してください。
  profile_version = null # aws_signer_signing_profile.example.version

  #-------------------------------------------------------------
  # アクセス権限設定
  #-------------------------------------------------------------

  # action (Required)
  # 設定内容: プリンシパルに許可する Signer API アクションを指定します。
  # 設定可能な値:
  #   - "signer:GetSigningProfile"   # 署名プロファイルの詳細情報を取得する権限
  #   - "signer:RevokeSignature"     # 署名を失効させる権限
  #   - "signer:StartSigningJob"     # 署名ジョブを開始する権限
  # 省略時: 省略不可（必須項目）
  action = "signer:StartSigningJob"

  # principal (Required)
  # 設定内容: 権限を付与する対象の AWS プリンシパルを指定します。
  # 設定可能な値:
  #   - AWS アカウント ID（例: "123456789012"）
  #   - IAM ロールの ARN（例: "arn:aws:iam::123456789012:role/MyRole"）
  #   - IAM ユーザーの ARN（例: "arn:aws:iam::123456789012:user/MyUser"）
  # 省略時: 省略不可（必須項目）
  principal = "123456789012"

  #-------------------------------------------------------------
  # ステートメント識別子設定
  #-------------------------------------------------------------

  # statement_id (Optional)
  # 設定内容: ポリシーステートメントの一意な識別子を指定します。
  # 設定可能な値: 英数字とハイフン・アンダースコアを含む文字列
  # 省略時: statement_id_prefix の値またはランダムな値が自動生成されます（computed）
  # 注意: statement_id と statement_id_prefix は同時に指定できません。
  #       同一プロファイル内で一意の値を指定してください。
  statement_id = "example-statement"

  # statement_id_prefix (Optional)
  # 設定内容: Terraform がユニークなステートメントIDを自動生成する際のプレフィックスを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: statement_id の値が使用されます（computed）
  # 注意: statement_id と statement_id_prefix は同時に指定できません。
  #       statement_id_prefix を使用すると、プレフィックスにランダムな文字列が付加されます。
  # statement_id_prefix = "example-prefix-"
  statement_id_prefix = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用されます（computed）
  region = null # "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# id - ステートメントIDを含む一意の識別子
#
#---------------------------------------------------------------
