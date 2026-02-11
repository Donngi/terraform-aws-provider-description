#---------------------------------------------------------------
# AWS CloudWatch Synthetics Canary
#---------------------------------------------------------------
#
# Amazon CloudWatch Syntheticsのカナリアをプロビジョニングするリソースです。
# カナリアは、エンドポイントやAPIの可用性・レイテンシーを継続的に監視する
# スクリプトベースのモニターです。実際のユーザーと同じアクションを実行し、
# 問題を早期に検出します。
#
# NOTE: カナリア作成時、AWSは暗黙的にサポートリソース（Lambda関数等）を作成します。
#       カナリア削除時、これらの暗黙的リソースは自動削除されません。
#       削除前にDeleteCanaryのドキュメントを参照してください。
#
# AWS公式ドキュメント:
#   - CloudWatch Synthetics概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries.html
#   - Synthetics API Reference (DeleteCanary): https://docs.aws.amazon.com/AmazonSynthetics/latest/APIReference/API_DeleteCanary.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_synthetics_canary" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: カナリアの名前を指定します。
  # 設定可能な値: 最大255文字。小文字英数字、ハイフン、アンダースコアが使用可能
  name = "my-canary"

  # handler (Required)
  # 設定内容: カナリア実行時のエントリポイントを指定します。
  # 設定可能な値: ".handler" で終わる文字列（例: "exports.handler", "mycanary.handler"）
  handler = "exports.handler"

  # runtime_version (Required)
  # 設定内容: カナリアで使用するランタイムバージョンを指定します。
  # 設定可能な値: syn-python-selenium-1.0, syn-nodejs-puppeteer-3.0, syn-nodejs-2.2 等
  # 注意: バージョンは頻繁に更新されるため、最新の有効なバージョンはAWS公式ドキュメントを参照してください。
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_Library.html
  runtime_version = "syn-nodejs-puppeteer-3.0"

  # execution_role_arn (Required)
  # 設定内容: カナリアの実行に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 参考: https://docs.aws.amazon.com/AmazonSynthetics/latest/APIReference/API_CreateCanary.html#API_CreateCanary_RequestSyntax
  execution_role_arn = "arn:aws:iam::123456789012:role/my-canary-execution-role"

  #-------------------------------------------------------------
  # スクリプトソース設定
  #-------------------------------------------------------------

  # zip_file (Optional)
  # 設定内容: カナリアスクリプトを直接含むZIPファイルのパスを指定します。
  # 設定可能な値: 最大225KBのZIPファイルパス
  # 注意: s3_bucket, s3_key, s3_versionと排他的（どちらか一方のみ指定可能）
  zip_file = "canary-script.zip"

  # s3_bucket (Optional)
  # 設定内容: カナリアスクリプトが配置されているS3バケット名を指定します。
  # 設定可能な値: 既存のS3バケット名
  # 注意: zip_fileと排他的
  s3_bucket = null

  # s3_key (Optional)
  # 設定内容: カナリアスクリプトのS3キーを指定します。
  # 設定可能な値: S3オブジェクトキー
  # 注意: zip_fileと排他的
  s3_key = null

  # s3_version (Optional)
  # 設定内容: カナリアスクリプトのS3バージョンIDを指定します。
  # 設定可能な値: S3オブジェクトバージョンID
  # 注意: zip_fileと排他的
  s3_version = null

  #-------------------------------------------------------------
  # アーティファクト設定
  #-------------------------------------------------------------

  # artifact_s3_location (Required)
  # 設定内容: カナリアのテスト実行アーティファクトを保存するS3の場所を指定します。
  # 設定可能な値: S3ロケーション（例: "s3://my-bucket/canary-artifacts/"）
  artifact_s3_location = "s3://my-canary-artifacts-bucket/"

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule (Required)
  # 設定内容: カナリアの実行スケジュールを設定するブロックです。
  schedule {
    # expression (Required)
    # 設定内容: カナリアの実行頻度をrate式またはcron式で指定します。
    # 設定可能な値:
    #   - rate式: rate(数値 単位) - 単位はminute, minutes, hour
    #   - cron式: cron(式) - 標準のcron式構文
    # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_cron.html
    expression = "rate(5 minutes)"

    # duration_in_seconds (Optional)
    # 設定内容: スケジュールに従ってカナリアが実行を継続する期間（秒）を指定します。
    # 設定可能な値: 正の整数（秒数）
    # 省略時: 無期限に実行を継続
    duration_in_seconds = null

    # retry_config (Optional)
    # 設定内容: カナリア実行失敗時のリトライ設定を行うブロックです。
    retry_config {
      # max_retries (Required)
      # 設定内容: 最大リトライ回数を指定します。
      # 設定可能な値: 0〜2
      # 注意: max_retriesが2の場合、run_config.timeout_in_secondsは600秒未満にする必要があります。
      max_retries = 0
    }
  }

  #-------------------------------------------------------------
  # 実行設定
  #-------------------------------------------------------------

  # run_config (Optional)
  # 設定内容: カナリアの個別実行に関する設定ブロックです。
  run_config {
    # timeout_in_seconds (Optional)
    # 設定内容: カナリアの実行タイムアウト（秒）を指定します。
    # 設定可能な値: 正の整数
    # 省略時: カナリアの実行頻度に基づき設定（最大840秒 = 14分）
    timeout_in_seconds = 60

    # memory_in_mb (Optional)
    # 設定内容: カナリア実行時に利用可能な最大メモリ量（MB）を指定します。
    # 設定可能な値: 64の倍数
    # 省略時: デフォルト値が適用
    memory_in_mb = 960

    # ephemeral_storage (Optional)
    # 設定内容: カナリア実行時のエフェメラルストレージ容量（MB）を指定します。
    # 設定可能な値: 正の整数（MB）
    # 省略時: 1024
    ephemeral_storage = 1024

    # active_tracing (Optional)
    # 設定内容: AWS X-Rayのアクティブトレースを有効にするかを指定します。
    # 設定可能な値:
    #   - true: X-Rayトレースを有効化
    #   - false: X-Rayトレースを無効化
    # 注意: syn-nodejs-2.0以降のランタイムバージョンでのみ有効
    active_tracing = false

    # environment_variables (Optional)
    # 設定内容: カナリア実行時にアクセス可能な環境変数のマップを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 注意: Lambdaの予約済み環境変数は使用不可
    # 参考: https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html#configuration-envvars-runtime
    environment_variables = null
  }

  #-------------------------------------------------------------
  # 保持期間設定
  #-------------------------------------------------------------

  # success_retention_period (Optional)
  # 設定内容: 成功した実行データの保持日数を指定します。
  # 設定可能な値: 1〜455（日）
  # 省略時: 31日
  success_retention_period = 31

  # failure_retention_period (Optional)
  # 設定内容: 失敗した実行データの保持日数を指定します。
  # 設定可能な値: 1〜455（日）
  # 省略時: 31日
  failure_retention_period = 31

  #-------------------------------------------------------------
  # アーティファクト暗号化設定
  #-------------------------------------------------------------

  # artifact_config (Optional)
  # 設定内容: カナリアがS3にアップロードするアーティファクトの暗号化設定ブロックです。
  artifact_config {
    # s3_encryption (Optional)
    # 設定内容: S3アーティファクトの暗号化設定を行うブロックです。
    s3_encryption {
      # encryption_mode (Optional)
      # 設定内容: アーティファクトの暗号化方式を指定します。
      # 設定可能な値:
      #   - "SSE_S3": Amazon S3管理キーによるサーバーサイド暗号化
      #   - "SSE_KMS": AWS KMS管理キーによるサーバーサイド暗号化
      encryption_mode = "SSE_S3"

      # kms_key_arn (Optional)
      # 設定内容: SSE_KMS暗号化で使用するカスタマー管理KMSキーのARNを指定します。
      # 設定可能な値: 有効なKMSキーARN
      # 注意: encryption_modeが"SSE_KMS"の場合にのみ使用
      kms_key_arn = null
    }
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Optional)
  # 設定内容: カナリアをVPC内で実行するための設定ブロックです。
  vpc_config {
    # subnet_ids (Required within vpc_config)
    # 設定内容: カナリアを実行するサブネットのIDを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # security_group_ids (Required within vpc_config)
    # 設定内容: カナリアに適用するセキュリティグループのIDを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    security_group_ids = ["sg-12345678"]

    # ipv6_allowed_for_dual_stack (Optional)
    # 設定内容: デュアルスタックサブネットに接続されたVPCカナリアでIPv6アウトバウンドトラフィックを許可するかを指定します。
    # 設定可能な値:
    #   - true: IPv6アウトバウンドトラフィックを許可
    #   - false (デフォルト): IPv6アウトバウンドトラフィックを不許可
    ipv6_allowed_for_dual_stack = false
  }

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # start_canary (Optional)
  # 設定内容: カナリアを作成後に実行開始するかを指定します。
  # 設定可能な値:
  #   - true: カナリアを実行開始
  #   - false: カナリアを停止状態で作成
  start_canary = false

  # delete_lambda (Optional)
  # 設定内容: カナリア削除時にカナリアが使用するLambda関数とレイヤーも削除するかを指定します。
  # 設定可能な値:
  #   - true: Lambda関数とレイヤーも削除
  #   - false (デフォルト): Lambda関数とレイヤーを残す
  delete_lambda = false

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
  tags = {
    Name        = "my-canary"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カナリアのAmazon Resource Name (ARN)
#
# - engine_arn: カナリアエンジンとして使用されるLambda関数のARN
#
# - id: カナリアの名前
#
# - source_location_arn: Syntheticsがカナリアスクリプトコードを格納する
#                        Lambdaレイヤーの ARN
#
# - status: カナリアのステータス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - timeline: カナリアの作成日時、変更日時、最終実行日時を含む構造体
#   - created: カナリアの作成日時
#   - last_modified: カナリアの最終変更日時
#   - last_started: カナリアの最終実行開始日時
#   - last_stopped: カナリアの最終実行終了日時
#
# - vpc_config.vpc_id: カナリアが実行されるVPCのID
#---------------------------------------------------------------
