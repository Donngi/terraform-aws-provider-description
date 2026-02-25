#---------------------------------------------------------------
# AWS IVS Playback Key Pair
#---------------------------------------------------------------
#
# Amazon Interactive Video Service (IVS) の再生認証キーペアをプロビジョニングするリソースです。
# キーペアはプライベートチャンネルの視聴者認証トークン（JWT）の署名・検証に使用されます。
# 顧客が生成したECDSA公開鍵をAWSに登録し、対応する秘密鍵は顧客が管理します。
#
# AWS公式ドキュメント:
#   - 再生キーの作成またはインポート: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/private-channels-create-key.html
#   - プライベートチャンネルのワークフロー: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/private-channels-workflow.html
#   - PlaybackKeyPair APIリファレンス: https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_PlaybackKeyPair.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ivs_playback_key_pair
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ivs_playback_key_pair" "example" {
  #-------------------------------------------------------------
  # 公開鍵設定
  #-------------------------------------------------------------

  # public_key (Required, Forces new resource)
  # 設定内容: 顧客が生成したキーペアの公開鍵部分を指定します。
  # 設定可能な値: PEM形式のECDSA公開鍵文字列
  # 注意: 一度登録したキーペアは更新できません。変更する場合は既存キーを削除して新規作成が必要です。
  #       AWSアカウントあたり最大3つのキーペアのみ登録可能です。
  # 参考: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/private-channels-create-key.html
  public_key = file("./public-key.pem")

  #-------------------------------------------------------------
  # 識別設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: 再生キーペアの名前を指定します。
  # 設定可能な値: 0-128文字の文字列（英数字、ハイフン、アンダースコア）
  # 省略時: AWSが自動生成した名前を使用します。
  name = "my-playback-key-pair"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグ、キー1-128文字、値0-256文字）
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-playback-key-pair"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 再生キーペアのAmazon Resource Name (ARN)
#        形式: arn:aws:ivs:[リージョン]:[アカウントID]:playback-key/[キーID]
#
# - fingerprint: キーペアの識別子（フィンガープリント）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
