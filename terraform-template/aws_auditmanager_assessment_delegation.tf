#---------------------------------------------------------------
# AWS Audit Manager Assessment Delegation
#---------------------------------------------------------------
#
# AWS Audit Managerのアセスメント委任をプロビジョニングするリソースです。
# 監査所有者は、アセスメント内のコントロールセットを専門知識を持つ
# 他のユーザー（デリゲート）に委任してレビューを依頼できます。
# デリゲートは証拠のレビュー、コメントの追加、コントロールステータスの更新が可能です。
#
# AWS公式ドキュメント:
#   - Audit Manager Delegations概要: https://docs.aws.amazon.com/audit-manager/latest/userguide/delegate.html
#   - コントロールセットの委任: https://docs.aws.amazon.com/audit-manager/latest/userguide/delegation-for-audit-owners-delegating-a-control-set.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_assessment_delegation
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_assessment_delegation" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # assessment_id (Required)
  # 設定内容: 委任を作成するアセスメントの識別子を指定します。
  # 設定可能な値: 有効なAudit Managerアセスメントの識別子
  # 用途: どのアセスメントのコントロールセットを委任するかを指定
  assessment_id = aws_auditmanager_assessment.example.id

  # control_set_id (Required)
  # 設定内容: 委任するコントロールセットの名前を指定します。
  # 設定可能な値: アセスメント作成時に使用したコントロールセット名
  # 注意: この値はアセスメント作成時のコントロールセット名であり、
  #       AWSが生成するIDではありません。属性名に「_id」が含まれているのは
  #       基盤となるAWS APIとの一貫性を保つためです。
  control_set_id = "example-control-set"

  # role_arn (Required)
  # 設定内容: デリゲートに関連付けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 用途: 委任先のユーザーまたはロールを識別するために使用
  # 関連機能: Audit Manager デリゲート権限
  #   デリゲートには、コントロールの更新、証拠の確認、コメントの追加などの
  #   権限が必要です。
  #   - https://docs.aws.amazon.com/audit-manager/latest/userguide/delegation-for-audit-owners-delegating-a-control-set.html
  role_arn = aws_iam_role.delegate.arn

  # role_type (Required)
  # 設定内容: カスタマーペルソナのタイプを指定します。
  # 設定可能な値:
  #   - "RESOURCE_OWNER": リソース所有者（アセスメント委任では常にこの値を使用）
  # 注意: アセスメント委任の場合、role_typeは常に「RESOURCE_OWNER」である必要があります。
  role_type = "RESOURCE_OWNER"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # comment (Optional)
  # 設定内容: 委任リクエストを説明するコメントを指定します。
  # 設定可能な値: 任意のテキスト文字列
  # 用途: デリゲートに対してレビューの指示や背景情報を提供
  comment = "Please review this control set and provide feedback."

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
# - delegation_id: 委任の一意の識別子
#
# - id: リソースの一意の識別子。assessment_id、role_arn、control_set_idを
#       カンマ区切りで連結した文字列です。
#
# - status: 委任のステータス
#---------------------------------------------------------------
