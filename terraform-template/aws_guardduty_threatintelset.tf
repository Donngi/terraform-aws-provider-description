#---------------------------------------------------------------
# AWS GuardDuty ThreatIntelSet
#---------------------------------------------------------------
#
# Amazon GuardDuty の脅威インテリジェンスセット（ThreatIntelSet）を
# プロビジョニングするリソースです。
# ThreatIntelSet は既知の悪意のある IP アドレスのリストを定義し、
# GuardDuty がこれらのセットに基づいてセキュリティの検出結果を生成します。
#
# 注意: メンバーアカウントのユーザーは ThreatIntelSet をアップロードおよび
# 管理できません。プライマリアカウントがアップロードした ThreatIntelSet は
# メンバーアカウントの GuardDuty 機能に適用されます。
#
# AWS公式ドキュメント:
#   - ThreatIntelSet の作成: https://docs.aws.amazon.com/guardduty/latest/ug/create-threat-intel-set.html
#   - CreateThreatIntelSet API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_CreateThreatIntelSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_threatintelset
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_threatintelset" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ThreatIntelSet を識別するためのフレンドリーな名前を指定します。
  # 設定可能な値: 文字列
  name = "MyThreatIntelSet"

  # detector_id (Required)
  # 設定内容: ThreatIntelSet を関連付ける GuardDuty ディテクターの ID を指定します。
  # 設定可能な値: 有効な GuardDuty ディテクター ID
  # 参考: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_CreateDetector.html
  detector_id = "abc123def456"

  #-------------------------------------------------------------
  # ファイル設定
  #-------------------------------------------------------------

  # format (Required)
  # 設定内容: ThreatIntelSet を含むファイルのフォーマットを指定します。
  # 設定可能な値:
  #   - "TXT": 改行区切りの IP アドレスリスト
  #   - "STIX": STIX 2.0 形式
  #   - "OTX_CSV": AlienVault OTX CSV 形式
  #   - "ALIEN_VAULT": AlienVault OTX ネイティブ形式
  #   - "PROOF_POINT": Proofpoint ET Intelligence 形式
  #   - "FIRE_EYE": FireEye iSIGHT 形式
  format = "TXT"

  # location (Required)
  # 設定内容: ThreatIntelSet を含むファイルの URI を指定します。
  # 設定可能な値: S3 オブジェクトの URL（例: https://s3.amazonaws.com/{bucket}/{key}）
  # 注意: GuardDuty がファイルにアクセスできるよう、S3 バケットポリシーで
  #       guardduty.amazonaws.com サービスプリンシパルへのアクセスを許可する必要があります。
  location = "https://s3.amazonaws.com/my-bucket/MyThreatIntelSet"

  #-------------------------------------------------------------
  # 有効化設定
  #-------------------------------------------------------------

  # activate (Required)
  # 設定内容: アップロードされた ThreatIntelSet を GuardDuty が使用開始するかどうかを指定します。
  # 設定可能な値:
  #   - true: ThreatIntelSet を有効化し、GuardDuty が検出に使用します。
  #   - false: ThreatIntelSet を無効化します。GuardDuty は検出に使用しません。
  activate = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
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
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "MyThreatIntelSet"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: GuardDuty ThreatIntelSet の Amazon Resource Name (ARN)
# - id: GuardDuty ThreatIntelSet の ID
# - threat_intel_set_id: GuardDuty ThreatIntelSet の ID
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
