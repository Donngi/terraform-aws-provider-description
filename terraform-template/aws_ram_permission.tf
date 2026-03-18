#---------------------------------------------------------------
# AWS Resource Access Manager (RAM) Permission
#---------------------------------------------------------------
#
# AWS Resource Access Manager (RAM) のカスタマーマネージド権限を管理するリソースです。
# カスタマーマネージド権限を作成して、RAM Resource Share で共有されるリソースに対する
# アクセス制御を細かくカスタマイズできます。
#
# カスタマーマネージド権限は、AWSが提供するデフォルトのマネージド権限では
# 要件を満たせない場合に使用します。リソースタイプごとに許可するアクションを
# JSON形式のポリシーテンプレートで定義します。
#
# AWS公式ドキュメント:
#   - RAM 概要: https://docs.aws.amazon.com/ram/latest/userguide/what-is.html
#   - カスタマーマネージド権限: https://docs.aws.amazon.com/ram/latest/userguide/permissions-customer-managed.html
#   - 権限の管理: https://docs.aws.amazon.com/ram/latest/userguide/permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_permission
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_permission" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: カスタマーマネージド権限の名前を指定します。
  # 設定可能な値: 文字列 (AWSリージョン内で一意である必要があります)
  # 関連機能: RAM カスタマーマネージド権限名
  #   権限を識別するための名前。Resource Share に権限を関連付ける際に使用。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/permissions-customer-managed.html
  name = "custom-backup-vault-permission"

  # resource_type (Required)
  # 設定内容: このカスタマーマネージド権限が適用されるリソースタイプを指定します。
  # 設定可能な値: "<サービスコード>:<リソースタイプ>" 形式の文字列 (大文字小文字を区別しません)
  # 例:
  #   - "backup:BackupVault" (AWS Backup Vault)
  #   - "ec2:Subnet" (EC2 サブネット)
  #   - "ec2:TransitGateway" (Transit Gateway)
  #   - "imagebuilder:Component" (Image Builder コンポーネント)
  # 関連機能: RAM 共有可能リソースタイプ
  #   RAMで共有可能なリソースタイプの一覧はAWS公式ドキュメントを参照。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/shareable.html
  resource_type = "backup:BackupVault"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_template (Required)
  # 設定内容: 権限のポリシーテンプレートをJSON形式で指定します。
  # 設定可能な値: Effect、Action、Condition を含むJSON文字列
  # 注意:
  #   - Effect には "Allow" を指定します
  #   - Action にはリソースタイプに対応するAPIアクションを指定します
  #   - Condition は任意で条件を指定できます
  # 関連機能: RAM 権限ポリシー
  #   リソースベースポリシーの要素を定義し、共有先アカウントに許可する操作を制御。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/permissions-customer-managed.html
  policy_template = jsonencode({
    Effect = "Allow"
    Action = [
      "backup:ListProtectedResourcesByBackupVault",
      "backup:ListRecoveryPointsByBackupVault",
      "backup:DescribeRecoveryPoint",
      "backup:DescribeBackupVault"
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: カスタマーマネージド権限に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "custom-backup-vault-permission"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの削除操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する場合に使用
  timeouts {
    # delete (Optional)
    # 設定内容: 権限の削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30s", "2h45m")
    # 省略時: デフォルトのタイムアウト時間が使用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# - arn: カスタマーマネージド権限の ARN
# - default_version: 使用中のバージョンがデフォルトかどうか (bool)
# - status: 権限の現在のステータス
# - version: 権限のバージョン
# - tags_all: default_tags を含む全タグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_ram_resource_share: 権限を関連付ける Resource Share
# - aws_ram_resource_association: リソースを Resource Share に関連付け
# - aws_ram_principal_association: プリンシパルを Resource Share に関連付け
#---------------------------------------------------------------
