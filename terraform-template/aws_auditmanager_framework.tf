#---------------------------------------------------------------
# AWS Audit Manager Framework
#---------------------------------------------------------------
#
# AWS Audit Managerのカスタムフレームワークをプロビジョニングするリソースです。
# フレームワークは、コントロールセットとコントロールを論理的にグループ化し、
# 組織固有のコンプライアンス要件に対応した監査評価を実施するための基盤となります。
#
# AWS公式ドキュメント:
#   - AWS Audit Manager概要: https://docs.aws.amazon.com/audit-manager/latest/userguide/what-is.html
#   - カスタムフレームワークの作成: https://docs.aws.amazon.com/audit-manager/latest/userguide/create-custom-frameworks-from-scratch.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_framework
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_framework" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: フレームワークの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: フレームワークを識別するための一意の名前
  name = "my-custom-framework"

  # description (Optional)
  # 設定内容: フレームワークの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: フレームワークの目的や対象となるコンプライアンス要件を記述
  description = "カスタムコンプライアンスフレームワーク"

  # compliance_type (Optional)
  # 設定内容: 新しいカスタムフレームワークがサポートするコンプライアンスタイプを指定します。
  # 設定可能な値: 任意の文字列（例: "CIS", "HIPAA", "PCI_DSS", "GDPR", "SOC2"など）
  # 用途: フレームワークライブラリでキーワード検索する際に使用できます
  compliance_type = "CUSTOM"

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
  # コントロールセット設定
  #-------------------------------------------------------------
  # control_sets (Required)
  # 設定内容: フレームワークに関連付けるコントロールセットを定義します。
  # コントロールセットは、関連するコントロールを論理的にグループ化するためのコンテナです。
  # 注意: コンソールでは最大10個のコントロールセットを追加できます。
  #       それ以上追加する場合はAudit Manager APIを使用してください。

  control_sets {
    # name (Required)
    # 設定内容: コントロールセットの名前を指定します。
    # 設定可能な値: 任意の文字列
    # 用途: コントロールセットを識別するための名前
    name = "access-control-set"

    # controls (Required)
    # 設定内容: コントロールセット内のコントロールを定義します。
    # 各controlsブロックには、aws_auditmanager_controlリソースのIDを指定します。

    controls {
      # id (Required)
      # 設定内容: コントロールの一意識別子を指定します。
      # 設定可能な値: aws_auditmanager_controlリソースのID
      id = aws_auditmanager_control.access_control_1.id
    }

    controls {
      # id (Required)
      # 設定内容: コントロールの一意識別子を指定します。
      # 設定可能な値: aws_auditmanager_controlリソースのID
      id = aws_auditmanager_control.access_control_2.id
    }
  }

  control_sets {
    name = "data-protection-set"

    controls {
      id = aws_auditmanager_control.data_protection_1.id
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
  #   タグキーを使用してフレームワークライブラリでフレームワークを検索できます。
  tags = {
    Name        = "my-custom-framework"
    Environment = "production"
    Compliance  = "custom"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フレームワークのAmazon Resource Name (ARN)
#
# - id: フレームワークの一意識別子
#
# - framework_type: フレームワークのタイプ
#   （カスタムフレームワークまたは標準フレームワーク）
#
# - control_sets[*].id: フレームワーク内の各コントロールセットの一意識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
