#---------------------------------------------------------------
# Amazon GuardDuty ThreatIntelSet
#---------------------------------------------------------------
#
# GuardDutyの脅威インテリジェンスセットを管理するリソース。
# ThreatIntelSetは既知の悪意あるIPアドレスのリストで構成され、
# GuardDutyはこれらのセットに基づいて検出結果を生成します。
#
# 注意: 現在GuardDutyでは、メンバーアカウントのユーザーは
# ThreatIntelSetをアップロードおよび管理できません。
# プライマリアカウントによってアップロードされたThreatIntelSetは
# メンバーアカウントのGuardDuty機能に適用されます。
#
# AWS公式ドキュメント:
#   - CreateThreatIntelSet API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_CreateThreatIntelSet.html
#   - UpdateThreatIntelSet API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_UpdateThreatIntelSet.html
#   - GuardDuty Features: https://aws.amazon.com/guardduty/features/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_threatintelset
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_threatintelset" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # activate - (Required) GuardDutyがアップロードされたThreatIntelSetの使用を開始するかどうかを指定
  # ThreatIntelSetをアップロードした後、即座に検出に使用する場合はtrue、
  # 後で有効化する場合はfalseを指定します。
  # Type: bool
  activate = true

  # detector_id - (Required) GuardDutyディテクターのID
  # ThreatIntelSetを関連付けるGuardDutyディテクターの一意のIDを指定します。
  # 通常は aws_guardduty_detector リソースのidを参照します。
  # Type: string
  detector_id = "detector-id-12345"

  # format - (Required) ThreatIntelSetを含むファイルの形式
  # 有効な値:
  #   - TXT: プレーンテキスト形式（改行区切りのIPアドレス）
  #   - STIX: Structured Threat Information Expression形式
  #   - OTX_CSV: AlienVault Open Threat ExchangeのCSV形式
  #   - ALIEN_VAULT: AlienVault形式
  #   - PROOF_POINT: Proofpoint形式
  #   - FIRE_EYE: FireEye形式
  # Type: string
  format = "TXT"

  # location - (Required) ThreatIntelSetを含むファイルのURI
  # S3バケット内のオブジェクトのHTTPS URLを指定します。
  # GuardDutyはこのURIからファイルを読み取ります。
  # 例: "https://s3.amazonaws.com/bucket-name/object-key"
  # Type: string
  location = "https://s3.amazonaws.com/my-bucket/threat-intel-set.txt"

  # name - (Required) ThreatIntelSetを識別するための分かりやすい名前
  # GuardDutyコンソールやAPIレスポンスで表示される名前です。
  # Type: string
  name = "my-threat-intel-set"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # region - (Optional) このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # マルチリージョン構成でリソースごとに異なるリージョンを指定する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # region = "us-east-1"

  # tags - (Optional) リソースに付与するタグのキーと値のマップ
  # リソースの分類、管理、コスト配分などに使用します。
  # プロバイダーレベルで default_tags が設定されている場合、
  # ここで指定したタグは default_tags のタグを上書きします。
  # Type: map(string)
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）
#
# - arn
#   GuardDuty ThreatIntelSetのAmazon Resource Name (ARN)
#   Type: string
#
# - id
#   ThreatIntelSetのID（Terraform内部で自動生成）
#   Type: string
#
# - tags_all
#   リソースに割り当てられた全タグのマップ
#   プロバイダーの default_tags から継承されたタグも含まれます
#   Type: map(string)
#
#---------------------------------------------------------------
