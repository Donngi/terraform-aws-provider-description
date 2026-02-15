#---------------------------------------
# AWS CloudFormation StackSet Instance
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudformation_stack_set_instance
#
# CloudFormationスタックセットから個別のAWSアカウントまたはOrganizationの組織単位（OU）にスタックインスタンスをデプロイするためのリソース。
# スタックセットで定義されたテンプレートを複数のアカウント・リージョンに一括展開する際に使用します。
#
# 主な用途:
# - マルチアカウント環境での統一リソースのデプロイ
# - AWS Organizations配下の複数アカウントへの一括リソース展開
# - 特定リージョンへのスタックインスタンス作成
#
# 注意事項:
# - スタックセット本体（aws_cloudformation_stack_set）が事前に必要
# - Organizations統合デプロイの場合は管理アカウントまたは委任管理者からの実行が必要
# - 各アカウントでStackSetの実行権限が設定されている必要がある
# - パラメータ上書き（parameter_overrides）はスタックセットのパラメータに対して行う
#
# NOTE: このテンプレートには全ての利用可能な属性が含まれていますが、実際の使用時には必要な項目のみを選択してください。

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_cloudformation_stack_set_instance" "example" {
  # スタックセット名
  # 設定内容: デプロイ元となるスタックセットの名前
  # 必須項目
  stack_set_name = "example-stack-set"

  #---------------------------------------
  # デプロイターゲット設定
  #---------------------------------------

  # デプロイターゲット
  # 設定内容: Organizations統合を利用した複数アカウントへのデプロイ設定
  # 省略時: 単一アカウント（account_id）へのデプロイモード
  # deployment_targets {
  #   # アカウントフィルタータイプ
  #   # 設定内容: アカウント選択時のフィルタリング方法
  #   # 設定可能な値: INTERSECTION（積集合）、DIFFERENCE（差集合）、UNION（和集合）
  #   # 省略時: NONE
  #   account_filter_type = "NONE"
  #
  #   # デプロイ対象アカウントID
  #   # 設定内容: スタックインスタンスをデプロイするAWSアカウントIDのリスト
  #   # 形式: 12桁の数値文字列のセット
  #   # accounts = ["123456789012", "210987654321"]
  #
  #   # アカウントリストURL
  #   # 設定内容: デプロイ対象アカウントIDリストを含むS3オブジェクトのURL
  #   # 形式: s3://bucket-name/object-key
  #   # accounts_url = "s3://example-bucket/accounts.txt"
  #
  #   # 組織単位ID
  #   # 設定内容: デプロイ対象となるAWS OrganizationsのOU IDリスト
  #   # 形式: ou-xxxx-xxxxxxxx形式のIDセット
  #   # organizational_unit_ids = ["ou-xxxx-11111111", "ou-xxxx-22222222"]
  # }

  #---------------------------------------
  # アカウント・リージョン指定（レガシーモード）
  #---------------------------------------

  # デプロイ先アカウントID
  # 設定内容: スタックインスタンスをデプロイする単一AWSアカウントID
  # 省略時: 現在のアカウントにデプロイ
  # 備考: deployment_targetsとの併用不可（どちらか一方を使用）
  account_id = "123456789012"

  # デプロイ先リージョン
  # 設定内容: スタックインスタンスをデプロイするAWSリージョン（stack_set_instance_regionの代替）
  # 省略時: 現在のリージョンにデプロイ
  # 非推奨: stack_set_instance_regionの使用を推奨
  region = "us-east-1"

  # スタックインスタンスリージョン
  # 設定内容: スタックインスタンスをデプロイするAWSリージョン（推奨属性）
  # 省略時: 現在のリージョンにデプロイ
  stack_set_instance_region = "us-west-2"

  #---------------------------------------
  # パラメータ設定
  #---------------------------------------

  # パラメータ上書き
  # 設定内容: スタックセットで定義されたパラメータを上書きする値
  # 形式: キーバリューペアのマップ（キー: パラメータ名、値: 上書き値）
  # 省略時: スタックセットのデフォルトパラメータを使用
  parameter_overrides = {
    Environment  = "production"
    InstanceType = "t3.large"
  }

  #---------------------------------------
  # 運用設定
  #---------------------------------------

  # 操作プリファレンス
  # 設定内容: スタックインスタンスの作成・更新時の実行制御オプション
  # 省略時: デフォルトの逐次実行
  # operation_preferences {
  #   # 同時実行モード
  #   # 設定内容: リージョン間の同時実行制御方法
  #   # 設定可能な値: STRICT_FAILURE_TOLERANCE（厳格）、SOFT_FAILURE_TOLERANCE（緩和）
  #   # 省略時: STRICT_FAILURE_TOLERANCE
  #   concurrency_mode = "STRICT_FAILURE_TOLERANCE"
  #
  #   # 失敗許容数
  #   # 設定内容: 操作を停止するまでに許容されるスタック失敗数
  #   # 形式: 0以上の整数
  #   # 備考: failure_tolerance_percentageとの併用不可
  #   # failure_tolerance_count = 1
  #
  #   # 失敗許容率
  #   # 設定内容: 操作を停止するまでに許容されるスタック失敗率（パーセント）
  #   # 形式: 0-100の整数
  #   # 備考: failure_tolerance_countとの併用不可
  #   # failure_tolerance_percentage = 10
  #
  #   # 最大同時実行数
  #   # 設定内容: 同時に実行可能なスタック操作の最大数
  #   # 形式: 1以上の整数
  #   # 備考: max_concurrent_percentageとの併用不可
  #   # max_concurrent_count = 5
  #
  #   # 最大同時実行率
  #   # 設定内容: 同時に実行可能なスタック操作の最大割合（パーセント）
  #   # 形式: 1-100の整数
  #   # 備考: max_concurrent_countとの併用不可
  #   # max_concurrent_percentage = 50
  #
  #   # リージョン同時実行タイプ
  #   # 設定内容: 複数リージョンへのデプロイ時の同時実行制御
  #   # 設定可能な値: SEQUENTIAL（逐次実行）、PARALLEL（並列実行）
  #   # 省略時: SEQUENTIAL
  #   # region_concurrency_type = "SEQUENTIAL"
  #
  #   # リージョン実行順序
  #   # 設定内容: スタック操作を実行するリージョンの順序
  #   # 形式: リージョンコードのリスト
  #   # 備考: region_concurrency_type = "SEQUENTIAL"の場合に有効
  #   # region_order = ["us-east-1", "us-west-2", "eu-west-1"]
  # }

  # 呼び出しモード
  # 設定内容: StackSetの実行コンテキスト（Organizations統合時の権限モード）
  # 設定可能な値: SELF（セルフマネージド）、DELEGATED_ADMIN（委任管理者）
  # 省略時: SELF
  call_as = "SELF"

  # スタック保持
  # 設定内容: リソース削除時に実際のCloudFormationスタックを保持するかどうか
  # 設定可能な値: true（保持）、false（削除）
  # 省略時: false
  # 備考: trueの場合、Terraformリソースのみ削除され、実スタックは残る
  retain_stack = false

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # timeouts {
  #   # 作成タイムアウト
  #   # 設定内容: スタックインスタンス作成操作の最大待機時間
  #   # 形式: 時間文字列（例: 30m、1h）
  #   # 省略時: 30m
  #   create = "30m"
  #
  #   # 更新タイムアウト
  #   # 設定内容: スタックインスタンス更新操作の最大待機時間
  #   # 形式: 時間文字列（例: 30m、1h）
  #   # 省略時: 30m
  #   update = "30m"
  #
  #   # 削除タイムアウト
  #   # 設定内容: スタックインスタンス削除操作の最大待機時間
  #   # 形式: 時間文字列（例: 30m、1h）
  #   # 省略時: 30m
  #   delete = "30m"
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意識別子（スタックセット名,アカウントID,リージョンの組み合わせ）
# - stack_id: デプロイされたCloudFormationスタックのID
# - organizational_unit_id: スタックインスタンスがデプロイされた組織単位のID
# - stack_instance_summaries: 組織単位デプロイ時に作成されたスタックインスタンスのサマリーリスト
#   - account_id: スタックがデプロイされたアカウントID
#   - organizational_unit_id: スタックがデプロイされた組織単位ID
#   - stack_id: デプロイされたスタックのID
