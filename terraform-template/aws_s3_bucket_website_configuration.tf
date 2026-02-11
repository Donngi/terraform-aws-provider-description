################################################################################
# AWS S3 Bucket Website Configuration
################################################################################
# リソース: aws_s3_bucket_website_configuration
# プロバイダーバージョン: 6.28.0
#
# 概要:
# S3バケットのウェブサイト設定を管理するリソースです。
# S3でのウェブサイトホスティングを有効にし、インデックスドキュメント、
# エラードキュメント、リダイレクトルールなどを設定できます。
#
# 注意事項:
# - このリソースはS3ディレクトリバケットでは使用できません
# - redirect_all_requests_toとindex_documentは排他的な関係にあります
# - routing_ruleとrouting_rulesは同時に使用できません
#
# 参考リンク:
# - https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
################################################################################

resource "aws_s3_bucket_website_configuration" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # bucket - (必須、変更時に再作成)
  # 説明: バケットの名前
  # 型: string
  # 例: "my-website-bucket" または aws_s3_bucket.example.id
  bucket = "REPLACE_WITH_BUCKET_NAME"

  ################################################################################
  # オプションパラメータ - 基本設定
  ################################################################################

  # expected_bucket_owner - (オプション、変更時に再作成)
  # 説明: 期待されるバケット所有者のアカウントID
  # 型: string
  # 用途: バケット所有者を検証し、誤操作を防止
  # 例: "123456789012"
  # expected_bucket_owner = null

  # region - (オプション、computed)
  # 説明: このリソースが管理されるリージョン
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-east-1", "ap-northeast-1"
  # region = null

  ################################################################################
  # Index Document - インデックスドキュメント設定
  ################################################################################
  # 注意: redirect_all_requests_toが指定されていない場合は必須
  # ウェブサイトのデフォルトページを設定します

  index_document {
    # suffix - (必須)
    # 説明: ディレクトリリクエストに追加されるサフィックス
    # 型: string
    # 制約:
    #   - 空文字列は不可
    #   - スラッシュ文字を含めることは不可
    # 例: "index.html"を指定すると、"samplebucket/images/"へのリクエストは
    #     "images/index.html"のオブジェクトのデータを返します
    suffix = "index.html"
  }

  ################################################################################
  # Error Document - エラードキュメント設定
  ################################################################################
  # オプション: redirect_all_requests_toと競合
  # 4XXエラー発生時に表示されるドキュメントを設定します

  error_document {
    # key - (必須)
    # 説明: 4XXクラスのエラーが発生した際に使用されるオブジェクトキー名
    # 型: string
    # 例: "error.html", "404.html"
    key = "error.html"
  }

  ################################################################################
  # Redirect All Requests To - 全リクエストリダイレクト設定
  ################################################################################
  # オプション: index_documentが指定されていない場合は必須
  # 競合: error_document, index_document, routing_rule
  # 全てのリクエストを別のホストにリダイレクトする場合に使用します
  #
  # 使用例: バケット全体を別のドメインにリダイレクトする場合
  #
  # redirect_all_requests_to {
  #   # host_name - (必須)
  #   # 説明: リダイレクト先のホスト名
  #   # 型: string
  #   # 例: "example.com", "www.example.com"
  #   host_name = "example.com"
  #
  #   # protocol - (オプション)
  #   # 説明: リダイレクト時に使用するプロトコル
  #   # 型: string
  #   # デフォルト: 元のリクエストのプロトコル
  #   # 有効な値: "http", "https"
  #   # protocol = "https"
  # }

  ################################################################################
  # Routing Rule - ルーティングルール設定
  ################################################################################
  # オプション: redirect_all_requests_toおよびrouting_rulesと競合
  # リダイレクトが適用されるタイミングとその動作を定義します
  # 複数のルールを定義可能です

  routing_rule {
    # Condition - 条件設定
    # オプション: リダイレクトを適用する条件を定義
    condition {
      # http_error_code_returned_equals - (オプション)
      # 説明: リダイレクトが適用されるHTTPエラーコード
      # 型: string
      # 注意: key_prefix_equalsと同時に指定された場合、両方がtrueの時のみ適用
      # 例: "404", "403"
      # http_error_code_returned_equals = null

      # key_prefix_equals - (オプション)
      # 説明: リダイレクトが適用されるオブジェクトキー名のプレフィックス
      # 型: string
      # 注意: http_error_code_returned_equalsが指定されていない場合は必須
      # 例: "docs/", "images/"
      key_prefix_equals = "docs/"
    }

    # Redirect - リダイレクト設定
    # 必須: リダイレクト情報を定義
    redirect {
      # host_name - (オプション)
      # 説明: リダイレクトリクエストで使用するホスト名
      # 型: string
      # 例: "example.com"
      # host_name = null

      # http_redirect_code - (オプション)
      # 説明: レスポンスで使用するHTTPリダイレクトコード
      # 型: string
      # 例: "301", "302"
      # http_redirect_code = null

      # protocol - (オプション)
      # 説明: リダイレクト時に使用するプロトコル
      # 型: string
      # デフォルト: 元のリクエストのプロトコル
      # 有効な値: "http", "https"
      # protocol = null

      # replace_key_prefix_with - (オプション)
      # 説明: リダイレクトリクエストで使用するオブジェクトキーのプレフィックス
      # 型: string
      # 競合: replace_key_with
      # 例: "docs/"プレフィックスを持つ全てのページを"documents/"にリダイレクトする場合、
      #     conditionでkey_prefix_equals = "docs/"を設定し、
      #     replace_key_prefix_with = "documents/"を設定
      replace_key_prefix_with = "documents/"

      # replace_key_with - (オプション)
      # 説明: リダイレクトリクエストで使用する特定のオブジェクトキー
      # 型: string
      # 競合: replace_key_prefix_with
      # 例: "error.html"にリダイレクトする場合
      # replace_key_with = null
    }
  }

  ################################################################################
  # Routing Rules (JSON形式) - ルーティングルール設定 (JSON)
  ################################################################################
  # オプション: routing_ruleおよびredirect_all_requests_toと競合
  # ルーティングルールをJSON配列として定義します
  # 用途: ルーティングルールに空文字列("")が含まれる場合に使用
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-routingrules.html
  #
  # 使用例:
  # routing_rules = <<EOF
  # [{
  #     "Condition": {
  #         "KeyPrefixEquals": "docs/"
  #     },
  #     "Redirect": {
  #         "ReplaceKeyPrefixWith": ""
  #     }
  # }]
  # EOF

  ################################################################################
  # タグ
  ################################################################################
  # 注意: このリソースはタグをサポートしていません
  # バケット自体のタグはaws_s3_bucketリソースで管理してください
}

