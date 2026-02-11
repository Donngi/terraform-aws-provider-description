#---------------------------------------------------------------
# AWS Direct Connect Connection Association
#---------------------------------------------------------------
#
# Direct Connect Connection を LAG (Link Aggregation Group) に関連付けるリソースです。
# このリソースを使用することで、既存の Direct Connect 接続を LAG にバンドルし、
# 複数の接続の帯域幅を集約できます。
#
# LAGに接続を関連付けることで、以下のメリットがあります:
#   - 帯域幅の集約: 複数の接続を束ねて利用可能帯域を増加
#   - 冗長性の向上: 1つの接続が失敗しても他の接続でトラフィックを維持
#   - 管理の簡素化: 複数の接続を1つの論理インターフェースとして管理
#
# AWS公式ドキュメント:
#   - Direct Connect LAG: https://docs.aws.amazon.com/directconnect/latest/UserGuide/lags.html
#   - Direct Connect 接続: https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
#   - Direct Connect API リファレンス: https://docs.aws.amazon.com/directconnect/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_connection_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_connection_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: LAGに関連付けるDirect Connect接続のIDを指定します。
  # 設定可能な値: 有効なDirect Connect接続ID (例: dxcon-xxxxxxxx)
  # 用途: 既存の接続をLAGにバンドルするために必要
  # 関連機能: Direct Connect Connection
  #   接続は、AWSとお客様のデータセンター間の物理的な専用接続を表します。
  #   接続をLAGに関連付けるには、接続の帯域幅がLAGの接続帯域幅と一致している必要があります。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
  connection_id = aws_dx_connection.example.id

  # lag_id (Required)
  # 設定内容: 接続を関連付けるLAG (Link Aggregation Group) のIDを指定します。
  # 設定可能な値: 有効なLAG ID (例: dxlag-xxxxxxxx)
  # 用途: 複数のDirect Connect接続を束ねるLAGを指定
  # 関連機能: Direct Connect LAG
  #   LAGは、複数の物理接続を1つの論理接続としてグループ化します。
  #   これにより、複数の接続にわたるトラフィックを802.3adプロトコルを使用して集約できます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/lags.html
  lag_id = aws_dx_lag.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Direct Connectリソースはロケーションに依存するため、
  #       接続とLAGが同じロケーションにある必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 関連リソースの例
#---------------------------------------------------------------
# このリソースを使用する際の典型的な構成例です。
#
# resource "aws_dx_connection" "example" {
#   name      = "example-connection"
#   bandwidth = "1Gbps"
#   location  = "EqSe2-EQ"
# }
#
# resource "aws_dx_lag" "example" {
#   name                  = "example-lag"
#   connections_bandwidth = "1Gbps"
#   location              = "EqSe2-EQ"
# }
#
# resource "aws_dx_connection_association" "example" {
#   connection_id = aws_dx_connection.example.id
#   lag_id        = aws_dx_lag.example.id
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#   connection_idとlag_idを組み合わせた一意の識別子として使用されます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意事項
#---------------------------------------------------------------
# 1. 接続とLAGの帯域幅の一致
#    LAGに関連付ける接続の帯域幅は、LAGの connections_bandwidth と
#    一致している必要があります。例えば、1Gbpsの接続は1GbpsのLAGにのみ
#    関連付けることができます。
#
# 2. ロケーションの一致
#    接続とLAGは同じDirect Connectロケーションに存在する必要があります。
#    異なるロケーションの接続をLAGに関連付けることはできません。
#
# 3. 関連付けの影響
#    接続をLAGに関連付けると、その接続は個別に使用できなくなります。
#    接続をLAGから切り離すには、このリソースを削除する必要があります。
#---------------------------------------------------------------
