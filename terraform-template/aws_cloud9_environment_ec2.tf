#---------------------------------------------------------------
# AWS Cloud9 EC2 Environment
#---------------------------------------------------------------
#
# AWS Cloud9のEC2開発環境をプロビジョニングするリソースです。
# Cloud9はクラウドベースの統合開発環境（IDE）で、EC2インスタンス上で
# コードの作成、実行、デバッグが可能です。
#
# AWS公式ドキュメント:
#   - Cloud9環境の概要: https://docs.aws.amazon.com/cloud9/latest/user-guide/environments.html
#   - EC2環境の作成: https://docs.aws.amazon.com/cloud9/latest/user-guide/create-environment-main.html
#   - CreateEnvironmentEC2 API: https://docs.aws.amazon.com/cloud9/latest/APIReference/API_CreateEnvironmentEC2.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_ec2
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloud9_environment_ec2" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Cloud9環境の名前を指定します。
  # 設定可能な値: 文字列
  name = "my-cloud9-environment"

  # instance_type (Required)
  # 設定内容: 環境に接続するEC2インスタンスのタイプを指定します。
  # 設定可能な値: 有効なEC2インスタンスタイプ（例: t2.micro, t3.small, m5.large）
  # 注意: インスタンスタイプによって利用可能なリソース（CPU、メモリ）と料金が異なります
  instance_type = "t2.micro"

  # image_id (Required)
  # 設定内容: EC2インスタンスの作成に使用するAMIの識別子を指定します。
  # 設定可能な値:
  #   - "amazonlinux-2-x86_64": Amazon Linux 2 (x86_64)
  #   - "amazonlinux-2023-x86_64": Amazon Linux 2023 (x86_64)
  #   - "ubuntu-18.04-x86_64": Ubuntu 18.04 LTS (x86_64)
  #   - "ubuntu-22.04-x86_64": Ubuntu 22.04 LTS (x86_64)
  #   - "resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2-x86_64": SSMパラメータ経由でAmazon Linux 2を指定
  #   - "resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2023-x86_64": SSMパラメータ経由でAmazon Linux 2023を指定
  #   - "resolve:ssm:/aws/service/cloud9/amis/ubuntu-18.04-x86_64": SSMパラメータ経由でUbuntu 18.04を指定
  #   - "resolve:ssm:/aws/service/cloud9/amis/ubuntu-22.04-x86_64": SSMパラメータ経由でUbuntu 22.04を指定
  image_id = "amazonlinux-2023-x86_64"

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
  # 環境説明
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 環境の説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "My Cloud9 development environment"

  #-------------------------------------------------------------
  # 所有者設定
  #-------------------------------------------------------------

  # owner_arn (Optional)
  # 設定内容: 環境の所有者のARNを指定します。
  # 設定可能な値: 任意のAWS IAMプリンシパルのARN
  # 省略時: 環境の作成者が所有者になります
  # 注意: IAMユーザー、IAMロール、または Federated User のARNを指定可能
  owner_arn = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_id (Optional)
  # 設定内容: Cloud9がEC2インスタンスと通信するためのVPCサブネットIDを指定します。
  # 設定可能な値: 有効なサブネットID（例: subnet-xxxxxxxx）
  # 省略時: Cloud9がデフォルトのVPCとサブネットを使用
  # 注意: プライベートサブネットを使用する場合は、connection_typeをCONNECT_SSMに設定する必要があります
  subnet_id = null

  # connection_type (Optional)
  # 設定内容: EC2環境への接続タイプを指定します。
  # 設定可能な値:
  #   - "CONNECT_SSH": SSHを使用して接続（デフォルト）。インスタンスはパブリックサブネットに配置する必要があります
  #   - "CONNECT_SSM": AWS Systems Managerを使用して接続。プライベートサブネットでも使用可能
  # 関連機能: AWS Systems Manager Session Manager
  #   SSMを使用することで、インバウンドポートを開かずにプライベートサブネット内のインスタンスに接続可能
  #   - https://docs.aws.amazon.com/cloud9/latest/user-guide/ec2-ssm.html
  connection_type = "CONNECT_SSH"

  #-------------------------------------------------------------
  # 自動停止設定
  #-------------------------------------------------------------

  # automatic_stop_time_minutes (Optional)
  # 設定内容: 環境が最後に使用されてから、実行中のインスタンスがシャットダウンされるまでの時間（分）を指定します。
  # 設定可能な値: 正の整数（分単位）
  # 省略時: デフォルトで30分
  # 注意: コスト最適化のため、適切な値を設定することを推奨
  # 例: 30 = 30分後にシャットダウン、60 = 1時間後にシャットダウン
  automatic_stop_time_minutes = 30

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-cloud9-environment"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Cloud9環境のID
#
# - arn: Cloud9環境のAmazon Resource Name (ARN)
#
# - type: 環境のタイプ（例: "ssh" または "ec2"）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
