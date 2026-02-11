#---------------------------------------------------------------
# AWS AppSync API Cache
#---------------------------------------------------------------
#
# AWS AppSync GraphQL APIのサーバーサイドキャッシュを設定するリソースです。
# キャッシュを有効にすることで、リゾルバの実行結果をAmazon ElastiCache (Redis OSS)
# インスタンスに保存し、読み取り負荷の軽減とレスポンス時間の改善を実現します。
#
# AWS公式ドキュメント:
#   - AppSyncキャッシュ設定: https://docs.aws.amazon.com/appsync/latest/devguide/enabling-caching.html
#   - AppSync概要: https://docs.aws.amazon.com/appsync/latest/devguide/what-is-appsync.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_api_cache
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_api_cache" "example" {
  #-------------------------------------------------------------
  # API設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: キャッシュを有効にするGraphQL APIのIDを指定します。
  # 設定可能な値: aws_appsync_graphql_api リソースのID
  api_id = aws_appsync_graphql_api.example.id

  #-------------------------------------------------------------
  # キャッシング動作設定
  #-------------------------------------------------------------

  # api_caching_behavior (Required)
  # 設定内容: APIキャッシュの動作モードを指定します。
  # 設定可能な値:
  #   - "FULL_REQUEST_CACHING": 全リゾルバの実行結果を個別にキャッシュ。
  #       context.argumentsとcontext.identityをキャッシュキーとして使用。
  #       キャッシュヒット時はTTL期限までデータソースへのアクセスをバイパス。
  #   - "PER_RESOLVER_CACHING": リゾルバごとに個別にキャッシュを有効化。
  #       各リゾルバでTTLとキャッシュキーをカスタマイズ可能。
  # 関連機能: AppSyncサーバーサイドキャッシュ
  #   頻繁にリクエストされるデータをキャッシュし、リゾルバへの負荷を軽減。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/enabling-caching.html
  api_caching_behavior = "FULL_REQUEST_CACHING"

  #-------------------------------------------------------------
  # キャッシュインスタンスタイプ設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: キャッシュに使用するElastiCache (Redis OSS) インスタンスタイプを指定します。
  # 設定可能な値:
  #   - "SMALL": 1 vCPU, 1.5 GiB RAM, Low to moderate network
  #   - "MEDIUM": 2 vCPU, 3 GiB RAM, Low to moderate network
  #   - "LARGE": 2 vCPU, 12.3 GiB RAM, Up to 10 Gigabit network
  #   - "XLARGE": 4 vCPU, 25.05 GiB RAM, Up to 10 Gigabit network
  #   - "LARGE_2X": 8 vCPU, 50.47 GiB RAM, Up to 10 Gigabit network
  #   - "LARGE_4X": 16 vCPU, 101.38 GiB RAM, Up to 10 Gigabit network
  #   - "LARGE_8X": 32 vCPU, 203.26 GiB RAM, 10 Gigabit network (一部リージョン)
  #   - "LARGE_12X": 48 vCPU, 317.77 GiB RAM, 10 Gigabit network
  #   - "T2_SMALL": T2ファミリーの小型インスタンス
  #   - "T2_MEDIUM": T2ファミリーの中型インスタンス
  #   - "R4_LARGE": R4ファミリーの大型インスタンス
  #   - "R4_XLARGE": R4ファミリーのXLインスタンス
  #   - "R4_2XLARGE": R4ファミリーの2XLインスタンス
  #   - "R4_4XLARGE": R4ファミリーの4XLインスタンス
  #   - "R4_8XLARGE": R4ファミリーの8XLインスタンス
  # 注意: インスタンスタイプによりコストとパフォーマンスが異なります。
  #       ワークロードに応じて適切なサイズを選択してください。
  type = "LARGE"

  #-------------------------------------------------------------
  # TTL設定
  #-------------------------------------------------------------

  # ttl (Required)
  # 設定内容: キャッシュエントリの有効期間（秒）を指定します。
  # 設定可能な値: 1〜3600（秒）
  # 注意: 最大TTLは3,600秒（1時間）です。
  #       TTL期限切れ後、キャッシュエントリは自動的に削除されます。
  # 関連機能: キャッシュTTL
  #   キャッシュされたデータの有効期間を制御。短いTTLは新鮮なデータを提供し、
  #   長いTTLはパフォーマンスを向上させますが、データの鮮度が低下する可能性があります。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/enabling-caching.html
  ttl = 900

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
  # 暗号化設定
  #-------------------------------------------------------------

  # at_rest_encryption_enabled (Optional)
  # 設定内容: キャッシュの保存時暗号化を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 保存時暗号化を有効化
  #   - false: 保存時暗号化を無効化
  # 注意: 作成後にこの設定を変更することはできません。
  #       新規キャッシュでは暗号化がデフォルトで有効になり、無効化できません。
  # 関連機能: AppSyncキャッシュ暗号化
  #   キャッシュデータを暗号化して保護。コンプライアンス要件を満たすために重要。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/enabling-caching.html
  at_rest_encryption_enabled = true

  # transit_encryption_enabled (Optional)
  # 設定内容: キャッシュへの接続時の転送中暗号化を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 転送中暗号化を有効化
  #   - false: 転送中暗号化を無効化
  # 注意: 作成後にこの設定を変更することはできません。
  #       新規キャッシュでは暗号化がデフォルトで有効になり、無効化できません。
  # 関連機能: AppSyncキャッシュ暗号化
  #   AppSyncとキャッシュ間の通信を暗号化して保護。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/enabling-caching.html
  transit_encryption_enabled = true
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AppSync API ID（api_idと同じ値）
#
#---------------------------------------------------------------
