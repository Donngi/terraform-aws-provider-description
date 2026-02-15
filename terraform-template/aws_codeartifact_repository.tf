# AWS CodeArtifact Repository Resource
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: このテンプレートは aws_codeartifact_repository リソースの全設定項目を日本語コメント付きで示したものです。

#---------------------------------------
# リソース定義
#---------------------------------------
resource "aws_codeartifact_repository" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: リポジトリ名
  # 設定可能な値: 2〜100文字の英数字、ハイフン、アンダースコアの組み合わせ
  # 省略時: 省略不可（必須パラメータ）
  repository = "example-repository"

  # 設定内容: CodeArtifactドメイン名
  # 設定可能な値: リポジトリを含むドメインの名前
  # 省略時: 省略不可（必須パラメータ）
  domain = "example-domain"

  # 設定内容: ドメイン所有者のAWSアカウントID
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のアカウントIDが使用される
  domain_owner = "123456789012"

  #---------------------------------------
  # リポジトリ設定
  #---------------------------------------
  # 設定内容: リポジトリの説明
  # 設定可能な値: リポジトリの目的や用途を示すテキスト
  # 省略時: 説明なし
  description = "Example CodeArtifact repository for NPM packages"

  #---------------------------------------
  # 外部接続設定
  #---------------------------------------
  # 設定内容: 外部パブリックリポジトリへの接続
  # 設定可能な値: external_connections ブロック（最大1つ）
  # 省略時: 外部接続なし
  # external_connections {
  #   # 設定内容: 外部接続名
  #   # 設定可能な値: public:npmjs（npm）、public:pypi（Python）、public:maven-central（Maven）、public:maven-googleandroid（Android）、public:maven-gradleplugins（Gradle）、public:maven-commonsware（CommonsWare）、public:nuget-org（NuGet）、public:crates-io（Rust）など
  #   # 省略時: 省略不可（必須パラメータ）
  #   external_connection_name = "public:npmjs"
  # }

  #---------------------------------------
  # アップストリームリポジトリ設定
  #---------------------------------------
  # 設定内容: アップストリームリポジトリ（上流リポジトリ）
  # 設定可能な値: upstream ブロック（複数指定可能）
  # 省略時: アップストリームリポジトリなし
  # upstream {
  #   # 設定内容: アップストリームリポジトリ名
  #   # 設定可能な値: 同一ドメイン内の既存リポジトリ名
  #   # 省略時: 省略不可（必須パラメータ）
  #   repository_name = "upstream-repository"
  # }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースが管理されるリージョン
  # 設定可能な値: AWSリージョンコード（us-east-1、ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-repository"
    Environment = "production"
    Team        = "platform"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# 以下の属性がエクスポートされます:
#
# id                      - リポジトリのID（ARN）
# arn                     - リポジトリのARN
# administrator_account   - リポジトリの管理者アカウントのAWSアカウントID
# domain_owner            - ドメイン所有者のAWSアカウントID
# region                  - リソースが管理されているリージョン
# tags_all                - すべてのタグ（プロバイダー default_tags とリソース tags の統合）
#
# external_connections ブロック:
#   package_format        - パッケージフォーマット（npm、pypi、maven、nugetなど）
#   status                - 接続のステータス（Available など）
