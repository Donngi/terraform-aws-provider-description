#---------------------------------------------------------------
# AWS Directory Service Region
#---------------------------------------------------------------
#
# AWS Directory ServiceのMulti-Regionレプリケーションのためのリージョンを
# 管理するリソースです。
#
# Multi-Regionレプリケーションは、AWS Managed Microsoft ADの
# Enterprise Editionでのみサポートされています。
# このリソースにより、プライマリディレクトリを別のAWSリージョンに
# レプリケートし、地理的に分散した環境でのユーザー認証を
# 高速化することができます。
#
# AWS公式ドキュメント:
#   - AWS Directory Service概要: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html
#   - Multi-Regionレプリケーション: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_configure_multi_region_replication.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_region
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_directory_service_region" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # directory_id (Required)
  # 設定内容: リージョンレプリケーションを追加したいディレクトリの識別子を指定します。
  # 設定可能な値: 既存のAWS Managed Microsoft ADディレクトリのID
  # 注意: Multi-Regionレプリケーションは、AWS Managed Microsoft ADの
  #       Enterprise Editionでのみサポートされています。
  directory_id = aws_directory_service_directory.example.id

  # region_name (Required)
  # 設定内容: ドメインコントローラーを追加するリージョンの名前を指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-2, eu-west-1, ap-northeast-1）
  # 注意: プライマリディレクトリとは異なるリージョンを指定する必要があります
  region_name = "us-east-2"

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_settings (Required)
  # 設定内容: レプリケートされたリージョンのVPC情報を指定します。
  # 注意: 指定するVPCのCIDRブロックは、プライマリディレクトリのVPCと
  #       重複してはなりません。
  vpc_settings {
    # vpc_id (Required)
    # 設定内容: ディレクトリサーバーを作成するVPCの識別子を指定します。
    # 設定可能な値: 有効なVPC ID
    # 注意: 指定するリージョン（region_name）に存在するVPCを指定します
    vpc_id = aws_vpc.secondary.id

    # subnet_ids (Required)
    # 設定内容: ディレクトリサーバー用のサブネット識別子を指定します。
    # 設定可能な値: サブネットIDのセット
    # 注意: 異なるアベイラビリティゾーンに2つのサブネットを指定する必要があります
    #       サブネットは指定したVPC内に存在する必要があります
    subnet_ids = aws_subnet.secondary[*].id
  }

  #-------------------------------------------------------------
  # ドメインコントローラー設定
  #-------------------------------------------------------------

  # desired_number_of_domain_controllers (Optional)
  # 設定内容: レプリケートされたディレクトリで必要なドメインコントローラーの数を指定します。
  # 設定可能な値: 2以上の整数
  # 省略時: デフォルト値が適用されます（通常は2）
  # 注意: ドメインコントローラーの数は高可用性と認証パフォーマンスに影響します
  #       最小値は2です
  desired_number_of_domain_controllers = 2

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: region_nameとは異なり、これはTerraformがリソースを管理する際に使用する
  #       AWSプロバイダーのリージョンを指定します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "Secondary"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を指定します。
  # 注意: Multi-Regionレプリケーションの設定には時間がかかる場合があります
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "2h" などの時間文字列
    # 省略時: デフォルトのタイムアウト値が適用されます
    # 注意: リージョンへのレプリケーション設定には時間がかかることがあります
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "2h" などの時間文字列
    # 省略時: デフォルトのタイムアウト値が適用されます
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "2h" などの時間文字列
    # 省略時: デフォルトのタイムアウト値が適用されます
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディレクトリIDとリージョン名の組み合わせ
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
