#---------------------------------------------------------------
# Amazon Redshift Endpoint Access
#---------------------------------------------------------------
#
# Amazon Redshift クラスターへのVPCエンドポイントアクセスを作成および管理するリソースです。
# Redshift-managed VPC エンドポイントを使用すると、プライベートIPアドレスを通じて
# VPC内からRedshiftクラスターにアクセスできます。
#
# 主な用途:
#   - プライベートネットワーク経由でのRedshiftクラスターへの安全なアクセス
#   - 異なるVPCからのクラスターアクセス
#   - セキュリティグループによるアクセス制御の実装
#
# AWS公式ドキュメント:
#   - Redshift VPC エンドポイント: https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-cross-vpc.html
#   - Redshift セキュリティグループ: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-security-groups.html
#   - Redshift API リファレンス: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateEndpointAccess.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_endpoint_access
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_endpoint_access" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # endpoint_name (Required)
  # 設定内容: Redshift-managed VPC エンドポイントの名前を指定します。
  # 設定可能な値: 1〜30文字の英数字とハイフン。小文字で開始する必要があります
  # 用途: エンドポイントを一意に識別するための名前
  # 注意: 作成後の変更はリソースの再作成を引き起こします
  # 関連機能: Redshift Endpoint Access
  #   VPCエンドポイント経由でRedshiftクラスターにアクセスするための識別子。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-cross-vpc.html
  endpoint_name = "example-endpoint"

  # cluster_identifier (Required)
  # 設定内容: アクセスするRedshiftクラスターの識別子を指定します。
  # 設定可能な値: 既存のRedshiftクラスターの識別子
  # 用途: エンドポイントアクセスの対象となるクラスターを指定
  # 注意: 作成後の変更はリソースの再作成を引き起こします
  # 関連機能: Redshift Cluster
  #   このエンドポイント経由でアクセス可能にするクラスターを指定。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html
  cluster_identifier = "example-cluster"

  # subnet_group_name (Required)
  # 設定内容: エンドポイントのデプロイ先となるサブネットグループ名を指定します。
  # 設定可能な値: 既存のRedshiftサブネットグループ名
  # 用途: エンドポイントを配置するVPCサブネットを決定
  # 注意: 作成後の変更はリソースの再作成を引き起こします
  # 関連機能: Redshift Subnet Group
  #   AmazonがVPCエンドポイントをデプロイするサブネットを選択するために使用。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-cluster-subnet-groups.html
  subnet_group_name = "example-subnet-group"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # resource_owner (Optional, Computed)
  # 設定内容: クラスター所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のアカウントIDが使用されます
  # 用途: クロスアカウントでのクラスターアクセスを設定する場合に必要
  # 関連機能: Cross-Account Access
  #   異なるAWSアカウントが所有するRedshiftクラスターへのアクセスを許可。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-cross-vpc.html
  resource_owner = null

  # vpc_security_group_ids (Optional, Computed)
  # 設定内容: エンドポイントに適用するVPCセキュリティグループIDのセットを指定します。
  # 設定可能な値: セキュリティグループIDのセット
  # 省略時: VPCのデフォルトセキュリティグループが使用されます
  # 用途: エンドポイントへのインバウンドトラフィックの制御
  # 関連機能: VPC Security Groups
  #   エンドポイントへのアクセスを許可するポート、プロトコル、送信元を定義。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-security-groups.html
  vpc_security_group_ids = []

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はendpoint_nameと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Redshift-managed VPC エンドポイント名 (endpoint_nameと同じ)
#
# - address: エンドポイントのDNSアドレス
#   VPCエンドポイント経由でクラスターに接続する際に使用します
#
# - port: クラスターが受信接続を受け付けるポート番号
#   デフォルトは5439ですが、クラスター作成時に変更可能です
#
# - vpc_endpoint: プロキシ経由でRedshiftクラスターに接続するための
#   接続エンドポイント情報。以下の属性を含むリスト:
#   - vpc_endpoint_id: エンドポイントID
#   - vpc_id: エンドポイントが関連付けられているVPC ID
#   - network_interface: エンドポイントのネットワークインターフェース。
#     以下の属性を含むリスト:
#     - network_interface_id: ネットワークインターフェース識別子
#     - subnet_id: サブネット識別子
#     - private_ip_address: サブネット内のネットワークインターフェースのIPv4アドレス
#     - availability_zone: アベイラビリティゾーン
#
#---------------------------------------------------------------
#---------------------------------------------------------------
