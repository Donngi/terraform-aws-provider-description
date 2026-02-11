#---------------------------------------------------------------
# AWS Direct Connect Hosted Connection
#---------------------------------------------------------------
#
# AWS Direct Connect のホスト接続を作成するリソースです。
# このリソースは、インターコネクトまたはリンクアグリゲーショングループ（LAG）上に
# ホスト接続をプロビジョニングします。
#
# **重要**: このリソースは AWS Direct Connect パートナー専用です。
# 一般のAWSユーザーは使用できません。
#
# ホスト接続は、Direct Connect パートナーが顧客に代わって作成し、
# 顧客のAWSアカウントに割り当てる接続です。
#
# AWS公式ドキュメント:
#   - Direct Connect 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html
#   - ホスト接続: https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted_connection.html
#   - API リファレンス: https://docs.aws.amazon.com/directconnect/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_hosted_connection" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ホスト接続の名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 接続を識別するための名前。AWSコンソールやAPIで表示されます。
  # 関連機能: Direct Connect 接続の命名
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted_connection.html
  name = "tf-dx-hosted-connection"

  # bandwidth (Required)
  # 設定内容: ホスト接続の帯域幅を指定します。
  # 設定可能な値 (大文字小文字を区別):
  #   - ホスト接続: 50Mbps, 100Mbps, 200Mbps, 300Mbps, 400Mbps, 500Mbps,
  #                 1Gbps, 2Gbps, 5Gbps, 10Gbps, 25Gbps
  # 注意: 値は大文字小文字を区別します (例: "100Mbps" であり "100mbps" ではない)
  # 関連機能: Direct Connect 帯域幅オプション
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted_connection.html
  bandwidth = "100Mbps"

  # connection_id (Required)
  # 設定内容: ホスト接続を作成するインターコネクトまたはLAGのIDを指定します。
  # 設定可能な値: 既存のインターコネクトID (dxcon-xxxxxxxx) または LAG ID (dxlag-xxxxxxxx)
  # 用途: ホスト接続はインターコネクトまたはLAG上に作成されます
  # 関連機能: Direct Connect インターコネクトとLAG
  #   インターコネクトはパートナーが所有する物理接続で、複数のホスト接続を収容できます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/interconnects.html
  connection_id = "dxcon-ffabc123"

  # owner_account_id (Required)
  # 設定内容: ホスト接続を割り当てる顧客のAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 用途: パートナーが顧客のアカウントにホスト接続を割り当てる際に使用
  # 注意: 顧客はこの接続を受け入れる必要があります
  # 関連機能: Direct Connect 接続の割り当て
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted_connection.html
  owner_account_id = "123456789012"

  # vlan (Required)
  # 設定内容: ホスト接続に割り当てる専用VLANを指定します。
  # 設定可能な値: 1-4094 の整数
  # 用途: 802.1Q VLANタグ。インターコネクト上のトラフィックを分離するために使用
  # 注意: 同一インターコネクト上で一意である必要があります
  # 関連機能: Direct Connect VLAN
  #   VLANタグは、同一物理接続上の複数の論理接続を分離します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html
  vlan = 1

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 既存のホスト接続ID (dxcon-xxxxxxxx 形式)
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します。
  #       既存のリソースをインポートする場合に使用されることがあります。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ホスト接続のID (dxcon-xxxxxxxx 形式)
#
# - aws_device: 物理接続が終端するDirect Connectエンドポイント
#   例: "EqDC2-abcdefgh"
#
# - connection_region: 接続が存在するAWSリージョン
#   注: 廃止予定の region 属性の代わりに使用してください
#
# - has_logical_redundancy: 接続が同一アドレスファミリ (IPv4/IPv6) で
#   セカンダリBGPピアをサポートするかどうかを示します
#   値: "unknown", "yes", "no"
#
# - jumbo_frame_capable: この接続でジャンボフレームが有効かどうかを示すブール値
#   ジャンボフレームは最大9001バイトのMTUをサポートします
#
# - lag_id: 接続が関連付けられているLAGのID (該当する場合)
#
# - loa_issue_time: この接続に対するDescribeLoa APIの最新呼び出し時刻
#   LOA (Letter of Authorization) はデータセンターへのアクセスに必要な認可書
#
#---------------------------------------------------------------
