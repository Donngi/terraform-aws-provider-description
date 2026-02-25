#---------------------------------------------------------------
# Amazon MSK Connect カスタムプラグイン
#---------------------------------------------------------------
#
# Amazon MSK Connect のカスタムプラグインを管理するリソースです。
# カスタムプラグインは、S3 に保存された JAR ファイルや ZIP ファイルを
# ソースとして MSK Connect コネクターで利用するカスタムコネクターや
# トランスフォーマーを定義します。
#
# AWS公式ドキュメント:
#   - MSK Connect とは: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect.html
#   - カスタムプラグイン: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-plugins.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_custom_plugin
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mskconnect_custom_plugin" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: カスタムプラグインの名前を指定します。
  # 設定可能な値: 1〜128文字の英数字、ハイフン、アンダースコア
  name = "example-mskconnect-custom-plugin"

  # content_type (Required)
  # 設定内容: プラグインファイルのコンテンツタイプを指定します。
  # 設定可能な値:
  #   - "JAR": 単一の JAR ファイル
  #   - "ZIP": 複数の JAR ファイルを含む ZIP アーカイブ
  content_type = "JAR"

  # description (Optional)
  # 設定内容: カスタムプラグインの説明を指定します。
  # 設定可能な値: 任意の文字列（最大 1024 文字）
  # 省略時: 説明なし
  description = "Example MSK Connect custom plugin"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-mskconnect-custom-plugin"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # プラグインファイルの場所設定
  #-------------------------------------------------------------

  # location (Required)
  # 設定内容: プラグインファイルの場所を指定するブロックです。
  # 注意: このブロックは必須です。現時点では S3 のみがサポートされています。
  location {
    # s3 (Required)
    # 設定内容: S3 上のプラグインファイルの場所を指定するブロックです。
    s3 {
      # bucket_arn (Required)
      # 設定内容: プラグインファイルが格納された S3 バケットの ARN を指定します。
      # 設定可能な値: 有効な S3 バケットの ARN
      bucket_arn = "arn:aws:s3:::example-mskconnect-plugins-bucket"

      # file_key (Required)
      # 設定内容: S3 バケット内のプラグインファイルのオブジェクトキーを指定します。
      # 設定可能な値: 有効な S3 オブジェクトキー（例: "plugins/my-connector-1.0.0.jar"）
      file_key = "plugins/my-connector-1.0.0.jar"

      # object_version (Optional)
      # 設定内容: S3 オブジェクトのバージョン ID を指定します。
      # 設定可能な値: 有効な S3 オブジェクトバージョン ID
      # 省略時: 最新バージョンのオブジェクトを使用
      # 注意: バージョニングが有効な S3 バケットを使用する場合、
      #       特定バージョンを固定することでプラグインの不変性を確保できます
      object_version = null
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 注意: カスタムプラグインの作成・削除には数分かかる場合があります
  timeouts {
    # create (Optional)
    # 設定内容: カスタムプラグインの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "10m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    create = "10m"

    # delete (Optional)
    # 設定内容: カスタムプラグインの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の時間パース形式（例: "10m", "1h"）
    # 省略時: Terraform のデフォルトタイムアウトを使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタムプラグインの ARN
# - id: カスタムプラグインの ARN（arn と同じ値）
# - latest_revision: カスタムプラグインの最新リビジョン番号
# - state: カスタムプラグインの現在の状態
#          （CREATING, CREATE_FAILED, ACTIVE, UPDATING, UPDATE_FAILED, DELETING）
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
