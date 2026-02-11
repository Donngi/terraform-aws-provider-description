#---------------------------------------------------------------
# AWS Audit Manager Framework Share
#---------------------------------------------------------------
#
# AWS Audit Managerでカスタムフレームワークを他のAWSアカウントまたは
# 他のリージョンと共有するためのリソースです。
# 共有リクエストを作成すると、受信者は120日以内にリクエストを承諾または拒否できます。
# 承諾されると、カスタムフレームワークは受信者のフレームワークライブラリにレプリケートされます。
#
# AWS公式ドキュメント:
#   - Framework Sharing概要: https://docs.aws.amazon.com/audit-manager/latest/userguide/share-custom-framework.html
#   - 共有リクエストの送信: https://docs.aws.amazon.com/audit-manager/latest/userguide/framework-sharing.html
#   - Framework Sharingの概念と用語: https://docs.aws.amazon.com/audit-manager/latest/userguide/share-custom-framework-concepts-and-terminology.html
#   - StartAssessmentFrameworkShare API: https://docs.aws.amazon.com/audit-manager/latest/APIReference/API_StartAssessmentFrameworkShare.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_framework_share
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_framework_share" "example" {
  #-------------------------------------------------------------
  # 必須設定 - 共有先情報
  #-------------------------------------------------------------

  # destination_account (Required)
  # 設定内容: 共有先のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（例: "123456789012"）
  # 注意: 自分のアカウントIDを指定することで、別リージョンへのレプリケーションも可能です。
  destination_account = "123456789012"

  # destination_region (Required)
  # 設定内容: 共有先のAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 注意: Audit Managerがサポートされているリージョンを指定する必要があります。
  destination_region = "us-east-1"

  # framework_id (Required)
  # 設定内容: 共有するカスタムフレームワークのIDを指定します。
  # 設定可能な値: aws_auditmanager_frameworkリソースのID
  # 注意: 標準フレームワークは共有できません。カスタムフレームワークのみ共有可能です。
  #       また、センシティブなデータを含むフレームワークは共有できません。
  framework_id = aws_auditmanager_framework.example.id

  #-------------------------------------------------------------
  # オプション設定 - コメント
  #-------------------------------------------------------------

  # comment (Optional)
  # 設定内容: 共有リクエストに添付する送信者からのコメントを指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 受信者に共有の目的や注意事項を伝えるために使用します。
  comment = "Sharing custom compliance framework for cross-account audit"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: "ap-northeast-1", "us-east-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: これは共有元のリージョン設定であり、destination_regionとは異なります。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 共有リクエストの一意の識別子
#
# - status: 共有リクエストのステータス
#   可能な値:
#   - "ACTIVE": アクティブな共有リクエスト（受信者の応答待ち）
#   - "EXPIRING": 期限切れが近い共有リクエスト
#   - "SHARED": 共有が完了（受信者が承諾）
#   - "INACTIVE": 非アクティブ（期限切れ、拒否、または取り消し）
#   - "REPLICATING": レプリケーション中
#   - "FAILED": 共有に失敗
#
#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
# - 受信者は共有リクエストを受け取ってから120日以内に応答する必要があります。
# - 共有リクエストを送信すると、Audit ManagerはUS East (N. Virginia)と
#   US West (Oregon)リージョンにカスタムフレームワークのスナップショットを保存します。
# - リージョン間の共有では、共有リクエストの処理に最大10分かかる場合があります。
# - 共有後にカスタムフレームワークを更新した場合、
#   最新バージョンを共有するには再度共有リクエストを送信する必要があります。
#---------------------------------------------------------------
