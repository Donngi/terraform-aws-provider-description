#---------------------------------------------------------------
# AWS CloudFormation StackSet
#---------------------------------------------------------------
#
# AWS CloudFormation StackSet（スタックセット）をプロビジョニングするリソースです。
# StackSetは単一のCloudFormationテンプレートから複数のAWSアカウント・複数のリージョンに
# またがってスタックを作成・更新・削除できる機能で、マルチアカウント運用において
# 共通基盤（IAMロール、ネットワーク設定、セキュリティ設定等）を一元的にデプロイするために
# 利用されます。SELF_MANAGED権限モデルではユーザー自身が管理ロールと実行ロールを準備し、
# SERVICE_MANAGED権限モデルではAWS Organizationsと連携してOU単位での自動デプロイが可能です。
#
# AWS公式ドキュメント:
#   - CloudFormation StackSets概要: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html
#   - StackSet 権限モデル: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html#stackset-permission-models
#   - StackSet 操作オプション: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html#stackset-ops-options
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudformation_stack_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: スタックセットの名前を指定します。
  # 設定可能な値: 英数字とハイフン。最大128文字。先頭は英字。アカウント・リージョン内で一意である必要があります。
  # 注意: 作成後の変更不可（変更すると再作成）
  name = "example-stack-set"

  # description (Optional)
  # 設定内容: スタックセットの説明文を指定します。
  # 設定可能な値: 1-1024文字の文字列
  # 省略時: 説明なし
  description = "Multi-account baseline deployment via CloudFormation StackSet"

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
  # テンプレート設定
  #-------------------------------------------------------------

  # template_body (Optional)
  # 設定内容: CloudFormationテンプレート本文を文字列として指定します。
  # 設定可能な値: JSONまたはYAML形式のCloudFormationテンプレート文字列。最大51,200バイト。
  # 省略時: template_url を使用するか、APIから取得したテンプレートが格納されます。
  # 注意: template_url と排他的（どちらか一方のみ指定可能）
  # 関連機能: CloudFormation テンプレート
  #   テンプレートはStackSetからデプロイされる全スタックの構造を定義します。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html
  template_body = jsonencode({
    AWSTemplateFormatVersion = "2010-09-09"
    Parameters = {
      VPCCidr = {
        Type        = "String"
        Default     = "10.0.0.0/16"
        Description = "VPC CIDR block"
      }
    }
    Resources = {
      MyVPC = {
        Type = "AWS::EC2::VPC"
        Properties = {
          CidrBlock = { Ref = "VPCCidr" }
        }
      }
    }
  })

  # template_url (Optional)
  # 設定内容: S3に配置したCloudFormationテンプレートのURLを指定します。
  # 設定可能な値: HTTPS形式のS3 URL。テンプレートサイズは最大1MB。
  # 省略時: template_body を使用する場合は省略可
  # 注意: template_body と排他的（どちらか一方のみ指定可能）
  # 注意: S3バケットは StackSet を作成するアカウント・リージョンと同じリージョンに存在する必要があります。
  template_url = null

  # parameters (Optional)
  # 設定内容: テンプレートパラメータの値をキー・バリューマップで指定します。
  # 設定可能な値: テンプレートで定義されたパラメータ名と値のマップ
  # 省略時: テンプレートのデフォルト値が使用されます。
  # 注意: NoEchoパラメータや一部のパラメータはAPI応答で返却されないため、差分検出を避けるには
  #       lifecycle.ignore_changes に parameters を含める運用が推奨されます。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html
  parameters = {
    VPCCidr = "10.1.0.0/16"
  }

  #-------------------------------------------------------------
  # 機能設定
  #-------------------------------------------------------------

  # capabilities (Optional)
  # 設定内容: テンプレートに含まれる特定リソースタイプを許可する機能を指定します。
  # 設定可能な値:
  #   - "CAPABILITY_IAM": 名前なしIAMリソースの作成を許可
  #   - "CAPABILITY_NAMED_IAM": 名前付きIAMリソースの作成を許可
  #   - "CAPABILITY_AUTO_EXPAND": マクロやネストスタックの展開を許可
  # 省略時: 機能宣言なし。IAMリソース等を含むテンプレートはエラーになります。
  # 関連機能: CloudFormation IAM Capabilities
  #   IAMリソースを作成するテンプレートをデプロイする際は明示的な承認が必要です。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-iam-template.html#capabilities
  capabilities = ["CAPABILITY_IAM"]

  #-------------------------------------------------------------
  # 権限モデル設定
  #-------------------------------------------------------------

  # permission_model (Optional)
  # 設定内容: スタックセットが対象アカウントへデプロイする際の権限管理モデルを指定します。
  # 設定可能な値:
  #   - "SELF_MANAGED" (デフォルト): 管理者が事前に AWSCloudFormationStackSetAdministrationRole と
  #     AWSCloudFormationStackSetExecutionRole を準備して使用するモデル
  #   - "SERVICE_MANAGED": AWS Organizationsと連携し、CloudFormationが自動で必要なIAMロールを作成・管理するモデル
  # 省略時: "SELF_MANAGED"
  # 関連機能: StackSet 権限モデル
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html#stackset-permission-models
  permission_model = "SELF_MANAGED"

  # administration_role_arn (Optional)
  # 設定内容: 管理者アカウントで使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: SELF_MANAGED 権限モデルの場合、AWSCloudFormationStackSetAdministrationRole という名前のロールが
  #         事前に存在することが期待されます。
  # 注意: permission_model = "SERVICE_MANAGED" の場合は指定不可（AWSが管理）
  administration_role_arn = "arn:aws:iam::123456789012:role/AWSCloudFormationStackSetAdministrationRole"

  # execution_role_name (Optional)
  # 設定内容: ターゲットアカウントで使用するIAM実行ロールの「名前」を指定します（ARNではない点に注意）。
  # 設定可能な値: ターゲットアカウントに存在するIAMロール名
  # 省略時: SELF_MANAGED 権限モデルの場合、"AWSCloudFormationStackSetExecutionRole" が使用されます。
  # 注意: permission_model = "SERVICE_MANAGED" の場合は指定不可（AWSが管理）
  execution_role_name = "AWSCloudFormationStackSetExecutionRole"

  # call_as (Optional)
  # 設定内容: API呼び出しを管理アカウントとして実行するか、委任管理者として実行するかを指定します。
  # 設定可能な値:
  #   - "SELF" (デフォルト): 呼び出し元アカウントが管理アカウントとして実行
  #   - "DELEGATED_ADMIN": 呼び出し元アカウントを委任管理者として実行
  # 省略時: "SELF"
  # 注意: "DELEGATED_ADMIN" を使用するには、対象アカウントが Organizations の委任管理者として
  #       事前登録されており、organizations:ListDelegatedAdministrators 権限が必要です。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-delegated-admin.html
  call_as = "SELF"

  #-------------------------------------------------------------
  # 自動デプロイ設定（SERVICE_MANAGED専用）
  #-------------------------------------------------------------

  # auto_deployment (Optional)
  # 設定内容: AWS Organizations のOUに対する自動デプロイ動作の設定ブロックです。
  # 注意: permission_model = "SERVICE_MANAGED" の場合のみ指定可能
  # 関連機能: StackSet 自動デプロイ
  #   OUにアカウントが追加されると自動的にスタックがデプロイされ、削除されると自動的にスタックも削除されます。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-enable-trusted-access.html
  auto_deployment {

    # enabled (Optional)
    # 設定内容: 自動デプロイを有効にするかを指定します。
    # 設定可能な値:
    #   - true: OUにアカウントが追加・削除された際に自動でスタックを作成・削除
    #   - false: 自動デプロイを無効化
    # 省略時: false
    enabled = true

    # retain_stacks_on_account_removal (Optional)
    # 設定内容: ターゲットアカウントがOUから削除された際に、デプロイ済みスタックを保持するかを指定します。
    # 設定可能な値:
    #   - true: アカウントがOUから外れてもスタックを保持
    #   - false: アカウントがOUから外れたらスタックを削除
    # 省略時: false
    # 注意: enabled = true の場合に必須
    retain_stacks_on_account_removal = false

    # depends_on_stack_sets (Optional)
    # 設定内容: このスタックセットがデプロイされる前に存在している必要がある別のスタックセットの一覧を指定します。
    # 設定可能な値: スタックセット名のリスト
    # 省略時: 依存関係なし
    # 注意: SERVICE_MANAGEDの自動デプロイで、依存スタックセットが先にデプロイされていることを保証します。
    depends_on_stack_sets = []
  }

  #-------------------------------------------------------------
  # 実行管理設定
  #-------------------------------------------------------------

  # managed_execution (Optional)
  # 設定内容: スタックセット操作の同時実行・キューイング動作の設定ブロックです。
  # 関連機能: StackSet マネージド実行
  #   非競合の操作を並列実行し、競合する操作はキューに入れて順次実行します。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concurrent-ops.html
  managed_execution {

    # active (Optional)
    # 設定内容: 非競合操作の同時実行と競合操作のキューイングを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 非競合操作を並列実行、競合操作をキューイング
    #   - false: 操作を一つずつ実行
    # 省略時: false
    active = true
  }

  #-------------------------------------------------------------
  # 操作オプション設定
  #-------------------------------------------------------------

  # operation_preferences (Optional)
  # 設定内容: スタックセットの作成・更新・削除操作時に適用される動作を指定する設定ブロックです。
  # 関連機能: StackSet 操作オプション
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html#stackset-ops-options
  operation_preferences {

    # failure_tolerance_count (Optional)
    # 設定内容: 操作を失敗とみなすまでに許容するアカウント単位の失敗数を指定します。
    # 設定可能な値: 0以上の整数
    # 省略時: 0
    # 注意: failure_tolerance_percentage と排他的
    failure_tolerance_count = 0

    # failure_tolerance_percentage (Optional)
    # 設定内容: 操作を失敗とみなすまでに許容する失敗アカウントの割合（パーセント）を指定します。
    # 設定可能な値: 0-100の整数
    # 省略時: 指定なし
    # 注意: failure_tolerance_count と排他的
    failure_tolerance_percentage = null

    # max_concurrent_count (Optional)
    # 設定内容: 同時に操作を実行する最大アカウント数を指定します。
    # 設定可能な値: 1以上の整数。failure_tolerance_count より大きい値を指定する必要があります。
    # 省略時: 1
    # 注意: max_concurrent_percentage と排他的
    max_concurrent_count = 1

    # max_concurrent_percentage (Optional)
    # 設定内容: 同時に操作を実行する最大アカウント数の割合（パーセント）を指定します。
    # 設定可能な値: 1-100の整数
    # 省略時: 指定なし
    # 注意: max_concurrent_count と排他的
    max_concurrent_percentage = null

    # region_concurrency_type (Optional)
    # 設定内容: 複数リージョンへのデプロイにおけるリージョン間の同時実行モードを指定します。
    # 設定可能な値:
    #   - "SEQUENTIAL" (デフォルト): リージョンを順次処理
    #   - "PARALLEL": リージョンを並列処理
    # 省略時: "SEQUENTIAL"
    region_concurrency_type = "SEQUENTIAL"

    # region_order (Optional)
    # 設定内容: スタックセット操作を実行するリージョンの順序を指定します。
    # 設定可能な値: AWSリージョンコードのリスト
    # 省略時: 指定なし。region_concurrency_type = "SEQUENTIAL" の場合は任意の順序で実行されます。
    region_order = ["us-east-1", "us-west-2", "ap-northeast-1"]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: スタックセットおよびターゲットアカウントで作成される各スタックに適用するタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。最大50タグ。
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと一致するキーを持つタグは、
  #   プロバイダーレベルで定義されたものを上書きします。スタックセットのタグは作成される
  #   スタックリソースにも伝播されます。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-stack-tagging-resources.html
  tags = {
    Name        = "example-stack-set"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 各種操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # update (Optional)
    # 設定内容: 更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウト
    update = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スタックセット名（nameと同じ値）
# - arn: スタックセットのAmazon Resource Name (ARN)
# - stack_set_id: スタックセットの一意識別子（UUID形式）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
