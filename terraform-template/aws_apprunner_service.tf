#---------------------------------------------------------------
# AWS App Runner Service
#---------------------------------------------------------------
#
# AWS App Runnerサービスをプロビジョニングするリソースです。
# App Runnerは、コンテナイメージまたはソースコードリポジトリから、
# 自動的にスケールするWebサービスを構築・デプロイ・実行するフルマネージドサービスです。
#
# AWS公式ドキュメント:
#   - App Runnerとは: https://docs.aws.amazon.com/apprunner/latest/dg/what-is-apprunner.html
#   - App Runnerアーキテクチャと概念: https://docs.aws.amazon.com/apprunner/latest/dg/architecture.html
#   - サービスの作成: https://docs.aws.amazon.com/apprunner/latest/dg/manage-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_service" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # service_name (Required, Forces new resource)
  # 設定内容: App Runnerサービスの名前を指定します。
  # 設定可能な値: 4〜40文字の文字列。英数字、ハイフン、アンダースコアが使用可能。
  # 注意: リソース作成後は変更できません。
  service_name = "my-apprunner-service"

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
  # オートスケーリング設定
  #-------------------------------------------------------------

  # auto_scaling_configuration_arn (Optional)
  # 設定内容: サービスに関連付けるApp Runnerオートスケーリング設定リソースのARNを指定します。
  # 設定可能な値: 有効なApp Runnerオートスケーリング設定ARN
  # 省略時: App Runnerがデフォルトのオートスケーリング設定の最新リビジョンを関連付けます。
  # 関連機能: App Runner Auto Scaling
  #   リクエスト量に基づいてコンテナインスタンス数を自動的にスケーリング。
  #   aws_apprunner_auto_scaling_configuration_versionリソースで設定を定義可能。
  auto_scaling_configuration_arn = null

  #-------------------------------------------------------------
  # ソース設定 (必須)
  #-------------------------------------------------------------

  # source_configuration (Required)
  # 設定内容: App Runnerサービスにデプロイするソースを指定します。
  # コードリポジトリまたはイメージリポジトリのいずれかを指定できます。
  source_configuration {

    # auto_deployments_enabled (Optional)
    # 設定内容: ソースリポジトリからの継続的インテグレーションを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): リポジトリの変更（ソースコードのコミットまたは新しいイメージバージョン）ごとにデプロイを開始
    #   - false: 手動デプロイのみ
    auto_deployments_enabled = true

    #-----------------------------------------------------------
    # 認証設定 (Optional)
    #-----------------------------------------------------------

    # authentication_configuration (Optional)
    # 設定内容: 一部のソースリポジトリへのアクセス認証に必要なリソースを指定します。
    authentication_configuration {

      # access_role_arn (Optional)
      # 設定内容: App RunnerサービスがソースリポジトリにアクセスするためのIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      # 注意: ECRイメージリポジトリに必須（ECR Publicには不要）
      # 関連機能: App Runner ECRアクセス
      #   プライベートECRリポジトリからイメージをプルするには、必要なAmazon ECRアクション権限を
      #   含むアクセスロールを提供する必要があります。
      access_role_arn = null

      # connection_arn (Optional)
      # 設定内容: App Runnerサービスがソースリポジトリに接続するためのApp Runner接続のARNを指定します。
      # 設定可能な値: 有効なApp Runner接続ARN
      # 注意: GitHubおよびBitbucketコードリポジトリに必須
      # 関連機能: App Runner接続
      #   GitHubやBitbucketとの接続を確立し、プライベートリポジトリからコードをデプロイ可能。
      #   aws_apprunner_connectionリソースで作成。
      connection_arn = null
    }

    #-----------------------------------------------------------
    # コードリポジトリ設定 (code_repositoryまたはimage_repositoryのいずれかを指定)
    #-----------------------------------------------------------

    # code_repository (Optional)
    # 設定内容: ソースコードリポジトリの設定を指定します。
    # 注意: image_repositoryと排他的（どちらか一方のみ指定可能）
    code_repository {

      # repository_url (Required)
      # 設定内容: ソースコードを含むリポジトリの場所を指定します。
      # 設定可能な値: 有効なGitHubまたはBitbucketリポジトリURL
      # 例: "https://github.com/example/my-app"
      repository_url = "https://github.com/example/my-app"

      # source_directory (Optional)
      # 設定内容: ソースコードと設定ファイルが格納されているディレクトリのパスを指定します。
      # 設定可能な値: リポジトリルートからの相対パス
      # 省略時: リポジトリのルートディレクトリをデフォルトとして使用
      # 注意: ビルドおよび開始コマンドもこのディレクトリから実行されます。
      source_directory = null

      # source_code_version (Required)
      # 設定内容: 使用するソースコードのバージョンを指定します。
      source_code_version {

        # type (Required)
        # 設定内容: バージョン識別子の種類を指定します。
        # 設定可能な値:
        #   - "BRANCH": Gitブランチを指定
        type = "BRANCH"

        # value (Required)
        # 設定内容: ソースコードバージョンの値を指定します。
        # 設定可能な値: type=BRANCHの場合はブランチ名（例: "main", "develop"）
        value = "main"
      }

      # code_configuration (Optional)
      # 設定内容: ソースコードリポジトリからサービスをビルド・実行するための設定を指定します。
      code_configuration {

        # configuration_source (Required)
        # 設定内容: App Runner設定のソースを指定します。
        # 設定可能な値:
        #   - "REPOSITORY": ソースコードリポジトリ内のapprunner.yamlから設定を読み取り、
        #                   code_configuration_valuesパラメータを無視
        #   - "API": code_configuration_valuesで提供された設定値を使用し、
        #            リポジトリ内のapprunner.yamlを無視
        configuration_source = "API"

        # code_configuration_values (Optional)
        # 設定内容: App Runnerサービスをビルド・実行するための基本設定を指定します。
        # 注意: configuration_source=APIの場合に使用。apprunner.yamlファイルなしで
        #       App Runnerサービスを素早く起動する場合に使用します。
        code_configuration_values {

          # runtime (Required)
          # 設定内容: App Runnerサービスをビルド・実行するためのランタイム環境タイプを指定します。
          # 設定可能な値:
          #   - "PYTHON_3": Python 3
          #   - "NODEJS_12": Node.js 12
          #   - "NODEJS_14": Node.js 14
          #   - "NODEJS_16": Node.js 16
          #   - "CORRETTO_8": Amazon Corretto 8 (Java 8)
          #   - "CORRETTO_11": Amazon Corretto 11 (Java 11)
          #   - "GO_1": Go 1
          #   - "DOTNET_6": .NET 6
          #   - "PHP_81": PHP 8.1
          #   - "RUBY_31": Ruby 3.1
          runtime = "PYTHON_3"

          # build_command (Optional)
          # 設定内容: アプリケーションをビルドするためにApp Runnerが実行するコマンドを指定します。
          # 設定可能な値: 有効なシェルコマンド
          # 例: "pip install -r requirements.txt"
          build_command = "pip install -r requirements.txt"

          # start_command (Optional)
          # 設定内容: アプリケーションを開始するためにApp Runnerが実行するコマンドを指定します。
          # 設定可能な値: 有効なシェルコマンド
          # 例: "python app.py"
          start_command = "python app.py"

          # port (Optional)
          # 設定内容: アプリケーションがリッスンするポートを指定します。
          # 設定可能な値: ポート番号を文字列で指定
          # 省略時: "8080"
          port = "8080"

          # runtime_environment_variables (Optional)
          # 設定内容: App Runnerサービスで利用可能な環境変数を指定します。
          # 設定可能な値: キーと値のペアのマップ
          # 注意: "AWSAPPRUNNER"で始まるキーはシステム予約のため使用不可
          runtime_environment_variables = {
            ENV = "production"
          }

          # runtime_environment_secrets (Optional)
          # 設定内容: サービスで環境変数として利用可能なシークレットとパラメータを指定します。
          # 設定可能な値: キー（環境変数名）と値（AWS Secrets ManagerのシークレットARN
          #               またはSSM Parameter StoreのパラメータARN）のマップ
          # 注意: キーは環境での任意の名前（Secrets ManagerやSSMの名前と一致する必要なし）
          runtime_environment_secrets = {
            # DATABASE_PASSWORD = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:my-secret"
          }
        }
      }
    }

    #-----------------------------------------------------------
    # イメージリポジトリ設定 (code_repositoryまたはimage_repositoryのいずれかを指定)
    #-----------------------------------------------------------

    # image_repository (Optional)
    # 設定内容: ソースイメージリポジトリの設定を指定します。
    # 注意: code_repositoryと排他的（どちらか一方のみ指定可能）
    # image_repository {
    #
    #   # image_identifier (Required)
    #   # 設定内容: イメージの識別子を指定します。
    #   # 設定可能な値: Amazon ECRの場合はイメージ名（URI形式）
    #   # 例: "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-app:latest"
    #   #     "public.ecr.aws/aws-containers/hello-app-runner:latest"
    #   image_identifier = "public.ecr.aws/aws-containers/hello-app-runner:latest"
    #
    #   # image_repository_type (Required)
    #   # 設定内容: イメージリポジトリの種類を指定します。
    #   # 設定可能な値:
    #   #   - "ECR": Amazon Elastic Container Registry（プライベート）
    #   #   - "ECR_PUBLIC": Amazon ECR Public
    #   image_repository_type = "ECR_PUBLIC"
    #
    #   # image_configuration (Optional)
    #   # 設定内容: イメージを実行するための設定を指定します。
    #   image_configuration {
    #
    #     # port (Optional)
    #     # 設定内容: アプリケーションがリッスンするポートを指定します。
    #     # 設定可能な値: ポート番号を文字列で指定
    #     # 省略時: "8080"
    #     port = "8080"
    #
    #     # start_command (Optional)
    #     # 設定内容: アプリケーションを開始するためにApp Runnerが実行するコマンドを指定します。
    #     # 設定可能な値: 有効なシェルコマンド
    #     # 注意: 指定すると、Dockerイメージのデフォルト開始コマンドをオーバーライドします。
    #     start_command = null
    #
    #     # runtime_environment_variables (Optional)
    #     # 設定内容: App Runnerサービスで利用可能な環境変数を指定します。
    #     # 設定可能な値: キーと値のペアのマップ
    #     # 注意: "AWSAPPRUNNER"で始まるキーはシステム予約のため使用不可
    #     runtime_environment_variables = {}
    #
    #     # runtime_environment_secrets (Optional)
    #     # 設定内容: サービスで環境変数として利用可能なシークレットとパラメータを指定します。
    #     # 設定可能な値: キー（環境変数名）と値（AWS Secrets ManagerのシークレットARN
    #     #               またはSSM Parameter StoreのパラメータARN）のマップ
    #     runtime_environment_secrets = {}
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 暗号化設定 (Optional)
  #-------------------------------------------------------------

  # encryption_configuration (Optional, Forces new resource)
  # 設定内容: App Runnerがソースリポジトリのコピーとサービスログを暗号化するための
  #           カスタム暗号化キーを指定します。
  # 省略時: App RunnerはAWSマネージドCMKを使用します。
  # encryption_configuration {
  #
  #   # kms_key (Required)
  #   # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
  #   # 設定可能な値: 有効なKMSキーARN
  #   kms_key = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # }

  #-------------------------------------------------------------
  # ヘルスチェック設定 (Optional)
  #-------------------------------------------------------------

  # health_check_configuration (Optional)
  # 設定内容: サービスの正常性を監視するためにAWS App Runnerが実行する
  #           ヘルスチェックの設定を指定します。
  health_check_configuration {

    # protocol (Optional)
    # 設定内容: App Runnerがヘルスチェックに使用するIPプロトコルを指定します。
    # 設定可能な値:
    #   - "TCP" (デフォルト): TCPポートへの接続チェック
    #   - "HTTP": HTTPリクエストによるチェック（pathで指定したパスにリクエスト）
    protocol = "TCP"

    # path (Optional)
    # 設定内容: ヘルスチェックリクエストを送信するURLパスを指定します。
    # 設定可能な値: 0〜51200文字の文字列
    # 省略時: "/"
    # 注意: protocol="HTTP"の場合のみ使用されます。
    path = "/"

    # interval (Optional)
    # 設定内容: ヘルスチェック間の時間間隔（秒）を指定します。
    # 設定可能な値: 1〜20
    # 省略時: 5
    interval = 5

    # timeout (Optional)
    # 設定内容: ヘルスチェックが失敗と判断するまでの待機時間（秒）を指定します。
    # 設定可能な値: 1〜20
    # 省略時: 2
    timeout = 2

    # healthy_threshold (Optional)
    # 設定内容: サービスが正常と判断されるまでに連続して成功する必要があるチェック回数を指定します。
    # 設定可能な値: 1〜20
    # 省略時: 1
    healthy_threshold = 1

    # unhealthy_threshold (Optional)
    # 設定内容: サービスが異常と判断されるまでに連続して失敗する必要があるチェック回数を指定します。
    # 設定可能な値: 1〜20
    # 省略時: 5
    unhealthy_threshold = 5
  }

  #-------------------------------------------------------------
  # インスタンス設定 (Optional)
  #-------------------------------------------------------------

  # instance_configuration (Optional)
  # 設定内容: App Runnerサービスのインスタンス（スケーリングユニット）の
  #           ランタイム設定を指定します。
  instance_configuration {

    # cpu (Optional)
    # 設定内容: 各インスタンスに予約されるCPUユニット数を指定します。
    # 設定可能な値:
    #   - "256" または "0.25 vCPU": 0.25 vCPU
    #   - "512" または "0.5 vCPU": 0.5 vCPU
    #   - "1024" (デフォルト) または "1 vCPU": 1 vCPU
    #   - "2048" または "2 vCPU": 2 vCPU
    #   - "4096" または "4 vCPU": 4 vCPU
    cpu = "1024"

    # memory (Optional)
    # 設定内容: 各インスタンスに予約されるメモリ量を指定します。
    # 設定可能な値:
    #   - "512" または "0.5 GB": 512 MB
    #   - "1024" または "1 GB": 1024 MB
    #   - "2048" (デフォルト) または "2 GB": 2048 MB
    #   - "3072" または "3 GB": 3072 MB
    #   - "4096" または "4 GB": 4096 MB
    #   - "6144" または "6 GB": 6144 MB
    #   - "8192" または "8 GB": 8192 MB
    #   - "10240" または "10 GB": 10240 MB
    #   - "12288" または "12 GB": 12288 MB
    memory = "2048"

    # instance_role_arn (Optional)
    # 設定内容: App Runnerサービスに権限を提供するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 関連機能: インスタンスロール
    #   コードがAWS APIを呼び出す際に必要な権限を提供します。
    #   例: S3バケットへのアクセス、DynamoDBへの読み書きなど。
    instance_role_arn = null
  }

  #-------------------------------------------------------------
  # ネットワーク設定 (Optional)
  #-------------------------------------------------------------

  # network_configuration (Optional)
  # 設定内容: App Runnerサービスが実行するWebアプリケーションのネットワーク
  #           トラフィックに関連する設定を指定します。
  network_configuration {

    # ip_address_type (Optional)
    # 設定内容: 受信パブリックネットワーク設定のIPバージョンを指定します。
    # 設定可能な値:
    #   - "IPV4" (デフォルト): IPv4のみ
    #   - "DUAL_STACK": IPv4とIPv6の両方
    ip_address_type = "IPV4"

    # ingress_configuration (Optional)
    # 設定内容: 受信ネットワークトラフィックのネットワーク設定を指定します。
    ingress_configuration {

      # is_publicly_accessible (Optional)
      # 設定内容: App Runnerサービスにパブリックにアクセス可能かどうかを指定します。
      # 設定可能な値:
      #   - true: サービスにパブリックにアクセス可能
      #   - false: Amazon VPC内からのみプライベートにアクセス可能
      # 関連機能: VPC Ingress Connection
      #   falseに設定した場合、aws_apprunner_vpc_ingress_connectionを使用して
      #   VPCからのプライベートアクセスを設定できます。
      is_publicly_accessible = true
    }

    # egress_configuration (Optional)
    # 設定内容: 送信メッセージトラフィックのネットワーク設定を指定します。
    egress_configuration {

      # egress_type (Optional)
      # 設定内容: 送信トラフィックの種類を指定します。
      # 設定可能な値:
      #   - "DEFAULT": パブリックインターネット経由の送信トラフィック
      #   - "VPC": VPCコネクタを通じたVPC経由の送信トラフィック
      egress_type = "DEFAULT"

      # vpc_connector_arn (Optional)
      # 設定内容: App Runnerサービスに関連付けるVPCコネクタのARNを指定します。
      # 設定可能な値: 有効なApp Runner VPCコネクタARN
      # 注意: egress_type="VPC"の場合のみ有効
      # 関連機能: VPCコネクタ
      #   App RunnerサービスがVPC内のリソース（RDS、ElastiCacheなど）に
      #   アクセスするために使用します。aws_apprunner_vpc_connectorリソースで作成。
      vpc_connector_arn = null
    }
  }

  #-------------------------------------------------------------
  # オブザーバビリティ設定 (Optional)
  #-------------------------------------------------------------

  # observability_configuration (Optional)
  # 設定内容: サービスのオブザーバビリティ設定を指定します。
  # 関連機能: X-Rayトレーシング
  #   App RunnerサービスでAWS X-Rayトレーシングを有効にし、
  #   リクエストの追跡と分析が可能になります。
  # observability_configuration {
  #
  #   # observability_enabled (Required)
  #   # 設定内容: オブザーバビリティ設定リソースをサービスに関連付けるかを指定します。
  #   # 設定可能な値:
  #   #   - true: オブザーバビリティ設定を有効化（observability_configuration_arnも指定）
  #   #   - false: オブザーバビリティ設定を無効化
  #   observability_enabled = true
  #
  #   # observability_configuration_arn (Optional)
  #   # 設定内容: サービスに関連付けるオブザーバビリティ設定のARNを指定します。
  #   # 設定可能な値: 有効なApp Runnerオブザーバビリティ設定ARN
  #   # 注意: observability_enabled=trueの場合のみ指定
  #   # 関連リソース: aws_apprunner_observability_configurationリソースで作成
  #   observability_configuration_arn = "arn:aws:apprunner:ap-northeast-1:123456789012:observabilityconfiguration/my-config/1/00000000000000000000000000000001"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-apprunner-service"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: App RunnerサービスのARN
#
# - service_id: App Runnerがこのサービスに生成した英数字のID。
#               AWSリージョン内で一意。
#
# - service_url: App Runnerがこのサービス用に生成したサブドメインURL。
#                このURLを使用してサービスのWebアプリケーションにアクセス可能。
#
# - status: App Runnerサービスの現在の状態。
#           CREATING, RUNNING, DELETING, DELETED, OPERATION_IN_PROGRESS など。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
