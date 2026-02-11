#---------------------------------------------------------------
# AWS Verified Access Instance
#---------------------------------------------------------------
#
# AWS Verified Access Instanceをプロビジョニングするリソースです。
# Verified Access Instanceは、VPNなしで企業のアプリケーションやリソースへの
# 安全なアクセスを提供するサービスの基盤となるコンポーネントで、
# トラストプロバイダーとVerified Accessグループを組織化するために使用します。
#
# AWS公式ドキュメント:
#   - Verified Access Instanceの作成と管理: https://docs.aws.amazon.com/verified-access/latest/ug/create-verified-access-instance.html
#   - FIPS準拠: https://docs.aws.amazon.com/verified-access/latest/ug/fips-compliance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedaccess_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedaccess_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: AWS Verified Instanceの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なしで作成されます。
  # 用途: インスタンスの目的や用途を文書化するために使用
  description = "Example Verified Access Instance"

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # fips_enabled (Optional, Forces new resource)
  # 設定内容: Verified Access InstanceでFederal Information Processing Standards (FIPS)の
  #           サポートを有効化または無効化します。
  # 設定可能な値:
  #   - true: FIPS準拠を有効化
  #   - false (デフォルト): FIPS準拠を無効化
  # 関連機能: FIPS準拠
  #   米国およびカナダ政府標準の暗号モジュールを使用して機密情報を保護します。
  #   特定のAWSリージョン（US East (Ohio, N. Virginia)、US West (N. California, Oregon)、
  #   Canada (Central)、AWS GovCloud (US) West and East）で利用可能です。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/fips-compliance.html
  # 注意: 作成後の変更はできません（Forces new resource）。
  #       既存の環境をFIPS準拠に変更するには、元のエンドポイント、グループ、
  #       インスタンスを削除し、新規作成が必要です。
  fips_enabled = false

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # cidr_endpoints_custom_subdomain (Optional)
  # 設定内容: CIDRエンドポイントのカスタムサブドメインを指定します。
  # 設定可能な値: 有効なドメイン名（例: test.example.com）
  # 関連機能: ネットワークCIDRエンドポイント
  #   非HTTP(S)プロトコル（SSH、RDPなど）を使用するアプリケーションやリソースへの
  #   安全なアクセスを提供するために使用されます。
  #   カスタムサブドメインを追加した後、Verified Accessから提供される
  #   ネームサーバーでサブドメインのネームサーバーを更新する必要があります。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/create-verified-access-instance.html
  # 参考: カスタムサブドメインの追加方法は、コンソールまたはAWS CLIを使用して実行可能
  cidr_endpoints_custom_subdomain = null

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
  # ID設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 省略時: AWSによって自動的に生成されたIDが使用されます。
  # 注意: 通常は省略し、AWSに自動生成させることを推奨します。
  id = null

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
    Name        = "example-verified-access-instance"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられた全てのタグのマップ（プロバイダーのdefault_tagsを含む）
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsがマージされた値が自動的に設定されます。
  # 注意: 通常はこのフィールドを明示的に設定する必要はありません。
  #       プロバイダーのdefault_tags設定とリソース固有のtagsが自動的に統合されます。
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWS Verified Access InstanceのID
#
# - creation_time: Verified Access Instanceが作成された時刻
#
# - last_updated_time: Verified Access Instanceが最後に更新された時刻
#
# - name_servers: カスタムサブドメインを設定した際にVerified Accessから提供される
#                 ネームサーバーのリスト。サブドメインのネームサーバーを
#                 これらの値で更新する必要があります。
#
# - verified_access_trust_providers: AWS Verified Access Trust Providersに関する
#                                     情報を提供する1つ以上のブロック。
#                                     各ブロックには以下の属性が含まれます:
#   - description: トラストプロバイダーの説明
#   - device_trust_provider_type: デバイスベースのトラストプロバイダーのタイプ
#   - trust_provider_type: トラストプロバイダーのタイプ（ユーザーベースまたはデバイスベース）
#   - user_trust_provider_type: ユーザーベースのトラストプロバイダーのタイプ
#   - verified_access_trust_provider_id: トラストプロバイダーのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#---------------------------------------------------------------
