#---------------------------------------------------------------
# AWS MSK Connect Custom Plugin
#---------------------------------------------------------------
#
# Amazon MSK Connect のカスタムプラグインをプロビジョニングする。
#
# カスタムプラグインは、コネクタのロジックを定義するコードを含むAWSリソース。
# JAR ファイルまたは ZIP ファイルを S3 バケットにアップロードし、
# その場所を指定してプラグインを作成する。1つのプラグインから
# 複数のコネクタを作成できる（1対多の関係）。
#
# AWS公式ドキュメント:
#   - Create custom plugins: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-plugins.html
#   - MSK Connect API - CreateCustomPlugin: https://docs.aws.amazon.com/MSKC/latest/mskc/API_CreateCustomPlugin.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_custom_plugin
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mskconnect_custom_plugin" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # name - (Required, Forces new resource)
  # カスタムプラグインの名前。
  # リソース作成後の変更は新しいリソースの再作成が必要。
  name = "example-plugin"

  # content_type - (Required, Forces new resource)
  # プラグインファイルのタイプ。
  # 許可される値:
  #   - "ZIP" : ZIPアーカイブ（複数のJARファイルを含む場合に使用）
  #   - "JAR" : 単一のJARファイル
  # リソース作成後の変更は新しいリソースの再作成が必要。
  content_type = "ZIP"

  # location - (Required, Forces new resource)
  # カスタムプラグインの場所に関する情報。
  # S3バケットに格納されたプラグインファイルの場所を指定する。
  # リソース作成後の変更は新しいリソースの再作成が必要。
  location {
    # s3 - (Required, Forces new resource)
    # Amazon S3 に格納されているプラグインファイルの情報。
    s3 {
      # bucket_arn - (Required, Forces new resource)
      # プラグインファイルが格納されている S3 バケットの ARN。
      # 例: "arn:aws:s3:::my-plugin-bucket"
      bucket_arn = "arn:aws:s3:::example-bucket"

      # file_key - (Required, Forces new resource)
      # S3 バケット内のオブジェクトのファイルキー。
      # JAR または ZIP ファイルへのパスを指定する。
      # 例: "plugins/debezium-connector.zip"
      file_key = "plugins/example-plugin.zip"

      # object_version - (Optional, Forces new resource)
      # S3 バケット内のオブジェクトのバージョン。
      # S3 バージョニングが有効な場合に特定のバージョンを指定できる。
      # 指定しない場合は最新バージョンが使用される。
      # リソース作成後の変更は新しいリソースの再作成が必要。
      # object_version = "abc123def456"
    }
  }

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description - (Optional, Forces new resource)
  # カスタムプラグインの概要説明。
  # プラグインの用途や機能を記述する。
  # リソース作成後の変更は新しいリソースの再作成が必要。
  # description = "Debezium connector plugin for MySQL CDC"

  # region - (Optional)
  # このリソースを管理する AWS リージョン。
  # 指定しない場合は、プロバイダー設定のリージョンが使用される。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags - (Optional)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーのタグはこちらで定義された値で上書きされる。
  # tags = {
  #   Environment = "production"
  #   Project     = "data-pipeline"
  # }

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------

  # timeouts - (Optional)
  # リソース操作のタイムアウト設定。
  # カスタムプラグインの作成・削除には時間がかかる場合があるため、
  # 必要に応じてタイムアウト値を調整する。
  # timeouts {
  #   # create - (Optional)
  #   # リソース作成時のタイムアウト。
  #   # 形式: "60m"（60分）、"1h"（1時間）など。
  #   # デフォルト値はプロバイダーによって設定される。
  #   create = "10m"
  #
  #   # delete - (Optional)
  #   # リソース削除時のタイムアウト。
  #   # 形式: "60m"（60分）、"1h"（1時間）など。
  #   # デフォルト値はプロバイダーによって設定される。
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能（Terraform設定では指定不可）:
#
# arn - カスタムプラグインの Amazon Resource Name (ARN)。
#       例: "arn:aws:kafkaconnect:ap-northeast-1:123456789012:custom-plugin/example-plugin/abc123"
#       コネクタ作成時にこの ARN を指定してプラグインを参照する。
#
# latest_revision - カスタムプラグインの最新リビジョン番号。
#                   正常に作成されたリビジョンの ID を示す数値。
#
# state - カスタムプラグインの状態。
#         "CREATING" : 作成中
#         "CREATE_FAILED" : 作成失敗
#         "ACTIVE" : アクティブ（使用可能）
#         "UPDATING" : 更新中
#         "UPDATE_FAILED" : 更新失敗
#         "DELETING" : 削除中
#
# tags_all - プロバイダーの default_tags で設定されたタグを含む、
#            リソースに割り当てられた全タグのマップ。
#---------------------------------------------------------------
