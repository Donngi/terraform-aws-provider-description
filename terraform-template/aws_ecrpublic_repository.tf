#---------------------------------------------------------------
# AWS ECR Public Repository
#---------------------------------------------------------------
#
# Amazon Elastic Container Registry (ECR) Publicのパブリックリポジトリを
# プロビジョニングするリソースです。パブリックリポジトリは一般公開される
# コンテナイメージを保存し、ECR Public Galleryで共有することができます。
#
# 重要: このリソースは us-east-1 リージョンでのみ使用可能です。
#
# AWS公式ドキュメント:
#   - ECR Public概要: https://docs.aws.amazon.com/AmazonECR/latest/public/what-is-ecr.html
#   - ECR Public Gallery: https://gallery.ecr.aws/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecrpublic_repository
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecrpublic_repository" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # repository_name (Required)
  # 設定内容: パブリックリポジトリの名前を指定します。
  # 設定可能な値: 2-205文字の小文字英数字、ハイフン、アンダースコア、スラッシュ
  # 注意: 作成後の変更はリソースの再作成を伴います。
  repository_name = "my-public-repo"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: us-east-1（このリソースは us-east-1 でのみ利用可能）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 重要: ECR Publicはus-east-1リージョンでのみ利用可能なため、必ずus-east-1を指定してください。
  region = "us-east-1"

  # force_destroy (Optional)
  # 設定内容: Terraform destroyの実行時に、リポジトリ内にイメージが残っている場合でも
  #           強制的にリポジトリを削除するかを指定します。
  # 設定可能な値:
  #   - true: イメージが存在してもリポジトリを削除
  #   - false (デフォルト): イメージが存在する場合は削除をブロック
  # 注意: trueに設定すると、リポジトリ内のすべてのイメージが削除されます。
  force_destroy = false

  #-------------------------------------------------------------
  # カタログデータ設定（ECR Public Galleryでの表示内容）
  #-------------------------------------------------------------

  # catalog_data (Optional)
  # 設定内容: ECR Public Galleryで表示されるリポジトリのカタログ情報を設定します。
  # 関連機能: ECR Public Gallery カタログデータ
  #   リポジトリの詳細情報を一般公開し、ユーザーがリポジトリを検索・理解しやすくします。
  #   - https://docs.aws.amazon.com/AmazonECR/latest/public/public-repository-catalog-data.html
  catalog_data {
    # about_text (Optional)
    # 設定内容: リポジトリの内容に関する詳細な説明を指定します。
    # 設定可能な値: Markdown形式のテキスト（最大25,600文字）
    # 用途: ECR Public Galleryのリポジトリ詳細ページに表示されます。
    about_text = <<-EOT
      # My Public Container Image

      This repository contains public container images for...

      ## Features
      - Feature 1
      - Feature 2
    EOT

    # description (Optional)
    # 設定内容: リポジトリの内容に関する簡潔な説明を指定します。
    # 設定可能な値: テキスト（最大1,024文字）
    # 用途: ECR Public Galleryの検索結果およびリポジトリ詳細の両方に表示されます。
    description = "Public container images for my application"

    # architectures (Optional)
    # 設定内容: リポジトリ内のイメージが対応するシステムアーキテクチャを指定します。
    # 設定可能な値: "ARM", "ARM 64", "x86", "x86-64" のセット
    # 用途: ECR Public Galleryでバッジとして表示され、検索フィルターとして使用されます。
    architectures = ["x86-64", "ARM 64"]

    # operating_systems (Optional)
    # 設定内容: リポジトリ内のイメージが対応するオペレーティングシステムを指定します。
    # 設定可能な値: "Linux", "Windows" のセット
    # 用途: ECR Public Galleryでバッジとして表示され、検索フィルターとして使用されます。
    operating_systems = ["Linux"]

    # logo_image_blob (Optional, Computed)
    # 設定内容: リポジトリのロゴ画像をBase64エンコードしたデータを指定します。
    # 設定可能な値: Base64エンコードされた画像データ
    # 制約: 認証済みアカウントでのみ表示されます。
    # 注意: この属性はドリフト検出が無効化されています。
    # 用途: filebase64()関数を使用してローカルの画像ファイルを指定できます。
    logo_image_blob = filebase64("${path.module}/logo.png")

    # usage_text (Optional)
    # 設定内容: リポジトリの内容の使用方法に関する詳細情報を指定します。
    # 設定可能な値: Markdown形式のテキスト（最大25,600文字）
    # 用途: ECR Public Galleryに公開され、コンテキスト、サポート情報、
    #       追加の使用方法の詳細を提供します。
    usage_text = <<-EOT
      ## Usage

      ```bash
      docker pull public.ecr.aws/my-namespace/my-public-repo:latest
      docker run public.ecr.aws/my-namespace/my-public-repo:latest
      ```
    EOT
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-public-repo"
    Environment = "production"
    Public      = "true"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間をカスタマイズします。
  timeouts {
    # delete (Optional)
    # 設定内容: リポジトリ削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "20m", "1h"）
    # デフォルト: 20分
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リポジトリのAmazon Resource Name (ARN)
#
# - id: リポジトリ名
#
# - registry_id: リポジトリが作成されたレジストリのID
#
# - repository_uri: リポジトリのURI
#        形式: public.ecr.aws/{registry_alias}/{repository_name}
#        用途: docker pullやdocker pushコマンドで使用
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
