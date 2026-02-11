#---------------------------------------------------------------
# AWS CodeDeploy Application
#---------------------------------------------------------------
#
# AWS CodeDeployアプリケーションをプロビジョニングするリソースです。
# CodeDeployアプリケーションは、デプロイメントの基盤となるリソースであり、
# デプロイメントグループとデプロイメント設定を含みます。
# Server、Lambda、ECS、Kubernetesの各プラットフォームに対応しています。
#
# AWS公式ドキュメント:
#   - CodeDeploy概要: https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html
#   - CodeDeployアプリケーション: https://docs.aws.amazon.com/codedeploy/latest/userguide/applications.html
#   - CreateApplication API: https://docs.aws.amazon.com/codedeploy/latest/APIReference/API_CreateApplication.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codedeploy_app" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アプリケーションの名前を指定します。
  # 設定可能な値: 1-100文字の文字列。AWSアカウント内で一意である必要があります。
  # 注意: この値は必須パラメータです。
  name = "my-application"

  #-------------------------------------------------------------
  # コンピュートプラットフォーム設定
  #-------------------------------------------------------------

  # compute_platform (Optional)
  # 設定内容: デプロイメントの対象となるコンピュートプラットフォームを指定します。
  # 設定可能な値:
  #   - "Server" (デフォルト): Amazon EC2インスタンスまたはオンプレミスサーバー
  #   - "Lambda": AWS Lambda関数
  #   - "ECS": Amazon Elastic Container Service
  #   - "Kubernetes": Kubernetesクラスター
  # 省略時: "Server"
  # 関連機能: CodeDeployコンピュートプラットフォーム
  #   各プラットフォームでは異なるデプロイメント戦略とライフサイクルイベントが利用可能です。
  #   Serverプラットフォームでは、In-PlaceデプロイメントとBlue/Greenデプロイメントが可能です。
  #   - https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-steps.html
  compute_platform = "Server"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
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
    Name        = "my-application"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all (Optional)
  # 設定内容: リソースに割り当てるすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: この属性はプロバイダーのdefault_tagsとマージされた結果を表示する
  #       computed属性であり、通常は直接設定しません。tagsを使用してください。
  # 関連機能: AWSリソースタグ付け
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  #-------------------------------------------------------------
  # リソースID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 注意: この属性はAWSによって自動的に割り当てられるcomputed属性であり、
  #       通常は直接設定しません。省略することを推奨します。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - application_id: アプリケーションのID
#
# - arn: CodeDeployアプリケーションのAmazon Resource Name (ARN)
#
# - github_account_name: GitHub アカウント接続の名前
#
# - id: AWSによって割り当てられたアプリケーションのID
#
# - linked_to_github: 指定されたアプリケーションでユーザーがGitHubで
#                     認証されているかどうかを示すブール値
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
