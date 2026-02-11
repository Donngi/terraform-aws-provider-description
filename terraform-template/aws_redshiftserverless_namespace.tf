#---------------------------------------------------------------
# Amazon Redshift Serverless Namespace
#---------------------------------------------------------------
#
# Amazon Redshift Serverless の名前空間をプロビジョニングするリソースです。
# Redshift Serverless は、データウェアハウスのキャパシティ管理を自動化し、
# クエリのワークロードに応じてコンピューティングリソースをスケールします。
# Namespace は、データベース、スキーマ、テーブル、ユーザー、およびアクセス権限を
# グループ化する論理コンテナです。
#
# AWS公式ドキュメント:
#   - Redshift Serverless 概要: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-whatis.html
#   - Namespace の管理: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-console-namespaces.html
#   - Redshift Serverless API リファレンス: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_namespace
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftserverless_namespace" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # namespace_name (Required)
  # 設定内容: Redshift Serverless 名前空間の名前を指定します。
  # 設定可能な値: 小文字の英数字とハイフンのみを含む3〜64文字の文字列
  # 注意: 名前空間名は作成後に変更できません。変更すると新しいリソースが作成されます
  # 関連機能: Redshift Serverless Namespace
  #   名前空間は、データベースオブジェクトとユーザーのコレクションを管理します。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-console-namespaces.html
  namespace_name = "example-namespace"

  #-------------------------------------------------------------
  # 管理者アカウント設定
  #-------------------------------------------------------------

  # admin_username (Optional)
  # 設定内容: 名前空間内で作成される最初のデータベースの管理者ユーザー名を指定します。
  # 設定可能な値: 1〜128文字の英数字とアンダースコア。先頭は英字である必要があります
  # 省略時: デフォルトの管理者ユーザー名 "admin" が使用されます
  # 関連機能: Redshift データベース管理者
  #   管理者ユーザーはデータベース内の全オブジェクトに対する完全な権限を持ちます。
  #   - https://docs.aws.amazon.com/redshift/latest/dg/r_Users.html
  admin_username = "admin"

  # admin_user_password (Optional)
  # 設定内容: 名前空間内で作成される最初のデータベースの管理者パスワードを指定します。
  # 設定可能な値: 8〜64文字で、大文字、小文字、数字を含む文字列
  # 注意: admin_user_password_wo および manage_admin_password と競合します
  # セキュリティ上の理由から、admin_user_password_wo の使用が推奨されます
  # 関連機能: Redshift パスワード管理
  #   管理者パスワードはデータベースへの初期アクセスに使用されます。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-connecting.html
  admin_user_password = null

  # admin_user_password_wo (Optional, Write-Only)
  # 設定内容: 名前空間内で作成される最初のデータベースの管理者パスワードを指定します。
  # 設定可能な値: 8〜64文字で、大文字、小文字、数字を含む文字列
  # 注意: admin_user_password および manage_admin_password と競合します
  # 用途: Terraform 1.11.0以降で使用可能なWrite-Only引数。Terraform stateに保存されません
  # 関連機能: Write-Only Arguments
  #   機密情報をTerraform stateファイルに保存せずに管理できます。
  #   - https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments
  admin_user_password_wo = null

  # admin_user_password_wo_version (Optional)
  # 設定内容: admin_user_password_wo と組み合わせて使用し、パスワード更新をトリガーします。
  # 設定可能な値: 任意の整数値
  # 用途: admin_user_password_wo の更新が必要な場合、この値をインクリメントします
  # 関連機能: Write-Only Arguments の更新管理
  #   Write-Only引数は通常、変更検出できないため、このバージョン番号で更新を管理します。
  admin_user_password_wo_version = null

  # manage_admin_password (Optional)
  # 設定内容: AWS Secrets Manager を使用して名前空間の管理者パスワードを管理するかどうかを指定します。
  # 設定可能な値: true または false
  # 注意: admin_user_password および admin_user_password_wo と競合します
  # 用途: AWS Secrets Manager による自動パスワード管理を有効化する場合に使用
  # 関連機能: AWS Secrets Manager 統合
  #   管理者パスワードを自動的に生成・ローテーションし、Secrets Managerに保存します。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
  manage_admin_password = null

  # admin_password_secret_kms_key_id (Optional)
  # 設定内容: 名前空間の管理者パスワードを暗号化するために使用するKMSキーのIDを指定します。
  # 設定可能な値: KMS キーのARNまたはキーID
  # 用途: manage_admin_password を true に設定した場合、Secrets Managerに保存される
  #       パスワードを暗号化するために使用されます
  # 関連機能: AWS KMS による暗号化
  #   Secrets Managerに保存される管理者パスワードをカスタムKMSキーで暗号化できます。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/overview.html
  admin_password_secret_kms_key_id = null

  #-------------------------------------------------------------
  # データベース設定
  #-------------------------------------------------------------

  # db_name (Optional)
  # 設定内容: 名前空間内で作成される最初のデータベースの名前を指定します。
  # 設定可能な値: 1〜127文字の英数字とアンダースコア。先頭は英字である必要があります
  # 省略時: デフォルトのデータベース名 "dev" が使用されます
  # 関連機能: Redshift データベース
  #   名前空間内に最初に作成されるデータベース。追加のデータベースはSQLで作成できます。
  #   - https://docs.aws.amazon.com/redshift/latest/dg/t_creating_database.html
  db_name = "dev"

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: Amazon Web Services Key Management Service キーのARNを指定します。
  # 設定可能な値: KMS キーのARN
  # 用途: 名前空間内のデータを暗号化するために使用されます
  # 省略時: AWS管理のキーが使用されます
  # 関連機能: Redshift 暗号化
  #   保管データを暗号化してセキュリティを強化します。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
  kms_key_id = null

  # default_iam_role_arn (Optional)
  # 設定内容: 名前空間のデフォルトとして設定するIAMロールのARNを指定します。
  # 設定可能な値: IAM ロールのARN
  # 注意: default_iam_role_arn を指定する場合、iam_roles にも含める必要があります
  # 関連機能: Redshift IAM ロール
  #   S3、Glue、その他のAWSサービスへのアクセスを許可するためのデフォルトロール。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/authorizing-redshift-service.html
  default_iam_role_arn = null

  # iam_roles (Optional)
  # 設定内容: 名前空間に関連付けるIAMロールのARNのリストを指定します。
  # 設定可能な値: IAM ロールのARNの配列
  # 用途: S3からのデータロード、Glueカタログへのアクセスなどに使用
  # 関連機能: Redshift IAM ロール
  #   複数のIAMロールを関連付けて、異なるAWSリソースへのアクセスを許可できます。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/copy-unload-iam-role.html
  iam_roles = []

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # log_exports (Optional)
  # 設定内容: 名前空間がエクスポートできるログのタイプを指定します。
  # 設定可能な値: "userlog", "connectionlog", "useractivitylog" の配列
  # 用途: CloudWatch Logs にRedshiftのログを送信する場合に使用
  # 関連機能: Redshift ロギング
  #   ユーザーアクティビティ、接続、およびユーザーログをCloudWatch Logsに送信できます。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing.html
  log_exports = []

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/amazon-redshift-tagging.html
  tags = {
    Name        = "example-namespace"
    Environment = "development"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。Redshift Namespace Nameと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - admin_password_secret_arn: 名前空間の管理者ユーザー認証情報のシークレットの
#   Amazon Resource Name (ARN)。manage_admin_password が true の場合に設定されます
#
# - arn: Redshift Serverless Namespace のAmazon Resource Name (ARN)
#
# - id: Redshift Namespace Name
#
# - namespace_id: Redshift Namespace ID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
#
# # 基本的な名前空間の作成
# resource "aws_redshiftserverless_namespace" "basic" {
#   namespace_name = "basic-namespace"
# }
#
# # IAMロールとログエクスポートを含む名前空間
#---------------------------------------------------------------
