#---------------------------------------------------------------
# VPC Lattice Service Network
#---------------------------------------------------------------
# VPC Lattice のサービスネットワークを作成します。サービスネットワークは、複数のサービスを
# 論理的にグループ化するための境界であり、VPCやアカウント間でのサービス間通信を
# 可能にします。サービスネットワークにサービスとVPCを関連付けることで、VPC内の
# クライアントがサービスにアクセスできるようになります。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-networks.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_service_network
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートは参考例です。実際の利用環境に応じて適切な値を設定してください。
#---------------------------------------------------------------

resource "aws_vpclattice_service_network" "example" {

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サービスネットワークの名前を指定します
  # 設定可能な値: アカウント内で一意の名前。英数字とハイフンを使用可能
  # 関連機能: VPC Lattice サービスネットワーク - https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-networks.html
  name = "my-service-network"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # auth_type (Optional)
  # 設定内容: サービスネットワークへのアクセスに使用する認証タイプを指定します。サービスネットワークレベルで認証ポリシーを設定することで、ネットワーク全体のアクセス制御を実施できます
  # 設定可能な値: NONE（認証なし）または AWS_IAM（IAMベースの認証）
  # 省略時: NONE
  # 関連機能: VPC Lattice 認証ポリシー - https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html
  auth_type = "AWS_IAM"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルエンドポイント - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるキー・バリュー形式のタグを指定します
  # 設定可能な値: 任意のキー・バリューペアのマップ
  # 省略時: タグなし（プロバイダーの default_tags があれば適用されます）
  tags = {
    Name        = "my-service-network"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# arn - サービスネットワークの Amazon Resource Name (ARN)
# tags_all - プロバイダーの default_tags を含む、リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
