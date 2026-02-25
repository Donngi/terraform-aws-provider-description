#---------------------------------------------------------------
# Amazon SageMaker Model
#---------------------------------------------------------------
#
# Amazon SageMaker AIのモデルをプロビジョニングするリソースです。
# 推論コードと関連するアーティファクトを格納したコンテナを定義し、
# エンドポイントやバッチ変換ジョブで使用できるモデルを作成します。
# 単一コンテナモデル（primary_container）と複数コンテナの
# 推論パイプライン（container）の両方に対応します。
#
# AWS公式ドキュメント:
#   - SageMaker AIモデル作成: https://docs.aws.amazon.com/sagemaker/latest/dg/realtime-endpoints-deployment.html
#   - コンテナ定義: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_ContainerDefinition.html
#   - プライベートDockerレジストリ: https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-containers-inference-private.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_model
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_model" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: モデルの名前を指定します。
  # 設定可能な値: 1-63文字の英数字・ハイフン
  # 省略時: Terraformがランダムな一意の名前を生成します。
  name = "my-sagemaker-model"

  # execution_role_arn (Required)
  # 設定内容: SageMaker AIがモデルアーティファクトおよびDockerイメージへ
  #           アクセスするために引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html
  execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ネットワーク分離設定
  #-------------------------------------------------------------

  # enable_network_isolation (Optional)
  # 設定内容: コンテナのネットワーク分離を有効にするかを指定します。
  #           有効にするとコンテナはインターネットへの呼び出しを行えなくなります。
  # 設定可能な値:
  #   - true: ネットワーク分離を有効化。コンテナは受信・送信ネットワーク呼び出しを行えません
  #   - false: ネットワーク分離を無効化
  # 省略時: false
  enable_network_isolation = false

  #-------------------------------------------------------------
  # プライマリコンテナ設定
  #-------------------------------------------------------------

  # primary_container (Optional)
  # 設定内容: 単一モデルエンドポイントの推論コードを含むプライマリDockerコンテナの
  #           設定ブロックです。container引数が指定されていない場合は必須です。
  # 注意: primary_container と container はどちらか一方を指定します。
  primary_container {

    # image (Optional)
    # 設定内容: Amazon ECRまたはVPCからアクセス可能なDockerレジストリに
    #           格納された推論コードイメージのパスを指定します。
    # 設定可能な値: 有効なECRイメージURIまたはDockerレジストリパス（最大255文字）
    image = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-inference-image:latest"

    # container_hostname (Optional)
    # 設定内容: 推論パイプラインにおけるコンテナを一意に識別するDNSホスト名を指定します。
    # 設定可能な値: 1-63文字。英数字とハイフンが使用可能（パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}）
    container_hostname = "primary"

    # model_data_url (Optional)
    # 設定内容: モデルアーティファクトが格納されているS3の場所のURLを指定します。
    #           単一の圧縮tarアーカイブ（.tar.gz）を指す必要があります。
    # 設定可能な値: 有効なS3 URL（例: s3://bucket/path/model.tar.gz）
    # 注意: model_data_source と排他的。どちらか一方を指定してください。
    model_data_url = "s3://my-bucket/my-model/model.tar.gz"

    # mode (Optional)
    # 設定内容: コンテナがホストするモデルの種類を指定します。
    # 設定可能な値:
    #   - "SingleModel" (デフォルト): 単一モデルをホスト
    #   - "MultiModel": 複数モデルをホスト（マルチモデルエンドポイント用）
    mode = "SingleModel"

    # environment (Optional)
    # 設定内容: Dockerコンテナに設定する環境変数のマップを指定します。
    # 設定可能な値: 文字列のキーバリューマップ（全キーと値の合計が32KBまで）
    environment = {
      SAGEMAKER_PROGRAM        = "inference.py"
      SAGEMAKER_SUBMIT_DIRECTORY = "s3://my-bucket/my-model/code.tar.gz"
    }

    # model_package_name (Optional)
    # 設定内容: モデルの作成に使用するモデルパッケージのARNまたは名前を指定します。
    # 設定可能な値: モデルパッケージのARN（例: arn:aws:sagemaker:...:model-package/...）または名前
    model_package_name = null

    # inference_specification_name (Optional)
    # 設定内容: モデルパッケージバージョンの推論仕様名を指定します。
    # 設定可能な値: 1-63文字の英数字・ハイフン
    inference_specification_name = null

    #-------------------------------------------------------------
    # イメージ設定
    #-------------------------------------------------------------

    # image_config (Optional)
    # 設定内容: モデルコンテナがAmazon ECRかVPCからアクセス可能なプライベートDockerレジストリに
    #           あるかどうかを指定する設定ブロックです。
    # 関連機能: プライベートDockerレジストリサポート
    #   VPC内のプライベートDockerレジストリからモデルイメージを取得する場合に設定します。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-containers-inference-private.html
    image_config {

      # repository_access_mode (Required)
      # 設定内容: モデルコンテナがAmazon ECRにあるかVPCからアクセス可能な
      #           プライベートDockerレジストリにあるかを指定します。
      # 設定可能な値:
      #   - "Platform": Amazon ECRからイメージを取得
      #   - "Vpc": VPCからアクセス可能なプライベートDockerレジストリからイメージを取得
      repository_access_mode = "Platform"

      # repository_auth_config (Optional)
      # 設定内容: プライベートDockerレジストリの認証設定ブロックです。
      #           repository_access_mode が "Vpc" かつ認証が必要な場合のみ指定します。
      repository_auth_config {

        # repository_credentials_provider_arn (Required)
        # 設定内容: プライベートDockerレジストリへの認証情報を提供するAWS Lambda関数のARNを指定します。
        # 設定可能な値: 有効なLambda関数ARN
        # 参考: https://docs.aws.amazon.com/lambda/latest/dg/getting-started-create-function.html
        repository_credentials_provider_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:registry-credentials-provider"
      }
    }

    #-------------------------------------------------------------
    # モデルデータソース設定（非圧縮モデル用）
    #-------------------------------------------------------------

    # model_data_source (Optional)
    # 設定内容: デプロイするMLモデルデータの場所を指定する設定ブロックです。
    #           非圧縮モデルのデプロイに使用します。
    # 注意: model_data_url と排他的。どちらか一方を指定してください。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/large-model-inference-uncompressed.html
    model_data_source {

      # s3_data_source (Required)
      # 設定内容: デプロイするモデルデータのS3の場所を指定する設定ブロックです。
      s3_data_source {

        # s3_uri (Required)
        # 設定内容: デプロイするモデルデータのS3パスを指定します。
        # 設定可能な値: 有効なS3 URI（例: s3://bucket/prefix/）
        s3_uri = "s3://my-bucket/uncompressed-model/"

        # s3_data_type (Required)
        # 設定内容: デプロイするモデルデータの種類を指定します。
        # 設定可能な値:
        #   - "S3Object": 単一S3オブジェクト
        #   - "S3Prefix": S3プレフィックス（ディレクトリ）
        s3_data_type = "S3Prefix"

        # compression_type (Required)
        # 設定内容: モデルデータの圧縮方式を指定します。
        # 設定可能な値:
        #   - "None": 非圧縮
        #   - "Gzip": Gzip圧縮
        compression_type = "None"

        # model_access_config (Optional)
        # 設定内容: MLモデルのアクセス設定ファイルを指定する設定ブロックです。
        #           EULAへの同意が必要なモデルを使用する場合に指定します。
        model_access_config {

          # accept_eula (Required)
          # 設定内容: モデルのエンドユーザーライセンス契約（EULA）への同意を指定します。
          # 設定可能な値:
          #   - true: EULAに同意。このモデルを必要とするEULAを受け入れる場合は true を設定する必要があります
          #   - false: EULAに不同意
          # 注意: このモデルをダウンロードまたは使用する前に、適用されるライセンス条項を
          #       確認し、ユースケースに適していることを確認する責任があります。
          accept_eula = true
        }
      }
    }

    #-------------------------------------------------------------
    # 追加モデルデータソース設定
    #-------------------------------------------------------------

    # additional_model_data_source (Optional)
    # 設定内容: model_data_source で指定されたデータに加えて、モデルが利用可能な
    #           追加データソースを指定する設定ブロックです。最大5件まで指定可能です。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_ContainerDefinition.html
    additional_model_data_source {

      # channel_name (Required)
      # 設定内容: 追加モデルデータソースオブジェクトのカスタム名を指定します。
      #           /opt/ml/additional-model-data-sources/<channel_name>/ に格納されます。
      # 設定可能な値: 文字列
      channel_name = "additional-data"

      # s3_data_source (Required)
      # 設定内容: デプロイする追加モデルデータのS3の場所を指定する設定ブロックです。
      s3_data_source {

        # s3_uri (Required)
        # 設定内容: 追加モデルデータのS3パスを指定します。
        # 設定可能な値: 有効なS3 URI
        s3_uri = "s3://my-bucket/additional-data/"

        # s3_data_type (Required)
        # 設定内容: 追加モデルデータの種類を指定します。
        # 設定可能な値:
        #   - "S3Object": 単一S3オブジェクト
        #   - "S3Prefix": S3プレフィックス（ディレクトリ）
        s3_data_type = "S3Prefix"

        # compression_type (Required)
        # 設定内容: 追加モデルデータの圧縮方式を指定します。
        # 設定可能な値:
        #   - "None": 非圧縮
        #   - "Gzip": Gzip圧縮
        compression_type = "None"

        # model_access_config (Optional)
        # 設定内容: 追加MLモデルのアクセス設定ファイルを指定する設定ブロックです。
        model_access_config {

          # accept_eula (Required)
          # 設定内容: モデルのエンドユーザーライセンス契約（EULA）への同意を指定します。
          # 設定可能な値:
          #   - true: EULAに同意
          #   - false: EULAに不同意
          accept_eula = true
        }
      }
    }

    #-------------------------------------------------------------
    # マルチモデル設定
    #-------------------------------------------------------------

    # multi_model_config (Optional)
    # 設定内容: マルチモデルエンドポイントの追加設定ブロックです。
    # 関連機能: SageMaker マルチモデルエンドポイント
    #   1つのエンドポイントで複数のモデルをホストし、リソースを効率的に共有する機能。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/multi-model-endpoints.html
    multi_model_config {

      # model_cache_setting (Optional)
      # 設定内容: マルチモデルエンドポイントのモデルキャッシュを有効にするかを指定します。
      # 設定可能な値:
      #   - "Enabled" (デフォルト): モデルをキャッシュ。毎回メモリにロードせず再利用
      #   - "Disabled": モデルキャッシュを無効化。多数のモデルを低頻度で呼び出す場合に有効
      model_cache_setting = "Enabled"
    }
  }

  #-------------------------------------------------------------
  # マルチコンテナ設定（推論パイプライン用）
  #-------------------------------------------------------------

  # container (Optional)
  # 設定内容: 推論パイプライン用の複数コンテナを定義する設定ブロックです。
  #           primary_container が指定されていない場合は必須です。
  #           コンテナはシリアルに実行され、推論パイプラインを形成します。
  # 注意: primary_container と container はどちらか一方を指定します。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipelines.html
  container {

    # image (Optional)
    # 設定内容: Amazon ECRまたはVPCからアクセス可能なDockerレジストリに
    #           格納された推論コードイメージのパスを指定します。
    # 設定可能な値: 有効なECRイメージURIまたはDockerレジストリパス（最大255文字）
    image = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/preprocessing:latest"

    # container_hostname (Optional)
    # 設定内容: 推論パイプラインにおけるコンテナを一意に識別するDNSホスト名を指定します。
    #           ロギングとメトリクスのために使用されます。
    # 設定可能な値: 1-63文字。英数字とハイフンが使用可能
    container_hostname = "preprocessing"

    # model_data_url (Optional)
    # 設定内容: モデルアーティファクトが格納されているS3の場所のURLを指定します。
    # 設定可能な値: 有効なS3 URL（例: s3://bucket/path/model.tar.gz）
    # 注意: model_data_source と排他的。どちらか一方を指定してください。
    model_data_url = "s3://my-bucket/preprocessing/model.tar.gz"

    # mode (Optional)
    # 設定内容: コンテナがホストするモデルの種類を指定します。
    # 設定可能な値:
    #   - "SingleModel" (デフォルト): 単一モデルをホスト
    #   - "MultiModel": 複数モデルをホスト
    mode = "SingleModel"

    # environment (Optional)
    # 設定内容: Dockerコンテナに設定する環境変数のマップを指定します。
    # 設定可能な値: 文字列のキーバリューマップ（全キーと値の合計が32KBまで）
    environment = {}

    # model_package_name (Optional)
    # 設定内容: モデルの作成に使用するモデルパッケージのARNまたは名前を指定します。
    # 設定可能な値: モデルパッケージのARNまたは名前
    model_package_name = null

    # inference_specification_name (Optional)
    # 設定内容: モデルパッケージバージョンの推論仕様名を指定します。
    # 設定可能な値: 1-63文字の英数字・ハイフン
    inference_specification_name = null

    #-------------------------------------------------------------
    # イメージ設定
    #-------------------------------------------------------------

    # image_config (Optional)
    # 設定内容: モデルコンテナがAmazon ECRかVPCからアクセス可能なプライベートDockerレジストリに
    #           あるかどうかを指定する設定ブロックです。
    image_config {

      # repository_access_mode (Required)
      # 設定内容: モデルコンテナがAmazon ECRにあるかプライベートDockerレジストリにあるかを指定します。
      # 設定可能な値:
      #   - "Platform": Amazon ECRからイメージを取得
      #   - "Vpc": VPCからアクセス可能なプライベートDockerレジストリからイメージを取得
      repository_access_mode = "Platform"

      # repository_auth_config (Optional)
      # 設定内容: プライベートDockerレジストリの認証設定ブロックです。
      #           repository_access_mode が "Vpc" かつ認証が必要な場合のみ指定します。
      repository_auth_config {

        # repository_credentials_provider_arn (Required)
        # 設定内容: プライベートDockerレジストリへの認証情報を提供するAWS Lambda関数のARNを指定します。
        # 設定可能な値: 有効なLambda関数ARN
        repository_credentials_provider_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:registry-credentials-provider"
      }
    }

    #-------------------------------------------------------------
    # モデルデータソース設定（非圧縮モデル用）
    #-------------------------------------------------------------

    # model_data_source (Optional)
    # 設定内容: デプロイするMLモデルデータの場所を指定する設定ブロックです。
    # 注意: model_data_url と排他的。どちらか一方を指定してください。
    model_data_source {

      # s3_data_source (Required)
      # 設定内容: デプロイするモデルデータのS3の場所を指定する設定ブロックです。
      s3_data_source {

        # s3_uri (Required)
        # 設定内容: デプロイするモデルデータのS3パスを指定します。
        # 設定可能な値: 有効なS3 URI
        s3_uri = "s3://my-bucket/pipeline-model/"

        # s3_data_type (Required)
        # 設定内容: デプロイするモデルデータの種類を指定します。
        # 設定可能な値:
        #   - "S3Object": 単一S3オブジェクト
        #   - "S3Prefix": S3プレフィックス（ディレクトリ）
        s3_data_type = "S3Prefix"

        # compression_type (Required)
        # 設定内容: モデルデータの圧縮方式を指定します。
        # 設定可能な値:
        #   - "None": 非圧縮
        #   - "Gzip": Gzip圧縮
        compression_type = "None"

        # model_access_config (Optional)
        # 設定内容: MLモデルのアクセス設定ファイルを指定する設定ブロックです。
        model_access_config {

          # accept_eula (Required)
          # 設定内容: モデルのエンドユーザーライセンス契約（EULA）への同意を指定します。
          # 設定可能な値:
          #   - true: EULAに同意
          #   - false: EULAに不同意
          accept_eula = true
        }
      }
    }

    #-------------------------------------------------------------
    # 追加モデルデータソース設定
    #-------------------------------------------------------------

    # additional_model_data_source (Optional)
    # 設定内容: model_data_source で指定されたデータに加えて利用可能な
    #           追加データソースを指定する設定ブロックです。最大5件まで指定可能です。
    additional_model_data_source {

      # channel_name (Required)
      # 設定内容: 追加モデルデータソースオブジェクトのカスタム名を指定します。
      # 設定可能な値: 文字列
      channel_name = "additional-data"

      # s3_data_source (Required)
      # 設定内容: 追加モデルデータのS3の場所を指定する設定ブロックです。
      s3_data_source {

        # s3_uri (Required)
        # 設定内容: 追加モデルデータのS3パスを指定します。
        # 設定可能な値: 有効なS3 URI
        s3_uri = "s3://my-bucket/additional-data/"

        # s3_data_type (Required)
        # 設定内容: 追加モデルデータの種類を指定します。
        # 設定可能な値:
        #   - "S3Object": 単一S3オブジェクト
        #   - "S3Prefix": S3プレフィックス（ディレクトリ）
        s3_data_type = "S3Prefix"

        # compression_type (Required)
        # 設定内容: 追加モデルデータの圧縮方式を指定します。
        # 設定可能な値:
        #   - "None": 非圧縮
        #   - "Gzip": Gzip圧縮
        compression_type = "None"

        # model_access_config (Optional)
        # 設定内容: 追加MLモデルのアクセス設定ファイルを指定する設定ブロックです。
        model_access_config {

          # accept_eula (Required)
          # 設定内容: モデルのエンドユーザーライセンス契約（EULA）への同意を指定します。
          # 設定可能な値:
          #   - true: EULAに同意
          #   - false: EULAに不同意
          accept_eula = true
        }
      }
    }

    #-------------------------------------------------------------
    # マルチモデル設定
    #-------------------------------------------------------------

    # multi_model_config (Optional)
    # 設定内容: マルチモデルエンドポイントの追加設定ブロックです。
    multi_model_config {

      # model_cache_setting (Optional)
      # 設定内容: マルチモデルエンドポイントのモデルキャッシュを有効にするかを指定します。
      # 設定可能な値:
      #   - "Enabled" (デフォルト): モデルをキャッシュ
      #   - "Disabled": モデルキャッシュを無効化
      model_cache_setting = "Enabled"
    }
  }

  #-------------------------------------------------------------
  # 推論実行設定（マルチコンテナエンドポイント用）
  #-------------------------------------------------------------

  # inference_execution_config (Optional)
  # 設定内容: マルチコンテナエンドポイントにおけるコンテナの呼び出し方法を
  #           指定する設定ブロックです。
  # 関連機能: SageMaker 推論パイプライン
  #   複数コンテナが順番にリクエストを処理する推論パイプラインの実行方式を制御します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/inference-pipelines.html
  inference_execution_config {

    # mode (Required)
    # 設定内容: マルチコンテナエンドポイントにおけるコンテナの実行モードを指定します。
    # 設定可能な値:
    #   - "Serial": コンテナが順番に実行される推論パイプラインモード
    #   - "Direct": 特定のコンテナに直接ルーティングするモード
    mode = "Serial"
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Optional)
  # 設定内容: モデルコンテナをVPC内のリソースに接続するためのネットワーク設定ブロックです。
  # 関連機能: SageMaker VPCアクセス
  #   VPC内のプライベートリソースへのアクセスや、インターネットトラフィックの制限が可能です。
  #   プライベートDockerレジストリを使用する場合は vpc_config の設定が必要です。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-containers-inference-private.html
  vpc_config {

    # security_group_ids (Required)
    # 設定内容: トレーニングジョブまたはモデルに適用するセキュリティグループIDのリストを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    security_group_ids = ["sg-12345678"]

    # subnets (Required)
    # 設定内容: トレーニングジョブまたはモデルに接続するVPC内のサブネットIDのリストを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    subnets = ["subnet-12345678", "subnet-87654321"]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "my-sagemaker-model"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: モデルのAmazon Resource Name (ARN)
# - name: モデルの名前
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
