#---------------------------------------------------------------
# Amazon Redshift Serverless Endpoint Access
#---------------------------------------------------------------
#
# Amazon Redshift Serverless エンドポイントアクセスを作成するリソースです。
# Redshift Serverless ワークグループへの VPC エンドポイント経由のアクセスを
# 構成し、プライベートな接続を確立できます。
#
# このリソースにより以下が可能になります:
#   - VPC 内からワークグループへのプライベートな接続
#   - 特定のサブネットとセキュリティグループの割り当て
#   - 複数のアカウント間でのワークグループアクセス管理
#
# AWS公式ドキュメント:
#   - Redshift Serverless 概要: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-whatis.html
#   - Redshift Serverless エンドポイント: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-connecting.html
#   - Redshift API リファレンス: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_endpoint_access
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftserverless_endpoint_access" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # endpoint_name (Required)
  # 設定内容: エンドポイントアクセスの名前を指定します。
  # 設定可能な値: 英数字とハイフンを含む文字列。一意である必要があります
  # 注意: 作成後の変更は不可。変更すると新しいリソースが作成されます
  # 関連機能: Amazon Redshift Serverless エンドポイント
  #   エンドポイント名はDNS名の一部として使用され、接続時の識別子となります。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-connecting.html
  endpoint_name = "example-endpoint"

  # workgroup_name (Required)
  # 設定内容: アクセスする Redshift Serverless ワークグループの名前を指定します。
  # 設定可能な値: 既存のワークグループ名
  # 注意: 作成後の変更は不可。変更すると新しいリソースが作成されます
  # 関連機能: Redshift Serverless ワークグループ
  #   ワークグループはコンピューティングリソースとデータベースのグループです。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-workgroup-namespace.html
  workgroup_name = "example-workgroup"

  # subnet_ids (Required)
  # 設定内容: エンドポイントに関連付ける VPC サブネットの ID リストを指定します。
  # 設定可能な値: VPC サブネット ID の配列 (例: ["subnet-12345678", "subnet-87654321"])
  # 注意: 複数のアベイラビリティゾーンにまたがるサブネットを指定することで高可用性を実現
  # 関連機能: VPC エンドポイント
  #   プライベートサブネット内にエンドポイントを配置することで、
  #   インターネットを経由せずに Redshift にアクセスできます。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-subnet-group-console.html
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # vpc_security_group_ids (Optional)
  # 設定内容: ワークグループに関連付けるセキュリティグループの ID リストを指定します。
  # 設定可能な値: VPC セキュリティグループ ID の配列 (例: ["sg-12345678"])
  # 省略時: VPC のデフォルトセキュリティグループが使用されます
  # 用途: エンドポイントへのネットワークアクセスを制御
  # 関連機能: VPC セキュリティグループ
  #   インバウンドルールで適切なポート(通常5439)とソースIPを許可する必要があります。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-security-groups.html
  vpc_security_group_ids = ["sg-12345678"]

  # owner_account (Optional)
  # 設定内容: Redshift Serverless ワークグループを所有する AWS アカウント ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID
  # 省略時: 現在のアカウントが使用されます
  # 用途: クロスアカウントでのワークグループアクセスを構成する場合に使用
  # 関連機能: AWS クロスアカウントアクセス
  #   別アカウントのワークグループにアクセスする際に、所有者アカウントを明示的に指定。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-cross-account.html
  owner_account = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID。エンドポイント名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Redshift Serverless エンドポイントアクセスの Amazon Resource Name (ARN)
#
# - id: Redshift エンドポイントアクセス名 (endpoint_name と同じ値)
#
# - address: VPC エンドポイントの DNS アドレス
#   エンドポイントへの接続に使用する DNS 名
#
# - port: Amazon Redshift Serverless がリッスンするポート番号
#   通常は 5439 (Redshift のデフォルトポート)
#
# - vpc_endpoint: VPC エンドポイントまたは Redshift Serverless ワークグループの詳細情報
#   - vpc_endpoint_id: VPC エンドポイントの一意の識別子
#   - vpc_id: VPC エンドポイントが配置されている VPC の ID
#   - network_interface: エンドポイントのネットワークインターフェイス情報のリスト
#     各ネットワークインターフェイスには以下が含まれます:
#     - availability_zone: ネットワークインターフェイスが配置されているアベイラビリティゾーン
#     - network_interface_id: ネットワークインターフェイスの一意の識別子
#     - private_ip_address: サブネット内のネットワークインターフェイスの IPv4 アドレス
#     - subnet_id: ネットワークインターフェイスが配置されているサブネットの一意の識別子
#
#---------------------------------------------------------------
