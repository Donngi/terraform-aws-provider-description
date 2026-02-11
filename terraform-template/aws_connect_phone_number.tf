#---------------------------------------------------------------
# AWS Connect Phone Number
#---------------------------------------------------------------
#
# Amazon Connectインスタンスまたはトラフィック配信グループに
# 電話番号をクレーム（要求）するリソースです。
# 電話番号は、顧客が連絡先センターに電話をかけるために使用されます。
#
# AWS公式ドキュメント:
#   - Amazon Connect開始ガイド: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
#   - 電話番号の取得: https://docs.aws.amazon.com/connect/latest/adminguide/get-connect-number.html
#   - ClaimPhoneNumber API: https://docs.aws.amazon.com/connect/latest/APIReference/API_ClaimPhoneNumber.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_phone_number
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_connect_phone_number" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # country_code (Required, Forces new resource)
  # 設定内容: 電話番号を取得する国のISO国コードを指定します。
  # 設定可能な値: ISO国コード（例: "US", "JP", "GB"など）
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_SearchAvailablePhoneNumbers.html#connect-SearchAvailablePhoneNumbers-request-PhoneNumberCountryCode
  # 注意: この値の変更はリソースの再作成を引き起こします。
  country_code = "US"

  # target_arn (Required)
  # 設定内容: 電話番号をクレームするAmazon Connectインスタンスまたはトラフィック配信グループのARNを指定します。
  # 設定可能な値: 有効なAmazon Connectインスタンスまたはトラフィック配信グループのARN
  # 関連機能: Amazon Connect インスタンス
  #   電話番号は特定のConnectインスタンスまたはトラフィック配信グループに関連付けられます。
  #   トラフィック配信グループに関連付けると、複数のリージョンでの冗長性が実現できます。
  #   - https://docs.aws.amazon.com/connect/latest/adminguide/claim-phone-numbers-traffic-distribution-groups.html
  target_arn = "arn:aws:connect:us-east-1:123456789012:instance/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

  # type (Required, Forces new resource)
  # 設定内容: 電話番号のタイプを指定します。
  # 設定可能な値:
  #   - "TOLL_FREE": フリーダイヤル番号。発信者側に通話料金が発生しない。複数のキャリアで冗長性を提供
  #   - "DID": Direct Inward Dialing番号。市内番号として発信者に表示される
  # 関連機能: Amazon Connect 電話番号タイプ
  #   - TOLL_FREEは最高レベルの可用性とキャリア冗長性を提供しますが、DIDより高コスト
  #   - DIDは単一キャリアで管理され、発信者にローカルな存在感を提供
  #   - https://docs.aws.amazon.com/connect/latest/adminguide/concepts-telephony.html
  # 注意: この値の変更はリソースの再作成を引き起こします。
  type = "DID"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: 電話番号の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: この値の変更はリソースの再作成を引き起こします。
  description = "Main customer service line"

  # prefix (Optional, Forces new resource)
  # 設定内容: 利用可能な電話番号をフィルタリングするためのプレフィックスを指定します。
  # 設定可能な値: 国コードを含む"+"で始まる文字列（例: "+18005"）
  # 用途: 特定の市外局番や番号パターンを持つ電話番号を検索する際に使用
  # 注意:
  #   - 国コードの一部として"+"を含める必要があります
  #   - リソースをインポートする際は、この引数を指定しないでください
  #   - この値の変更はリソースの再作成を引き起こします。
  prefix = "+18005"

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
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "main-customer-line"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30m", "1h"）
    # デフォルト: プロバイダーのデフォルト値
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30m", "1h"）
    # デフォルト: プロバイダーのデフォルト値
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30m", "1h"）
    # デフォルト: プロバイダーのデフォルト値
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 電話番号のAmazon Resource Name (ARN)
#
# - id: 電話番号の識別子
#
# - phone_number: 電話番号。形式は "[+] [国コード] [市外局番を含む加入者番号]"
#
# - status: 電話番号のステータスを指定するブロック。以下の属性を含みます:
#   - status: 電話番号のステータス。有効な値: "CLAIMED" | "IN_PROGRESS" | "FAILED"
#   - message: ステータスメッセージ
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
