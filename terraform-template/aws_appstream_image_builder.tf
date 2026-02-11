#---------------------------------------------------------------
# AWS AppStream 2.0 Image Builder
#---------------------------------------------------------------
#
# Amazon AppStream 2.0のイメージビルダーをプロビジョニングするリソースです。
# イメージビルダーは、アプリケーションのインストールやイメージの作成に使用する
# 仮想マシンです。カスタムイメージを作成するためのベースとなります。
#
# AWS公式ドキュメント:
#   - AppStream 2.0概要: https://docs.aws.amazon.com/appstream2/latest/developerguide/what-is-appstream.html
#   - イメージビルダー: https://docs.aws.amazon.com/appstream2/latest/developerguide/tutorial-image-builder-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_image_builder
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appstream_image_builder" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: イメージビルダーの一意な名前を指定します。
  # 設定可能な値: 1-100文字の文字列
  # 注意: リソース作成後は変更できません。
  name = "my-image-builder"

  # instance_type (Required)
  # 設定内容: イメージビルダーの起動時に使用するインスタンスタイプを指定します。
  # 設定可能な値: AppStream 2.0がサポートするインスタンスタイプ
  #   - stream.standard.small
  #   - stream.standard.medium
  #   - stream.standard.large
  #   - stream.standard.xlarge
  #   - stream.standard.2xlarge
  #   - stream.compute.large
  #   - stream.compute.xlarge
  #   - stream.compute.2xlarge
  #   - stream.compute.4xlarge
  #   - stream.compute.8xlarge
  #   - stream.memory.large
  #   - stream.memory.xlarge
  #   - stream.memory.2xlarge
  #   - stream.memory.4xlarge
  #   - stream.memory.8xlarge
  #   - stream.memory.z1d.large
  #   - stream.memory.z1d.xlarge
  #   - stream.memory.z1d.2xlarge
  #   - stream.memory.z1d.3xlarge
  #   - stream.memory.z1d.6xlarge
  #   - stream.memory.z1d.12xlarge
  #   - stream.graphics-design.large
  #   - stream.graphics-design.xlarge
  #   - stream.graphics-design.2xlarge
  #   - stream.graphics-design.4xlarge
  #   - stream.graphics-desktop.2xlarge
  #   - stream.graphics.g4dn.xlarge
  #   - stream.graphics.g4dn.2xlarge
  #   - stream.graphics.g4dn.4xlarge
  #   - stream.graphics.g4dn.8xlarge
  #   - stream.graphics.g4dn.12xlarge
  #   - stream.graphics.g4dn.16xlarge
  #   - stream.graphics-pro.4xlarge
  #   - stream.graphics-pro.8xlarge
  #   - stream.graphics-pro.16xlarge
  # 関連機能: AppStream 2.0 インスタンスファミリー
  #   用途に応じて標準、コンピューティング最適化、メモリ最適化、
  #   グラフィック最適化などのインスタンスタイプを選択できます。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/instance-types.html
  instance_type = "stream.standard.large"

  #-------------------------------------------------------------
  # イメージ設定
  #-------------------------------------------------------------

  # image_name (Optional, Required if image_arn not provided)
  # 設定内容: イメージビルダーの作成に使用するイメージの名前を指定します。
  # 設定可能な値: パブリック、プライベート、または共有イメージの名前
  # 注意: image_arnと排他的（どちらか一方を指定）
  image_name = "AppStream-WinServer2019-10-05-2022"

  # image_arn (Optional, Required if image_name not provided)
  # 設定内容: 使用するパブリック、プライベート、または共有イメージのARNを指定します。
  # 設定可能な値: 有効なイメージARN
  # 注意: image_nameと排他的（どちらか一方を指定）
  image_arn = null

  #-------------------------------------------------------------
  # 表示設定
  #-------------------------------------------------------------

  # display_name (Optional)
  # 設定内容: AppStreamイメージビルダーの表示名を指定します。
  # 設定可能な値: 人間が読みやすい形式の名前
  # 省略時: nameと同じ値が使用されます。
  display_name = "My Image Builder"

  # description (Optional)
  # 設定内容: イメージビルダーの説明を指定します。
  # 設定可能な値: 説明文字列（最大256文字）
  description = "Image builder for custom application image"

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
  # エージェント設定
  #-------------------------------------------------------------

  # appstream_agent_version (Optional)
  # 設定内容: 使用するAppStream 2.0エージェントのバージョンを指定します。
  # 設定可能な値: 有効なエージェントバージョン文字列
  #   - "LATEST": 最新のエージェントバージョンを使用
  #   - 特定のバージョン番号
  # 省略時: 最新の安定バージョンが使用されます。
  # 関連機能: AppStream 2.0 エージェント
  #   ストリーミングセッションの管理やユーザーとの接続を処理します。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/agent-software.html
  appstream_agent_version = null

  #-------------------------------------------------------------
  # IAM設定
  #-------------------------------------------------------------

  # iam_role_arn (Optional)
  # 設定内容: イメージビルダーに適用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: AppStream 2.0 IAMロール
  #   イメージビルダーインスタンスがAWSサービスにアクセスする際の権限を制御します。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/roles-required-for-appstream.html
  iam_role_arn = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # enable_default_internet_access (Optional)
  # 設定内容: イメージビルダーのデフォルトインターネットアクセスを有効または無効にします。
  # 設定可能な値:
  #   - true: デフォルトのインターネットアクセスを有効化
  #   - false: デフォルトのインターネットアクセスを無効化（VPC設定が必要）
  # 省略時: true
  # 関連機能: AppStream 2.0 ネットワーク設定
  #   VPCを使用する場合は、NATゲートウェイまたはNATインスタンスを介した
  #   インターネットアクセスを設定できます。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/internet-access.html
  enable_default_internet_access = false

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Optional)
  # 設定内容: イメージビルダーのVPC設定を指定します。
  # 関連機能: AppStream 2.0 VPC設定
  #   イメージビルダーをVPC内に配置し、セキュリティグループとサブネットを設定します。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/vpc-setup-recommendations.html
  vpc_config {
    # subnet_ids (Optional)
    # 設定内容: イメージビルダーインスタンスにネットワークインターフェースを
    #           アタッチするサブネットのIDを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    # 注意: 複数のサブネットを指定する場合、それらは同じアベイラビリティゾーン内にある必要があります。
    subnet_ids = ["subnet-12345678"]

    # security_group_ids (Optional)
    # 設定内容: イメージビルダーのセキュリティグループIDを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    # 省略時: デフォルトのセキュリティグループが使用されます。
    security_group_ids = ["sg-12345678"]
  }

  #-------------------------------------------------------------
  # アクセスエンドポイント設定
  #-------------------------------------------------------------

  # access_endpoint (Optional)
  # 設定内容: インターフェースVPCエンドポイント（インターフェースエンドポイント）
  #           オブジェクトのセットを指定します。最大4つまで設定可能です。
  # 関連機能: AppStream 2.0 プライベート接続
  #   インターフェースVPCエンドポイントを使用して、インターネットを経由せずに
  #   ストリーミングセッションに接続できます。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/private-access.html
  access_endpoint {
    # endpoint_type (Required)
    # 設定内容: インターフェースエンドポイントのタイプを指定します。
    # 設定可能な値:
    #   - "STREAMING": ストリーミング用エンドポイント
    # 参考: https://docs.aws.amazon.com/appstream2/latest/APIReference/API_AccessEndpoint.html
    endpoint_type = "STREAMING"

    # vpce_id (Optional)
    # 設定内容: インターフェースVPCエンドポイントのIDを指定します。
    # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-xxxxxxxxxxxxxxxxx）
    vpce_id = null
  }

  #-------------------------------------------------------------
  # ドメイン参加設定
  #-------------------------------------------------------------

  # domain_join_info (Optional)
  # 設定内容: イメージビルダーをMicrosoft Active Directoryドメインに参加させるための
  #           ディレクトリ名と組織単位（OU）の設定を指定します。
  # 関連機能: AppStream 2.0 Active Directory統合
  #   Active Directoryドメインに参加することで、ユーザー認証や
  #   グループポリシーを活用できます。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/active-directory.html
  domain_join_info {
    # directory_name (Optional)
    # 設定内容: ディレクトリの完全修飾名を指定します。
    # 設定可能な値: 完全修飾ドメイン名（例: corp.example.com）
    directory_name = null

    # organizational_unit_distinguished_name (Optional)
    # 設定内容: コンピューターアカウントの組織単位（OU）の識別名を指定します。
    # 設定可能な値: OU識別名（例: OU=Computers,OU=MyCompany,DC=corp,DC=example,DC=com）
    organizational_unit_distinguished_name = null
  }

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
    Name        = "my-image-builder"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AppStreamイメージビルダーのAmazon Resource Name (ARN)
#
# - created_time: イメージビルダーが作成された日時
#                 （UTC、RFC 3339拡張形式）
#
# - id: イメージビルダーの名前（name属性と同じ値）
#
# - state: イメージビルダーの状態
#          有効な値についてはAWSドキュメントを参照:
#          https://docs.aws.amazon.com/appstream2/latest/APIReference/API_ImageBuilder.html#AppStream2-Type-ImageBuilder-State
#          - PENDING: 保留中
#          - UPDATING_AGENT: エージェント更新中
#          - RUNNING: 実行中
#          - STOPPING: 停止中
#          - STOPPED: 停止済み
#          - REBOOTING: 再起動中
#          - SNAPSHOTTING: スナップショット作成中
#          - DELETING: 削除中
#          - FAILED: 失敗
#          - UPDATING: 更新中
#---------------------------------------------------------------
