#---------------------------------------------------------------
# AWS X-Ray Sampling Rule
#---------------------------------------------------------------
#
# AWS X-Rayのサンプリングルールをプロビジョニングするリソースです。
# サンプリングルールは、X-Ray SDKやAWS Distro for OpenTelemetry（ADOT）が
# どのリクエストを記録するかを制御します。ルールには優先度、リザーバーサイズ、
# 固定レートなどを設定でき、トレースデータ量とコストを最適化できます。
#
# AWS公式ドキュメント:
#   - X-Rayサンプリングルールの設定: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-sampling.html
#   - X-Ray APIでのサンプリングルールの使用: https://docs.aws.amazon.com/xray/latest/devguide/xray-api-sampling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/xray_sampling_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_xray_sampling_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # rule_name (Optional)
  # 設定内容: サンプリングルールの名前を指定します。
  # 設定可能な値: 一意の文字列
  # 省略時: 名前なしのルールが作成されます。
  # 注意: ルール名はアカウント内で一意である必要があります。
  rule_name = "example-sampling-rule"

  # priority (Required)
  # 設定内容: サンプリングルールの優先度を指定します。
  # 設定可能な値: 1〜9999の整数
  # 関連機能: サンプリングルールの優先度
  #   サービスは優先度の昇順でルールを評価し、最初にマッチしたルールで
  #   サンプリングの判定を行います。数値が小さいほど優先度が高くなります。
  #   デフォルトルールの優先度は10000で、他のルールにマッチしないリクエストに適用されます。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-sampling.html
  priority = 9999

  # version (Required)
  # 設定内容: サンプリングルールフォーマットのバージョンを指定します。
  # 設定可能な値: 1（現在サポートされている唯一のバージョン）
  version = 1

  #-------------------------------------------------------------
  # サンプリングレート設定
  #-------------------------------------------------------------

  # reservoir_size (Required)
  # 設定内容: 固定レートを適用する前に、1秒あたりにサンプリングするリクエストの
  #          固定数を指定します。
  # 設定可能な値: 0以上の整数
  # 関連機能: リザーバー
  #   リザーバーはサービスが直接使用するのではなく、ルールを使用するすべての
  #   サービスに対して集合的に適用されます。X-Rayがリザーバーからクォータを
  #   各サービスインスタンスに均等に分配します。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-sampling.html
  reservoir_size = 1

  # fixed_rate (Required)
  # 設定内容: リザーバーが枯渇した後に、マッチしたリクエストをサンプリングする割合を
  #          指定します。
  # 設定可能な値: 0〜1の小数（0.0 = 0%, 1.0 = 100%）
  # 注意: コンソールでは0〜100のパーセンテージで設定しますが、
  #       Terraformでは0〜1の小数値で指定します。
  #   例: 5% = 0.05, 10% = 0.1, 100% = 1.0
  # 関連機能: 固定レート
  #   リザーバーで確保された分を超えるリクエストに対して、この割合でサンプリングを行います。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-sampling.html
  fixed_rate = 0.05

  #-------------------------------------------------------------
  # マッチング条件設定
  #-------------------------------------------------------------

  # service_name (Required)
  # 設定内容: セグメント内でサービスが自身を識別するために使用する名前にマッチさせます。
  # 設定可能な値: 文字列（ワイルドカード使用可能: "*"で0文字以上、"?"で1文字にマッチ）
  # 注意:
  #   - X-Ray SDK: レコーダーで設定したサービス名
  #   - Amazon API Gateway: "api-name/stage" の形式
  service_name = "*"

  # service_type (Required)
  # 設定内容: セグメント内でサービスが自身のタイプを識別するために使用するオリジンにマッチさせます。
  # 設定可能な値: 文字列（ワイルドカード使用可能）
  #   - "AWS::ElasticBeanstalk::Environment": Elastic Beanstalk環境
  #   - "AWS::EC2::Instance": EC2インスタンス
  #   - "AWS::ECS::Container": ECSコンテナ
  #   - "AWS::EKS::Container": EKSコンテナ
  #   - "AWS::APIGateway::Stage": API Gatewayステージ
  #   - "AWS::AppSync::GraphQLAPI": AppSync APIリクエスト
  #   - "AWS::StepFunctions::StateMachine": Step Functionsステートマシン
  #   - "*": すべてのサービスタイプにマッチ
  # 参考: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-sampling.html
  service_type = "*"

  # host (Required)
  # 設定内容: HTTPホストヘッダーのホスト名にマッチさせます。
  # 設定可能な値: 文字列（ワイルドカード使用可能）
  #   例: "*.example.com", "api.example.com", "*"
  host = "*"

  # http_method (Required)
  # 設定内容: HTTPリクエストのメソッドにマッチさせます。
  # 設定可能な値: 文字列（ワイルドカード使用可能）
  #   例: "GET", "POST", "PUT", "DELETE", "*"
  http_method = "*"

  # url_path (Required)
  # 設定内容: リクエストURLのパス部分にマッチさせます。
  # 設定可能な値: 文字列（ワイルドカード使用可能）
  #   例: "/api/*", "/health", "*"
  url_path = "*"

  # resource_arn (Required)
  # 設定内容: サービスが実行されているAWSリソースのARNにマッチさせます。
  # 設定可能な値: 文字列（ワイルドカード使用可能）
  #   例: "arn:aws:execute-api:*:*:*", "*"
  # 注意: X-Ray SDKはresource_arnが"*"に設定されたルールのみ使用可能です。
  #       Amazon API Gatewayの場合はステージARNを指定します。
  resource_arn = "*"

  #-------------------------------------------------------------
  # カスタム属性設定
  #-------------------------------------------------------------

  # attributes (Optional)
  # 設定内容: リクエストから派生したセグメント属性にマッチさせるためのキーと値のマップを
  #          指定します。
  # 設定可能な値: キーと値のペアのマップ（文字列）
  # 省略時: 属性によるフィルタリングは行われません。
  # 注意: X-Ray SDKは属性を指定したルールをサポートしていません（無視されます）。
  #       Amazon API Gatewayの場合は元のHTTPリクエストのヘッダーが使用されます。
  # 参考: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-sampling.html
  attributes = {}

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
    Name        = "example-sampling-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サンプリングルールのAmazon Resource Name (ARN)
#
# - id: サンプリングルールの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
