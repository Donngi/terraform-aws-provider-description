#---------------------------------------------------------------
# Amazon Q Business Application
#---------------------------------------------------------------
#
# Amazon Q Businessのアプリケーション環境をプロビジョニングするリソースです。
# Amazon Q Businessは、組織のデータに基づいて質問応答や要約を提供する
# 生成AIアシスタントサービスです。アプリケーションはIAM Identity Centerと
# 統合され、エンドユーザーがウェブエクスペリエンスを通じてアクセスできます。
#
# AWS公式ドキュメント:
#   - Amazon Q Business アプリケーション作成: https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/create-app.html
#   - Amazon Q Business アプリケーション管理: https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/supported-app-actions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/qbusiness_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_qbusiness_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required)
  # 設定内容: Amazon Q Businessアプリケーションの表示名を指定します。
  # 設定可能な値: 文字列
  display_name = "example-qbusiness-app"

  # description (Optional)
  # 設定内容: Amazon Q Businessアプリケーションの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Example Amazon Q Business application"

  #-------------------------------------------------------------
  # IAM設定
  #-------------------------------------------------------------

  # iam_service_role_arn (Required)
  # 設定内容: Amazon Q Businessアプリケーションに権限を提供するIAMサービスロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このロールはAmazon CloudWatch LogsおよびメトリクスへのアクセスをAmazon Q Businessに付与する必要があります。
  iam_service_role_arn = "arn:aws:iam::123456789012:role/qbusiness-service-role"

  #-------------------------------------------------------------
  # IAM Identity Center設定
  #-------------------------------------------------------------

  # identity_center_instance_arn (Required)
  # 設定内容: Amazon Q Businessアプリケーションを作成または接続するIAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスARN
  # 参考: https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/create-app.html
  identity_center_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"

  #-------------------------------------------------------------
  # 添付ファイル設定
  #-------------------------------------------------------------

  # attachments_configuration (Required)
  # 設定内容: エンドユーザーのファイルアップロード機能の有効・無効を設定するブロックです。
  attachments_configuration {

    # attachments_control_mode (Required)
    # 設定内容: ファイルアップロード機能の有効・無効状態を指定します。
    # 設定可能な値:
    #   - "ENABLED": ファイルアップロード機能を有効化
    #   - "DISABLED": ファイルアップロード機能を無効化
    attachments_control_mode = "ENABLED"
  }

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: データの暗号化に使用するKMSキーの設定ブロックです。
  # 省略時: AWSマネージドキーによる暗号化が適用されます。
  # 参考: https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/create-app.html
  encryption_configuration {

    # kms_key_id (Required)
    # 設定内容: データの暗号化に使用するAWS KMSキーの識別子を指定します。
    # 設定可能な値: 有効なKMSキーIDまたはARN
    # 注意: Amazon Q Businessは非対称キーをサポートしていません。対称キーを使用してください。
    kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

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
  # 省略時: タグなし
  tags = {
    Name        = "example-qbusiness-app"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Q Businessアプリケーションのアプリケーションid
# - arn: Q BusinessアプリケーションのARN
# - identity_center_application_arn: Amazon Q BusinessアプリケーションにアタッチされたAWS IAM Identity CenterアプリケーションのARN
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグマップ
#---------------------------------------------------------------
