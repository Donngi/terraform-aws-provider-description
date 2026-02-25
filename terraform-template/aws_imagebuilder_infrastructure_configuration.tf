#---------------------------------------------------------------
# AWS ImageBuilder Infrastructure Configuration
#---------------------------------------------------------------
#
# EC2 Image Builder のインフラストラクチャ設定をプロビジョニングするリソースです。
# ビルドパイプラインがイメージを作成する際に使用するEC2インスタンスの設定（インスタンスタイプ、
# IAMプロファイル、ネットワーク設定、ロギング設定など）を定義します。
#
# AWS公式ドキュメント:
#   - EC2 Image Builder インフラストラクチャ設定: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-infra-config.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_infrastructure_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_infrastructure_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: インフラストラクチャ設定の名前を指定します。
  # 設定可能な値: 文字列
  name = "example-infra-config"

  # instance_profile_name (Required)
  # 設定内容: ビルドおよびテストインスタンスに割り当てるIAMインスタンスプロファイルの名前を指定します。
  # 設定可能な値: 有効なIAMインスタンスプロファイル名
  # 注意: インスタンスプロファイルにはEC2 Image Builderが必要とする権限が付与されている必要があります。
  instance_profile_name = "example-instance-profile"

  # description (Optional)
  # 設定内容: インフラストラクチャ設定の説明を指定します。
  # 設定可能な値: 文字列
  description = "example infrastructure configuration"

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
  # インスタンス設定
  #-------------------------------------------------------------

  # instance_types (Optional)
  # 設定内容: ビルドおよびテストに使用するEC2インスタンスタイプのセットを指定します。
  # 設定可能な値: 有効なEC2インスタンスタイプの文字列セット（例: "t2.nano", "t3.micro"）
  # 省略時: Image Builderが自動的に選択します。
  instance_types = ["t3.micro", "t3.small"]

  # key_pair (Optional)
  # 設定内容: ビルドおよびテストインスタンスに関連付けるEC2キーペアの名前を指定します。
  # 設定可能な値: 有効なEC2キーペア名
  # 省略時: キーペアは関連付けられません。
  key_pair = "example-key-pair"

  # terminate_instance_on_failure (Optional)
  # 設定内容: パイプラインが失敗した場合にインスタンスを終了するかを指定します。
  # 設定可能な値:
  #   - true: 失敗時にインスタンスを終了する
  #   - false: 失敗時にインスタンスを保持する（トラブルシューティング用）
  # 省略時: false
  terminate_instance_on_failure = true

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_id (Optional)
  # 設定内容: ビルドおよびテストインスタンスを起動するEC2サブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID
  # 注意: security_group_ids と併せて指定する必要があります。
  subnet_id = "subnet-12345678"

  # security_group_ids (Optional)
  # 設定内容: ビルドおよびテストインスタンスに関連付けるEC2セキュリティグループIDのセットを指定します。
  # 設定可能な値: 有効なEC2セキュリティグループIDの文字列セット
  security_group_ids = ["sg-12345678"]

  # sns_topic_arn (Optional)
  # 設定内容: ビルドの状態変更通知を送信するSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN
  # 省略時: 通知は送信されません。
  sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:imagebuilder-notifications"

  #-------------------------------------------------------------
  # リソースタグ設定
  #-------------------------------------------------------------

  # resource_tags (Optional)
  # 設定内容: インフラストラクチャ設定によって作成されるEC2インスタンス等のリソースに
  #           割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  resource_tags = {
    Project = "imagebuilder-project"
  }

  #-------------------------------------------------------------
  # インスタンスメタデータ設定
  #-------------------------------------------------------------

  # instance_metadata_options (Optional)
  # 設定内容: パイプラインのビルドおよびテストインスタンスが使用するHTTPリクエストの
  #           インスタンスメタデータオプションの設定ブロックです。
  # 関連機能: EC2 Instance Metadata Service (IMDSv2)
  #   インスタンスメタデータへのアクセス制御を設定します。IMDSv2を強制することで
  #   セキュリティを向上できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html
  instance_metadata_options {

    # http_put_response_hop_limit (Optional)
    # 設定内容: インスタンスメタデータリクエストが宛先に到達するためにトラバースできる
    #           ホップ数を指定します。
    # 設定可能な値: 1 から 64 の整数
    # 省略時: 1
    http_put_response_hop_limit = 1

    # http_tokens (Optional)
    # 設定内容: インスタンスメタデータ取得リクエストに署名済みトークンが必要かどうかを指定します。
    # 設定可能な値:
    #   - "required": IMDSv2 を強制（トークン必須）
    #   - "optional": IMDSv1 と IMDSv2 の両方を許可
    http_tokens = "required"
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging (Optional)
  # 設定内容: ビルドおよびテストのログをS3に保存するためのロギング設定ブロックです。
  # 関連機能: EC2 Image Builder ロギング
  #   ビルドアクティビティのログをS3バケットに保存します。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-infra-config.html
  logging {

    #-------------------------------------------------------------
    # S3ログ設定
    #-------------------------------------------------------------

    # s3_logs (Required within logging)
    # 設定内容: S3ログの設定ブロックです。loggingブロックを指定する場合は必須です。
    s3_logs {

      # s3_bucket_name (Required)
      # 設定内容: ログを保存するS3バケットの名前を指定します。
      # 設定可能な値: 有効なS3バケット名
      s3_bucket_name = "example-imagebuilder-logs-bucket"

      # s3_key_prefix (Optional)
      # 設定内容: S3ログのプレフィックスを指定します。
      # 設定可能な値: 文字列（例: "logs/imagebuilder/"）
      # 省略時: "/" が使用されます。
      s3_key_prefix = "logs/imagebuilder/"
    }
  }

  #-------------------------------------------------------------
  # 配置設定
  #-------------------------------------------------------------

  # placement (Optional)
  # 設定内容: イメージから起動されるインスタンスの実行場所を定義する配置設定ブロックです。
  # 関連機能: EC2 Dedicated Hosts / Placement Groups
  #   専用ホストやテナンシー設定を使用して、インスタンスの配置を制御します。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-overview.html
  placement {

    # availability_zone (Optional)
    # 設定内容: ビルドおよびテストインスタンスを起動するアベイラビリティゾーンを指定します。
    # 設定可能な値: 有効なアベイラビリティゾーン名（例: "ap-northeast-1a"）
    availability_zone = "ap-northeast-1a"

    # host_id (Optional)
    # 設定内容: ビルドおよびテストインスタンスを実行する専用ホストのIDを指定します。
    # 設定可能な値: 有効な専用ホストID
    # 注意: host_resource_group_arn と同時に指定することはできません。
    host_id = null

    # host_resource_group_arn (Optional)
    # 設定内容: ビルドおよびテストインスタンスを起動するホストリソースグループのARNを指定します。
    # 設定可能な値: 有効なホストリソースグループARN
    # 注意: host_id と同時に指定することはできません。
    host_resource_group_arn = null

    # tenancy (Optional)
    # 設定内容: インスタンスの配置テナンシーを指定します。
    # 設定可能な値:
    #   - "default": 共有ハードウェアでインスタンスを実行
    #   - "dedicated": 専用の単一テナントハードウェアでインスタンスを実行
    #   - "host": 専用ホスト上でインスタンスを実行
    tenancy = "default"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: インフラストラクチャ設定リソース自体に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: resource_tags はビルドで作成されるリソース（EC2インスタンス等）に付与されるタグです。
  #       tags はこのインフラストラクチャ設定リソース自体に付与されるタグです。
  tags = {
    Name        = "example-infra-config"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: インフラストラクチャ設定のARN（arnと同じ値）
# - arn: インフラストラクチャ設定のAmazon Resource Name (ARN)
# - date_created: 設定が作成された日付
# - date_updated: 設定が最後に更新された日付
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