################################################################################
# 出力値
################################################################################

# id - バケット名、またはexpected_bucket_ownerが指定されている場合は
#      バケット名とexpected_bucket_ownerをカンマ(,)で結合した値
output "s3_bucket_website_configuration_id" {
  description = "The S3 bucket website configuration ID"
  value       = aws_s3_bucket_website_configuration.example.id
}

# website_domain - ウェブサイトエンドポイントのドメイン
# 用途: Route 53エイリアスレコード作成に使用
output "s3_bucket_website_domain" {
  description = "The domain of the website endpoint (used to create Route 53 alias records)"
  value       = aws_s3_bucket_website_configuration.example.website_domain
}

# website_endpoint - ウェブサイトエンドポイント
output "s3_bucket_website_endpoint" {
  description = "The website endpoint"
  value       = aws_s3_bucket_website_configuration.example.website_endpoint
}

################################################################################
# 使用例
################################################################################

# 例1: 基本的なウェブサイト設定（インデックスとエラードキュメント）
#
# resource "aws_s3_bucket" "example" {
#   bucket = "my-website-bucket"
# }
#
# resource "aws_s3_bucket_website_configuration" "example" {
#   bucket = aws_s3_bucket.example.id
#
#   index_document {
#     suffix = "index.html"
#   }
#
#   error_document {
#     key = "error.html"
#   }
# }

# 例2: ルーティングルールを使用した設定
#
# resource "aws_s3_bucket_website_configuration" "with_routing" {
#   bucket = aws_s3_bucket.example.id
#
#   index_document {
#     suffix = "index.html"
#   }
#
#   error_document {
#     key = "error.html"
#   }
#
#   routing_rule {
#     condition {
#       key_prefix_equals = "docs/"
#     }
#     redirect {
#       replace_key_prefix_with = "documents/"
#     }
#   }
# }

# 例3: 全リクエストをリダイレクト
#
# resource "aws_s3_bucket_website_configuration" "redirect_all" {
#   bucket = aws_s3_bucket.example.id
#
#   redirect_all_requests_to {
#     host_name = "example.com"
#     protocol  = "https"
#   }
# }

# 例4: JSON形式のルーティングルール
#
# resource "aws_s3_bucket_website_configuration" "json_routing" {
#   bucket = aws_s3_bucket.example.id
#
#   index_document {
#     suffix = "index.html"
#   }
#
#   error_document {
#     key = "error.html"
#   }
#
#   routing_rules = <<EOF
# [{
#     "Condition": {
#         "KeyPrefixEquals": "docs/"
#     },
#     "Redirect": {
#         "ReplaceKeyPrefixWith": ""
#     }
# }]
# EOF
# }

################################################################################
# ベストプラクティス
################################################################################
#
# 1. セキュリティ:
#    - バケットポリシーでウェブサイトへのアクセスを適切に制御
#    - CloudFrontと組み合わせてHTTPS通信を実現
#    - パブリックアクセスブロック設定を適切に構成
#
# 2. パフォーマンス:
#    - CloudFrontのCDNを活用して低レイテンシーを実現
#    - 適切なキャッシュ設定を行う
#
# 3. コスト最適化:
#    - S3のストレージクラスを適切に選択
#    - ライフサイクルポリシーで古いコンテンツを自動削除
#
# 4. 可用性:
#    - Route 53でフェイルオーバー設定を構成
#    - 複数リージョンでのレプリケーションを検討
#
# 5. 運用:
#    - アクセスログを有効化して監視
#    - バケットバージョニングを有効化してロールバックを容易に
#    - CI/CDパイプラインでコンテンツを自動デプロイ
################################################################################
