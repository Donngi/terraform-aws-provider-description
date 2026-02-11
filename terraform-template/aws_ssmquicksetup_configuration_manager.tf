#---------------------------------------------------------------
# AWS SSM Quick Setup Configuration Manager
#---------------------------------------------------------------
#
# AWS Systems Manager Quick Setupの構成マネージャーをプロビジョニングするリソースです。
# 構成マネージャーは、Quick Setupの構成定義をデプロイします。構成定義には、
# 特定の構成タイプをデプロイするために必要なすべての情報が含まれます。
# パッチポリシー、ホスト管理、Config準拠パックなど、さまざまな構成タイプをサポートします。
#
# AWS公式ドキュメント:
#   - Quick Setup APIの使用: https://docs.aws.amazon.com/systems-manager/latest/userguide/quick-setup-api.html
#   - サポートされている構成タイプ: https://docs.aws.amazon.com/systems-manager/latest/userguide/quick-setup-config-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmquicksetup_configuration_manager
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssmquicksetup_configuration_manager" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 構成マネージャーの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: 構成マネージャーを識別するための一意の名前を設定してください。
  name = "example-configuration-manager"

  # description (Optional)
  # 設定内容: 構成マネージャーの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  # 用途: 構成マネージャーの目的や内容を記載し、管理性を向上させます。
  description = "Example configuration manager for patch policy"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-configuration-manager"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 構成定義
  #-------------------------------------------------------------

  # configuration_definition (Required)
  # 設定内容: Quick Setup構成マネージャーがデプロイする構成の定義を指定します。
  # 注意: 複数の構成定義を含めることができます。
  configuration_definition {

    # type (Required)
    # 設定内容: Quick Setup構成のタイプを指定します。
    # 設定可能な値:
    #   - "AWSQuickSetupType-PatchPolicy": パッチポリシー構成
    #   - "AWSQuickSetupType-SSMHostMgmt": ホスト管理構成
    #   - "AWSQuickSetupType-DHMC": デフォルトホスト管理構成
    #   - その他のQuick Setup構成タイプ
    # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/quick-setup-config-types.html
    type = "AWSQuickSetupType-PatchPolicy"

    # parameters (Required)
    # 設定内容: 構成定義タイプのパラメータを指定します。
    # 設定可能な値: キーと値のペアのマップ（構成タイプによって異なります）
    # 注意: パラメータは構成タイプによって変化します。
    #       各構成タイプの完全なパラメータリストについては、AWS APIドキュメントを参照してください。
    # 参考: https://docs.aws.amazon.com/quick-setup/latest/APIReference/API_ConfigurationDefinitionInput.html
    parameters = {
      "ConfigurationOptionsPatchOperation" : "Scan",
      "ConfigurationOptionsScanValue" : "cron(0 1 * * ? *)",
      "ConfigurationOptionsScanNextInterval" : "false",
      "PatchBaselineRegion" : "ap-northeast-1",
      "PatchBaselineUseDefault" : "default",
      "PatchPolicyName" : "example-policy",
      "OutputLogEnableS3" : "false",
      "RateControlConcurrency" : "10%",
      "RateControlErrorThreshold" : "2%",
      "IsPolicyAttachAllowed" : "false",
      "TargetAccounts" : "123456789012",
      "TargetRegions" : "ap-northeast-1",
      "TargetType" : "*"
    }

    # local_deployment_administration_role_arn (Optional)
    # 設定内容: ローカル構成デプロイメントを管理するために使用されるIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 省略時: デフォルトのロールが使用されます
    # 用途: 構成のデプロイメントを管理するための適切な権限を持つロールを指定します。
    local_deployment_administration_role_arn = "arn:aws:iam::123456789012:role/AWS-QuickSetup-PatchPolicy-LocalAdministrationRole"

    # local_deployment_execution_role_name (Optional)
    # 設定内容: ローカル構成をデプロイするために使用されるIAMロールの名前を指定します。
    # 設定可能な値: IAMロール名
    # 省略時: デフォルトのロール名が使用されます
    # 用途: 構成の実行に必要な権限を持つロールの名前を指定します。
    local_deployment_execution_role_name = "AWS-QuickSetup-PatchPolicy-LocalExecutionRole"

    # type_version (Optional)
    # 設定内容: 使用するQuick Setupタイプのバージョンを指定します。
    # 設定可能な値: バージョン文字列
    # 省略時: 最新バージョンが使用されます
    # 注意: 特定のバージョンを指定しない限り、最新のタイプバージョンが自動的に使用されます。
    type_version = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 作成、更新、削除操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    # 注意: 削除操作のタイムアウトは、破棄操作が発生する前に
    #       変更がstateに保存される場合にのみ適用されます。
    # 参考: https://pkg.go.dev/time#ParseDuration
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - manager_arn: 構成マネージャーのARN
#
# - status_summaries: 構成マネージャーの状態のサマリー。
#                     デプロイメントステータス、関連付けステータス、
#                     ドリフトステータス、ヘルスチェックなどが含まれます。
#   - status: 現在のステータス
#   - status_message: 該当する場合、現在のステータスとステータスタイプに
#                     関連する情報メッセージを返します
#   - status_type: ステータスサマリーのタイプ
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
