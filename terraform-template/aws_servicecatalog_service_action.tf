#---------------------------------------------------------------
# AWS Service Catalog Service Action
#---------------------------------------------------------------
#
# AWS Service Catalogのセルフサービスアクションをプロビジョニングするリソースです。
# セルフサービスアクションにより、エンドユーザーはプロビジョニング済み製品に対して
# AWS Systems Manager（SSM）ドキュメントを通じた操作（再起動、バックアップ等）を
# 管理者の承認なしに実行できます。
#
# AWS公式ドキュメント:
#   - Service Catalog Self-Service Actions: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/using-service-actions.html
#   - CreateServiceAction API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreateServiceAction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_service_action
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_service_action" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: セルフサービスアクションの名前を指定します。
  # 設定可能な値: 1〜256文字の英数字、アンダースコア、ハイフン、ドット
  name = "RestartEC2Instance"

  # description (Optional)
  # 設定内容: セルフサービスアクションの説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 省略時: 説明なし
  description = "EC2インスタンスを再起動するセルフサービスアクション"

  #-------------------------------------------------------------
  # 言語設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: 使用する言語コードを指定します。
  # 設定可能な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: "en"（英語）
  accept_language = "jp"

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
  # アクション定義設定
  #-------------------------------------------------------------

  # definition (Required)
  # 設定内容: セルフサービスアクションの定義設定ブロックです。
  # 関連機能: Service Catalog セルフサービスアクション定義
  #   SSMドキュメントを使用してエンドユーザーが実行できる操作を定義します。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/using-service-actions.html
  definition {

    # name (Required)
    # 設定内容: SSMドキュメントの名前を指定します。
    # 設定可能な値: SSMドキュメント名またはARN（共有ドキュメントの場合はARN必須）
    # 注意: AWS管理ドキュメント（例: AWS-RestartEC2Instance）は名前で指定可能。
    #       共有SSMドキュメントを使用する場合はARNを指定する必要があります。
    name = "AWS-RestartEC2Instance"

    # version (Required)
    # 設定内容: SSMドキュメントのバージョンを指定します。
    # 設定可能な値: SSMドキュメントバージョン番号（例: "1"）
    version = "1"

    # type (Optional)
    # 設定内容: サービスアクション定義のタイプを指定します。
    # 設定可能な値:
    #   - "SSM_AUTOMATION": SSM Automationドキュメントを使用（唯一の有効値）
    # 省略時: "SSM_AUTOMATION"
    type = "SSM_AUTOMATION"

    # assume_role (Optional)
    # 設定内容: セルフサービスアクションを代わりに実行するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN。プロビジョニング製品の起動ロールを再利用する場合は "LAUNCH_ROLE" を指定
    # 省略時: アクション実行者の権限を使用
    # 注意: 適切なIAMポリシーがロールにアタッチされている必要があります。
    assume_role = "arn:aws:iam::123456789012:role/ServiceCatalogActionRole"

    # parameters (Optional)
    # 設定内容: SSMドキュメントに渡すパラメーターをJSON形式で指定します。
    # 設定可能な値: JSON形式の文字列。各パラメーターに "Name" と "Type" を含む配列
    #   - "Type" に指定可能な値:
    #     - "TARGET": ターゲットリソースのID（例: EC2インスタンスID）
    #     - "TEXT_VALUE": テキスト値
    #     - "REQUESTER": リクエスト元のAmazonリソースネーム
    # 省略時: パラメーターなし
    # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreateServiceAction.html
    parameters = jsonencode([
      {
        Name = "InstanceId"
        Type = "TARGET"
      }
    ])
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "3m"

    # read (Optional)
    # 設定内容: リソース読み取りのタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    read = "10m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "3m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "3m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サービスアクションの識別子
#---------------------------------------------------------------
