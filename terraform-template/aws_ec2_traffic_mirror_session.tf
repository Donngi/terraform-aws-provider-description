################################################################################
# aws_ec2_traffic_mirror_session
################################################################################
# AWS Provider Version: 6.28.0
#
# リソース概要:
# Traffic Mirror Sessionは、VPCトラフィックミラーリングの中核となるリソースで、
# トラフィックミラーソース（監視対象のネットワークインターフェース）と
# トラフィックミラーターゲット（ミラーリングされたトラフィックの送信先）間の
# 関係を確立します。このセッションにより、EC2インスタンスやRDSインスタンスなどの
# ネットワークトラフィックをコピーして、セキュリティ監視、脅威検出、
# トラブルシューティング、ネットワーク分析ツールに送信できます。
#
# トラフィックミラーリングの仕組み:
# 1. ミラーリングされたトラフィックはVXLANヘッダーでカプセル化されます
# 2. セッション番号によって、複数のセッションが存在する場合の評価順序が決まります
# 3. フィルタールールに一致した最初のセッションがパケットをミラーリングします
# 4. ソースとターゲットは同じVPCまたは異なるVPC（VPCピアリング、Transit Gateway経由）に配置可能
#
# 制約事項:
# - すべてのネットワークインターフェースがミラーソースとして使用可能ではありません
# - EC2インスタンスの場合、Nitroベースのインスタンスのみがミラーリングをサポートします
# - ソースネットワークインターフェースが削除されると、トラフィックミラーリングセッションも削除されます
# - ネットワークインターフェースが既存のトラフィックミラーターゲットで使用されている場合、
#   ソースとして使用できません
# - NLBターゲットの場合、デフォルトのパケット長は8500バイトに設定されます
#
# 主なユースケース:
# - セキュリティ分析とコンプライアンス監査
# - 侵入検知システム(IDS)への トラフィック送信
# - ネットワークパフォーマンスの監視と最適化
# - トラブルシューティングとデバッグ
# - パケットレベルでの詳細なトラフィック分析
#
# 参考資料:
# - https://docs.aws.amazon.com/vpc/latest/mirroring/traffic-mirroring-considerations.html
# - https://docs.aws.amazon.com/vpc/latest/mirroring/traffic-mirroring-sessions.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_traffic_mirror_session

