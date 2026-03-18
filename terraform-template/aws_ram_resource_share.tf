#---------------------------------------------------------------
# AWS Resource Access Manager (RAM) Resource Share
#---------------------------------------------------------------
#
# AWS Resource Access Manager (RAM) の Resource Share を管理するリソースです。
# AWS RAMを使用すると、リソースを複数のAWSアカウント間で安全に共有できます。
#
# プリンシパル (アカウント・OU・組織) との関連付けには aws_ram_principal_association
# リソースを使用し、共有するリソースとの関連付けには aws_ram_resource_association
# リソースを使用します。
#
# 共有可能なリソースの例:
#   - EC2: AMI、Capacity Reservations、Dedicated Hosts、Prefix Lists、Subnets、
#         Transit Gateways、Transit Gateway Multicast Domains
#   - License Manager: License Configurations
#   - AWS Network Firewall: Firewall Policies、Rule Groups
#   - AWS Resource Groups: Resource Groups
#   - Route 53: Resolver Rules、Resolver Query Log Configs
#   - AWS Glue: Data Catalogs、Databases、Tables
#   - AWS App Mesh: Meshes
#   - その他多数のAWSサービス
#
# AWS公式ドキュメント:
#   - RAM 概要: https://docs.aws.amazon.com/ram/latest/userguide/what-is.html
#   - リソース共有の管理: https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
#   - 共有可能なリソース: https://docs.aws.amazon.com/ram/latest/userguide/shareable.html
#   - RAM API リファレンス: https://docs.aws.amazon.com/ram/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_resource_share" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Resource Share の名前を指定します。
  # 設定可能な値: 文字列 (最大255文字)
  # 用途: Resource Share を識別するための分かりやすい名前
  # 関連機能: RAM Resource Share 名
  #   Resource Share を管理およびフィルタリングする際に使用される識別子。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing.html
  name = "example-resource-share"

  #-------------------------------------------------------------
  # プリンシパルアクセス設定
  #-------------------------------------------------------------

  # allow_external_principals (Optional)
  # 設定内容: AWS Organizations 外のプリンシパルに対してリソース共有を許可するかを指定します。
  # 設定可能な値:
  #   - true: AWS Organizations 外部のAWSアカウントとリソースを共有可能
  #   - false: AWS Organizations 内のアカウントとのみ共有可能
  # 省略時: false が設定されます
  # 注意: 外部アカウントと共有する場合、受信側が明示的に招待を承認する必要があります
  # 関連機能: RAM 外部プリンシパル共有
  #   組織外のアカウントとリソースを共有する場合に有効化。セキュリティ上の考慮が必要。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/working-with-sharing-create.html
  allow_external_principals = true

  #-------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------

  # permission_arns (Optional, Computed)
  # 設定内容: Resource Share に関連付ける RAM 権限の Amazon Resource Name (ARN) のセットを指定します。
  # 設定可能な値: RAM 権限の ARN のセット
  # 省略時: 共有される各リソースタイプにデフォルトバージョンの権限が自動的にアタッチされます
  # 注意:
  #   - Resource Share に含まれる各リソースタイプにつき、1つの権限のみを関連付け可能
  #   - 空のリスト [] を設定すると全要素が削除されます
  # 用途: 共有リソースへのアクセス権限をカスタマイズする場合に使用
  # 関連機能: RAM マネージド権限
  #   AWSが管理する権限ポリシー。リソースタイプごとに異なる権限を定義可能。
  #   デフォルト権限は読み取り専用または基本的な操作権限を提供。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/permissions.html
  permission_arns = null

  #-------------------------------------------------------------
  # リソース共有構成
  #-------------------------------------------------------------

  # resource_share_configuration (Optional)
  # 設定内容: Resource Share の構成設定を指定するブロックです。
  # 用途: アカウントが組織を離脱した際のリソース共有動作を制御します。
  resource_share_configuration {
    # retain_sharing_on_account_leave_organization (Optional, Computed)
    # 設定内容: アカウントが AWS Organizations を離脱した際にリソース共有へのアクセスを維持するかを指定します。
    # 設定可能な値:
    #   - true: 組織離脱後もコンシューマーアカウントがリソース共有へのアクセスを維持
    #   - false: 組織離脱時にリソース共有へのアクセスを自動的に取り消し
    # 省略時: AWSのデフォルト動作に従います
    # 注意: セキュリティポリシーに応じて適切に設定してください。
    #       組織外のアカウントにリソースアクセスが残ることを防ぎたい場合は false を推奨。
    retain_sharing_on_account_leave_organization = null
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Resource Share 自体はリージョン固有ですが、一部のリソース (例: Transit Gateway)
  #       は複数のリージョンをまたいで共有可能です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Resource Share に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/ram/latest/userguide/working-with-tags.html
  tags = {
    Name        = "example-resource-share"
    Environment = "production"
    Purpose     = "cross-account-resource-sharing"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する場合に使用
  timeouts {
    # create (Optional)
    # 設定内容: Resource Share の作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m" は 30分)
    # 省略時: デフォルトのタイムアウト時間が使用されます
    create = null

    # delete (Optional)
    # 設定内容: Resource Share の削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m" は 30分)
    # 省略時: デフォルトのタイムアウト時間が使用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Resource Share の Amazon Resource Name (ARN)
#
# - id: Resource Share の Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   Resource Share に割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# Resource Share の完全な設定には以下のリソースも必要です:
#
# - aws_ram_principal_association: プリンシパル (AWSアカウント、OU、組織) を
#   Resource Share に関連付けます
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association
#
# - aws_ram_resource_association: 共有するリソース (Subnet、Transit Gateway等) を
#   Resource Share に関連付けます
#---------------------------------------------------------------
