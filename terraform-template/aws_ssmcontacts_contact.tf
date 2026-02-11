#---------------------------------------------------------------
# AWS Systems Manager Incident Manager Contact
#---------------------------------------------------------------
#
# AWS Systems Manager Incident Managerで使用する連絡先または
# エスカレーションプランをプロビジョニングするリソースです。
# インシデント発生時に通知する個人の連絡先、エスカレーションプラン、
# オンコールスケジュールを定義します。
#
# AWS公式ドキュメント:
#   - Incident Manager概要: https://docs.aws.amazon.com/incident-manager/latest/userguide/what-is-incident-manager.html
#   - エスカレーションプランの作成: https://docs.aws.amazon.com/incident-manager/latest/userguide/escalation.html
#   - Contact API リファレンス: https://docs.aws.amazon.com/incident-manager/latest/APIReference/API_SSMContacts_Contact.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssmcontacts_contact" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # alias (Required)
  # 設定内容: 連絡先またはエスカレーションプランの一意で識別可能なエイリアスを指定します。
  # 設定可能な値: 1-255文字の文字列（小文字の英数字、アンダースコア、ハイフン）
  # 注意: パターンは ^[a-z0-9_\-]*$ に準拠する必要があります
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/APIReference/API_SSMContacts_Contact.html
  alias = "example-contact"

  # type (Required)
  # 設定内容: 連絡先のタイプを指定します。
  # 設定可能な値:
  #   - "PERSONAL": 個人の連絡先（単一の個人）
  #   - "ESCALATION": エスカレーションプラン（事前定義された連絡先のセット）
  #   - "ONCALL_SCHEDULE": オンコールスケジュール
  # 関連機能: Incident Manager連絡先タイプ
  #   連絡先タイプによって、インシデント時の通知方法が異なります。
  #   PERSONALは単一の連絡先、ESCALATIONは段階的なエスカレーション、
  #   ONCALL_SCHEDULEはスケジュールに基づいた通知を行います。
  #   - https://docs.aws.amazon.com/incident-manager/latest/APIReference/API_SSMContacts_Contact.html
  type = "PERSONAL"

  # display_name (Optional)
  # 設定内容: 連絡先またはエスカレーションプランのフルネームを指定します。
  # 設定可能な値: 0-255文字の文字列
  # 省略時: 表示名なしで連絡先が作成されます
  # 注意: パターンは ^[\p{L}\p{Z}\p{N}_.\-]*$ に準拠する必要があります
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/APIReference/API_SSMContacts_Contact.html
  display_name = "Example Contact"

  #-------------------------------------------------------------
  # 識別子管理
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: TerraformがリソースのARNを自動的に設定します
  # 注意: 通常はこのプロパティを設定する必要はありません。
  #       Terraformが自動的に管理します。
  id = null

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/tagging.html
  tags = {
    Name        = "example-contact"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられたすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tags設定ブロックから継承されたタグと
  #         tagsで指定したタグがマージされます
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックから継承されたタグを含む、
  #   リソースに割り当てられたすべてのタグのマップ。
  #   通常はこのプロパティを明示的に設定する必要はありません。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  # NOTE: 連絡先はレプリケーションセットに暗黙的に依存します。
  # Terraformでレプリケーションセットを設定した場合は、depends_on引数に
  # 追加することを推奨します。
  # 例:
  # depends_on = [aws_ssmincidents_replication_set.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 連絡先またはエスカレーションプランのAmazon Resource Name (ARN)
#---------------------------------------------------------------
