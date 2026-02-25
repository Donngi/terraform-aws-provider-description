#---------------------------------------------------------------
# Amazon Redshift Endpoint Authorization
#---------------------------------------------------------------
#
# Amazon RedshiftのRedshift管理型VPCエンドポイントのアクセス認可をプロビジョニングするリソースです。
# クラスター所有者（grantor）アカウントから別のAWSアカウント（grantee）に対して、
# Redshift管理型VPCエンドポイント経由でクラスターへのクロスアカウントアクセスを許可します。
# RA3ノードタイプのプロビジョニングクラスターで使用し、クラスター再配置または
# マルチAZが有効である必要があります。
#
# AWS公式ドキュメント:
#   - Redshift管理型VPCエンドポイント: https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-cross-vpc.html
#   - AuthorizeEndpointAccess APIリファレンス: https://docs.aws.amazon.com/redshift/latest/APIReference/API_AuthorizeEndpointAccess.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_endpoint_authorization
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_endpoint_authorization" "example" {
  #-------------------------------------------------------------
  # 認可対象アカウント設定
  #-------------------------------------------------------------

  # account (Required)
  # 設定内容: アクセスを許可するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  account = "012345678901"

  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: アクセスを許可するRedshiftクラスターの識別子を指定します。
  # 設定可能な値: 既存のRedshiftクラスターの識別子文字列
  # 注意: 対象クラスターはRA3ノードタイプであり、クラスター再配置またはマルチAZが有効である必要があります。
  cluster_identifier = "example-cluster"

  #-------------------------------------------------------------
  # VPCアクセス制御設定
  #-------------------------------------------------------------

  # vpc_ids (Optional)
  # 設定内容: アクセスを許可するVPCのIDセットを指定します。
  # 設定可能な値: 有効なVPC IDの集合（セット型）
  # 省略時: granteeアカウント内のすべてのVPCにアクセスが許可されます（allowed_all_vpcs = true）。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-cross-vpc.html
  vpc_ids = ["vpc-12345678", "vpc-87654321"]

  #-------------------------------------------------------------
  # 削除動作設定
  #-------------------------------------------------------------

  # force_delete (Optional)
  # 設定内容: 認可の失効アクションを強制するかどうかを指定します。
  # 設定可能な値:
  #   - true: 認可に関連付けられたRedshift管理型VPCエンドポイントも合わせて削除されます。
  #   - false: 既存のVPCエンドポイントが存在する場合は削除が拒否されます。
  # 省略時: false
  force_delete = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Redshift Endpoint AuthorizationのID。accountとcluster_identifierをコロン（:）で結合した値。
# - allowed_all_vpcs: granteeアカウント内のすべてのVPCにクラスターへのアクセスが許可されているかどうかを示します。
# - endpoint_count: 当該認可に対して作成されたRedshift管理型VPCエンドポイントの数。
# - grantee: クラスターのgranteeのAWSアカウントID。
# - grantor: クラスター所有者のAWSアカウントID。
#---------------------------------------------------------------
