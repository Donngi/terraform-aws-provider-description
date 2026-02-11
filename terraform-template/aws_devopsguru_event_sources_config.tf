#---------------------------------------------------------------
# AWS DevOps Guru Event Sources Config
#---------------------------------------------------------------
#
# AWS DevOps Guruのイベントソース設定をプロビジョニングするリソースです。
# 現在、DevOps Guruと統合できるサービスはAmazon CodeGuru Profilerのみです。
# CodeGuru Profilerはプロアクティブな推奨事項を生成し、DevOps Guruに保存・表示できます。
#
# AWS公式ドキュメント:
#   - DevOps Guru概要: https://docs.aws.amazon.com/devops-guru/latest/userguide/welcome.html
#   - CodeGuru Profiler統合: https://docs.aws.amazon.com/codeguru/latest/profiler-ug/what-is-codeguru-profiler.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devopsguru_event_sources_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 注意:
#   - このリソースを削除すると、CodeGuru Profilerのステータスが「DISABLED」に設定されます。
#     「ENABLED」設定を保持したままTerraformリソースを削除したい場合は、
#     removedブロック（Terraform 1.7以降）を使用してください。
#   - イベントソースはアカウントレベルで設定されます。
#     永続的な差分を避けるため、このリソースは1回だけ定義してください。
#
#---------------------------------------------------------------

resource "aws_devopsguru_event_sources_config" "example" {
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
  # イベントソース設定
  #-------------------------------------------------------------

  # event_sources (Required)
  # 設定内容: DevOps GuruがEventBridge経由で他のAWSサービスと統合するための設定情報です。
  # 注意: このブロックは必須です
  event_sources {

    # amazon_code_guru_profiler (Required)
    # 設定内容: DevOps GuruがAWS CodeGuru Profilerから生成された推奨事項を
    #          消費するかどうかの設定を格納します。
    amazon_code_guru_profiler {

      # status (Required)
      # 設定内容: CodeGuru Profiler統合のステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": CodeGuru Profilerからの推奨事項をDevOps Guruで受信する
      #   - "DISABLED": CodeGuru Profilerからの推奨事項を受信しない
      # 関連機能: CodeGuru Profilerはアプリケーションのパフォーマンスを分析し、
      #          プロアクティブな推奨事項を生成します。DevOps Guruでこれらの
      #          推奨事項を一元的に確認・管理できます。
      status = "ENABLED"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSリージョン
#       注意: この属性は非推奨（deprecated）です
#
#---------------------------------------------------------------
