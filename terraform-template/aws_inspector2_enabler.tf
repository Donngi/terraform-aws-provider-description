#---------------------------------------------------------------
# AWS Inspector2 Enabler
#---------------------------------------------------------------
#
# Amazon Inspector V2のスキャンを有効化するリソースです。
# 指定したAWSアカウントに対して、EC2・ECR・Lambda等のリソースタイプの
# 脆弱性スキャンを有効にします。
# このリソースはOrganizationの管理者アカウントで作成する必要があります。
#
# AWS公式ドキュメント:
#   - Amazon Inspector スキャンの有効化: https://docs.aws.amazon.com/inspector/latest/user/activate-scans.html
#   - Enable API: https://docs.aws.amazon.com/inspector/v2/APIReference/API_Enable.html
#   - メンバーアカウントのスキャン有効化: https://docs.aws.amazon.com/inspector/latest/user/adding-member-accounts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_enabler
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector2_enabler" "example" {
  #-------------------------------------------------------------
  # 対象アカウント設定
  #-------------------------------------------------------------

  # account_ids (Required)
  # 設定内容: Amazon Inspector V2スキャンを有効化する対象のAWSアカウントIDのセットを指定します。
  # 設定可能な値: AWSアカウントIDの文字列セット
  #   - Organizationの管理者アカウントIDを含めることができます
  #   - Organizationのメンバーアカウントを1つ以上指定できます
  # 参考: https://docs.aws.amazon.com/inspector/latest/user/adding-member-accounts.html
  account_ids = ["123456789012"]

  #-------------------------------------------------------------
  # スキャン対象リソースタイプ設定
  #-------------------------------------------------------------

  # resource_types (Required)
  # 設定内容: スキャンを有効化するリソースタイプのセットを指定します。少なくとも1つ必要です。
  # 設定可能な値:
  #   - "EC2": Amazon EC2インスタンスのパッケージ脆弱性とネットワーク到達可能性をスキャン
  #   - "ECR": Amazon ECRのコンテナイメージをスキャン（プライベートレジストリのスキャン設定をEnhanced Scanningに変更）
  #   - "LAMBDA": Lambdaファンクションのソフトウェア脆弱性をスキャン（過去90日以内に呼び出し・更新されたものが対象）
  #   - "LAMBDA_CODE": Lambdaファンクション内のカスタムアプリケーションコードの脆弱性をスキャン（LAMBDAの有効化が前提）
  #   - "CODE_REPOSITORY": コードリポジトリのスキャン
  # 参考: https://docs.aws.amazon.com/inspector/latest/user/activate-scans.html
  resource_types = ["EC2", "ECR"]

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
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 有効化されたアカウントIDのコンマ区切り文字列。Terraform内部で使用される識別子。
#---------------------------------------------------------------
