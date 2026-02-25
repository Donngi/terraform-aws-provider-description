#---------------------------------------------------------------
# AWS IAM User
#---------------------------------------------------------------
#
# AWS Identity and Access Management (IAM) のユーザーをプロビジョニングするリソースです。
# IAMユーザーはAWSサービスやリソースにアクセスするための個人またはサービスアカウントを
# 表します。ユーザーには認証情報（パスワード・アクセスキー）とポリシーを関連付けられます。
#
# AWS公式ドキュメント:
#   - IAM ユーザー: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
#   - IAM ユーザーの作成: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: IAMユーザーの名前を指定します。
  # 設定可能な値: 大文字・小文字の英数字、および以下の記号: =,.@-_.
  #   スペースは使用不可。ユーザー名は大文字小文字を区別しません。
  #   例えば "TESTUSER" と "testuser" は同一のユーザー名として扱われます。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html
  name = "example-user"

  # path (Optional)
  # 設定内容: ユーザーを配置するIAMパスを指定します。
  # 設定可能な値: スラッシュ（/）で始まりスラッシュで終わるパス文字列（例: "/system/"）
  # 省略時: "/" (ルートパス)
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
  path = "/"

  #-------------------------------------------------------------
  # 権限境界設定
  #-------------------------------------------------------------

  # permissions_boundary (Optional)
  # 設定内容: ユーザーに設定する権限境界ポリシーのARNを指定します。
  # 設定可能な値: IAMポリシーの有効なARN
  # 省略時: 権限境界は設定されません
  # 関連機能: IAM 権限境界
  #   ユーザーまたはロールが持てる最大権限を制限する機能。
  #   権限境界とアイデンティティベースポリシーの両方で許可されている場合のみ操作が実行可能。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
  permissions_boundary = null

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: ユーザー削除時にTerraform管理外のIAMアクセスキー・ログインプロファイル・
  #   MFAデバイスが存在していても強制的に削除するかを指定します。
  # 設定可能な値:
  #   - true: Terraform管理外のリソースが存在しても強制削除
  #   - false: Terraform管理外のアクセスキー・ログインプロファイル・MFAデバイスが存在する場合は削除失敗
  # 省略時: false
  # 注意: aws_iam_policy_attachmentを使用してポリシーをアタッチしている場合、
  #   ユーザーのnameまたはpathを変更する際はforce_destroyをtrueに設定する必要があります。
  #   aws_iam_user_policy_attachment（推奨）を使用する場合はこの制限はありません。
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-user"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWS が割り当てたユーザーのARN
#
# - id: ユーザーの名前
#
# - unique_id: AWS が割り当てたユーザーの一意のID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
