#---------------------------------------------------------------
# AWS Location Tracker
#---------------------------------------------------------------
#
# Amazon Location Serviceのトラッカーリソースを作成する。
# トラッカーは、モバイルデバイスやIoTデバイスなどの位置情報を
# 受信・保存し、リアルタイムでデバイスの位置を追跡するために使用する。
#
# AWS公式ドキュメント:
#   - Amazon Location Service デベロッパーガイド: https://docs.aws.amazon.com/location/latest/developerguide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_tracker
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_location_tracker" "this" {
  #---------------------------------------------------------------
  # 必須引数
  #---------------------------------------------------------------

  # tracker_name (Required, string)
  # トラッカーリソースの名前。
  # 同一AWSアカウント・リージョン内で一意である必要がある。
  tracker_name = "example-tracker"

  #---------------------------------------------------------------
  # オプション引数
  #---------------------------------------------------------------

  # description (Optional, string)
  # トラッカーリソースの説明文。
  # 用途やプロジェクト名などを記載すると管理しやすい。
  description = null

  # kms_key_id (Optional, string)
  # Amazon Locationリソースに割り当てるAWS KMSカスタマーマネージドキーの識別子。
  # KMSキーARNまたはキーIDを指定する。
  # 指定しない場合はAWSマネージドキーが使用される。
  kms_key_id = null

  # position_filtering (Optional, string)
  # トラッカーリソースの位置フィルタリング方法。
  # デバイスから送信された位置情報のうち、どの更新を保存するかを決定する。
  #
  # 設定可能な値:
  #   - "TimeBased" (デフォルト): 30秒間隔で位置を保存。頻繁な更新をフィルタリングしてコストを削減。
  #   - "DistanceBased": デバイスが30メートル以上移動した場合にのみ位置を保存。
  #   - "AccuracyBased": 精度ベースでフィルタリング。測定の不確実性を考慮して、
  #                      実際に移動したと判断される場合にのみ位置を保存。
  position_filtering = null

  # region (Optional, string)
  # このリソースを管理するAWSリージョン。
  # 指定しない場合はプロバイダー設定のリージョンが使用される。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # tags (Optional, map(string))
  # トラッカーリソースに付与するタグ。
  # プロバイダーレベルのdefault_tagsが設定されている場合、
  # 同じキーのタグはここで指定した値で上書きされる。
  tags = null
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能。
#
# create_time:
#   トラッカーリソースが作成された日時（ISO 8601形式）。
#
# tracker_arn:
#   トラッカーリソースのAmazon Resource Name (ARN)。
#   例: arn:aws:geo:ap-northeast-1:123456789012:tracker/example-tracker
#   他のAWSサービスからリソースを参照する際に使用する。
#
# update_time:
#   トラッカーリソースが最後に更新された日時（ISO 8601形式）。
#
# id:
#   リソースのID（tracker_nameと同じ値）。
#
# tags_all:
#   プロバイダーのdefault_tagsとマージされた全てのタグ。
#---------------------------------------------------------------
