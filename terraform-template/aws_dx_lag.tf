#---------------------------------------
# AWS Direct Connect LAG (Link Aggregation Group)
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_lag
#
# 複数のDirect Connect接続を単一の論理接続に集約するリンクアグリゲーショングループ。
# LACPプロトコルを使用して帯域幅を増強し、単一のDirect Connectエンドポイントで管理可能。
#
# ユースケース:
# - 複数の物理接続を束ねて帯域幅を増やす
# - 1Gbps/10Gbps/100Gbps/400Gbpsの専用接続をアグリゲート
# - Active/Active構成による高可用性の実現
#
# 制約事項:
# - LAG内の全接続は同一帯域幅である必要がある
# - 全接続は同一のDirect Connectエンドポイントで終端する必要がある
# - 100Gbps/400Gbpsは最大2接続、それ以外は最大4接続まで集約可能
# - MACsecキーはLAG全体で単一のキーを共有
#
# 料金:
# - LAG自体に追加料金は発生しない（接続単位で課金）
# - 各接続のポート時間料金とデータ転送料金が適用
#
# NOTE: このテンプレートは全ての利用可能な属性を網羅していますが、
# 実際の使用時には必須項目と必要な項目のみを設定してください。
#
# 参考: https://docs.aws.amazon.com/directconnect/latest/UserGuide/lags.html
#---------------------------------------

resource "aws_dx_lag" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: LAGの名前
  # 設定可能な値: 1文字以上の任意の文字列
  # 省略時: 省略不可（必須項目）
  name = "example-lag"

  # 設定内容: Direct Connectロケーション（データセンター/コロケーション施設のコード）
  # 設定可能な値: AWS Direct Connectロケーションコード（例: EqSe2, EqDa2, EqTy2等）
  # 省略時: 省略不可（必須項目）
  # 注意: 全接続は同一ロケーションに配置される
  location = "EqSe2"

  # 設定内容: LAG内の各接続の帯域幅
  # 設定可能な値: 1Gbps, 10Gbps, 100Gbps, 400Gbps
  # 省略時: 省略不可（必須項目）
  # 注意: LAG内の全接続は同一帯域幅である必要がある
  connections_bandwidth = "10Gbps"

  #---------------------------------------
  # 接続管理
  #---------------------------------------

  # 設定内容: LAGに関連付ける既存のDirect Connect接続ID
  # 設定可能な値: 既存の接続ID（dxcon-xxxxxxxx形式）
  # 省略時: 新規接続を作成せずLAGのみ作成
  # 注意: 指定した接続はLAGに移動され、関連するMACsecキーは再関連付けされる
  connection_id = "dxcon-xxxxxxxx"

  #---------------------------------------
  # リソース削除設定
  #---------------------------------------

  # 設定内容: LAG削除時に関連付けられた接続も強制的に削除するかどうか
  # 設定可能な値: true（強制削除）, false（削除前に接続の切り離しが必要）
  # 省略時: false
  # 注意: trueの場合、LAG削除時に全ての接続が削除される（データ損失の可能性あり）
  force_destroy = false

  #---------------------------------------
  # プロバイダー設定
  #---------------------------------------

  # 設定内容: サービスプロバイダー名（AWS Direct Connectパートナー経由の場合）
  # 設定可能な値: プロバイダー名の文字列
  # 省略時: プロバイダー情報なし（自動検出される場合もあり）
  # 注意: LAG内の全接続は同一プロバイダーである必要がある
  provider_name = "AWS Direct Connect Partner"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースが管理されるAWSリージョン
  # 設定可能な値: AWSリージョンコード（us-east-1, ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョン
  # 注意: リソースのメタデータ管理用で、物理的なロケーションとは別
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: LAGに付与するタグ
  # 設定可能な値: キーと値のペア（最大50個）
  # 省略時: タグなし
  tags = {
    Name        = "example-lag"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# arn                     - LAGのARN
# id                      - LAGのID（dxlag-xxxxxxxx形式）
# has_logical_redundancy  - 論理的な冗長性の有無（unknown/yes/no）
# jumbo_frame_capable     - ジャンボフレーム対応可否（9001 MTU）
# owner_account_id        - LAGを所有するAWSアカウントID
# provider_name           - サービスプロバイダー名
# tags_all                - プロバイダーデフォルトタグとリソースタグの統合結果
#
# 出力例:
# output "lag_id" {
#   value = aws_dx_lag.example.id
# }
