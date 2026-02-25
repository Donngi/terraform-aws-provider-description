#---------------------------------------------------------------
# Amazon GuardDuty IPSet (信頼済みIPリスト)
#---------------------------------------------------------------
#
# Amazon GuardDuty の IPSet（信頼済みIPリスト）をプロビジョニングするリソースです。
# IPSet は GuardDuty が脅威として検出しない信頼済み IP アドレスのリストを定義します。
# S3 バケットに配置したファイルを参照して IP アドレスリストを管理します。
#
# 注意: メンバーアカウントのユーザーは IPSet をアップロード・管理できません。
#       プライマリアカウントがアップロードした IPSet がメンバーアカウントに適用されます。
#
# AWS公式ドキュメント:
#   - GuardDuty IPSet 概要: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_upload-lists.html
#   - IPSet の追加と有効化: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-lists-create-activate.html
#   - CreateIPSet API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_CreateIPSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_ipset
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_ipset" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: IPSet の表示名を指定します。
  # 設定可能な値: 英小文字、英大文字、数字、ダッシュ(-)、アンダースコア(_)を含む文字列
  # 注意: 同一 AWS アカウント・リージョン内で一意の名前にする必要があります。
  name = "MyIPSet"

  # detector_id (Required)
  # 設定内容: IPSet を関連付ける GuardDuty ディテクターの ID を指定します。
  # 設定可能な値: GuardDuty ディテクターの ID 文字列
  # 参考: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_CreateIPSet.html
  detector_id = "abc123def456abc123def456abc12345"

  #-------------------------------------------------------------
  # IPリストファイル設定
  #-------------------------------------------------------------

  # format (Required)
  # 設定内容: IP アドレスリストを含むファイルのフォーマットを指定します。
  # 設定可能な値:
  #   - "TXT": 1行に1つの IP アドレスまたは CIDR ブロックを記載するプレーンテキスト形式
  #   - "STIX": Structured Threat Information Expression 形式
  #   - "OTX_CSV": Open Threat Exchange CSV 形式
  #   - "ALIEN_VAULT": AlienVault 形式
  #   - "PROOF_POINT": Proofpoint ET Intelligence Feed CSV 形式
  #   - "FIRE_EYE": FireEye iSIGHT Threat Intelligence CSV 形式
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_upload-lists.html
  format = "TXT"

  # location (Required)
  # 設定内容: IP アドレスリストを含むファイルの URI を指定します。
  # 設定可能な値: S3 オブジェクトの URI（例: https://s3.amazonaws.com/{bucket}/{key}）
  # 注意: GuardDuty のサービスリンクロールが S3 オブジェクトへのアクセス権限を持つ必要があります。
  # 参考: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-lists-create-activate.html
  location = "https://s3.amazonaws.com/my-guardduty-bucket/MyIPSet.txt"

  #-------------------------------------------------------------
  # 有効化設定
  #-------------------------------------------------------------

  # activate (Required)
  # 設定内容: GuardDuty がアップロードした IPSet を使用して脅威検出を開始するかどうかを指定します。
  # 設定可能な値:
  #   - true: IPSet を有効化し、GuardDuty が脅威検出に使用します（ステータス: Active）
  #   - false: IPSet を無効化します（ステータス: Inactive）
  # 注意: 有効化後、リストが有効になるまで数分かかる場合があります。
  activate = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "MyIPSet"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: GuardDuty IPSet の Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
