#---------------------------------------------------------------
# AWS Simple Workflow Service ドメイン
#---------------------------------------------------------------
#
# Amazon Simple Workflow Service (SWF) のドメインをプロビジョニングするリソースです。
# ドメインは、ワークフロー実行、アクティビティタイプ、およびワークフロータイプの
# スコープを定義する論理コンテナとして機能します。異なるドメイン内のワークフローは
# 相互に通信できません。
#
# AWS公式ドキュメント:
#   - Amazon SWFのドメイン: https://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dev-domains.html
#   - ドメインの登録: https://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dg-register-domain-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/swf_domain
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_swf_domain" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ドメインの名前を指定します。
  # 設定可能な値: 文字列（最大256文字）
  # 省略時: Terraformがランダムな一意の名前を自動生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dg-register-domain-api.html
  name = "my-workflow-domain"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: ドメイン名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 省略時: 指定なし。nameまたはname_prefixのいずれかを指定します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

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
  # ドメイン設定
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: ドメインの説明を指定します。
  # 設定可能な値: 文字列（最大1024文字）
  # 省略時: 説明なし
  # 用途: ドメインの目的や用途を記述します。
  # 参考: https://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dg-register-domain-api.html
  description = "Domain for managing application workflows"

  # workflow_execution_retention_period_in_days (Required, Forces new resource)
  # 設定内容: ワークフロー実行完了後にSWFが情報を保持する日数を指定します。
  # 設定可能な値: 0から90の整数（日数）
  #   - 0: ワークフロー実行履歴は保持されません
  #   - 1-90: 指定した日数の間、実行履歴が利用可能です
  # 関連機能: ワークフロー実行履歴の保持
  #   ワークフロー実行が完了した後、SWFは指定された保持期間中、
  #   実行に関する情報（履歴、状態、進捗等）を保持します。
  #   保持期間が過ぎると、この情報は自動的に削除されます。
  #   - https://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dev-domains.html
  # 注意: この値はドメイン作成後に変更できません（Forces new resource）
  workflow_execution_retention_period_in_days = "30"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-workflow-domain"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメインの名前。
#
# - arn: ドメインのAmazon Resource Name (ARN)。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
