#---------------------------------------------------------------
# AWS OpenSearch Package Association
#---------------------------------------------------------------
#
# Amazon OpenSearch Service ドメインにパッケージを関連付けるリソースです。
# カスタム辞書ファイル（TXT-DICTIONARY）やプラグイン（ZIP-PLUGIN）等の
# パッケージをドメインに関連付けることで、OpenSearch の機能を拡張できます。
#
# AWS公式ドキュメント:
#   - パッケージのインポートと管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-packages.html
#   - カスタムプラグイン: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-plugins.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_package_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_package_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # package_id (Required, Forces new resource)
  # 設定内容: ドメインに関連付けるパッケージの内部IDを指定します。
  # 設定可能な値: aws_opensearch_package リソースの id 属性の値
  # 注意: この値を変更すると、既存のリソースが破棄され新規作成されます。
  package_id = aws_opensearch_package.example.id

  # domain_name (Required, Forces new resource)
  # 設定内容: パッケージを関連付けるOpenSearchドメインの名前を指定します。
  # 設定可能な値: 既存のOpenSearchドメイン名（aws_opensearch_domain リソースの domain_name 属性の値）
  # 注意: この値を変更すると、既存のリソースが破棄され新規作成されます。
  domain_name = aws_opensearch_domain.my_domain.domain_name

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60m" や "2h" などのGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "60m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60m" や "2h" などのGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: パッケージ関連付けのID。
#
# - reference_path: OpenSearch Serviceクラスターノード上のパッケージの相対パス。
#                   カスタム辞書等のパッケージをOpenSearch設定で参照する際に使用します。
#---------------------------------------------------------------
