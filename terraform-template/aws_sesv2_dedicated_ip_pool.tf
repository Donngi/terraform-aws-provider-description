#---------------------------------------------------------------
# AWS SESv2 Dedicated IP Pool
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2の専用IPプールをプロビジョニングするリソースです。
# 専用IPプールは、1つ以上の専用IPアドレスをグループ化したもので、
# メールの種類（マーケティング、トランザクション等）ごとに送信者レピュテーションを
# 分離するために使用します。プールをコンフィギュレーションセットに関連付けることで、
# そのコンフィギュレーションセットを使用して送信されるメールは、
# プール内のアドレスから送信されます。
#
# AWS公式ドキュメント:
#   - 専用IPアドレスの概要: https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip.html
#   - 専用IPプールの作成: https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip-pools.html
#   - 専用IP (マネージド): https://docs.aws.amazon.com/ses/latest/dg/managed-dedicated-sending.html
#   - CreateDedicatedIpPool API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateDedicatedIpPool.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_dedicated_ip_pool
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_dedicated_ip_pool" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # pool_name (Required)
  # 設定内容: 専用IPプールの名前を指定します。
  # 設定可能な値: 一意の文字列
  # 注意: アカウント内で一意である必要があります。マネージドIPプールと同名にすることはできません。
  # 参考: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateDedicatedIpPool.html
  pool_name = "my-dedicated-ip-pool"

  #-------------------------------------------------------------
  # スケーリングモード設定
  #-------------------------------------------------------------

  # scaling_mode (Optional)
  # 設定内容: IPプールのスケーリングモードを指定します。
  # 設定可能な値:
  #   - "STANDARD": ユーザーが手動でIPアドレスを管理するモード。IPのウォームアップや
  #     スケールアウトを手動で行い、IPプールへの追加・削除も手動で管理します。
  #     継続的かつ予測可能な送信パターンと大量のメール送信に適しています。
  #   - "MANAGED": Amazon SESが自動的にIPアドレスを管理するモード。ISPごとに
  #     アダプティブウォームアップを行い、送信量に基づいて自動スケーリングします。
  #     送信パターンが不規則な場合や、管理の手間を軽減したい場合に適しています。
  # 省略時: AWS APIのデフォルトとしてSTANDARDプールが作成されます。
  # 関連機能: Amazon SES 専用IPアドレス
  #   STANDARDモードでは手動でのIP管理が必要ですが、MANAGEDモードではSESが
  #   最適なIP数の決定、ISPごとのウォームアップ、自動スケーリングを行います。
  #   - https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip.html
  #   - https://docs.aws.amazon.com/ses/latest/dg/managed-dedicated-sending.html
  scaling_mode = "STANDARD"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-dedicated-ip-pool"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 専用IPプールのAmazon Resource Name (ARN)
#
# - id: プール名（pool_nameと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
