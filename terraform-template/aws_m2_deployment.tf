#---------------------------------------------------------------
# AWS Mainframe Modernization Deployment
#---------------------------------------------------------------
#
# AWS Mainframe Modernization (M2) のアプリケーションデプロイメントを管理するリソースです。
# M2環境にアプリケーションの特定バージョンをデプロイし、起動状態を制御します。
# デプロイメントを更新することでアプリケーションバージョンのロールアウトが可能です。
#
# AWS公式ドキュメント:
#   - AWS Mainframe Modernization とは: https://docs.aws.amazon.com/m2/latest/userguide/what-is-m2.html
#   - アプリケーションのデプロイ: https://docs.aws.amazon.com/m2/latest/userguide/applications-m2-deploy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/m2_deployment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_m2_deployment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: デプロイ対象のM2アプリケーションIDを指定します。
  # 設定可能な値: 有効なM2アプリケーションID文字列
  application_id = "example-application-id"

  # application_version (Required)
  # 設定内容: デプロイするアプリケーションのバージョン番号を指定します。
  # 設定可能な値: 正の整数（アプリケーションに存在するバージョン番号）
  application_version = 1

  # environment_id (Required)
  # 設定内容: アプリケーションをデプロイするM2環境のIDを指定します。
  # 設定可能な値: 有効なM2環境ID文字列
  environment_id = "example-environment-id"

  # start (Required)
  # 設定内容: デプロイ後にアプリケーションを起動するかを指定します。
  # 設定可能な値:
  #   - true: デプロイ後にアプリケーションを起動する
  #   - false: デプロイのみ行い起動はしない
  start = true

  #-------------------------------------------------------------
  # 停止設定
  #-------------------------------------------------------------

  # force_stop (Optional)
  # 設定内容: アプリケーションを強制停止するかを指定します。
  #           デプロイメントの更新・削除時に実行中のアプリケーションを強制的に停止します。
  # 設定可能な値:
  #   - true: 強制停止を有効にする
  #   - false: 通常の停止手順を使用する
  # 省略時: false
  force_stop = false

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraform操作のタイムアウト時間の設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" 等のGo duration文字列（s, m, h が使用可能）
    # 省略時: プロバイダーデフォルト
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" 等のGo duration文字列（s, m, h が使用可能）
    # 省略時: プロバイダーデフォルト
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" 等のGo duration文字列（s, m, h が使用可能）
    # 省略時: プロバイダーデフォルト
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースID（application_id と deployment_id のコンマ区切り文字列）
# - deployment_id: M2デプロイメントの一意なID
#---------------------------------------------------------------
