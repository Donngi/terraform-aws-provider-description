#---------------------------------------------------------------
# EC2 Image Builder Infrastructure Configuration
#---------------------------------------------------------------
#
# EC2 Image Builderのインフラストラクチャ設定を管理します。
# この設定は、イメージのビルドとテストに使用されるEC2インスタンスの
# 環境設定を定義します。インスタンスタイプ、プレイスメント、IAMインスタンス
# プロファイル、VPC、サブネット、セキュリティグループ、S3ロギング場所、
# キーペア、SNSトピックなどを指定できます。
#
# AWS公式ドキュメント:
#   - Manage Image Builder infrastructure configuration: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-infra-config.html
#   - Create an infrastructure configuration: https://docs.aws.amazon.com/imagebuilder/latest/userguide/create-infra-config.html
#   - CreateInfrastructureConfiguration API: https://docs.aws.amazon.com/imagebuilder/latest/APIReference/API_CreateInfrastructureConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_infrastructure_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_infrastructure_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # インスタンスプロファイル名
  # - ビルドおよびテストインスタンスで使用されるIAMインスタンスプロファイルの名前
  # - インスタンスプロファイルには、カスタマイズ活動を実行し、
  #   Image Builderと通信するための適切な権限が必要
  instance_profile_name = "example-instance-profile"

  # 設定名
  # - インフラストラクチャ設定の名前
  # - 1〜126文字の長さで指定
  name = "example-infrastructure-configuration"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 説明
  # - インフラストラクチャ設定の説明
  # - 1〜1024文字の長さで指定可能
  description = "Example infrastructure configuration for Image Builder"

  # インスタンスタイプ
  # - ビルドおよびテストインフラストラクチャで使用するEC2インスタンスタイプのセット
  # - 複数のインスタンスタイプを指定することで、十分な容量を確保し、
  #   一時的なビルド失敗を減らすことができる
  # - macOSイメージの場合は、macOSをネイティブにサポートするインスタンスタイプが必要
  instance_types = ["t3.medium", "t3.large"]

  # キーペア
  # - 失敗したビルドのトラブルシューティング用のEC2キーペア名
  # - ビルドインスタンスへのSSHアクセスが必要な場合に指定
  key_pair = "example-keypair"

  # ID
  # - リソースの識別子（通常は自動的に設定されるため明示的な指定は不要）
  # - optionalだがcomputedなので、通常は指定しない
  # id = null

  # リージョン
  # - このリソースが管理されるリージョン
  # - デフォルトではプロバイダー設定のリージョンを使用
  # - optionalかつcomputedなので、通常は指定不要
  # region = "ap-northeast-1"

  # リソースタグ
  # - 設定によって作成されるインフラストラクチャに割り当てるリソースタグのキー・バリューマップ
  # - Image Builderによって起動されるEC2インスタンスなどに適用される
  resource_tags = {
    Environment = "Development"
    ManagedBy   = "ImageBuilder"
  }

  # セキュリティグループID
  # - EC2セキュリティグループ識別子のセット
  # - ビルドおよびテストインスタンスに適用されるセキュリティグループ
  # - subnet_idと併せて使用
  security_group_ids = ["sg-0123456789abcdef0"]

  # SNSトピックARN
  # - イベント通知用のSNSトピックのAmazon Resource Name (ARN)
  # - 暗号化されている場合、トピックを暗号化するキーはImage Builderアカウントに存在する必要がある
  sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"

  # サブネットID
  # - EC2サブネット識別子
  # - パイプラインのビルドおよびテストインスタンスが起動されるサブネット
  # - security_group_ids引数も必要
  subnet_id = "subnet-0123456789abcdef0"

  # タグ
  # - 設定に割り当てるリソースタグのキー・バリューマップ
  # - プロバイダーのdefault_tags設定ブロックと併用可能
  tags = {
    Name        = "example-infrastructure-configuration"
    Environment = "Production"
  }

  # タグ（全て）
  # - リソースに割り当てられる全てのタグ（プロバイダーのdefault_tagsから継承されるタグを含む）
  # - optionalかつcomputedなので、通常は指定不要（自動的に計算される）
  # tags_all = {}

  # 失敗時のインスタンス終了
  # - パイプラインが失敗した場合にインスタンスを終了するかどうか
  # - デフォルトはfalse（失敗時もインスタンスを保持してトラブルシューティング可能）
  # - trueに設定すると、失敗時に自動的にインスタンスが終了される
  terminate_instance_on_failure = true

  #---------------------------------------------------------------
  # ネストブロック: instance_metadata_options
  #---------------------------------------------------------------
  # インスタンスメタデータオプション
  # - パイプラインビルドがEC2ビルドおよびテストインスタンスを起動するために
  #   使用するHTTPリクエストのインスタンスメタデータオプションを設定

  instance_metadata_options {
    # HTTPプットレスポンスホップリミット
    # - インスタンスが目的地に到達するために通過できるホップ数
    # - インスタンスメタデータサービスへのリクエストが通過できるネットワークホップの最大数
    http_put_response_hop_limit = 1

    # HTTPトークン
    # - インスタンスメタデータ取得リクエストに署名付きトークンが必要かどうか
    # - 有効な値: required（IMDSv2を強制）, optional（IMDSv1とIMDSv2の両方を許可）
    http_tokens = "required"
  }

  #---------------------------------------------------------------
  # ネストブロック: logging
  #---------------------------------------------------------------
  # ロギング設定
  # - アプリケーションログのロギング設定

  logging {
    # S3ログ設定
    # - Amazon S3へのログ出力設定（必須）

    s3_logs {
      # S3バケット名
      # - ログを保存するS3バケットの名前
      s3_bucket_name = "example-imagebuilder-logs-bucket"

      # S3キープレフィックス
      # - S3ログに使用するプレフィックス
      # - デフォルトは"/"
      # - ログファイルの整理やフィルタリングに使用
      s3_key_prefix = "imagebuilder-logs/"
    }
  }

  #---------------------------------------------------------------
  # ネストブロック: placement
  #---------------------------------------------------------------
  # プレイスメント設定
  # - イメージから起動されるインスタンスの実行場所を定義するプレイスメント設定

  placement {
    # アベイラビリティゾーン
    # - ビルドおよびテストインスタンスが起動されるアベイラビリティゾーン
    # - 特定のAZでインスタンスを起動したい場合に指定
    availability_zone = "ap-northeast-1a"

    # ホストID
    # - ビルドおよびテストインスタンスが実行される専用ホストのID
    # - host_resource_group_arnと競合（どちらか一方のみ指定可能）
    # - macOSイメージの場合に専用ホストIDを指定
    # host_id = "h-0123456789abcdef0"

    # ホストリソースグループARN
    # - ビルドおよびテストインスタンスを起動するホストリソースグループのARN
    # - host_idと競合（どちらか一方のみ指定可能）
    # host_resource_group_arn = "arn:aws:resource-groups:ap-northeast-1:123456789012:group/example-host-resource-group"

    # テナンシー
    # - インスタンスのプレイスメントテナンシー
    # - 有効な値: default（共有ハードウェア）, dedicated（専用インスタンス）, host（専用ホスト）
    tenancy = "default"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - id
#     設定のAmazon Resource Name (ARN)
#
# - arn
#     設定のAmazon Resource Name (ARN)
#
# - date_created
#     設定が作成された日時
#
# - date_updated
#     設定が最後に更新された日時
#
# - tags_all
#     リソースに割り当てられたタグのマップ
#     プロバイダーのdefault_tags設定ブロックから継承されたタグを含む
#
#---------------------------------------------------------------
