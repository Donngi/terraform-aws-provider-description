#---------------------------------------------------------------
# AWS Bedrock Custom Model
#---------------------------------------------------------------
#
# Amazon Bedrockのカスタムモデルをプロビジョニングするリソースです。
# モデルカスタマイズは、特定のユースケースのパフォーマンスを向上させるために
# 基盤モデルにトレーニングデータを提供するプロセスです。
#
# このリソースは2つのAmazon Bedrockエンティティと対話します:
#   1. Continued Pre-training または Fine-tuning ジョブ（リソース作成時に開始）
#   2. カスタマイズジョブ完了時に出力されるカスタムモデル
#
# AWS公式ドキュメント:
#   - Bedrock Custom Models: https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html
#   - Hyperparameters: https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models-hp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_custom_model
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrock_custom_model" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # custom_model_name (Required)
  # 設定内容: カスタムモデルの名前を指定します。
  # 設定可能な値: 文字列
  custom_model_name = "my-custom-model"

  # job_name (Required)
  # 設定内容: カスタマイズジョブの名前を指定します。
  # 設定可能な値: 文字列
  job_name = "my-customization-job"

  # base_model_identifier (Required)
  # 設定内容: 基盤モデルのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なBedrock基盤モデルのARN
  # 例: "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-text-express-v1"
  base_model_identifier = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-text-express-v1"

  # role_arn (Required)
  # 設定内容: Bedrockがタスクを実行するために引き受けることができるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールにはS3バケットへのアクセス権限とBedrock操作の権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/BedrockCustomModelRole"

  # hyperparameters (Required)
  # 設定内容: モデルのチューニングに関連するパラメータを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 主なパラメータ:
  #   - epochCount: トレーニングエポック数
  #   - batchSize: バッチサイズ
  #   - learningRate: 学習率
  #   - learningRateWarmupSteps: 学習率ウォームアップステップ数
  # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models-hp.html
  hyperparameters = {
    "epochCount"              = "1"
    "batchSize"               = "1"
    "learningRate"            = "0.005"
    "learningRateWarmupSteps" = "0"
  }

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
  # カスタマイズタイプ設定
  #-------------------------------------------------------------

  # customization_type (Optional)
  # 設定内容: カスタマイズのタイプを指定します。
  # 設定可能な値:
  #   - "FINE_TUNING": ファインチューニング。ラベル付きデータを使用してモデルを特定のタスクに適応させる
  #   - "CONTINUED_PRE_TRAINING": 継続事前トレーニング。追加の未ラベルデータでモデルをさらにトレーニング
  # 省略時: ベースモデルに基づいてデフォルト値が設定されます
  customization_type = "FINE_TUNING"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # custom_model_kms_key_id (Optional)
  # 設定内容: カスタムモデルを暗号化するためのKMSキーARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 関連機能: AWS KMS暗号化
  #   カスタムモデルは保管時にこのキーを使用して暗号化されます。
  custom_model_kms_key_id = null

  #-------------------------------------------------------------
  # データ設定
  #-------------------------------------------------------------

  # output_data_config (Required)
  # 設定内容: 出力データのS3ロケーションを指定します。
  output_data_config {
    # s3_uri (Required)
    # 設定内容: 出力データを保存するS3 URIを指定します。
    # 設定可能な値: 有効なS3 URI（例: "s3://bucket-name/output/"）
    s3_uri = "s3://my-bucket/output/"
  }

  # training_data_config (Required)
  # 設定内容: トレーニングデータセットに関する情報を指定します。
  training_data_config {
    # s3_uri (Required)
    # 設定内容: トレーニングデータを保存するS3 URIを指定します。
    # 設定可能な値: 有効なS3 URI（例: "s3://bucket-name/training/train.jsonl"）
    s3_uri = "s3://my-bucket/training/train.jsonl"
  }

  # validation_data_config (Optional)
  # 設定内容: 検証データセットに関する情報を指定します。
  validation_data_config {
    # validator (Required within validation_data_config)
    # 設定内容: バリデーターに関する情報を指定します。
    validator {
      # s3_uri (Required)
      # 設定内容: 検証データを保存するS3 URIを指定します。
      # 設定可能な値: 有効なS3 URI
      s3_uri = "s3://my-bucket/validation/validation.jsonl"
    }
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Optional)
  # 設定内容: このジョブで使用するリソースを含むプライベートVPCの設定パラメータを指定します。
  # 関連機能: VPCでのBedrockカスタムモデルジョブ
  #   VPC内でカスタマイズジョブを実行することで、ネットワークセキュリティを強化できます。
  vpc_config {
    # security_group_ids (Required within vpc_config)
    # 設定内容: VPC設定のセキュリティグループIDを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    security_group_ids = ["sg-12345678"]

    # subnet_ids (Required within vpc_config)
    # 設定内容: VPC設定のサブネットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    subnet_ids = ["subnet-12345678", "subnet-87654321"]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: カスタマイズジョブとカスタムモデルに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-custom-model"
    Environment = "development"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 注意: カスタマイズジョブはトレーニングデータのサイズとハイパーパラメータに
    #       依存して数時間かかることがあります。
    create = "24h"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - custom_model_arn: 出力モデルのARN
#
# - job_arn: カスタマイズジョブのARN
#
# - job_status: カスタマイズジョブのステータス。
#               正常なジョブは出力モデルが使用可能になると
#               InProgress から Completed に遷移します。
#
# - training_metrics: カスタマイズジョブに関連するメトリクス
#     - training_loss: カスタマイズジョブに関連する損失メトリクス
#
# - validation_metrics: 提供した各バリデーターの損失メトリクス
#     - validation_loss: バリデーターに関連する検証損失
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
