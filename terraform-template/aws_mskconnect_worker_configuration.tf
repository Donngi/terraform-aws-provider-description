#---------------------------------------------------------------
# AWS MSK Connect Worker Configuration
#---------------------------------------------------------------
#
# Amazon MSK Connectのワーカー構成（Worker Configuration）を作成します。
# ワーカーはコネクタのロジックを実行するJava仮想マシン（JVM）プロセスです。
# ワーカー構成では、key.converterやvalue.converterなどの
# Apache Kafka Connectの設定プロパティを定義できます。
#
# AWS公式ドキュメント:
#   - MSK Connect Workers: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-workers.html
#   - カスタムワーカー構成の作成: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-create-custom-worker-config.html
#   - サポートされるワーカー構成プロパティ: https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-supported-worker-config-properties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_worker_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mskconnect_worker_configuration" "this" {
  #---------------------------------------------------------------
  # 必須引数（Required Arguments）
  #---------------------------------------------------------------

  # name (Required, Forces new resource)
  # ワーカー構成の名前
  # - 一意の識別名を指定
  # - 作成後の変更は新しいリソースの作成が必要（Forces new resource）
  name = "example-worker-configuration"

  # properties_file_content (Required, Forces new resource)
  # connect-distributed.propertiesファイルの内容
  # - Base64エンコードまたは生の形式で指定可能
  # - key.converterとvalue.converterは必須プロパティ
  # - 作成後の変更は新しいリソースの作成が必要（Forces new resource）
  #
  # サポートされるプロパティ:
  #   - key.converter: キーのシリアライズ/デシリアライズ形式
  #   - value.converter: 値のシリアライズ/デシリアライズ形式
  #   - producer.*: プロデューサー設定プロパティ
  #   - consumer.*: コンシューマー設定プロパティ
  #
  # 一般的なコンバーター:
  #   - org.apache.kafka.connect.storage.StringConverter
  #   - org.apache.kafka.connect.json.JsonConverter
  #   - io.confluent.connect.avro.AvroConverter
  properties_file_content = <<EOT
key.converter=org.apache.kafka.connect.storage.StringConverter
value.converter=org.apache.kafka.connect.storage.StringConverter
EOT

  #---------------------------------------------------------------
  # オプション引数（Optional Arguments）
  #---------------------------------------------------------------

  # description (Optional, Forces new resource)
  # ワーカー構成の説明
  # - 用途や設定内容を記述
  # - 作成後の変更は新しいリソースの作成が必要（Forces new resource）
  description = "Example worker configuration for MSK Connect"

  # region (Optional)
  # このリソースを管理するAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンが使用される
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (Optional)
  # リソースに割り当てるタグのマップ
  # - プロバイダーレベルのdefault_tagsと組み合わせて使用可能
  # - 同じキーのタグはこちらが優先される
  tags = {
    Name        = "example-worker-configuration"
    Environment = "development"
  }

  #---------------------------------------------------------------
  # timeoutsブロック（Optional）
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定
  # - deleteのみ設定可能

  # timeouts {
  #   # delete (Optional)
  #   # 削除操作のタイムアウト時間
  #   # - 形式: "10m"（10分）、"1h"（1時間）など
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です。
#
# arn
#   ワーカー構成のAmazon Resource Name (ARN)
#   例: "arn:aws:kafkaconnect:ap-northeast-1:123456789012:worker-configuration/example/abc123"
#
# id
#   リソースの識別子（ARNと同じ値）
#
# latest_revision
#   ワーカー構成の最新リビジョンID
#   - 正常に作成されたリビジョンのIDが設定される
#
# tags_all
#   プロバイダーのdefault_tagsとリソースのtagsを統合した全タグのマップ
#---------------------------------------------------------------
