#---------------------------------------------------------------
# AWS Lightsail Container Service
#---------------------------------------------------------------
#
# AWS Lightsailでコンテナアプリケーションをデプロイ、実行、管理するための
# スケーラブルなコンピューティングおよびネットワーキングプラットフォームです。
# コンテナイメージを使用してアプリケーションを実行でき、負荷分散やHTTPS
# エンドポイントが自動的に提供されます。
#
# AWS公式ドキュメント:
#   - Container Service概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services.html
#   - キャパシティ変更: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-changing-container-service-capacity.html
#   - カスタムドメイン: https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-creating-container-services-certificates
#   - リージョンとAZ: https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_container_service
#
# Provider Version: 6.28.0
# Generated: 2025-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_container_service" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コンテナサービスの名前を指定します。
  # 設定可能な値: 1〜63文字の文字列
  # 注意: 各AWSリージョンのLightsailアカウント内で一意である必要があります。
  name = "container-service-1"

  # power (Required)
  # 設定内容: コンテナサービスのパワー仕様を指定します。
  #           パワーはメモリ量、vCPU数、および各ノードの月額料金を決定します。
  # 設定可能な値:
  #   - "nano": 512 MB RAM, 0.25 vCPUs
  #   - "micro": 1 GB RAM, 0.25 vCPUs
  #   - "small": 2 GB RAM, 0.5 vCPUs
  #   - "medium": 4 GB RAM, 1 vCPUs
  #   - "large": 8 GB RAM, 2 vCPUs
  #   - "xlarge": 16 GB RAM, 4 vCPUs
  # 参考: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_ContainerService.html
  power = "nano"

  # scale (Required)
  # 設定内容: コンテナサービスのスケール仕様を指定します。
  #           スケールはコンテナサービスの割り当てコンピュートノード数を決定します。
  # 設定可能な値: 1〜20の整数
  # 注意: 月額料金は power × scale で計算されます。
  #       高可用性を確保するには、複数のノード（scale >= 2）を使用することを推奨します。
  scale = 1

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # is_disabled (Optional)
  # 設定内容: コンテナサービスを無効化するかを指定します。
  # 設定可能な値:
  #   - true: コンテナサービスを無効化
  #   - false: コンテナサービスを有効化（デフォルト）
  # 注意: 無効化してもリソースは削除されず、課金は継続されます。
  is_disabled = false

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: Lightsail Container Serviceが利用可能なリージョンを確認してください。
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: キーのみのタグを作成する場合は、空文字列を値として使用します。
  #       プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "container-service-1"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # private_registry_access ブロック (Optional)
  #-------------------------------------------------------------
  # プライベートコンテナイメージリポジトリ（Amazon ECRなど）への
  # アクセス設定を定義します。
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services.html

  private_registry_access {
    # ecr_image_puller_role ブロック (Optional)
    # Amazon ECRプライベートリポジトリへのアクセス設定を定義します。

    ecr_image_puller_role {
      # is_active (Optional)
      # 設定内容: ECRイメージプーラーロールを有効化するかを指定します。
      # 設定可能な値:
      #   - true: ロールを有効化（ECRプライベートイメージへのアクセスを許可）
      #   - false: ロールを無効化（デフォルト）
      # 注意: 有効化すると、principal_arnが自動的に生成されます。
      #       このARNをECRリポジトリポリシーで使用して、アクセス権限を付与します。
      is_active = true
    }
  }

  #-------------------------------------------------------------
  # public_domain_names ブロック (Optional)
  #-------------------------------------------------------------
  # コンテナサービスで使用するパブリックドメイン名を定義します。
  # 最大4つのパブリックドメイン名を指定できます。
  # 注意: パブリックドメイン名を使用する前に、SSL/TLS証明書を作成して
  #       検証する必要があります。
  # 参考: https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-creating-container-services-certificates

  public_domain_names {
    # certificate ブロック (Required, 複数指定可能)
    # パブリックドメイン名用の証明書設定を定義します。

    certificate {
      # certificate_name (Required)
      # 設定内容: 証明書の名前を指定します。
      # 設定可能な値: Lightsailで作成された証明書の名前
      # 注意: 証明書は事前にaws_lightsail_certificateリソースで作成し、
      #       検証済みである必要があります。
      certificate_name = "example-certificate"

      # domain_names (Required)
      # 設定内容: 証明書に関連付けるドメイン名のリストを指定します。
      # 設定可能な値: 完全修飾ドメイン名（FQDN）のリスト
      # 注意: 証明書に含まれるドメイン名と一致する必要があります。
      domain_names = [
        "www.example.com",
        "example.com",
      ]
    }

    # 複数の証明書を使用する場合の例
    # certificate {
    #   certificate_name = "another-certificate"
    #   domain_names = [
    #     "api.example.com",
    #   ]
    # }
  }

  #-------------------------------------------------------------
  # timeouts ブロック (Optional)
  #-------------------------------------------------------------
  # リソース操作のタイムアウト設定を定義します。

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # デフォルト: 30分
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # デフォルト: 30分
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # デフォルト: 30分
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンテナサービスのAmazon Resource Name (ARN)
#
# - availability_zone: アベイラビリティゾーン
#   フォーマット例: us-east-2a（大文字小文字を区別）
#
# - created_at: コンテナサービスが作成された日時
#
# - id: nameと同じ値
#
# - power_id: コンテナサービスのパワーID
#
# - principal_arn: コンテナサービスのプリンシパルARN
#   用途: 標準AWSアカウントとLightsailコンテナサービス間の信頼関係を
#         作成するために使用できます。標準AWSアカウント内のリソースへの
#         アクセス権限をサービスに付与できます。
#
# - private_domain_name: コンテナサービスのプライベートドメイン名
#   注意: LightsailアカウントのデフォルトVPC内の他のリソースから
#         のみアクセス可能です。
#
#---------------------------------------------------------------
