################################################################################
# Route53 Traffic Policy Instance
################################################################################
# トラフィックポリシーインスタンスを作成し、指定されたホストゾーンにリソースレコードセットを自動的に作成します。
# トラフィックポリシーを使用することで、単一のドメイン名に対して複数のDNSルーティング設定を組み合わせることができます。
#
# 主な機能:
# - トラフィックポリシーの設定に基づいてDNSルーティングを実現
# - フェイルオーバー、地理的ルーティング、レイテンシーベースルーティングなどを組み合わせ可能
# - トラフィックポリシーのバージョン管理に対応
# - ポリシーインスタンスの作成後、Route 53が自動的にリソースレコードセットを作成
#
# 料金情報:
# - 各ポリシーレコード（インスタンス）に月額料金が発生します
# - 複数のドメイン/サブドメインで同じポリシーを使用する場合、CNAMEまたはエイリアスレコードで参照することで料金を削減可能
#
# 注意事項:
# - トラフィックポリシーは事前に作成されている必要があります
# - ポリシーインスタンス作成後、リソースレコードセットの作成に若干の遅延があります
# - 削除する場合は、Route 53がDNSクエリへの応答を停止します
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_traffic_policy_instance
# API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_CreateTrafficPolicyInstance.html
################################################################################

resource "aws_route53_traffic_policy_instance" "example" {
  # name - (Required) トラフィックポリシーインスタンスのドメイン名
  # Route 53がこの名前に対するDNSクエリに応答する際に、トラフィックポリシーで作成されたリソースレコードセットを使用します
  #
  # 指定方法:
  # - 完全修飾ドメイン名（FQDN）を指定します（例: "test.example.com"）
  # - ホストゾーンで管理されているドメインまたはサブドメインである必要があります
  # - 最大長: 1024文字
  #
  # 使用例:
  # - "example.com"（ルートドメイン）
  # - "www.example.com"（サブドメイン）
  # - "api.production.example.com"（マルチレベルサブドメイン）
  name = "test.example.com"

  # traffic_policy_id - (Required) 使用するトラフィックポリシーのID
  # Route 53が生成するUUID形式のIDです
  #
  # 取得方法:
  # - AWS Management Console、CLI、またはAPIでトラフィックポリシーを作成した際に生成されます
  # - 形式: UUIDv4（例: "b3gb108f-ea6f-45a5-baab-9d112d8b4037"）
  # - 長さ: 最小1文字、最大36文字
  #
  # トラフィックポリシーについて:
  # - トラフィックポリシーはJSON形式でルーティングルールを定義します
  # - フェイルオーバー、地理的ルーティング、レイテンシー、加重ルーティングなどを組み合わせ可能
  # - aws_route53_traffic_policyリソースまたはRoute 53コンソールで作成できます
  traffic_policy_id = "b3gb108f-ea6f-45a5-baab-9d112d8b4037"

  # traffic_policy_version - (Required) 使用するトラフィックポリシーのバージョン
  # トラフィックポリシーは編集時に自動的に新しいバージョンが作成されます
  #
  # バージョン管理:
  # - トラフィックポリシーの各編集で新しいバージョンが自動生成されます
  # - バージョン番号は1から始まり、編集ごとに増加します
  # - 範囲: 1〜1000
  # - 異なるバージョンを使用することで、段階的なロールアウトやロールバックが可能です
  #
  # ベストプラクティス:
  # - 本番環境では安定したバージョンを指定
  # - テスト環境で新バージョンを検証してから本番に適用
  traffic_policy_version = 1

  # hosted_zone_id - (Required) リソースレコードセットを作成するホストゾーンのID
  # Route 53が管理するホストゾーンの一意の識別子です
  #
  # 指定方法:
  # - ホストゾーンIDは通常「Z」で始まる英数字の文字列です（例: "Z033120931TAQO548OGJC"）
  # - aws_route53_zoneリソースのzone_id属性を参照することを推奨します
  # - 最大長: 32文字
  #
  # 注意事項:
  # - パブリックホストゾーンとプライベートホストゾーンの両方に対応
  # - 指定したnameがこのホストゾーンで管理されているドメイン配下である必要があります
  #
  # 参照例:
  # hosted_zone_id = aws_route53_zone.main.zone_id
  hosted_zone_id = "Z033120931TAQO548OGJC"

  # ttl - (Required) TTL（Time To Live）値（秒単位）
  # Route 53が作成するすべてのリソースレコードセットに適用されるTTL値です
  #
  # TTLについて:
  # - DNSリゾルバーがレコードをキャッシュする期間を指定します
  # - 範囲: 0〜2147483647秒
  # - 一般的な値: 60（1分）、300（5分）、3600（1時間）、86400（1日）
  #
  # 推奨値:
  # - 頻繁に変更される場合: 60〜300秒（短いTTL）
  # - 安定したエンドポイント: 3600〜86400秒（長いTTL）
  # - 本番環境移行時: 300秒程度（柔軟性を確保）
  # - 安定稼働後: 3600秒以上（DNSクエリ負荷を軽減）
  #
  # トレードオフ:
  # - 短いTTL: 変更が素早く反映されるが、DNSクエリが増加
  # - 長いTTL: DNSクエリが減少するが、変更の反映に時間がかかる
  ttl = 360

  ################################################################################
  # Computed Attributes（読み取り専用属性）
  ################################################################################
  # 以下の属性は自動的に設定され、他のリソースから参照可能です:
  #
  # - id: トラフィックポリシーインスタンスのID（Route 53が自動生成）
  #   例: "df579d9a-6396-410e-ac22-e7ad60cf9e7e"
  #   使用例: aws_route53_traffic_policy_instance.example.id
  #
  # - arn: Amazon Resource Name（ARN）
  #   形式: arn:aws:route53:::trafficpolicyinstance/{id}
  #   使用例: aws_route53_traffic_policy_instance.example.arn
  #   IAMポリシーやタグで使用可能
  ################################################################################

  ################################################################################
  # 使用例と一般的なパターン
  ################################################################################
  # 1. 既存のトラフィックポリシーとホストゾーンを参照する場合:
  #
  # resource "aws_route53_traffic_policy_instance" "example" {
  #   name                   = "api.${aws_route53_zone.main.name}"
  #   traffic_policy_id      = aws_route53_traffic_policy.example.id
  #   traffic_policy_version = aws_route53_traffic_policy.example.version
  #   hosted_zone_id         = aws_route53_zone.main.zone_id
  #   ttl                    = 300
  # }
  #
  # 2. 複数のドメインで同じトラフィックポリシーを使用する場合（CNAMEで参照）:
  #
  # resource "aws_route53_traffic_policy_instance" "primary" {
  #   name                   = "api.example.com"
  #   traffic_policy_id      = var.traffic_policy_id
  #   traffic_policy_version = var.traffic_policy_version
  #   hosted_zone_id         = aws_route53_zone.main.zone_id
  #   ttl                    = 300
  # }
  #
  # resource "aws_route53_record" "alias" {
  #   zone_id = aws_route53_zone.main.zone_id
  #   name    = "www.example.com"
  #   type    = "CNAME"
  #   ttl     = 300
  #   records = [aws_route53_traffic_policy_instance.primary.name]
  # }
  #
  # 3. 複数環境で異なるポリシーバージョンを使用する場合:
  #
  # resource "aws_route53_traffic_policy_instance" "staging" {
  #   name                   = "api.staging.example.com"
  #   traffic_policy_id      = aws_route53_traffic_policy.example.id
  #   traffic_policy_version = 2  # 新しいバージョンをステージングで検証
  #   hosted_zone_id         = aws_route53_zone.staging.zone_id
  #   ttl                    = 60  # 短いTTLで柔軟性を確保
  # }
  #
  # resource "aws_route53_traffic_policy_instance" "production" {
  #   name                   = "api.example.com"
  #   traffic_policy_id      = aws_route53_traffic_policy.example.id
  #   traffic_policy_version = 1  # 検証済みの安定バージョン
  #   hosted_zone_id         = aws_route53_zone.main.zone_id
  #   ttl                    = 300
  # }
  ################################################################################

  ################################################################################
  # トラブルシューティング
  ################################################################################
  # よくあるエラーと対処法:
  #
  # 1. "NoSuchTrafficPolicy":
  #    - traffic_policy_idが存在しないか、誤っています
  #    - トラフィックポリシーが作成されているか確認してください
  #
  # 2. "NoSuchHostedZone":
  #    - hosted_zone_idが存在しないか、誤っています
  #    - ホストゾーンIDを確認してください
  #
  # 3. "TrafficPolicyInstanceAlreadyExists":
  #    - 同じホストゾーン内で同じnameのインスタンスが既に存在します
  #    - 既存のインスタンスを削除するか、異なる名前を使用してください
  #
  # 4. "TooManyTrafficPolicyInstances":
  #    - アカウントのトラフィックポリシーインスタンス数がクォータを超えています
  #    - 不要なインスタンスを削除するか、AWSサポートにクォータ引き上げを依頼してください
  #
  # 5. State "Failed":
  #    - インスタンス作成後にstateが"Failed"になる場合があります
  #    - AWS Management Consoleで詳細なエラーメッセージを確認してください
  #    - トラフィックポリシーのJSON定義を確認し、構文エラーや無効なエンドポイントがないか確認してください
  ################################################################################

  ################################################################################
  # セキュリティとベストプラクティス
  ################################################################################
  # 1. TTL設定:
  #    - 初期設定やテスト時は短いTTL（60-300秒）を使用
  #    - 安定稼働後は長いTTL（3600秒以上）でDNSクエリ負荷を軽減
  #
  # 2. バージョン管理:
  #    - ステージング環境で新しいバージョンを検証してから本番環境に適用
  #    - ロールバックに備えて、以前のバージョンも保持
  #
  # 3. コスト最適化:
  #    - 複数のドメイン/サブドメインで同じトラフィックポリシーを使用する場合、
  #      1つのポリシーインスタンスを作成し、他はCNAMEまたはエイリアスレコードで参照
  #
  # 4. モニタリング:
  #    - CloudWatch Logsでクエリログを有効化し、トラフィックパターンを監視
  #    - Route 53メトリクスでDNSクエリ数を追跡
  #
  # 5. 命名規則:
  #    - nameには明確で一貫性のある命名規則を使用（例: {service}.{environment}.{domain}）
  #    - 環境（dev/staging/prod）を明確に区別
  ################################################################################

  ################################################################################
  # インポート
  ################################################################################
  # 既存のRoute53トラフィックポリシーインスタンスをインポートする場合:
  #
  # terraform import aws_route53_traffic_policy_instance.example df579d9a-6396-410e-ac22-e7ad60cf9e7e
  #
  # インスタンスIDはAWS Management Console、CLI、またはAPIで確認できます:
  # aws route53 list-traffic-policy-instances
  ################################################################################
}
