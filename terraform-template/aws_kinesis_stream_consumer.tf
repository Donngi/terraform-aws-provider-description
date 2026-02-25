#---------------------------------------------------------------
# Amazon Kinesis Data Streams コンシューマー
#---------------------------------------------------------------
#
# Amazon Kinesis Data Streams の拡張ファンアウトコンシューマーを登録するリソースです。
# 拡張ファンアウトは各コンシューマーが専用スループット（最大2MB/秒/シャード）で
# データを受信できる機能です。通常のGetRecords APIとは異なり、
# SubscribeToShard APIを使用してプッシュ型のストリーミングを実現します。
#
# AWS公式ドキュメント:
#   - 拡張ファンアウト: https://docs.aws.amazon.com/streams/latest/dev/enhanced-fan-out.html
#   - コンシューマーの管理: https://docs.aws.amazon.com/streams/latest/dev/building-enhanced-consumers-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream_consumer
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_stream_consumer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コンシューマーの名前を指定します。
  # 設定可能な値: 最大128文字の英数字、ハイフン、アンダースコア、ピリオド
  # 注意: 同一ストリームに登録できるコンシューマーは最大20個です
  name = "example-consumer"

  # stream_arn (Required)
  # 設定内容: コンシューマーを登録するKinesis Data StreamsストリームのARNを指定します。
  # 設定可能な値: 有効なKinesis StreamのARN（arn:aws:kinesis:<region>:<account>:stream/<name>）
  stream_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/example-stream"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #           一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-consumer"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンシューマーを識別するARN
#
# - creation_timestamp: コンシューマーが作成された日時（ISO 8601形式）
#
# - id: コンシューマーのARN（arn と同じ値）
#
# - name: コンシューマーの名前
#
# - stream_arn: コンシューマーが登録されているストリームのARN
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
