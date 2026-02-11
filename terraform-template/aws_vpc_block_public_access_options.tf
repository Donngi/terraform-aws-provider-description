#---------------------------------------------------------------
# VPC Block Public Access Options
#---------------------------------------------------------------
#
# VPCブロックパブリックアクセス（BPA）オプションを管理するリソースです。
# AWSアカウント全体でVPCリソースへのパブリックインターネットアクセスを
# ブロックしながら、必要に応じて例外を許可するセキュリティ機能です。
#
# VPC BPAには2つのモードがあります:
# - Bidirectional（双方向）: インターネットゲートウェイおよびegress-only
#   インターネットゲートウェイとの間のすべてのトラフィックをブロック
# - Ingress-only（受信のみ）: VPCへのすべてのインターネットトラフィックを
#   ブロックしますが、NATゲートウェイとegress-onlyインターネットゲートウェイ
#   との間のトラフィックは許可
#
# AWS公式ドキュメント:
#   - Block public access to VPCs and subnets: https://docs.aws.amazon.com/vpc/latest/userguide/security-vpc-bpa.html
#   - VpcBlockPublicAccessOptions API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpcBlockPublicAccessOptions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpc_block_public_access_options
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_block_public_access_options" "example" {

  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # internet_gateway_block_mode (Required)
  # 設定内容: インターネットゲートウェイに対するブロックモード
  # 設定可能な値:
  #   - "block-bidirectional": 双方向のトラフィックをブロック（送受信両方）
  #   - "block-ingress": 受信トラフィックのみブロック（送信は許可）
  #   - "off": ブロック機能を無効化
  # 省略時: 設定必須
  # 注意: このリソースを削除すると、このアカウントとリージョンの設定値は
  #      "off" に設定されます
  # 関連機能: VPC Block Public Access
  #   VPC BPAの詳細とベストプラクティス - https://docs.aws.amazon.com/vpc/latest/userguide/security-vpc-bpa.html
  internet_gateway_block_mode = "block-bidirectional"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1 など
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: VPC BPAは特定のリージョンに対して設定されます
  # 関連機能: AWS Regional Endpoints
  #   リージョナルエンドポイントの詳細 - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: VPC BPAオプション作成のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトタイムアウト値
    # 注意: 数値と単位のサフィックスで構成（s=秒、m=分、h=時間）
    # create = "30s"

    # update (Optional)
    # 設定内容: VPC BPAオプション更新のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトタイムアウト値
    # update = "30s"

    # delete (Optional)
    # 設定内容: VPC BPAオプション削除のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトタイムアウト値
    # 注意: destroy操作前に状態に変更が保存される場合のみ適用されます
    # delete = "30s"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# - id: リソースのID（AWSアカウントIDとリージョンの組み合わせ）
# - aws_account_id: これらのオプションが適用されるAWSアカウントID
# - aws_region: これらのオプションが適用されるAWSリージョン
#---------------------------------------------------------------
