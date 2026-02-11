#---------------------------------------------------------------
# AWS Backup Selection
#---------------------------------------------------------------
#
# AWS Backupバックアッププランに対してバックアップ対象リソースの選択条件を
# 管理するリソースです。バックアッププランにリソースを割り当てる方法として、
# ARN指定、タグベースの選択、条件ベースのフィルタリングをサポートしています。
#
# AWS公式ドキュメント:
#   - AWS Backup概要: https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html
#   - リソース割り当て: https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html
#   - BackupSelection API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_BackupSelection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_selection" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リソース選択ドキュメントの表示名を指定します。
  # 設定可能な値: 1-50文字の英数字または'-_.'を含む文字列
  # 注意: パターン: ^[a-zA-Z0-9\-\_\.]{1,50}$
  name = "my-backup-selection"

  # plan_id (Required)
  # 設定内容: リソース選択を関連付けるバックアッププランのIDを指定します。
  # 設定可能な値: 有効なバックアッププランID
  plan_id = aws_backup_plan.example.id

  # iam_role_arn (Required)
  # 設定内容: AWS Backupがターゲットリソースのバックアップ・リストア時に
  #           認証に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: AWS BackupサービスロールとIAMポリシー
  #   AWS管理ポリシー（AWSBackupServiceRolePolicyForBackup等）を使用するか、
  #   カスタムポリシーを作成してIAMロールにアタッチします。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/access-control.html#managed-policies
  iam_role_arn = aws_iam_role.backup.arn

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
  # リソース選択（ARN指定）
  #-------------------------------------------------------------

  # resources (Optional)
  # 設定内容: バックアッププランに割り当てるリソースのARN配列を指定します。
  # 設定可能な値: Amazon Resource Names (ARNs) の配列
  #   - ワイルドカードなし: 最大500個のARN
  #   - ワイルドカードあり: 最大30個のARN（例: arn:aws:ec2:*:*:volume/*）
  # 注意: 複数のARNを指定した場合、いずれかのARNに一致するリソースがバックアップ対象（OR条件）
  # 関連機能: リソースタイプ別のバックアップ
  #   特定のリソース（EC2インスタンス、EBSボリューム、RDSインスタンス等）を
  #   明示的に指定してバックアップ対象とします。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html
  resources = [
    aws_db_instance.example.arn,
    aws_ebs_volume.example.arn,
  ]

  # not_resources (Optional)
  # 設定内容: バックアッププランから除外するリソースのARN配列を指定します。
  # 設定可能な値: Amazon Resource Names (ARNs) の配列
  #   - ワイルドカードなし: 最大500個のARN
  #   - ワイルドカードあり: 最大30個のARN
  # 注意: 多数のリソースを除外する場合は、タグベースの選択など別の戦略を検討
  # 関連機能: リソース除外
  #   バックアップ対象から特定のリソースを除外します。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html
  not_resources = null

  #-------------------------------------------------------------
  # タグベースのリソース選択
  #-------------------------------------------------------------

  # selection_tag (Optional)
  # 設定内容: タグベースの条件でバックアップ対象リソースを指定します。
  # 関連機能: タグによるリソース選択
  #   タグのキーと値を使用してリソースをフィルタリングします。
  #   複数のselection_tagブロックはOR条件で評価されます。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html
  selection_tag {
    # type (Required)
    # 設定内容: リソースフィルタリングに適用する操作タイプを指定します。
    # 設定可能な値:
    #   - "STRINGEQUALS": タグのキーと値が完全一致するリソースを選択
    type = "STRINGEQUALS"

    # key (Required)
    # 設定内容: フィルタリングに使用するタグキーを指定します。
    # 設定可能な値: 有効なタグキー文字列
    key = "backup"

    # value (Required)
    # 設定内容: フィルタリングに使用するタグ値を指定します。
    # 設定可能な値: 有効なタグ値文字列
    value = "true"
  }

  #-------------------------------------------------------------
  # 条件ベースのリソース選択
  #-------------------------------------------------------------

  # condition (Optional)
  # 設定内容: より高度な条件ベースのフィルタリングでバックアップ対象リソースを指定します。
  # 関連機能: 条件によるリソース選択
  #   StringEquals、StringLike、StringNotEquals、StringNotLikeの4つの演算子を
  #   サポートしています。複数の条件を指定した場合はAND条件で評価されます。
  #   selection_tagより柔軟なフィルタリングが可能なため、こちらの使用が推奨されています。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html
  condition {
    # string_equals (Optional)
    # 設定内容: タグ値が完全一致するリソースをフィルタリングします（完全一致）。
    # 設定可能な値: keyとvalueのペアを持つブロック
    string_equals {
      # key (Required)
      # 設定内容: フィルタリングに使用するキーを指定します。
      # 設定可能な値: "aws:ResourceTag/<TagKey>" 形式の文字列
      key = "aws:ResourceTag/Environment"

      # value (Required)
      # 設定内容: フィルタリングに使用する値を指定します。
      # 設定可能な値: タグ値文字列
      value = "production"
    }

    # string_like (Optional)
    # 設定内容: ワイルドカード（*）を使用したパターンマッチングでリソースをフィルタリングします。
    # 設定可能な値: keyとvalueのペアを持つブロック
    # 注意: ワイルドカード（*）を文字列のどこにでも使用可能（例: "prod*", "*rod*"）
    string_like {
      # key (Required)
      # 設定内容: フィルタリングに使用するキーを指定します。
      # 設定可能な値: "aws:ResourceTag/<TagKey>" 形式の文字列
      key = "aws:ResourceTag/Application"

      # value (Required)
      # 設定内容: フィルタリングに使用するパターンを指定します。
      # 設定可能な値: ワイルドカードを含むパターン文字列
      value = "app*"
    }

    # string_not_equals (Optional)
    # 設定内容: タグ値が一致しないリソースをフィルタリングします（否定一致）。
    # 設定可能な値: keyとvalueのペアを持つブロック
    string_not_equals {
      # key (Required)
      # 設定内容: フィルタリングに使用するキーを指定します。
      # 設定可能な値: "aws:ResourceTag/<TagKey>" 形式の文字列
      key = "aws:ResourceTag/Backup"

      # value (Required)
      # 設定内容: 除外する値を指定します。
      # 設定可能な値: タグ値文字列
      value = "false"
    }

    # string_not_like (Optional)
    # 設定内容: ワイルドカードを使用したパターンに一致しないリソースをフィルタリングします。
    # 設定可能な値: keyとvalueのペアを持つブロック
    string_not_like {
      # key (Required)
      # 設定内容: フィルタリングに使用するキーを指定します。
      # 設定可能な値: "aws:ResourceTag/<TagKey>" 形式の文字列
      key = "aws:ResourceTag/Environment"

      # value (Required)
      # 設定内容: 除外するパターンを指定します。
      # 設定可能な値: ワイルドカードを含むパターン文字列
      value = "test*"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Backup Selection識別子
#---------------------------------------------------------------
