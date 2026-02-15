#---------------------------------------------------------------
# AWS CodeConnections Host
#---------------------------------------------------------------
#
# AWS CodeConnectionsのホストリソースをプロビジョニングします。
# ホストは、サードパーティプロバイダー（GitHub Enterprise Server、
# GitLab self-managedなど）がインストールされているインフラストラクチャ
# を表すリソースです。このホストは、特定のプロバイダータイプへの
# 接続を作成する際に使用されます。
#
# 重要: ホストは作成後、デフォルトでPENDING状態になります。
#       プロバイダーの設定を完了させることで使用可能になります。
#
# AWS公式ドキュメント:
#   - CodeConnections概要: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections.html
#   - ホストの作成方法: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-hosts.html
#   - Host APIリファレンス: https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Host.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeconnections_host
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codeconnections_host" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ホストの名前を指定します。
  # 設定可能な値: 1～64文字の文字列
  # 用途: ホストを識別するための名前を設定します
  name = "example-host"

  #-------------------------------------------------------------
  # プロバイダー設定
  #-------------------------------------------------------------

  # provider_type (Required)
  # 設定内容: サードパーティプロバイダーのタイプを指定します。
  # 設定可能な値:
  #   - "Bitbucket": Bitbucket Server
  #   - "GitHub": GitHub（クラウド版）
  #   - "GitHubEnterpriseServer": GitHub Enterprise Server（セルフホスト版）
  #   - "GitLab": GitLab.com（クラウド版）
  #   - "GitLabSelfManaged": GitLab self-managed（セルフホスト版）
  #   - "AzureDevOps": Azure DevOps
  # 注意: セルフホストプロバイダー（GitHubEnterpriseServer、GitLabSelfManaged等）
  #       を使用する場合、通常はVPC設定が必要です
  provider_type = "GitHubEnterpriseServer"

  # provider_endpoint (Required)
  # 設定内容: プロバイダーのエンドポイントURLを指定します。
  # 設定可能な値: 1～512文字のURL文字列
  # 用途: セルフホストプロバイダーの場合、プロバイダーがインストールされている
  #       サーバーのURL（例: https://github.example.com）を指定します
  # 注意: エンドポイントはHTTPSプロトコルを使用することを推奨します
  provider_endpoint = "https://github.example.com"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # VPCネットワーク設定
  #-------------------------------------------------------------

  # vpc_configuration (Optional)
  # 設定内容: セルフホストプロバイダーへの接続に使用するVPC構成を指定します。
  # 用途: プライベートネットワーク内にあるGitHub Enterprise ServerやGitLab
  #       self-managedなどに接続する場合に使用します
  # 参考: https://docs.aws.amazon.com/dtconsole/latest/userguide/vpc-interface-endpoints.html
  vpc_configuration {
    # vpc_id (Required)
    # 設定内容: VPCのIDを指定します。
    # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
    # 用途: ホストが配置されるVPCを指定します
    vpc_id = "vpc-12345678"

    # subnet_ids (Required)
    # 設定内容: サブネットIDのセットを指定します。
    # 設定可能な値: 1つ以上のサブネットID
    # 用途: ホストが使用するサブネットを指定します
    # 注意: 高可用性を確保するため、複数のアベイラビリティゾーンの
    #       サブネットを使用することを推奨します
    subnet_ids = [
      "subnet-12345678",
      "subnet-87654321"
    ]

    # security_group_ids (Required)
    # 設定内容: セキュリティグループIDのセットを指定します。
    # 設定可能な値: 1つ以上のセキュリティグループID
    # 用途: ホストへのネットワークアクセスを制御するセキュリティグループを指定します
    # 注意: プロバイダーエンドポイントへのアウトバウンドHTTPS（443）通信を
    #       許可するセキュリティグループを設定してください
    security_group_ids = [
      "sg-12345678"
    ]

    # tls_certificate (Optional)
    # 設定内容: プロバイダーエンドポイントのTLS証明書を指定します。
    # 設定可能な値: PEM形式のTLS証明書文字列
    # 用途: プロバイダーが自己署名証明書を使用している場合や、
    #       カスタムCA証明書を使用している場合に指定します
    # 注意: 証明書は信頼できるものを使用してください
    tls_certificate = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大200個）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-host"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられるすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #        すべてのタグが自動的に設定されます
  # 注意: 通常は省略し、tagsとプロバイダーのdefault_tagsで管理することを推奨
  tags_all = null

  #-------------------------------------------------------------
  # その他の設定
  #-------------------------------------------------------------

  # id (Optional, Computed, Deprecated)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: CodeConnections HostのARN
  # 省略時: 自動的にHostのARNが設定されます
  # 注意: 非推奨の属性です。通常は省略し、自動生成されたIDを使用することを推奨
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: CodeConnections HostのARN（非推奨）
#
# - arn: CodeConnections HostのARN
#       ホストを一意に識別するAmazon Resource Name
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# タイムアウト設定
#---------------------------------------------------------------
# このリソースは以下のタイムアウト設定をサポートします:
#
# timeouts {
#   create = "30m"  # 作成操作のタイムアウト（デフォルト: 30分）
#   update = "30m"  # 更新操作のタイムアウト（デフォルト: 30分）
#   delete = "30m"  # 削除操作のタイムアウト（デフォルト: 30分）
# }
#---------------------------------------------------------------
