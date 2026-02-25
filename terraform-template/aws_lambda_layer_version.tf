#---------------------------------------------------------------
# AWS Lambda Layer Version
#---------------------------------------------------------------
#
# AWS Lambda Layerのバージョンをプロビジョニングするリソースです。
# Lambda Layerを使用することで、複数のLambda関数間でコードや依存関係を
# 共有することができます。レイヤーにはライブラリ、カスタムランタイム、
# データ、設定ファイルなどを含めることができます。
#
# AWS公式ドキュメント:
#   - Lambda Layers: https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_layer_version" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # layer_name (Required)
  # 設定内容: Lambda Layerの一意な名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  layer_name = "my-lambda-layer"

  # description (Optional)
  # 設定内容: Lambda Layerの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Shared utilities and dependencies for Lambda functions"

  # license_info (Optional)
  # 設定内容: Lambda Layerのライセンス情報を指定します。
  # 設定可能な値: SPDX識別子または任意のライセンス文字列（例: "MIT", "Apache-2.0"）
  # 省略時: ライセンス情報なし
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/API_PublishLayerVersion.html#SSS-PublishLayerVersion-request-LicenseInfo
  license_info = "MIT"

  #-------------------------------------------------------------
  # ランタイム互換性設定
  #-------------------------------------------------------------

  # compatible_runtimes (Optional)
  # 設定内容: このレイヤーが対応するランタイムのリストを指定します。
  # 設定可能な値: 最大15個のランタイム識別子のリスト
  #   例: "nodejs20.x", "nodejs18.x", "python3.12", "python3.11",
  #       "java21", "java17", "dotnet8", "ruby3.3" 等
  # 省略時: 互換ランタイムを限定しない
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/API_PublishLayerVersion.html#SSS-PublishLayerVersion-request-CompatibleRuntimes
  compatible_runtimes = ["nodejs20.x", "nodejs18.x"]

  # compatible_architectures (Optional)
  # 設定内容: このレイヤーが対応するアーキテクチャのリストを指定します。
  # 設定可能な値:
  #   - "x86_64": x86 64ビットアーキテクチャ
  #   - "arm64": ARM 64ビットアーキテクチャ（Graviton2）
  # 省略時: 互換アーキテクチャを限定しない
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/API_PublishLayerVersion.html#SSS-PublishLayerVersion-request-CompatibleArchitectures
  compatible_architectures = ["x86_64", "arm64"]

  #-------------------------------------------------------------
  # コードソース設定（ローカルファイル）
  #-------------------------------------------------------------

  # filename (Optional)
  # 設定内容: レイヤーのデプロイパッケージ（.zipファイル）のローカルファイルパスを指定します。
  # 設定可能な値: 有効なローカルファイルパス（.zipファイル）
  # 省略時: s3_bucket/s3_key を使用してS3からコードを取得
  # 注意: s3_bucket, s3_key, s3_object_version と排他的（同時指定不可）
  filename = "lambda_layer_payload.zip"

  #-------------------------------------------------------------
  # コードソース設定（S3）
  #-------------------------------------------------------------

  # s3_bucket (Optional)
  # 設定内容: レイヤーのデプロイパッケージを格納するS3バケット名を指定します。
  # 設定可能な値: 有効なS3バケット名
  # 省略時: filename でローカルファイルを使用
  # 注意: filename と排他的（同時指定不可）。Lambda関数と同じリージョンのバケットを指定すること
  s3_bucket = null

  # s3_key (Optional)
  # 設定内容: デプロイパッケージを格納するS3オブジェクトのキーを指定します。
  # 設定可能な値: 有効なS3オブジェクトキー（.zipファイル）
  # 省略時: filename でローカルファイルを使用
  # 注意: filename と排他的（同時指定不可）
  s3_key = null

  # s3_object_version (Optional)
  # 設定内容: デプロイパッケージを格納するS3オブジェクトのバージョンIDを指定します。
  # 設定可能な値: 有効なS3オブジェクトバージョンID
  # 省略時: S3バケットの最新バージョンのオブジェクトを使用
  # 注意: filename と排他的（同時指定不可）
  s3_object_version = null

  #-------------------------------------------------------------
  # コードハッシュ設定
  #-------------------------------------------------------------

  # source_code_hash (Optional)
  # 設定内容: ソースコード変更時にリプレースメントをトリガーするための仮想属性です。
  #           filename または s3_key で指定されるパッケージファイルの
  #           Base64エンコードされたSHA-256ハッシュを設定します。
  # 設定可能な値: Base64エンコードされたSHA-256ハッシュ文字列
  #   例: filebase64sha256("lambda_layer_payload.zip") を使用
  # 省略時: ソースコードの変更が自動検出されない
  source_code_hash = filebase64sha256("lambda_layer_payload.zip")

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: 以前にデプロイしたLambda Layerの古いバージョンを保持するかを指定します。
  # 設定可能な値:
  #   - true: terraform destroy 時にレイヤーバージョンを削除せず、Terraform stateからのみ削除
  #   - false (デフォルト): terraform destroy 時にレイヤーバージョンを削除
  # 省略時: false（destroy時にレイヤーバージョンを削除）
  # 注意: true に設定すると、compatible_architectures, compatible_runtimes, description,
  #       filename, layer_name, license_info, s3_bucket, s3_key, s3_object_version,
  #       source_code_hash のいずれかを変更しても既存バージョンは削除されず、
  #       Terraformが管理しない意図的なダングリングリソースが残ります。
  skip_destroy = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: バージョン番号を含むLambda LayerのARN
# - code_sha256: .zipファイルの生のSHA-256サムのBase64エンコード表現
# - created_date: このリソースが作成された日時
# - layer_arn: バージョン番号を含まないLambda LayerのARN
# - signing_job_arn: コード署名ジョブのARN
# - signing_profile_version_arn: 署名プロファイルバージョンのARN
# - source_code_size: 関数の.zipファイルのサイズ（バイト単位）
# - version: Lambda Layerのバージョン番号
#---------------------------------------------------------------
