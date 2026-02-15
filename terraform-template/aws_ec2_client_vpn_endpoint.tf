#---------------------------------------
# AWS EC2 Client VPN Endpoint
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_client_vpn_endpoint
#
# 用途: VPCリソースへの安全なリモートアクセスを提供するClient VPNエンドポイントを管理
# 主な機能:
#   - クライアント認証（証明書/Active Directory/SAML）
#   - IPv4/IPv6/デュアルスタック対応
#   - スプリットトンネル設定
#   - 接続ログとバナー表示
#   - セルフサービスポータル
#
# 制限事項:
#   - 1エンドポイントにつき1つのIdPのみ関連付け可能
#   - 最大2つの認証方法を組み合わせ可能（証明書+ユーザーベース）
#   - SAMLレスポンスの最大サイズ制限あり
#   - VPN接続数はVPCのサブネットCIDRサイズに依存
#
# 注意事項:
#   - サーバー証明書はAWS Certificate Managerに事前登録が必要
#   - 認証方法の変更は既存接続に影響を与える
#   - セキュリティグループは関連付けられたサブネットのENIに適用
#   - 課金は時間単位+データ転送量で発生
#
# NOTE: 本テンプレートは全属性を網羅していますが、実際の使用時は必要な項目のみを設定してください

resource "aws_ec2_client_vpn_endpoint" "example" {
  #---------------------------------------
  # サーバー証明書設定（必須）
  #---------------------------------------
  # 設定内容: VPNサーバー証明書のARN（AWS Certificate Managerに登録）
  # 認証方式: クライアント認証方式に関わらず必須
  # 証明書要件: RFC 5280準拠、CN属性を含むSubjectフィールド
  # キーサイズ: 1024-bitまたは2048-bit RSAキー対応
  # 自動更新: 証明書更新後5時間以内にエンドポイントに自動反映
  server_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-ab12-cd34-ef56-abcdef123456"

  #---------------------------------------
  # クライアントIPアドレス範囲設定
  #---------------------------------------
  # 設定内容: VPN接続クライアントに割り当てるIPv4 CIDRブロック
  # CIDRサイズ: /12〜/22の範囲（最小4096アドレス〜最大1,048,576アドレス）
  # 重複禁止: VPCやオンプレミスネットワークと重複しない範囲を指定
  # デュアルスタック: IPv6使用時も本設定は必須
  # 省略時: デフォルト値なし（必須パラメータではないがほぼ必須）
  client_cidr_block = "10.0.0.0/16"

  #---------------------------------------
  # VPC関連付け設定
  #---------------------------------------
  # 設定内容: Client VPNエンドポイントを配置するVPCのID
  # 用途: ターゲットネットワークとの関連付け
  # ネットワーク関連付け: 別途aws_ec2_client_vpn_network_associationリソースで設定
  # 省略時: VPC IDが自動設定される場合あり（ネットワーク関連付け時）
  vpc_id = "vpc-12345678"

  #---------------------------------------
  # セキュリティグループ設定
  #---------------------------------------
  # 設定内容: ターゲットネットワークのENIに適用するセキュリティグループIDのセット
  # 適用対象: Client VPN経由でアクセスされるリソース側のENI
  # 推奨設定: VPNクライアントからのアクセスを許可するインバウンドルール
  # 省略時: VPCのデフォルトセキュリティグループが適用
  security_group_ids = ["sg-12345678", "sg-87654321"]

  #---------------------------------------
  # 認証設定（必須）
  #---------------------------------------
  # 認証方式: 証明書/Active Directory/SAML（最大2つまで組み合わせ可能）
  # 組み合わせ例: 証明書+Active Directory、証明書+SAML
  # 最小個数: 1個（必須）
  # 最大個数: 2個
  authentication_options {
    # 設定内容: 認証タイプの種類
    # 設定可能な値:
    #   - certificate-authentication（証明書ベース）
    #   - directory-service-authentication（Active Directory）
    #   - federated-authentication（SAML 2.0フェデレーション）
    # RFC 5280: 証明書認証の場合、CN属性を含むSubjectフィールドが必要
    type = "certificate-authentication"

    # 設定内容: 証明書認証時のルート証明書チェーンARN
    # 用途: クライアント証明書の検証に使用
    # ACM登録: クライアント証明書のCAがサーバー証明書と異なる場合のみACMに登録
    # 証明書管理: ユーザー毎に個別証明書を作成し失効管理が可能
    # 省略時: type=certificate-authenticationの場合は必須
    root_certificate_chain_arn = "arn:aws:acm:us-east-1:123456789012:certificate/efgh5678-ef56-gh78-ij90-efghij567890"
  }

  # Active Directory認証の例（オプション）
  # authentication_options {
  #   type                = "directory-service-authentication"
  #   active_directory_id = "d-1234567890"
  # }

  # SAML認証の例（オプション）
  # authentication_options {
  #   type              = "federated-authentication"
  #   saml_provider_arn = "arn:aws:iam::123456789012:saml-provider/MyIdP"
  #   self_service_saml_provider_arn = "arn:aws:iam::123456789012:saml-provider/SelfServiceIdP"
  # }

  #---------------------------------------
  # 接続ログ設定（必須）
  #---------------------------------------
  # 用途: クライアント接続のログ記録とモニタリング
  # 保存先: CloudWatch Logsまたは無効化
  # コンプライアンス: 監査要件がある場合は有効化を推奨
  connection_log_options {
    # 設定内容: 接続ログの有効/無効
    # 設定可能な値: true（有効）、false（無効）
    # 推奨設定: セキュリティ監査のため有効化
    enabled = true

    # 設定内容: ログ出力先CloudWatch Logsロググループ名
    # 要件: ロググループは事前作成が必要
    # IAM権限: Client VPNサービスに書き込み権限が必要
    # 省略時: enabled=trueの場合は必須
    cloudwatch_log_group = "/aws/vpn/client-vpn-endpoint"

    # 設定内容: ログストリーム名
    # 省略時: 自動生成されたストリーム名が使用される
    # 参照用: Computed属性として値を取得可能
    cloudwatch_log_stream = "vpn-connection-logs"
  }

  #---------------------------------------
  # DNSサーバー設定
  #---------------------------------------
  # 設定内容: VPN接続時にクライアントが使用するDNSサーバーのIPアドレスリスト
  # 最大個数: 2つまで指定可能
  # 推奨設定: VPC内リソースへの名前解決にVPC DNSサーバーを指定
  # Split Horizon DNS: プライベートホストゾーンの名前解決に必要
  # 省略時: クライアント側のローカルDNS設定が使用される
  dns_servers = ["10.0.0.2", "10.0.0.3"]

  #---------------------------------------
  # トランスポート設定
  #---------------------------------------
  # 設定内容: VPNセッションで使用するトランスポートプロトコル
  # 設定可能な値: tcp、udp
  # TCP特性: 信頼性重視、ファイアウォール通過性が高い
  # UDP特性: 低遅延、パフォーマンス重視
  # 省略時: udp（推奨）
  transport_protocol = "udp"

  # 設定内容: Client VPNエンドポイントのポート番号
  # 設定可能な値: 443、1194（udpの場合）、443のみ（tcpの場合）
  # セキュリティ: ファイアウォールで許可が必要
  # 省略時: プロトコルに応じたデフォルト値（UDP=1194、TCP=443）
  vpn_port = 1194

  #---------------------------------------
  # スプリットトンネル設定
  #---------------------------------------
  # 設定内容: スプリットトンネルの有効/無効
  # 設定可能な値: true（有効）、false（無効）
  # 有効時: VPN経由ルート以外のトラフィックはローカルインターネット経由
  # 無効時: 全トラフィックがVPN経由（フルトンネル）
  # セキュリティ: コンプライアンス要件に応じて選択
  # データ転送量: 有効化によりVPN経由のデータ量を削減可能
  # 省略時: false（全トラフィックVPN経由）
  split_tunnel = true

  #---------------------------------------
  # セッション管理設定
  #---------------------------------------
  # 設定内容: VPNセッションの最大継続時間（時間単位）
  # 設定可能な値: 8、10、12、24時間
  # 用途: セキュリティポリシーに基づく定期的な再認証
  # 省略時: 24時間（デフォルト）
  session_timeout_hours = 12

  # 設定内容: セッションタイムアウト時に自動切断するか
  # 設定可能な値: true（切断）、false（切断しない）
  # true時: session_timeout_hours経過後に自動切断・再認証要求
  # false時: アイドル状態でもセッション維持
  # 省略時: false
  disconnect_on_session_timeout = true

  #---------------------------------------
  # セルフサービスポータル設定
  #---------------------------------------
  # 設定内容: セルフサービスポータルの有効/無効
  # 設定可能な値: enabled、disabled
  # enabled時: ユーザーが自分でVPNクライアント設定ファイルをダウンロード可能
  # ポータルURL: self_service_portal_urlで参照可能
  # 省略時: disabled
  self_service_portal = "enabled"

  #---------------------------------------
  # IPアドレスタイプ設定
  #---------------------------------------
  # 設定内容: Client VPNエンドポイントのIPアドレスタイプ
  # 設定可能な値: ipv4、ipv6、dual-stack
  # dual-stack: IPv4とIPv6両方をサポート
  # 要件: VPCサブネットのIPアドレス設定と整合性が必要
  # 省略時: ipv4
  endpoint_ip_address_type = "ipv4"

  # 設定内容: VPNトラフィックのIPアドレスタイプ
  # 設定可能な値: ipv4、ipv6、dual-stack
  # エンドポイントとトラフィックで異なる設定も可能
  # 省略時: endpoint_ip_address_typeと同じ値
  traffic_ip_address_type = "ipv4"

  #---------------------------------------
  # クライアント接続オプション（オプション）
  #---------------------------------------
  # 用途: Lambda関数による接続認可の制御
  # ユースケース: 追加の認証ロジックや条件付きアクセス制御
  client_connect_options {
    # 設定内容: クライアント接続時のLambda認可の有効/無効
    # 設定可能な値: true（有効）、false（無効）
    # 省略時: false
    enabled = false

    # 設定内容: 接続時に実行するLambda関数のARN
    # 実行タイミング: クライアント接続時
    # 関数要件: Client VPN接続コンテキストを受け取り認可結果を返す
    # 省略時: enabled=falseの場合は不要
    # lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:client-vpn-authorizer"
  }

  #---------------------------------------
  # ログインバナーオプション（オプション）
  #---------------------------------------
  # 用途: VPNセッション確立時にクライアントに表示するカスタムテキストバナー
  # 対象クライアント: AWS提供クライアント使用時のみ表示
  # ユースケース: 利用規約、セキュリティ警告の表示
  client_login_banner_options {
    # 設定内容: ログインバナーの有効/無効
    # 設定可能な値: true（有効）、false（無効）
    # 省略時: false
    enabled = false

    # 設定内容: 表示するバナーテキスト
    # 文字数制限: 最大1400文字
    # 改行対応: 改行文字を含めることが可能
    # 省略時: enabled=trueの場合は空のバナー
    # banner_text = "Authorized users only. All activities are monitored."
  }

  #---------------------------------------
  # クライアントルート強制オプション（オプション）
  #---------------------------------------
  # 用途: 管理者定義ルートの強制適用
  # 動作: VPN接続デバイス上で管理者定義ルートを上書き不可にする
  client_route_enforcement_options {
    # 設定内容: ルート強制の有効/無効
    # 設定可能な値: true（強制）、false（強制なし）
    # true時: クライアント側でルートテーブル変更不可
    # セキュリティ: トラフィック制御の厳格化に有効
    # 省略時: false
    enforced = false
  }

  #---------------------------------------
  # 説明とタグ
  #---------------------------------------
  # 設定内容: Client VPNエンドポイントの説明
  # 用途: 管理画面での識別、目的の明確化
  # 文字数制限: 最大255文字
  description = "Development environment Client VPN endpoint"

  # 設定内容: リソースに付与するタグ
  # キー/値のペア: 最大50個まで
  # 自動タグ付け: tags_allにプロバイダーレベルのデフォルトタグが統合される
  tags = {
    Name        = "dev-client-vpn"
    Environment = "development"
    ManagedBy   = "terraform"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: AWSリージョンコード（us-east-1、ap-northeast-1など）
  # 用途: マルチリージョン構成での明示的なリージョン指定
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"
}

#---------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------
# 以下の属性はリソース作成後に参照可能:
#
# - id: Client VPNエンドポイントID（例: cvpn-endpoint-1234567890abcdef0）
# - arn: Client VPNエンドポイントのARN
# - dns_name: クライアントが接続に使用するDNS名（例: *.cvpn-endpoint-1234567890abcdef0.prod.clientvpn.us-east-1.amazonaws.com）
# - self_service_portal_url: セルフサービスポータルのURL（self_service_portal=enabled時のみ）
# - region: エンドポイントが管理されるリージョン
# - tags_all: 全タグ（リソースタグ+プロバイダーデフォルトタグ）
#
# 参照例:
# output "vpn_endpoint_id" {
#   value = aws_ec2_client_vpn_endpoint.example.id
# }
# output "vpn_dns_name" {
#   value = aws_ec2_client_vpn_endpoint.example.dns_name
# }
