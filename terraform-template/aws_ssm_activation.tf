#---------------------------------------------------------------
# AWS Systems Manager Activation
#---------------------------------------------------------------
#
# オンプレミスサーバー、仮想マシン、エッジデバイスをAWS Systems Managerで
# 管理できるようにするためのハイブリッドアクティベーションをプロビジョニングします。
# アクティベーションIDとアクティベーションコードが生成され、非EC2マシンへの
# SSM Agentインストール時に使用することでマネージドノードとして登録できます。
#
# AWS公式ドキュメント:
#   - ハイブリッドアクティベーション作成: https://docs.aws.amazon.com/systems-manager/latest/userguide/hybrid-activation-managed-nodes.html
#   - ハイブリッドおよびマルチクラウド環境: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-hybrid-multicloud.html
#   - CreateActivation API: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_CreateActivation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_activation
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_activation" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: マネージドノードとして登録されたインスタンスのデフォルト名を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 名前なしで登録されます
  name = "my-ssm-activation"

  # description (Optional)
  # 設定内容: 登録するリソースの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで作成されます
  description = "Hybrid activation for on-premises servers"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # iam_role (Required)
  # 設定内容: マネージドノードに関連付けるIAMロールを指定します。
  # 設定可能な値: 有効なIAMロール名またはID
  # 注意: ロールの信頼ポリシーに "Service": "ssm.amazonaws.com" の信頼関係と
  #       AmazonSSMManagedInstanceCore ポリシーのアタッチが必要です。
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/hybrid-activation-managed-nodes.html
  iam_role = "ssm-managed-instance-role"

  #-------------------------------------------------------------
  # アクティベーション期限設定
  #-------------------------------------------------------------

  # expiration_date (Optional)
  # 設定内容: このアクティベーションリクエストの有効期限をUTCタイムスタンプ（RFC3339形式）で指定します。
  # 設定可能な値: RFC3339形式のタイムスタンプ（例: "2024-12-31T00:00:00Z"）
  # 省略時: リソース作成時から24時間後が設定されます
  # 注意: 有効期限を過ぎたアクティベーションでは新しいマネージドノードを登録できません。
  #       Terraformは設定に値が存在する場合のみドリフト検知を実行します。
  expiration_date = "2026-12-31T00:00:00Z"

  #-------------------------------------------------------------
  # 登録数制限設定
  #-------------------------------------------------------------

  # registration_limit (Optional)
  # 設定内容: このアクティベーションで登録できるマネージドノードの最大数を指定します。
  # 設定可能な値: 正の整数
  # 省略時: 1 インスタンスが上限として設定されます
  # 参考: スタンダードインスタンス層では1アカウント・1リージョンあたり最大1,000ノードまで登録可能
  #   https://docs.aws.amazon.com/systems-manager/latest/userguide/fleet-manager-configure-instance-tiers.html
  registration_limit = 10

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
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしで作成されます
  # 注意: プロバイダーの default_tags 設定ブロックで定義されたタグと一致するキーは
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-ssm-activation"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アクティベーションID
# - activation_code: アクティベーション処理時にシステムが生成するコード。
#                    非EC2マシンへのSSM Agentインストール時に使用します。
# - expired: 現在のアクティベーションが有効期限切れかどうかを示すブール値
# - registration_count: このアクティベーションを使用して現在登録されているマネージドノードの数
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
