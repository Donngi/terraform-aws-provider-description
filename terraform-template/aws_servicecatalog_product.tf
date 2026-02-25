#---------------------------------------------------------------
# AWS Service Catalog Product
#---------------------------------------------------------------
#
# AWS Service Catalog の製品をプロビジョニングするリソースです。
# 製品は CloudFormation テンプレートをベースにした IT サービスを定義し、
# ポートフォリオに追加してエンドユーザーがセルフサービスで起動できる
# 承認済みリソースセットを提供します。
#
# AWS公式ドキュメント:
#   - 製品の作成と管理: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/catalogs_portfolios_products.html
#   - CreateProduct API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreateProduct.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_product" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 製品の名前を指定します。
  # 設定可能な値: 1-8191文字の文字列
  name = "My Product"

  # owner (Required)
  # 設定内容: 製品の所有者（個人または組織）の名前を指定します。
  # 設定可能な値: 1-8191文字の文字列
  owner = "IT Department"

  # type (Required)
  # 設定内容: 製品の種類を指定します。
  # 設定可能な値:
  #   - "CLOUD_FORMATION_TEMPLATE": CloudFormation テンプレートを使用した製品
  #   - "MARKETPLACE": AWS Marketplace の製品
  #   - "TERRAFORM_OPEN_SOURCE": Terraform オープンソースを使用した製品
  #   - "TERRAFORM_CLOUD": Terraform Cloud を使用した製品
  #   - "EXTERNAL": 外部リポジトリを使用した製品
  type = "CLOUD_FORMATION_TEMPLATE"

  # description (Optional)
  # 設定内容: 製品の説明を指定します。
  # 設定可能な値: 最大8191文字の文字列
  # 省略時: 説明なし
  description = "This product provisions an S3 bucket"

  # distributor (Optional)
  # 設定内容: 製品の配布者名を指定します。
  # 設定可能な値: 最大8191文字の文字列
  # 省略時: 配布者なし
  distributor = "My Organization"

  # support_description (Optional)
  # 設定内容: 製品のサポート情報の説明を指定します。
  # 設定可能な値: 最大8191文字の文字列
  # 省略時: サポート説明なし
  support_description = "Contact the IT help desk for issues"

  # support_email (Optional)
  # 設定内容: 製品サポートの連絡先メールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス（最大254文字）
  # 省略時: サポートメールなし
  support_email = "support@example.com"

  # support_url (Optional)
  # 設定内容: 製品サポートのウェブサイト URL を指定します。
  # 設定可能な値: 有効な URL（最大2083文字）
  # 省略時: サポート URL なし
  support_url = "https://support.example.com"

  #-------------------------------------------------------------
  # 言語設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: レスポンスに使用する言語コードを指定します。
  # 設定可能な値:
  #   - "en": 英語（デフォルト）
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: "en"（英語）
  accept_language = "en"

  #-------------------------------------------------------------
  # プロビジョニングアーティファクト設定
  #-------------------------------------------------------------

  # provisioning_artifact_parameters (Required)
  # 設定内容: 製品の初期バージョン（プロビジョニングアーティファクト）の
  #           パラメータを指定するブロックです。
  provisioning_artifact_parameters {

    # name (Optional)
    # 設定内容: アーティファクトのバージョン名を指定します。
    # 設定可能な値: 最大8191文字の文字列
    # 省略時: バージョン名なし
    name = "v1.0"

    # description (Optional)
    # 設定内容: アーティファクトの説明を指定します。
    # 設定可能な値: 最大8191文字の文字列
    # 省略時: 説明なし
    description = "Initial version"

    # type (Optional)
    # 設定内容: アーティファクトの種類を指定します。
    # 設定可能な値:
    #   - "CLOUD_FORMATION_TEMPLATE": CloudFormation テンプレート（デフォルト）
    #   - "MARKETPLACE_AMI": Marketplace の AMI
    #   - "MARKETPLACE_CAR": Marketplace クラスターとAWSリソース
    #   - "TERRAFORM_OPEN_SOURCE": Terraform オープンソーステンプレート
    #   - "TERRAFORM_CLOUD": Terraform Cloud テンプレート
    #   - "EXTERNAL": 外部アーティファクト
    # 省略時: "CLOUD_FORMATION_TEMPLATE"
    type = "CLOUD_FORMATION_TEMPLATE"

    # template_url (Optional)
    # 設定内容: CloudFormation テンプレートの S3 URL を指定します。
    #           template_url または template_physical_id のいずれかを指定します。
    # 設定可能な値: S3 に保存された CloudFormation テンプレートの URL
    # 省略時: template_physical_id を使用
    template_url = "https://s3.amazonaws.com/my-bucket/my-template.yaml"

    # template_physical_id (Optional)
    # 設定内容: CloudFormation テンプレートの物理 ID を指定します。
    #           MarketplaceAMI の場合に使用します。
    #           template_url または template_physical_id のいずれかを指定します。
    # 設定可能な値: CloudFormation テンプレートの物理 ID 文字列
    # 省略時: template_url を使用
    template_physical_id = null

    # disable_template_validation (Optional)
    # 設定内容: テンプレートの検証を無効化するかどうかを指定します。
    # 設定可能な値:
    #   - true: テンプレート検証を無効化
    #   - false: テンプレート検証を有効化
    # 省略時: false（テンプレート検証を有効化）
    disable_template_validation = false
  }

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
  # 省略時: タグなし
  tags = {
    Name        = "my-product"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" のような時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    create = "5m"

    # read (Optional)
    # 設定内容: リソース読み取り時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" のような時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    read = "10m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" のような時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" のような時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Service Catalog 製品の ID
# - arn: 製品の Amazon Resource Name (ARN)
# - created_time: 製品が作成された日時
# - has_default_path: 製品にデフォルトパスがあるかどうか
# - status: 製品の現在のステータス
# - tags_all: プロバイダーの default_tags を含むすべてのタグのマップ
#---------------------------------------------------------------
