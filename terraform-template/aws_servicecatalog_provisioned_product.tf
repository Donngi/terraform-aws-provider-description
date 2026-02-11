#---------------------------------------------------------------
# AWS Service Catalog Provisioned Product
#---------------------------------------------------------------
#
# AWS Service Catalogでプロビジョニングされた製品インスタンスを管理するリソースです。
# プロビジョニングされた製品は、製品のリソースインスタンスです。例えば、
# CloudFormationテンプレートに基づく製品をプロビジョニングすると、
# CloudFormationスタックとその基盤リソースが起動されます。
#
# AWS公式ドキュメント:
#   - Service Catalog プロビジョニングされた製品: https://docs.aws.amazon.com/servicecatalog/latest/userguide/enduser-viewstack.html
#   - プロビジョニングされた製品の更新: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_UpdateProvisionedProduct.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_provisioned_product
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_provisioned_product" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロビジョニングされた製品のユーザーフレンドリーな名前を指定します。
  # 設定可能な値: 文字列（1〜128文字）
  # 注意: プロビジョニングされた製品の一意の識別子として使用されます。
  name = "example-provisioned-product"

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的に生成します
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
  id = null

  #-------------------------------------------------------------
  # 製品識別設定
  #-------------------------------------------------------------

  # product_id (Optional)
  # 設定内容: 製品の識別子を指定します。
  # 設定可能な値: 製品ID（例: prod-abcdzk7xy33qa）
  # 注意: product_idまたはproduct_nameのいずれかを指定する必要があります（両方は指定不可）
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_ProvisionedProductAttribute.html
  product_id = "prod-abcdzk7xy33qa"

  # product_name (Optional)
  # 設定内容: 製品の名前を指定します。
  # 設定可能な値: 文字列
  # 注意: product_idまたはproduct_nameのいずれかを指定する必要があります（両方は指定不可）
  product_name = null

  #-------------------------------------------------------------
  # プロビジョニングアーティファクト設定
  #-------------------------------------------------------------

  # provisioning_artifact_id (Optional)
  # 設定内容: プロビジョニングアーティファクト（バージョン）の識別子を指定します。
  # 設定可能な値: プロビジョニングアーティファクトID（例: pa-4abcdjnxjj6ne）
  # 注意: provisioning_artifact_idまたはprovisioning_artifact_nameのいずれかを指定する必要があります（両方は指定不可）
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_ProvisionedProductAttribute.html
  provisioning_artifact_id = "pa-4abcdjnxjj6ne"

  # provisioning_artifact_name (Optional)
  # 設定内容: プロビジョニングアーティファクト（バージョン）の名前を指定します。
  # 設定可能な値: 文字列
  # 注意: provisioning_artifact_idまたはprovisioning_artifact_nameのいずれかを指定する必要があります（両方は指定不可）
  provisioning_artifact_name = null

  #-------------------------------------------------------------
  # パス設定
  #-------------------------------------------------------------

  # path_id (Optional)
  # 設定内容: 製品のパス識別子を指定します。
  # 設定可能な値: パスID文字列
  # 省略時: 製品にデフォルトパスがある場合は省略可能
  # 注意: 製品に複数のパスがある場合は必須。path_idまたはpath_nameのいずれかを指定しますが、両方は指定不可
  # 関連機能: Service Catalog Launch Paths
  #   製品へのアクセスパスを定義し、異なるポートフォリオを通じた製品へのアクセスを制御します。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/dg/API_DescribeProvisioningParameters.html
  path_id = null

  # path_name (Optional)
  # 設定内容: パスの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: path_idまたはpath_nameのいずれかを指定する必要があります（両方は指定不可）
  path_name = null

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
  # 言語設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: 言語コードを指定します。
  # 設定可能な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: en（英語）が使用されます
  accept_language = "en"

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # notification_arns (Optional)
  # 設定内容: スタック関連イベントを公開するSNSトピックのARNリストを指定します。
  # 設定可能な値: SNSトピックARNのリスト
  # 関連機能: CloudFormation Stack Notifications
  #   CloudFormationがスタックイベント（作成、更新、削除など）を指定されたSNSトピックに送信します。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-add-tags.html
  notification_arns = []

  #-------------------------------------------------------------
  # 削除動作設定
  #-------------------------------------------------------------

  # ignore_errors (Optional)
  # 設定内容: 削除時のみ適用。基盤リソースを削除できない場合でも、プロビジョニングされた製品の管理を停止するかを指定します。
  # 設定可能な値:
  #   - true: 基盤リソースの削除に失敗してもService Catalogでの管理を停止
  #   - false (デフォルト): 基盤リソースの削除が成功するまで管理を継続
  # 省略時: false
  # 注意: 削除時のみ有効な設定です
  ignore_errors = false

  # retain_physical_resources (Optional)
  # 設定内容: 削除時のみ適用。Service Catalogプロビジョニングされた製品を削除しながら、CloudFormationスタック、スタックセット、または基盤リソースを残すかを指定します。
  # 設定可能な値:
  #   - true: プロビジョニングされた製品レコードのみ削除し、基盤リソースは保持
  #   - false (デフォルト): プロビジョニングされた製品と基盤リソースの両方を削除
  # 省略時: false
  # 注意: 削除時のみ有効な設定です
  retain_physical_resources = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: プロビジョニングされた製品に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  # 注意: タグに競合するキーが含まれる場合、AWSはエラーを報告します
  tags = {
    Name        = "example-provisioned-product"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、リソースに割り当てられたすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダー設定とリソースのtagsがマージされます
  # 注意: 通常は明示的に設定する必要はありません。プロバイダーのdefault_tagsと自動的にマージされます。
  tags_all = null

  #-------------------------------------------------------------
  # プロビジョニングパラメータ設定
  #-------------------------------------------------------------

  # provisioning_parameters (Optional)
  # 設定内容: 製品のプロビジョニングに必要な管理者指定のパラメータを設定します。
  # 関連機能: Service Catalog Provisioning Parameters
  #   製品テンプレート（CloudFormationなど）で定義されたパラメータに値を提供します。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-servicecatalog-cloudformationprovisionedproduct-provisioningparameter.html
  provisioning_parameters {
    # key (Required)
    # 設定内容: パラメータのキー名を指定します。
    # 設定可能な値: 文字列（1〜1000文字）
    # 関連機能: CloudFormation Template Parameters
    #   製品テンプレートで定義されたパラメータ名と一致する必要があります。
    #   - https://docs.aws.amazon.com/servicecatalog/latest/dg/API_DescribeProvisioningParameters.html
    key = "InstanceType"

    # value (Optional)
    # 設定内容: パラメータの値を指定します。
    # 設定可能な値: 文字列（最大4096文字）
    # 注意: use_previous_valueがtrueの場合は無視されます
    value = "t3.micro"

    # use_previous_value (Optional)
    # 設定内容: valueを無視して以前のパラメータ値を保持するかを指定します。
    # 設定可能な値:
    #   - true: 以前の値を使用（valueは無視される）
    #   - false (デフォルト): 指定されたvalueを使用
    # 省略時: false
    # 注意: 初回プロビジョニング時は無視されます（更新時のみ有効）
    use_previous_value = false
  }

  #-------------------------------------------------------------
  # スタックセットプロビジョニング設定
  #-------------------------------------------------------------

  # stack_set_provisioning_preferences (Optional)
  # 設定内容: スタックセットのプロビジョニング設定を指定します。
  # 関連機能: AWS CloudFormation StackSets
  #   複数のAWSアカウントおよびリージョンにスタックを展開する機能。
  #   Service CatalogのSTACKSET制約で定義されたアカウントとリージョン内で展開されます。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-servicecatalog-cloudformationprovisionedproduct-provisioningpreferences.html
  # 注意: このブロックは最大1つまで指定可能です
  stack_set_provisioning_preferences {
    # accounts (Optional)
    # 設定内容: プロビジョニングされた製品へのアクセス権を持つ1つ以上のAWSアカウントを指定します。
    # 設定可能な値: AWSアカウントIDのリスト
    # 省略時: STACKSET制約のすべてのアカウントがデフォルト値として使用されます
    # 注意: 指定されたAWSアカウントはSTACKSET制約のアカウントリスト内に含まれている必要があります
    # 関連機能: Service Catalog STACKSET Constraint
    #   aws_servicecatalog_provisioning_parametersデータソースを使用してSTACKSET制約のアカウントリストを取得できます。
    #   - https://docs.aws.amazon.com/servicecatalog/latest/dg/API_DescribeProvisioningParameters.html
    accounts = ["123456789012", "210987654321"]

    # regions (Optional)
    # 設定内容: プロビジョニングされた製品が利用可能になる1つ以上のAWSリージョンを指定します。
    # 設定可能な値: AWSリージョンコードのリスト
    # 省略時: STACKSET制約のすべてのリージョンがデフォルト値として使用されます
    # 注意: 指定されたリージョンはSTACKSET制約のリージョンリスト内に含まれている必要があります
    regions = ["ap-northeast-1", "us-east-1"]

    # failure_tolerance_count (Optional)
    # 設定内容: リージョンごとに、このオペレーションが失敗してもAWS Service Catalogがそのリージョンでオペレーションを停止する前に許容される失敗アカウント数を指定します。
    # 設定可能な値: 数値（0以上）
    # 省略時: 0（値が指定されていない場合のデフォルト値）
    # 注意: failure_tolerance_countまたはfailure_tolerance_percentageのいずれかを指定しますが、両方は指定不可
    # 関連機能: CloudFormation StackSets Failure Tolerance
    #   スタックセットオペレーションの失敗許容度を制御し、大規模展開時のリスクを管理します。
    #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html
    failure_tolerance_count = 0

    # failure_tolerance_percentage (Optional)
    # 設定内容: リージョンごとに、このスタックオペレーションが失敗してもAWS Service Catalogがそのリージョンでオペレーションを停止する前に許容される失敗アカウントの割合を指定します。
    # 設定可能な値: 数値（パーセンテージ）
    # 注意: failure_tolerance_countまたはfailure_tolerance_percentageのいずれかを指定しますが、両方は指定不可
    #       パーセンテージに基づいてアカウント数を計算する際、AWS Service Catalogは次の整数に切り捨てます。
    failure_tolerance_percentage = null

    # max_concurrency_count (Optional)
    # 設定内容: このオペレーションを一度に実行する最大アカウント数を指定します。
    # 設定可能な値: 数値（1以上）
    # 注意: max_concurrency_countまたはmax_concurrency_percentageのいずれかを指定しますが、両方は指定不可
    #       この設定はfailure_tolerance_countに依存し、max_concurrency_countは最大でもfailure_tolerance_count + 1です。
    #       大規模展開では、サービススロットリングにより実際の同時実行数が低くなる場合があります。
    # 関連機能: CloudFormation StackSets Concurrency
    #   スタックセットオペレーションの並列実行数を制御し、展開速度とリスクのバランスを調整します。
    #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html
    max_concurrency_count = 1

    # max_concurrency_percentage (Optional)
    # 設定内容: このオペレーションを一度に実行する最大アカウントの割合を指定します。
    # 設定可能な値: 数値（パーセンテージ）
    # 注意: max_concurrency_countまたはmax_concurrency_percentageのいずれかを指定しますが、両方は指定不可
    #       パーセンテージに基づいてアカウント数を計算する際、切り捨てが0になる場合を除き、
    #       AWS Service Catalogは次の整数に切り捨てます。0になる場合は代わりに1に設定されます。
    max_concurrency_percentage = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    create = null

    # read (Optional)
    # 設定内容: 読み取り操作のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    read = null

    # update (Optional)
    # 設定内容: 更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    update = null

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: プロビジョニングされた製品のAmazon Resource Name (ARN)
#
# - cloudwatch_dashboard_names: 製品のプロビジョニング時に作成されたCloudWatchダッシュボードのセット
#
# - created_time: プロビジョニングされた製品が作成された時刻
#
# - id: プロビジョニングされた製品のID
#
# - last_provisioning_record_id: この製品で実行された最後のリクエストのレコード識別子
#        （タイプ: ProvisionedProduct、UpdateProvisionedProduct、
#        ExecuteProvisionedProductPlan、TerminateProvisionedProduct）
#
# - last_record_id: この製品で実行された最後のリクエストのレコード識別子
#
# - last_successful_provisioning_record_id: この製品で実行された最後の成功したリクエストのレコード識別子
#        （タイプ: ProvisionedProduct、UpdateProvisionedProduct、
#        ExecuteProvisionedProductPlan、TerminateProvisionedProduct）
#
# - launch_role_arn: プロビジョニングされた製品に関連付けられた起動ロールのARN
#
#---------------------------------------------------------------
