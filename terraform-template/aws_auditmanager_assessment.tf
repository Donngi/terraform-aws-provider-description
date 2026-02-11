#---------------------------------------------------------------
# AWS Audit Manager Assessment
#---------------------------------------------------------------
#
# AWS Audit Managerの評価(Assessment)をプロビジョニングするリソースです。
# 評価はフレームワークに基づいて作成され、指定したAWSアカウントとサービスを
# 対象に、継続的なコンプライアンス証拠の収集を自動化します。
#
# AWS公式ドキュメント:
#   - AWS Audit Manager概要: https://docs.aws.amazon.com/audit-manager/latest/userguide/what-is.html
#   - 評価の作成: https://docs.aws.amazon.com/audit-manager/latest/userguide/create-assessments.html
#   - 証拠の収集方法: https://docs.aws.amazon.com/audit-manager/latest/userguide/how-evidence-is-collected.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_assessment
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_assessment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 評価の名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-assessment"

  # framework_id (Required)
  # 設定内容: 評価の作成に使用するフレームワークの一意識別子を指定します。
  # 設定可能な値: 有効なAudit Managerフレームワークの識別子
  # 関連機能: Audit Managerフレームワーク
  #   事前定義済みまたはカスタムのフレームワークを使用して評価を作成します。
  #   フレームワークはコンプライアンス要件（PCI-DSS、SOC 2等）に対応するコントロールを含みます。
  framework_id = aws_auditmanager_framework.example.id

  # description (Optional)
  # 設定内容: 評価の説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example assessment for compliance monitoring"

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
  # 評価レポートの保存先設定
  #-------------------------------------------------------------

  # assessment_reports_destination (Required)
  # 設定内容: 評価レポートの保存先を設定します。
  # 関連機能: 評価レポート
  #   評価から生成されるレポートの保存先を指定します。
  #   現在はS3バケットのみがサポートされています。
  assessment_reports_destination {
    # destination (Required)
    # 設定内容: 評価レポートの保存先を指定します。
    # 設定可能な値: S3バケットのURI（形式: s3://{bucket_name}）
    destination = "s3://${aws_s3_bucket.audit_reports.id}"

    # destination_type (Required)
    # 設定内容: 保存先の種類を指定します。
    # 設定可能な値:
    #   - "S3": S3バケットを保存先として使用（現在サポートされている唯一の値）
    destination_type = "S3"
  }

  #-------------------------------------------------------------
  # ロール設定
  #-------------------------------------------------------------

  # roles (Required)
  # 設定内容: 評価にアクセスできるIAMロールを指定します。
  # 関連機能: 評価のロール
  #   評価の管理やレビューを行うための権限を持つロールを定義します。
  #   評価作成時は必ずPROCESS_OWNERタイプのロールが必要です。
  roles {
    # role_arn (Required)
    # 設定内容: IAMロールのAmazon Resource Name (ARN)を指定します。
    # 設定可能な値: 有効なIAMロールのARN
    role_arn = aws_iam_role.audit_owner.arn

    # role_type (Required)
    # 設定内容: ロールの種類を指定します。
    # 設定可能な値:
    #   - "PROCESS_OWNER": 評価のプロセスオーナー（評価作成時に必須）
    #   - "RESOURCE_OWNER": リソースオーナー（証拠のレビュー担当者）
    # 注意: 評価作成時は必ずPROCESS_OWNERを指定する必要があります
    role_type = "PROCESS_OWNER"
  }

  #-------------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------------

  # scope (Required)
  # 設定内容: 評価の対象となるAWSアカウントとサービスを定義します。
  # 関連機能: 評価スコープ
  #   評価の範囲を定義し、証拠収集の対象を決定します。
  #   AWS Audit Managerはスコープ内のリソースから自動的に証拠を収集します。
  #   参考: https://docs.aws.amazon.com/audit-manager/latest/APIReference/API_Scope.html
  scope {
    # aws_accounts (Optional)
    # 設定内容: 評価対象のAWSアカウントを指定します。
    # 注意: 最小1件、最大200件まで指定可能
    aws_accounts {
      # id (Required)
      # 設定内容: AWSアカウントの識別子を指定します。
      # 設定可能な値: 12桁のAWSアカウントID
      id = data.aws_caller_identity.current.account_id
    }

    # aws_services (Optional)
    # 設定内容: 評価対象のAWSサービスを指定します。
    # 注意: この属性は非推奨です。AWS Audit Managerは評価コントロールと
    #       データソースに基づいてスコープ内のサービスを自動推論します。
    #       明示的に指定しても無視される可能性があります。
    aws_services {
      # service_name (Required)
      # 設定内容: AWSサービスの名前を指定します。
      # 設定可能な値: AWSサービス名（例: S3, EC2, Lambda, IAM, RDS等）
      service_name = "S3"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-assessment"
    Environment = "production"
    Compliance  = "SOC2"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 評価のAmazon Resource Name (ARN)
#
# - id: 評価の一意識別子
#
# - roles_all: 評価にアクセスできるすべてのロールの完全なリスト。
#              rolesブロックで明示的に設定されたロールに加え、
#              デフォルトですべてのAudit Manager評価にアクセスできるロールも含まれます。
#              各要素は以下の属性を持ちます:
#              - role_arn: ロールのARN
#              - role_type: ロールの種類（PROCESS_OWNER または RESOURCE_OWNER）
#
# - status: 評価のステータス。有効な値は ACTIVE および INACTIVE です。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
