#---------------------------------------------------------------
# AWS VPC Lattice Target Group Attachment
#---------------------------------------------------------------
#
# Amazon VPC Latticeのターゲットグループにターゲットをアタッチするリソースです。
# ターゲットグループにEC2インスタンス、IPアドレス、Lambda関数、
# Application Load Balancer等を登録し、VPC Latticeサービスへの
# トラフィックルーティング先として設定できます。
#
# AWS公式ドキュメント:
#   - VPC Lattice概要: https://docs.aws.amazon.com/vpc-lattice/latest/ug/what-is-vpc-lattice.html
#   - ターゲットグループ: https://docs.aws.amazon.com/vpc-lattice/latest/ug/target-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_target_group_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_target_group_attachment" "example" {
  #-------------------------------------------------------------
  # ターゲットグループ設定
  #-------------------------------------------------------------

  # target_group_identifier (Required)
  # 設定内容: ターゲットを登録するターゲットグループのIDまたはARNを指定します。
  # 設定可能な値: VPC Latticeターゲットグループの有効なIDまたはARN
  # 注意: ターゲットグループは事前に作成されている必要があります。
  # 参考: https://docs.aws.amazon.com/vpc-lattice/latest/ug/target-groups.html
  target_group_identifier = "tg-0123456789abcdef0"

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target (Required)
  # 設定内容: ターゲットグループに登録するターゲットの情報を指定します。
  # 設定可能な値: ターゲットの詳細を含むブロック（最大1件）
  target {
    # id (Required)
    # 設定内容: ターゲットのIDを指定します。
    # 設定可能な値:
    #   - EC2インスタンスの場合: インスタンスID（例: i-0123456789abcdef0）
    #   - IPターゲットの場合: IPアドレス（例: 10.0.0.1）
    #   - Lambda関数の場合: 関数ARN
    #   - ALBの場合: ロードバランサーARN
    # 参考: https://docs.aws.amazon.com/vpc-lattice/latest/ug/target-groups.html
    id = "i-0123456789abcdef0"

    # port (Optional)
    # 設定内容: ターゲットへのトラフィックをルーティングするポート番号を指定します。
    # 設定可能な値: 1〜65535の整数
    # 省略時: ターゲットグループのデフォルトポートを使用
    # 注意: Lambdaターゲットの場合はポート指定不要
    port = 80
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 各操作のタイムアウト時間を指定します。
  # 関連機能: Terraform Operation Timeouts
  #   リソースの作成・削除操作に対するタイムアウトをカスタマイズできます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ターゲットグループIDとターゲットIDを組み合わせた一意の識別子
#---------------------------------------------------------------
