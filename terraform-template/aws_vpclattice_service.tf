#---------------------------------------------------------------
# VPC Lattice Service
#---------------------------------------------------------------
# VPC Lattice のサービスを作成します。VPC Lattice は、VPC やアカウント間でのサービス間通信と
# セキュリティを提供するフルマネージドなアプリケーションネットワーキングサービスです。
# サービスはサービスネットワークに関連付けることで、クライアントからのリクエストを
# 受け付けられるようになります。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/services.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_service
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートは参考例です。実際の利用環境に応じて適切な値を設定してください。
#---------------------------------------------------------------

resource "aws_vpclattice_service" "example" {

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サービスの名前を指定します
  # 設定可能な値: 3～40文字のa-z、0-9、ハイフン(-)を使用可能。ハイフンは先頭・末尾・連続使用は不可。アカウント内で一意である必要があります
  # 関連機能: VPC Lattice サービス - https://docs.aws.amazon.com/vpc-lattice/latest/ug/services.html
  name = "my-lattice-service"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # auth_type (Optional)
  # 設定内容: サービスへのアクセスに使用する認証タイプを指定します
  # 設定可能な値: NONE（認証なし）または AWS_IAM（IAMベースの認証）
  # 省略時: NONE
  # 関連機能: VPC Lattice 認証ポリシー - https://docs.aws.amazon.com/vpc-lattice/latest/ug/auth-policies.html
  auth_type = "AWS_IAM"

  #-------------------------------------------------------------
  # カスタムドメイン設定
  #-------------------------------------------------------------

  # custom_domain_name (Optional)
  # 設定内容: サービスのカスタムドメイン名を指定します。指定すると、VPC Lattice が生成するデフォルトのFQDNの代わりに、このドメイン名を使用できます
  # 設定可能な値: 有効な完全修飾ドメイン名（FQDN）。所有しているドメインまたはAmazon/サードパーティ提供のドメインを使用可能
  # 省略時: VPC Lattice が自動生成するドメイン名を使用
  # 関連機能: カスタムドメイン名 - https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-custom-domain-name.html
  custom_domain_name = "api.example.com"

  # certificate_arn (Optional)
  # 設定内容: HTTPS リクエストを処理するための SSL/TLS 証明書の ARN を指定します。ACM（AWS Certificate Manager）で管理されている証明書を使用します
  # 設定可能な値: AWS Certificate Manager の証明書ARN。証明書のドメイン名は custom_domain_name と一致する必要があります。2048ビット RSA キーの証明書のみサポート
  # 省略時: HTTPS リクエストを処理できません
  # 関連機能: 証明書持ち込み (BYOC) - https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-byoc.html
  certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/12345678-1234-1234-1234-123456789012"

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
    Name        = "my-lattice-service"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# arn - サービスの Amazon Resource Name (ARN)
# dns_entry - サービスの DNS 名（VPC Lattice が自動生成）
# id - サービスの一意識別子
# status - サービスのステータス（ACTIVE, CREATE_IN_PROGRESS, DELETE_IN_PROGRESS など）
# tags_all - プロバイダーの default_tags を含む、リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