resource "aws_ec2_traffic_mirror_session" "example" {
  ###############################################################################
  # 必須パラメータ (Required Parameters)
  ###############################################################################

  # network_interface_id - (必須, 新規作成を強制)
  # ミラーソースとなるネットワークインターフェースのID
  #
  # 説明:
  # - トラフィックをミラーリングする対象のENI（Elastic Network Interface）を指定します
  # - EC2インスタンスの場合、primary_network_interface_idを使用します
  # - すべてのネットワークインターフェースがミラーソースとして適格ではありません
  # - Nitroベースのインスタンスのみがミラーリングをサポートしています
  # - このインターフェースが既にトラフィックミラーターゲットで使用されている場合は
  #   ソースとして使用できません
  #
  # 注意事項:
  # - この値を変更すると、リソースが再作成されます（Forces new resource）
  # - ソースインターフェースが削除されると、セッションも自動的に削除されます
  # - インターフェースは有効な状態（available/in-use）である必要があります
  #
  # 対応するAWS APIパラメータ: NetworkInterfaceId
  # 型: string
  # 必須: はい
  network_interface_id = aws_instance.example.primary_network_interface_id

  # session_number - (必須)
  # セッション番号（トラフィックミラーリングセッションの評価順序）
  #
  # 説明:
  # - インターフェースが複数のセッションで使用される場合のセッション評価順序を決定します
  # - 一致するフィルタを持つ最初のセッションがパケットをミラーリングします
  # - 低い番号のセッションが高い番号のセッションより先に評価されます
  # - 同じインターフェースで複数のセッションを使用する場合、各セッションに
  #   異なる番号を割り当てる必要があります
  #
  # 使用例:
  # - セッション1: すべてのHTTPトラフィックをセキュリティツールにミラー
  # - セッション2: すべてのSSHトラフィックを監査ツールにミラー
  # - セッション3: その他のトラフィックをネットワーク分析ツールにミラー
  #
  # ベストプラクティス:
  # - 優先度の高いセキュリティ関連のミラーリングには低い番号を使用
  # - 一般的な監視やログ収集には高い番号を使用
  # - 番号の間に間隔を空けて、後で追加のセッションを挿入できるようにする
  #
  # 対応するAWS APIパラメータ: SessionNumber
  # 型: integer
  # 必須: はい
  # 有効な値: 1-32766
  session_number = 1

  # traffic_mirror_filter_id - (必須)
  # トラフィックミラーフィルターのID
  #
  # 説明:
  # - どのトラフィックをミラーリングするかを定義するフィルターのIDを指定します
  # - フィルターには、プロトコル、送信元/宛先CIDR、ポート範囲などのルールが含まれます
  # - デフォルトでは、トラフィックはミラーリングされず、フィルタールールを
  #   作成してミラーリングするトラフィックを指定する必要があります
  #
  # フィルターの例:
  # - インバウンドTCPトラフィックのみをミラー
  # - 特定のポート（例: 80, 443）のトラフィックをミラー
  # - 特定のCIDR範囲からのトラフィックをミラー
  # - VPC間トラフィックを除外してインターネットバウンドトラフィックのみをミラー
  #
  # 注意事項:
  # - フィルターは aws_ec2_traffic_mirror_filter リソースで事前に作成する必要があります
  # - フィルターには複数のインバウンド/アウトバウンドルールを含めることができます
  # - amazon-dns のようなネットワークサービスもフィルタリング可能です
  #
  # 対応するAWS APIパラメータ: TrafficMirrorFilterId
  # 型: string
  # 必須: はい
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.example.id

  # traffic_mirror_target_id - (必須)
  # トラフィックミラーターゲットのID
  #
  # 説明:
  # - ミラーリングされたトラフィックの送信先を指定します
  # - ターゲットは以下のいずれかになります:
  #   1. ネットワークインターフェース（ENI）
  #   2. Network Load Balancer（NLB）のARN - 高可用性のため推奨
  #   3. Gateway Load Balancer エンドポイント - 高可用性のため推奨
  #
  # ターゲットタイプの選択:
  # - ENI: シンプルな構成、単一のインスタンスへの直接ミラーリング
  # - NLB: 複数の監視インスタンスへの負荷分散、高可用性
  # - GWLB: アプライアンスベースの分析、スケーラブルなセキュリティ監視
  #
  # NLBターゲットの要件:
  # - ポート4789でUDPリスナーが必要
  # - クロスゾーン負荷分散を有効化することを推奨
  # - セキュリティグループでVXLANトラフィック（ポート4789 UDP）を許可
  #
  # ネットワーク構成:
  # - ソースとターゲットは同じVPCまたは異なるVPCに配置可能
  # - 異なるVPCの場合、VPCピアリング、Transit Gateway、または
  #   Gateway Load Balancer エンドポイント経由で接続
  # - ターゲットは異なるAWSアカウントが所有することも可能
  #
  # 対応するAWS APIパラメータ: TrafficMirrorTargetId
  # 型: string
  # 必須: はい
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.example.id

  ###############################################################################
  # オプションパラメータ (Optional Parameters)
  ###############################################################################

  # description - (オプション)
  # トラフィックミラーセッションの説明
  #
  # 説明:
  # - セッションの目的や用途を説明する人間が読めるテキスト
  # - セッション管理やトラブルシューティングに役立つ情報を含めることを推奨
  #
  # 推奨される記述内容:
  # - セッションの目的（例: "セキュリティ監視", "パフォーマンス分析"）
  # - 監視対象のアプリケーションやサービス
  # - 責任者やチーム名
  # - 作成日時や環境情報
  #
  # 例:
  # - "Production web server traffic monitoring for security analysis"
  # - "Database traffic mirroring to performance analysis tool"
  # - "SSH traffic monitoring for compliance audit - Created by SecOps team"
  #
  # 対応するAWS APIパラメータ: Description
  # 型: string
  # 必須: いいえ
  # デフォルト: なし
  description = "Traffic mirror session for production web servers - security monitoring"

  # packet_length - (オプション)
  # ミラーリングする各パケットのバイト数
  #
  # 説明:
  # - VXLANヘッダー後のバイト数を指定します（VXLANヘッダー自体は含まれません）
  # - パケット全体をミラーリングする場合は、このパラメータを指定しないでください
  # - パケットのサブセットをミラーリングする場合、ミラーリングする長さ（バイト単位）を
  #   この値に設定します
  #
  # ユースケース:
  # - ヘッダー情報のみが必要な場合（パケットの最初の数百バイト）
  # - ネットワーク帯域幅やストレージコストを削減したい場合
  # - 大量のトラフィックから統計情報のみを収集する場合
  #
  # NLBターゲットの制約:
  # - Network Load Balancerターゲットの場合、デフォルトは8500バイト
  # - 有効な値: 1-8500バイト
  # - 8500バイトを超える値を設定するとエラーが発生します
  #
  # 注意事項:
  # - パケット長を制限すると、一部のプロトコル分析機能が制限される可能性があります
  # - HTTPSのようなペイロードを含むプロトコルでは、完全な分析にフルパケットが必要
  # - ヘッダー分析のみの場合は、通常200-300バイトで十分
  #
  # 対応するAWS APIパラメータ: PacketLength
  # 型: integer
  # 必須: いいえ
  # デフォルト: パケット全体（NLBの場合は8500バイト）
  # 有効な値: 1-8500
  # packet_length = 8500

  # virtual_network_id - (オプション)
  # トラフィックミラーセッションのVXLAN ID
  #
  # 説明:
  # - ミラーリングされたトラフィックをカプセル化するために使用されるVXLAN IDを指定します
  # - VXLAN（Virtual Extensible LAN）は、レイヤー2フレームをUDPパケット内で
  #   カプセル化するネットワーク仮想化技術です（RFC 7348）
  # - 指定しない場合、アカウント全体で一意なIDがランダムに選択されます
  #
  # VXLANの仕組み:
  # - ミラーリングされたトラフィックはVXLANヘッダーでカプセル化されます
  # - カプセル化されたパケットはUDPポート4789で送信されます
  # - ターゲット側の監視ソフトウェアはVXLANパケットを処理できる必要があります
  #
  # ユースケース:
  # - 複数のミラーセッションからのトラフィックを識別する必要がある場合
  # - 既存の監視インフラストラクチャが特定のVNIを期待している場合
  # - トラフィックソースを分類してルーティングする必要がある場合
  #
  # 注意事項:
  # - VNIを指定する場合、同じターゲットを使用する他のセッションと重複しないように
  #   注意してください
  # - ターゲット側の監視ツールがVXLANカプセル化を処理できることを確認してください
  # - AWS Marketplaceの監視ソリューションの多くはVXLANをサポートしています
  #
  # 対応するAWS APIパラメータ: VirtualNetworkId
  # 型: integer
  # 必須: いいえ
  # デフォルト: アカウント全体で一意なランダムID
  # 有効な値: 1-16777215 (24ビット値)
  # virtual_network_id = 12345

  # tags - (オプション)
  # リソースタグのキーと値のマップ
  #
  # 説明:
  # - リソースの整理、管理、コスト配分に使用されるメタデータタグ
  # - プロバイダーの default_tags 設定ブロックが存在する場合、一致するキーを持つタグは
  #   プロバイダーレベルで定義されたものを上書きします
  #
  # タグのベストプラクティス:
  # - Environment: 環境識別（dev, staging, production）
  # - Application: アプリケーション名
  # - Team: 責任チーム名
  # - CostCenter: コスト配分用
  # - Purpose: リソースの目的
  # - ManagedBy: 管理ツール（例: "Terraform"）
  #
  # タグ戦略:
  # - 組織全体で一貫したタグ付け規則を使用
  # - AWS Cost Explorer でコスト分析を容易にするタグを含める
  # - セキュリティポリシーやコンプライアンス要件に関連するタグを追加
  # - 自動化やフィルタリングに使用できるタグを含める
  #
  # 注意事項:
  # - タグキーと値は大文字小文字を区別します
  # - タグキーの最大長: 128文字
  # - タグ値の最大長: 256文字
  # - リソースあたり最大50個のタグ
  #
  # 対応するAWS APIパラメータ: Tags
  # 型: map(string)
  # 必須: いいえ
  # デフォルト: なし
  tags = {
    Name        = "production-web-traffic-mirror"
    Environment = "production"
    Application = "web-server"
    Team        = "security-ops"
    Purpose     = "security-monitoring"
    ManagedBy   = "Terraform"
    CostCenter  = "security"
  }

  # region - (オプション)
  # このリソースが管理されるリージョン
  #
  # 説明:
  # - リソースが作成・管理されるAWSリージョンを指定します
  # - 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます
  #
  # マルチリージョン構成:
  # - 異なるリージョンで個別のトラフィックミラーセッションを作成可能
  # - リージョン間でのトラフィックミラーリングはサポートされていません
  # - ソース、ターゲット、フィルターは同じリージョンに存在する必要があります
  #
  # ベストプラクティス:
  # - 通常はプロバイダー設定のリージョンを使用することを推奨
  # - 明示的なリージョン指定は、特定のリージョンに固定する必要がある場合のみ
  # - マルチリージョンデプロイメントでは、プロバイダーエイリアスの使用を推奨
  #
  # 対応するAWS APIパラメータ: Region
  # 型: string
  # 必須: いいえ
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-east-1"
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# これらの属性は Terraform によって自動的に設定され、参照のみ可能です。

# arn
# トラフィックミラーセッションのARN（Amazon Resource Name）
#
# 説明:
# - セッションを一意に識別するAWS ARN
# - IAMポリシー、リソースベースのポリシー、クロスアカウントアクセスで使用
# - 形式: arn:aws:ec2:region:account-id:traffic-mirror-session/tms-xxxxxxxxx
#
# 使用例:
# - IAMポリシーでの権限制御
# - CloudTrail ログでのリソース識別
# - クロスアカウント共有の参照
#
# 参照方法: aws_ec2_traffic_mirror_session.example.arn
# 型: string

# id
# セッションの名前（セッションID）
#
# 説明:
# - セッションを識別する一意のID
# - 形式: tms-xxxxxxxxxxxxxxxxx
# - AWS APIやCLIコマンドで使用
# - Terraform の depends_on や参照に使用
#
# 使用例:
# - 他のリソースからの参照
# - データソースでの検索
# - AWS CLIコマンドでの操作
#
# 参照方法: aws_ec2_traffic_mirror_session.example.id
# 型: string

# owner_id
# セッションを所有するAWSアカウントID
#
# 説明:
# - セッションを作成したAWSアカウントの12桁のID
# - マルチアカウント環境でのリソース所有権の識別に使用
# - 共有リソースやクロスアカウント構成の管理に役立つ
#
# 使用例:
# - セッションの所有権確認
# - マルチアカウント環境でのリソース追跡
# - コスト配分とチャージバック
#
# 参照方法: aws_ec2_traffic_mirror_session.example.owner_id
# 型: string

# tags_all
# リソースに割り当てられたすべてのタグのマップ
#
# 説明:
# - リソース固有のタグとプロバイダーの default_tags から継承されたタグの両方を含みます
# - プロバイダーレベルで設定されたデフォルトタグも含まれます
# - タグの完全なビューを提供し、すべての適用されたタグを確認できます
#
# 使用例:
# - 実際に適用されているすべてのタグの確認
# - タグベースのリソース管理とフィルタリング
# - コンプライアンスとガバナンスの監査
#
# 参照方法: aws_ec2_traffic_mirror_session.example.tags_all
# 型: map(string)

################################################################################
# 使用例 (Usage Examples)
################################################################################

# 例1: 基本的なトラフィックミラーセッション
# EC2インスタンスからNetwork Load Balancerへのトラフィックミラーリング
/*
resource "aws_ec2_traffic_mirror_filter" "example" {
  description      = "Traffic mirror filter for web traffic"
  network_services = ["amazon-dns"]
}

resource "aws_ec2_traffic_mirror_target" "nlb_target" {
  description               = "Traffic mirror target - NLB"
  network_load_balancer_arn = aws_lb.monitoring_nlb.arn
}

resource "aws_ec2_traffic_mirror_session" "web_traffic" {
  description              = "Mirror web server traffic to security monitoring NLB"
  network_interface_id     = aws_instance.web_server.primary_network_interface_id
  session_number           = 1
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.example.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.nlb_target.id

  tags = {
    Name        = "web-server-mirror"
    Environment = "production"
  }
}
*/

# 例2: 複数セッションでの優先順位付け
# 同じインターフェースで異なるフィルターを使用した複数セッション
/*
# セッション1: HTTPSトラフィックを優先的にセキュリティツールへ
resource "aws_ec2_traffic_mirror_session" "https_priority" {
  description              = "Priority mirroring for HTTPS traffic"
  network_interface_id     = aws_instance.app_server.primary_network_interface_id
  session_number           = 1  # 最初に評価
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.https_only.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.security_tool.id

  tags = {
    Name     = "https-priority-mirror"
    Priority = "high"
  }
}

# セッション2: その他のトラフィックを一般監視ツールへ
resource "aws_ec2_traffic_mirror_session" "general_traffic" {
  description              = "General traffic mirroring"
  network_interface_id     = aws_instance.app_server.primary_network_interface_id
  session_number           = 2  # 次に評価
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.all_traffic.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.monitoring_tool.id

  tags = {
    Name     = "general-traffic-mirror"
    Priority = "normal"
  }
}
*/

# 例3: パケット長制限とVXLAN IDの指定
# 帯域幅を節約するためにヘッダーのみをキャプチャ
/*
resource "aws_ec2_traffic_mirror_session" "header_only" {
  description              = "Mirror packet headers only for metadata analysis"
  network_interface_id     = aws_instance.database.primary_network_interface_id
  session_number           = 1
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.database_filter.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.analyzer.id

  # ヘッダー情報のみをキャプチャ（帯域幅削減）
  packet_length = 256

  # 特定のVXLAN IDで識別
  virtual_network_id = 1001

  tags = {
    Name       = "database-header-mirror"
    CaptureType = "headers-only"
  }
}
*/

# 例4: クロスVPCトラフィックミラーリング
# Transit Gateway経由で異なるVPCのターゲットへミラーリング
/*
resource "aws_ec2_traffic_mirror_session" "cross_vpc" {
  description              = "Cross-VPC traffic mirroring via Transit Gateway"
  network_interface_id     = aws_instance.source_vpc_instance.primary_network_interface_id
  session_number           = 1
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.cross_vpc_filter.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target_vpc_nlb.id

  tags = {
    Name         = "cross-vpc-mirror"
    SourceVPC    = "vpc-source-123"
    TargetVPC    = "vpc-target-456"
    Connectivity = "transit-gateway"
  }
}

# 注意: ソースVPCからターゲットVPCへのルーティングが設定されていることを確認
*/

# 例5: Gateway Load Balancerエンドポイントへのミラーリング
# スケーラブルなセキュリティアプライアンスへのトラフィック送信
/*
resource "aws_ec2_traffic_mirror_target" "gwlb_endpoint" {
  description                      = "Gateway Load Balancer endpoint target"
  gateway_load_balancer_endpoint_id = aws_vpc_endpoint.gwlb_endpoint.id
}

resource "aws_ec2_traffic_mirror_session" "to_gwlb" {
  description              = "Mirror traffic to GWLB for security inspection"
  network_interface_id     = aws_instance.workload.primary_network_interface_id
  session_number           = 1
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.security_filter.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.gwlb_endpoint.id

  tags = {
    Name           = "gwlb-security-mirror"
    InspectionType = "deep-packet-inspection"
  }
}
*/

################################################################################
# トラブルシューティング (Troubleshooting)
################################################################################

# よくある問題と解決策:

# 1. ミラーリングされたトラフィックが届かない
#    原因:
#    - ソースからターゲットへのルーティングが設定されていない
#    - ターゲットのセキュリティグループがVXLANトラフィック（UDP 4789）を許可していない
#    - ネットワークACLがトラフィックをブロックしている
#    解決策:
#    - VPCルートテーブルでターゲットへのルートを確認
#    - ターゲットのセキュリティグループでUDP 4789の受信を許可
#    - ネットワークACLの設定を確認

# 2. "Network interface is not eligible for mirroring"エラー
#    原因:
#    - インスタンスタイプがNitroベースではない
#    - ネットワークインターフェースが既にトラフィックミラーターゲットとして使用されている
#    解決策:
#    - Nitroベースのインスタンスタイプを使用（C5, M5, R5など）
#    - インターフェースがターゲットとして使用されていないことを確認

# 3. パケット長の設定エラー
#    原因:
#    - NLBターゲットで8500バイトを超える値を設定
#    解決策:
#    - packet_length を 1-8500 の範囲内に設定
#    - または packet_length を省略してデフォルト値を使用

# 4. セッション評価順序の問題
#    原因:
#    - 複数のセッションで session_number が重複または不適切
#    解決策:
#    - 各セッションに一意の session_number を割り当て
#    - 優先度の高いフィルターに低い番号を使用

# 5. クロスVPC接続の失敗
#    原因:
#    - VPCピアリング、Transit Gateway、またはGWLBエンドポイントが正しく設定されていない
#    - ルートテーブルにターゲットVPCへのルートがない
#    解決策:
#    - VPC接続の設定を確認
#    - 両方のVPCのルートテーブルを確認
#    - トランジットゲートウェイのルートテーブルを確認

################################################################################
# セキュリティのベストプラクティス
################################################################################

# 1. 最小権限の原則
#    - トラフィックミラーリングに必要な最小限の権限のみを付与
#    - IAMポリシーでセッション作成を特定のリソースに制限

# 2. ネットワークセグメンテーション
#    - ミラーターゲットを専用のセキュリティVPCに配置
#    - 監視トラフィックを本番トラフィックから分離

# 3. 暗号化
#    - ミラーリングされたトラフィックには機密情報が含まれる可能性がある
#    - ターゲット側でのデータ保管時の暗号化を検討
#    - クロスVPCの場合、トランジット暗号化を検討

# 4. アクセス制御
#    - ターゲットインスタンスへのアクセスを制限
#    - セキュリティグループで必要最小限のポートのみを開放
#    - VPCフローログで監視トラフィック自体を監視

# 5. コンプライアンス
#    - データ保持ポリシーに従った監視データの管理
#    - PCI-DSS、HIPAA などの規制要件への準拠
#    - 監査ログとしてのCloudTrail有効化

################################################################################
# コスト最適化のヒント
################################################################################

# 1. パケット長の最適化
#    - 完全なペイロードが不要な場合は packet_length を設定
#    - ヘッダー情報のみで十分な場合は 200-300 バイトに制限

# 2. フィルターの精密化
#    - 必要なトラフィックのみをミラーリングするようフィルターを設定
#    - 不要な内部VPCトラフィックを除外

# 3. セッションの優先順位付け
#    - 重要なトラフィックのみを常時監視
#    - 一般的な監視は間欠的または条件付きで実行

# 4. ターゲットの選択
#    - NLBを使用して複数の監視インスタンスで負荷分散
#    - Auto Scalingでターゲットインスタンスの数を需要に応じて調整

# 5. データ転送コストの考慮
#    - 同じアベイラビリティーゾーン内でのミラーリングを優先
#    - クロスAZ、クロスリージョンのデータ転送コストを考慮
