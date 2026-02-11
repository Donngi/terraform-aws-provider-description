#---------------------------------------------------------------
# AWS Elastic Beanstalk Application Version
#---------------------------------------------------------------
#
# Elastic Beanstalk Application Version リソースを管理します。
# Elastic Beanstalkを使用すると、アプリケーションを実行するインフラストラクチャを
# 管理することなく、AWS クラウド内でアプリケーションをデプロイおよび管理できます。
#
# このリソースは、Beanstalk Environment にデプロイできる
# Beanstalk Application Version を作成します。
#
# 注意: 複数の Elastic Beanstalk Environment で Application Version リソースを
# 使用する場合、別の Environment で使用中の Application Version を削除しようと
# するとエラーが返される可能性があります。この問題を回避するには、各 Environment を
# 別々のAWSアカウントで作成するか、Elastic Beanstalk Application 内で一意の名前
# (例: <revision>-<environment>) を持つ aws_elastic_beanstalk_application_version
# リソースを作成してください。
#
# AWS公式ドキュメント:
#   - Elastic Beanstalk 概要: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html
#   - Application Versions: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications-versions.html
#   - Elastic Beanstalk API リファレンス: https://docs.aws.amazon.com/elasticbeanstalk/latest/api/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elastic_beanstalk_application_version" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: このアプリケーションバージョンの一意の名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 用途: Application Version を一意に識別するための名前
  # 注意: 同じアプリケーション内で重複しない一意の名前を指定する必要があります
  # 関連機能: Elastic Beanstalk アプリケーションバージョン
  #   アプリケーションの特定のバージョンを管理し、異なる環境にデプロイ可能にします。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications-versions.html
  name = "tf-test-version-label"

  # application (Required)
  # 設定内容: このバージョンが関連付けられている Beanstalk Application の名前を指定します。
  # 設定可能な値: 既存の Elastic Beanstalk Application の名前
  # 用途: アプリケーションバージョンを特定のアプリケーションに関連付けます
  # 関連機能: Elastic Beanstalk アプリケーション
  #   複数のバージョンと環境を管理するためのコンテナとなります。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications.html
  application = "tf-test-name"

  # bucket (Required)
  # 設定内容: アプリケーションバージョンのソースバンドルを含む S3 バケットを指定します。
  # 設定可能な値: 有効な S3 バケット名
  # 用途: デプロイ可能なアプリケーションコードを含むZIPまたはWARファイルを保存するバケット
  # 関連機能: S3 バケット
  #   アプリケーションのソースコードやバイナリを格納します。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications-sourcebundle.html
  bucket = "tftest.applicationversion.bucket"

  # key (Required)
  # 設定内容: アプリケーションバージョンのソースバンドルとなる S3 オブジェクトを指定します。
  # 設定可能な値: S3 バケット内のオブジェクトキー (パス)
  # 用途: デプロイするアプリケーションのソースコードを含むファイルを指定
  # 注意: ZIPまたはWAR形式のファイルである必要があります
  # 関連機能: S3 オブジェクト
  #   アプリケーションコードをパッケージ化したファイルです。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications-sourcebundle.html
  key = "beanstalk/go-v1.zip"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: アプリケーションバージョンの短い説明を指定します。
  # 設定可能な値: 自由形式のテキスト文字列
  # 省略時: 説明なしでバージョンが作成されます
  # 用途: バージョンの内容や変更点を記録するために使用
  # 関連機能: Elastic Beanstalk メタデータ
  #   バージョン管理とドキュメント化を支援します。
  description = "application version created by terraform"

  # force_delete (Optional)
  # 設定内容: 削除時に複数の Elastic Beanstalk Environment で使用中でも
  #           アプリケーションバージョンを強制削除するかどうかを指定します。
  # 設定可能な値:
  #   - true: 使用中でも強制的に削除
  #   - false: 使用中の場合は削除エラーが発生 (デフォルト)
  # 省略時: false が使用されます
  # 注意: 使用中のバージョンを削除すると、実行中の環境に影響を与える可能性があります
  # 関連機能: Elastic Beanstalk ライフサイクル管理
  #   不要になったバージョンを安全に削除する機能です。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/applications-lifecycle.html
  force_delete = false

  # process (Optional)
  # 設定内容: ソースバンドル内の環境マニフェスト (env.yaml) と設定ファイル
  #           (.ebextensions フォルダ内の *.config ファイル) を事前処理して検証するかを指定します。
  # 設定可能な値:
  #   - true: 設定ファイルを検証して、環境にデプロイする前に問題を特定
  #   - false: 検証をスキップ (デフォルト)
  # 省略時: false が使用されます
  # 用途: AWS CodeBuild または AWS CodeCommit を使用して作成するアプリケーション
  #       バージョンでは、処理を有効にする必要があります。Amazon S3 のソースバンドルから
  #       作成されたアプリケーションバージョンでは、処理はオプションです。
  # 注意: Elastic Beanstalk 設定ファイルを検証しますが、プロキシサーバーや
  #       Docker設定などのアプリケーション独自の設定ファイルは検証しません。
  # 関連機能: Elastic Beanstalk 設定ファイル検証
  #   デプロイ前に設定エラーを検出して、環境の作成失敗を防ぎます。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ebextensions.html
  process = true

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.tagging.html
  tags = {
    Name        = "example-app-version"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Elastic Beanstalk Application に割り当てられた ARN
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
