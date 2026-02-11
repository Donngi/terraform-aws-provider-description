#---------------------------------------------------------------
# AWS Systems Manager Document
#---------------------------------------------------------------
#
# AWS Systems Manager Documentをプロビジョニングするリソースです。
# SSMドキュメントは、Systems Managerが管理対象インスタンスで実行するアクションを
# 定義するJSON/YAML形式の設定ファイルです。Command、Automation、Session、Policy、
# Package、ApplicationConfiguration、ChangeCalendarなど、様々なドキュメントタイプを
# 作成できます。
#
# AWS公式ドキュメント:
#   - AWS Systems Manager Documents: https://docs.aws.amazon.com/systems-manager/latest/userguide/documents.html
#   - SSMドキュメントのスキーマと機能: https://docs.aws.amazon.com/systems-manager/latest/userguide/documents-schemas-features.html
#   - CreateDocument API: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_CreateDocument.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_document" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ドキュメントの名前を指定します。
  # 設定可能な値: 3-128文字の英数字、ハイフン、アンダースコア、ピリオド、コロン、スラッシュで構成される文字列
  # パターン: ^[a-zA-Z0-9_\-.:/]{3,128}$
  # 注意: 一意の名前である必要があります
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_CreateDocument.html#systemsmanager-CreateDocument-request-Name
  name = "MyCustomDocument"

  # document_type (Required)
  # 設定内容: ドキュメントのタイプを指定します。
  # 設定可能な値:
  #   - "Command": Run CommandやState Managerで使用するコマンドドキュメント
  #   - "Automation": Automationで使用する自動化ランブック
  #   - "Session": Session Managerで使用するセッションドキュメント
  #   - "Policy": State Managerで使用するポリシードキュメント
  #   - "Package": Distributorで使用するパッケージドキュメント
  #   - "ApplicationConfiguration": AWS AppConfigで使用するアプリケーション設定
  #   - "ApplicationConfigurationSchema": AWS AppConfigで使用するスキーマ
  #   - "DeploymentStrategy": デプロイメント戦略定義
  #   - "ChangeCalendar": Change Calendarで使用するカレンダードキュメント
  #   - "Automation.ChangeTemplate": 変更テンプレート
  #   - "ProblemAnalysis": 問題分析用ドキュメント
  #   - "ProblemAnalysisTemplate": 問題分析テンプレート
  #   - "CloudFormation": CloudFormationテンプレート
  #   - "ConformancePackTemplate": AWS Config準拠パックテンプレート
  #   - "QuickSetup": クイックセットアップ用ドキュメント
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/documents.html
  document_type = "Command"

  # content (Required)
  # 設定内容: SSMドキュメントのコンテンツをJSON/YAML形式で指定します。
  # 設定可能な値: JSON、YAML、またはTEXT形式の文字列（最大64KB）
  # 注意: このクォータには実行時の入力パラメータの内容も含まれます。
  #       コンテンツは外部ファイルに保存し、file()関数で参照することを推奨します。
  #       スキーマバージョン2.0以降のドキュメントのみ作成後の更新が可能です。
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/documents-schemas-features.html
  content = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Check ip configuration of a Linux instance.",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "example",
      "inputs": {
        "runCommand": ["ifconfig"]
      }
    }
  ]
}
DOC

  #-------------------------------------------------------------
  # フォーマット設定
  #-------------------------------------------------------------

  # document_format (Optional)
  # 設定内容: ドキュメントのフォーマットを指定します。
  # 設定可能な値:
  #   - "JSON" (デフォルト): JSON形式
  #   - "YAML": YAML形式
  #   - "TEXT": テキスト形式
  # 省略時: "JSON"が使用されます
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_CreateDocument.html#systemsmanager-CreateDocument-request-DocumentFormat
  document_format = "JSON"

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_type (Optional)
  # 設定内容: ドキュメントを実行できるリソースのタイプを指定します。
  # 設定可能な値: CloudFormationリソースタイプ形式の文字列（例: /AWS::EC2::Instance）
  # パターン: ^\\/[\\w\\.\\-\\:\\/]*$
  # 最大長: 200文字
  # 省略時: すべてのリソースタイプに対して実行可能
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html
  target_type = "/AWS::EC2::Instance"

  #-------------------------------------------------------------
  # バージョン設定
  #-------------------------------------------------------------

  # version_name (Optional)
  # 設定内容: ドキュメントに関連付けられたアーティファクトのバージョンを指定します。
  # 設定可能な値: 1-128文字の英数字、ハイフン、アンダースコア、ピリオドで構成される文字列
  # パターン: ^[a-zA-Z0-9_\\-.]{1,128}$
  # 注意: このバージョン名はドキュメントのすべてのバージョン間で一意である必要があり、変更できません
  # 例: "12.6"
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_CreateDocument.html#systemsmanager-CreateDocument-request-VersionName
  version_name = null

  #-------------------------------------------------------------
  # アタッチメント設定
  #-------------------------------------------------------------

  # attachments_source (Optional, 最大20個まで)
  # 設定内容: ドキュメントバージョンに添付するファイルのソースを指定します。
  # 注意: ドキュメントに最大20個のアタッチメントソースを定義できます
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_AttachmentsSource.html
  attachments_source {
    # key (Required)
    # 設定内容: アタッチメントの場所を識別するキーを指定します。
    # 設定可能な値:
    #   - "SourceUrl": ソースのURL
    #   - "S3FileUrl": S3ファイルのURL
    #   - "AttachmentReference": アタッチメント参照
    key = "SourceUrl"

    # values (Required)
    # 設定内容: アタッチメントの場所を識別する値を指定します。
    # 設定可能な値: keyのタイプに応じた文字列のリスト（単一要素）
    # 例: S3FileUrlの場合: ["s3://bucket-name/path/to/file.zip"]
    # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_AttachmentsSource.html
    values = ["https://example.com/path/to/attachment.zip"]

    # name (Optional)
    # 設定内容: アタッチメントファイルの名前を指定します。
    # 省略時: 自動的に名前が割り当てられます
    name = "MyAttachment"
  }

  #-------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------

  # permissions (Optional)
  # 設定内容: ドキュメントに付与する追加の権限を指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー "type": 権限のタイプ（現在は "Share" のみサポート）
  #   - キー "account_ids": アクセス権を付与するAWSアカウントID、または "All"
  # 例: { "type" = "Share", "account_ids" = "123456789012,987654321098" }
  # 例: { "type" = "Share", "account_ids" = "All" }
  # 注意: 他のアカウントとドキュメントを共有する場合に使用します
  permissions = {
    type        = "Share"
    account_ids = "123456789012"
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
  # 設定可能な値: キーと値のペアのマップ（最大1000タグ）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/tagging-documents.html
  tags = {
    Name        = "MyCustomDocument"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドキュメントのAmazon Resource Name (ARN)
#
# - created_date: ドキュメントが作成された日時
#
# - default_version: ドキュメントのデフォルトバージョン
#
# - description: ドキュメントの説明
#        ドキュメントのcontentから自動的に抽出されます
#
# - document_version: ドキュメントのバージョン番号
#
# - hash: ドキュメントが作成されたときにシステムによって生成されたSha256またはSha1ハッシュ
#
# - hash_type: ハッシュのタイプ
#        設定可能な値: "Sha256"、"Sha1"
#
# - id: ドキュメントの名前（nameと同じ値）
#
# - latest_version: ドキュメントの最新バージョン
#
#---------------------------------------------------------------
