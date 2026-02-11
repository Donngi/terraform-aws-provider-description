#---------------------------------------------------------------
# AWS DataZone Form Type
#---------------------------------------------------------------
#
# Amazon DataZoneのフォームタイプ（メタデータフォームの定義）をプロビジョニングするリソースです。
# フォームタイプは、データカタログ内のアセットにビジネスコンテキストを追加するための
# メタデータフォームの構造を定義します。カスタムフィールド定義を含むsmithyドキュメントを
# 使用してフォーム構造を指定します。
#
# AWS公式ドキュメント:
#   - Amazon DataZone概要: https://docs.aws.amazon.com/datazone/latest/userguide/what-is-datazone.html
#   - メタデータフォームの作成: https://docs.aws.amazon.com/datazone/latest/userguide/create-metadata-form.html
#   - CreateFormType API: https://docs.aws.amazon.com/datazone/latest/APIReference/API_CreateFormType.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_form_type
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_datazone_form_type" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_identifier (Required)
  # 設定内容: フォームタイプを作成するDataZoneドメインの識別子を指定します。
  # 設定可能な値: 有効なDataZoneドメインID（1〜36文字の英数字、ハイフン、アンダースコア）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  domain_identifier = aws_datazone_domain.example.id

  # name (Required)
  # 設定内容: フォームタイプの名前を指定します。
  # 設定可能な値: 1〜128文字の文字列
  # 注意: smithyドキュメント内の構造体名と一致する必要があります。
  #       リソース作成後の変更はできません（Forces new resource）
  # 例: smithyで "structure SageMakerModelFormType {...}" と定義した場合、
  #     nameは "SageMakerModelFormType" とする必要があります。
  name = "SageMakerModelFormType"

  # owning_project_identifier (Required)
  # 設定内容: フォームタイプを所有するDataZoneプロジェクトの識別子を指定します。
  # 設定可能な値: 1〜36文字の英数字、ハイフン、アンダースコア（^[a-zA-Z0-9_-]{1,36}）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  owning_project_identifier = aws_datazone_project.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: フォームタイプの説明を指定します。
  # 設定可能な値: 1〜2048文字の文字列
  # 省略時: 説明なし
  description = "SageMakerモデルのメタデータを収集するためのフォームタイプ"

  # status (Optional)
  # 設定内容: フォームタイプのステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED": フォームタイプを有効化（アセットへのアタッチが可能）
  #   - "DISABLED": フォームタイプを無効化
  # 省略時: "ENABLED"
  # 注意: statusが "ENABLED" の場合、Terraformからリソースを削除する前に
  #       AWSコンソールで手動で "DISABLED" に変更する必要があります。
  status = "DISABLED"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # モデル設定
  #-------------------------------------------------------------

  # model (Required Block)
  # 設定内容: フォームタイプのデータモデルを定義するブロックです。
  # 注意: smithyドキュメントを使用してフォームの構造を定義します。
  model {
    # smithy (Required)
    # 設定内容: APIのモデルを示すsmithyドキュメントを指定します。
    # 設定可能な値: 1〜100,000文字のsmithy形式の文字列
    # smithyドキュメントの構文:
    #   - @required: 必須フィールドを示すアノテーション
    #   - @amazon.datazone#searchable: フィールドを検索可能にするアノテーション
    #   - 対応する型: String, Integer, Boolean, Long, Float, Double, Timestamp
    # 注意: 構造体名はnameプロパティと一致する必要があります
    # 参考: https://smithy.io/2.0/spec/
    smithy = <<-EOF
structure SageMakerModelFormType {
    @required
    @amazon.datazone#searchable
    modelName: String

    @required
    modelArn: String

    @required
    creationTime: String

    @amazon.datazone#searchable
    modelDescription: String

    framework: String

    frameworkVersion: String
}
EOF
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional Block)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - created_at: フォームタイプが作成されたタイムスタンプ
#
# - created_by: フォームタイプを作成したDataZoneユーザー
#
# - imports: フォームタイプで指定されたインポートのリスト
#            各インポートはname（名前）とrevision（リビジョン）を含みます
#
# - origin_domain_id: フォームタイプが最初に作成されたDataZoneドメインの識別子
#
# - origin_project_id: フォームタイプが最初に作成されたプロジェクトの識別子
#
# - revision: フォームタイプのリビジョン番号（1〜64文字）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# aws_datazone_form_typeを使用するには、事前に以下のリソースが必要です:
#
# 1. DataZone Domain
# resource "aws_datazone_domain" "example" {
#---------------------------------------------------------------
