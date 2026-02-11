#---------------------------------------------------------------
# AWS ECR Registry Scanning Configuration
#---------------------------------------------------------------
#
# Amazon ECRプライベートレジストリのスキャン設定をプロビジョニングするリソースです。
# このリソースは完全に削除することができず、削除時はルールなしの
# デフォルトの「BASIC」スキャン設定に戻ります。
#
# Enhanced scanningはAmazon Inspectorと統合されており、
# コンテナイメージのOSおよびプログラミング言語パッケージの
# 脆弱性をスキャンします。
#
# AWS公式ドキュメント:
#   - ECRイメージスキャン概要: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html
#   - Enhanced scanning: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning-enhanced.html
#   - スキャンフィルター: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning-filters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecr_registry_scanning_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # scan_type (Required)
  # 設定内容: レジストリで使用するスキャンタイプを指定します。
  # 設定可能な値:
  #   - "ENHANCED": Amazon Inspectorと連携した拡張スキャン。
  #                 OSおよびプログラミング言語パッケージの脆弱性を検出。
  #                 継続的スキャン（CONTINUOUS_SCAN）とプッシュ時スキャン（SCAN_ON_PUSH）に対応。
  #   - "BASIC": 基本スキャン。OSの脆弱性のみを検出。
  #              プッシュ時スキャンと手動スキャンに対応。
  # 注意: Enhanced scanningにはAmazon Inspectorの追加コストが発生します。
  # 関連機能: Amazon Inspector
  #   - https://docs.aws.amazon.com/inspector/latest/user/scanning-ecr.html
  scan_type = "ENHANCED"

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
  # スキャンルール設定
  #-------------------------------------------------------------

  # rule (Optional)
  # 設定内容: スキャンルールを定義するブロックです。
  #          各ルールはスキャン頻度とリポジトリフィルターを指定します。
  # 注意:
  #   - 最大100個のルールを設定可能
  #   - Enhanced scanningでは、フィルターに一致しないリポジトリは
  #     スキャンが無効（Off）になります
  #   - 同じリポジトリにCONTINUOUS_SCANとSCAN_ON_PUSHの両方が一致する場合、
  #     CONTINUOUS_SCANが優先されます
  rule {
    # scan_frequency (Required)
    # 設定内容: スキャンの頻度を指定します。
    # 設定可能な値:
    #   - "CONTINUOUS_SCAN": 継続的なスキャン。
    #                        新しくプッシュされたイメージは設定された期間、
    #                        継続的にスキャンされます（Enhanced scanningのみ）。
    #   - "SCAN_ON_PUSH": プッシュ時のみスキャン。
    #                     イメージがプッシュされた時に1回スキャンを実行。
    # 注意: Basic scanningでは "SCAN_ON_PUSH" または手動スキャンのみ対応
    scan_frequency = "CONTINUOUS_SCAN"

    # repository_filter (Required)
    # 設定内容: スキャン対象のリポジトリを指定するフィルターです。
    # 注意: 1つ以上のフィルターを指定する必要があります
    repository_filter {
      # filter (Required)
      # 設定内容: リポジトリ名に一致させるフィルター文字列を指定します。
      # 設定可能な値:
      #   - リポジトリ名の一部または全体
      #   - ワイルドカード（*）を使用可能
      # 例:
      #   - "*": すべてのリポジトリに一致
      #   - "prod-*": "prod-" で始まるリポジトリに一致
      #   - "my-app": "my-app" を含むリポジトリに一致
      filter = "*"

      # filter_type (Required)
      # 設定内容: フィルターのタイプを指定します。
      # 設定可能な値:
      #   - "WILDCARD": ワイルドカードフィルター。
      #                 フィルター文字列でワイルドカード（*）が使用可能。
      filter_type = "WILDCARD"
    }
  }

  # 複数ルールの例:
  # 本番環境は継続的スキャン、その他はプッシュ時スキャン
  rule {
    scan_frequency = "SCAN_ON_PUSH"

    repository_filter {
      filter      = "dev-*"
      filter_type = "WILDCARD"
    }

    repository_filter {
      filter      = "staging-*"
      filter_type = "WILDCARD"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: レジストリID
#
# - registry_id: スキャン設定が適用されるレジストリID
#---------------------------------------------------------------
