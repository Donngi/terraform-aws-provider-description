#---------------------------------------------------------------
# AWS Service Catalog Constraint
#---------------------------------------------------------------
#
# AWS Service Catalogのポートフォリオ内の製品に対してコンストレイントを
# プロビジョニングするリソースです。コンストレイントはエンドユーザーが
# 製品を起動する際のルールを定義し、セキュリティやコンプライアンス要件を
# 満たすための制御を提供します。
#
# NOTE: このリソースは製品とポートフォリオの関連付けを行いません。
#       コンストレイントを作成する前に、aws_servicecatalog_product_portfolio_association
#       リソースを使用して製品とポートフォリオを関連付ける必要があります。
#
# AWS公式ドキュメント:
#   - Service Catalog コンストレイントの概要: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/constraints.html
#   - コンストレイントの追加: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/portfoliomgmt-constraints.html
#   - CreateConstraint API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreateConstraint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_constraint
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_constraint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # portfolio_id (Required)
  # 設定内容: コンストレイントを適用するポートフォリオのIDを指定します。
  # 設定可能な値: 有効なService Catalogポートフォリオの識別子
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/constraints.html
  portfolio_id = aws_servicecatalog_portfolio.example.id

  # product_id (Required)
  # 設定内容: コンストレイントを適用する製品のIDを指定します。
  # 設定可能な値: 有効なService Catalog製品の識別子
  product_id = aws_servicecatalog_product.example.id

  # type (Required)
  # 設定内容: コンストレイントの種類を指定します。
  # 設定可能な値:
  #   - "LAUNCH": 製品を起動する際のIAMロールを指定するコンストレイント。
  #              起動に使用するロールのARNまたはローカルロール名をparametersで指定します。
  #              1つの製品とポートフォリオの組み合わせに対してLAUNCHコンストレイントは1つのみ作成可能。
  #              STACKSETコンストレイントと共存不可。
  #   - "NOTIFICATION": 製品の起動時や特定イベント発生時にSNSトピックへ通知するコンストレイント。
  #                     parametersでSNSトピックのARNリストを指定します。
  #   - "RESOURCE_UPDATE": プロビジョニング済み製品のタグ更新を制御するコンストレイント。
  #                        parametersでTagUpdatesOnProvisionedProductをALLOWEDまたはNOT_ALLOWEDで指定します。
  #   - "STACKSET": CloudFormation StackSetsを使用した複数アカウント・リージョンへのデプロイを
  #                 設定するコンストレイント。LAUNCHコンストレイントと共存不可。
  #   - "TEMPLATE": エンドユーザーが製品を起動する際に設定できるCloudFormationテンプレートの
  #                 パラメータを制限するコンストレイント。
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/portfoliomgmt-constraints.html
  type = "LAUNCH"

  # parameters (Required)
  # 設定内容: コンストレイントのパラメータをJSON形式で指定します。
  #           typeの値によって指定するJSONの構造が異なります。
  # 設定可能な値（typeごとのJSON形式）:
  #   - LAUNCH:
  #       {"RoleArn": "arn:aws:iam::123456789012:role/LaunchRole"}
  #       または
  #       {"LocalRoleName": "LaunchRole"}
  #       ※ RoleArnとLocalRoleNameは排他的（どちらか一方のみ指定可能）
  #   - NOTIFICATION:
  #       {"NotificationArns": ["arn:aws:sns:us-east-1:123456789012:MyTopic"]}
  #   - RESOURCE_UPDATE:
  #       {"Version": "STRING_VALUE", "Properties": {"TagUpdatesOnProvisionedProduct": "ALLOWED"}}
  #       ※ TagUpdatesOnProvisionedProductにはALLOWEDまたはNOT_ALLOWEDを指定
  #   - STACKSET:
  #       {"Version": "STRING_VALUE", "Properties": {"AccountList": [...], "RegionList": [...],
  #         "AdminRole": "arn:aws:iam::...:role/AWSCloudFormationStackSetAdministrationRole",
  #         "ExecutionRole": "AWSCloudFormationStackSetExecutionRole"}}
  #   - TEMPLATE:
  #       {"Rules": {"rule_name": {...}}}
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreateConstraint.html
  parameters = jsonencode({
    "RoleArn" : "arn:aws:iam::123456789012:role/LaunchRole"
  })

  #-------------------------------------------------------------
  # 言語設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: レスポンスに使用する言語コードを指定します。
  # 設定可能な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: "en"（英語）
  accept_language = "en"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: コンストレイントの説明文を指定します。
  # 設定可能な値: 最大2000文字の文字列
  # 省略時: 説明なし（空文字列）
  description = "コンストレイントの説明"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: デフォルトのタイムアウト値を使用
    create = "3m"

    # read (Optional)
    # 設定内容: リソース読み取り時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: デフォルトのタイムアウト値を使用
    read = "10m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: デフォルトのタイムアウト値を使用
    update = "3m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: デフォルトのタイムアウト値を使用
    delete = "3m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コンストレイントの識別子
#
# - owner: コンストレイントの所有者（AWSアカウントID）
#
# - status: コンストレイントの現在のステータス
#           AVAILABLE、CREATING、FAILEDのいずれかの値
#---------------------------------------------------------------
