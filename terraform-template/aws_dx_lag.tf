# ================================================================================
# Terraform Resource: aws_dx_lag
# Provider Version: 6.28.0
# ================================================================================
#
# AWS Direct Connect Link Aggregation Group (LAG) を管理します。
# LAGは複数の専用接続を1つの論理インターフェースとして集約し、
# 帯域幅を増やすことができます。LAGはLink Aggregation Control Protocol (LACP)を
# 使用して、複数の接続を単一のDirect Connectエンドポイントで集約します。
#
# 公式ドキュメント:
# - リソース: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_lag
# - API: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_CreateLag.html
# - ガイド: https://docs.aws.amazon.com/directconnect/latest/UserGuide/lags.html
#
# 重要な制約:
# - すべての接続は専用接続である必要があります
# - すべての接続は同じ帯域幅を使用する必要があります
# - すべての接続は同じDirect Connectエンドポイントで終端する必要があります
# - 100 Gbps または 400 Gbps の接続は最大2つまで
# - 100 Gbps 未満のポート速度の接続は最大4つまで
# - LAGはpublic、private、transit すべてのタイプの仮想インターフェースをサポート
# ================================================================================

resource "aws_dx_lag" "example" {

  # ============================================================
  # 必須パラメータ (Required Parameters)
  # ============================================================

  # ------------------------------------------------------------
  # name
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: Yes
  #
  # LAGの名前。
  # LAGを識別するための分かりやすい名前を指定します。
  #
  # ユースケース:
  # - 環境や用途を識別しやすい名前を使用
  # - 複数のLAGを管理する場合の識別子として
  #
  # 例:
  # - "production-lag"
  # - "on-premises-to-aws-lag"
  # - "tokyo-datacenter-lag"
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/directconnect/latest/APIReference/API_CreateLag.html
  # ------------------------------------------------------------
  name = "example-lag"

  # ------------------------------------------------------------
  # connections_bandwidth
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: Yes
  #
  # LAGにバンドルされる個々の専用接続の帯域幅。
  # LAG内のすべての接続は同じ帯域幅を使用する必要があります。
  #
  # 有効な値:
  # - "1Gbps"  - 1ギガビット/秒（最大4接続）
  # - "10Gbps" - 10ギガビット/秒（最大4接続）
  # - "100Gbps" - 100ギガビット/秒（最大2接続）
  # - "400Gbps" - 400ギガビット/秒（最大2接続）
  #
  # 注意事項:
  # - 大文字小文字を区別します
  # - すべての接続で同じ値を使用する必要があります
  # - 専用接続のみサポート（ホスト接続は不可）
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/directconnect/latest/UserGuide/dedicated_connection.html
  # ------------------------------------------------------------
  connections_bandwidth = "1Gbps"

  # ------------------------------------------------------------
  # location
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: Yes
  #
  # LAGを割り当てるDirect Connectロケーション。
  # DescribeLocations APIで取得できるlocationCodeを使用します。
  #
  # ユースケース:
  # - 最も近いDirect Connectロケーションを選択
  # - 冗長化のために複数のロケーションを使用
  #
  # 例:
  # - "EqDC2" - Equinix DC2 (Ashburn, VA)
  # - "EqTY2" - Equinix TY2 (Tokyo)
  # - "EqSY3" - Equinix SY3 (Sydney)
  #
  # ロケーションの一覧:
  # https://aws.amazon.com/directconnect/locations/
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/directconnect/latest/APIReference/API_DescribeLocations.html
  # ------------------------------------------------------------
  location = "EqDC2"


  # ============================================================
  # オプションパラメータ (Optional Parameters)
  # ============================================================

  # ------------------------------------------------------------
  # connection_id
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: No
  #
  # LAGに移行する既存の専用接続のID。
  # 既存の接続をLAGに追加する場合に指定します。
  #
  # 注意事項:
  # - この操作により現在の物理専用接続が中断されます
  # - 接続はLAGのメンバーとして再確立されます
  # - 仮想インターフェースは自動的に関連付けが解除され、LAGに再関連付けされます
  # - 接続IDは変更されません
  # - 同じDirect Connectエンドポイントで終端する接続である必要があります
  #
  # ユースケース:
  # - 既存の単一接続をLAGに統合
  # - 既存の接続を新しいLAGに移行
  #
  # 例:
  # - "dxcon-fg5678gh"
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/directconnect/latest/UserGuide/associate-connection-with-lag.html
  # ------------------------------------------------------------
  # connection_id = "dxcon-fg5678gh"  # オプション: 既存の接続を移行する場合

  # ------------------------------------------------------------
  # force_destroy
  # ------------------------------------------------------------
  # タイプ: bool
  # 必須: No
  # デフォルト: false
  #
  # LAGに関連付けられているすべての接続を削除して、
  # エラーなしでLAGを削除できるようにするかどうか。
  #
  # 注意事項:
  # - trueに設定すると、LAG削除時に関連するすべての接続も削除されます
  # - 削除されたオブジェクトは復元できません
  # - 本番環境では慎重に使用してください
  #
  # ユースケース:
  # - テスト環境や開発環境でのクリーンアップ
  # - 一時的なLAGの自動削除
  #
  # 例:
  # - true  - LAG削除時に関連接続も削除
  # - false - LAG削除前に関連接続を手動で削除する必要がある
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/directconnect/latest/UserGuide/delete-lag.html
  # ------------------------------------------------------------
  # force_destroy = false  # オプション: デフォルトはfalse

  # ------------------------------------------------------------
  # provider_name
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: No
  # 計算される: Yes
  #
  # LAGに関連付けられているサービスプロバイダーの名前。
  # Direct Connect Partnerを使用する場合に指定します。
  #
  # ユースケース:
  # - Direct Connect Partnerを介してLAGを作成する場合
  # - プロバイダー情報を明示的に記録する場合
  #
  # 例:
  # - "Equinix"
  # - "AT&T"
  # - "Verizon"
  #
  # AWS公式ドキュメント:
  # https://aws.amazon.com/directconnect/partners/
  # ------------------------------------------------------------
  # provider_name = "Equinix"  # オプション: サービスプロバイダー名

  # ------------------------------------------------------------
  # region
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: No
  # デフォルト: プロバイダー設定のリージョン
  # 計算される: Yes
  #
  # このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # ユースケース:
  # - マルチリージョン構成で明示的にリージョンを指定
  # - プロバイダーのデフォルトリージョンと異なるリージョンで管理
  #
  # 例:
  # - "us-east-1"
  # - "ap-northeast-1"
  # - "eu-west-1"
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # ------------------------------------------------------------
  # region = "us-east-1"  # オプション: 明示的にリージョンを指定する場合


  # ============================================================
  # タグ (Tags)
  # ============================================================

  # ------------------------------------------------------------
  # tags
  # ------------------------------------------------------------
  # タイプ: map(string)
  # 必須: No
  #
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックで定義されたタグと
  # マージされます。
  #
  # ユースケース:
  # - コスト配分のためのタグ付け
  # - リソースの所有者や環境の識別
  # - 自動化スクリプトでのリソース検索
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Team        = "network"
  #   Project     = "datacenter-migration"
  #   ManagedBy   = "terraform"
  # }
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  # ------------------------------------------------------------
  tags = {
    Name        = "example-lag"
    Environment = "production"
  }

  # ------------------------------------------------------------
  # tags_all
  # ------------------------------------------------------------
  # タイプ: map(string)
  # 必須: No
  # 計算される: Yes
  #
  # リソースに割り当てられたすべてのタグ（プロバイダーの
  # default_tags設定ブロックで定義されたものを含む）のマップ。
  #
  # 注意事項:
  # - このパラメータは通常、明示的に設定する必要はありません
  # - プロバイダーレベルのdefault_tagsと個別のtagsが自動的にマージされます
  # - 読み取り専用として扱うのが推奨されます
  #
  # AWS公式ドキュメント:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # ------------------------------------------------------------
  # tags_all は通常設定不要（プロバイダーが自動的に計算）


  # ============================================================
  # ライフサイクル設定例
  # ============================================================
  # lifecycle {
  #   # LAGの誤削除を防止
  #   prevent_destroy = true
  #
  #   # 特定の属性の変更を無視
  #   ignore_changes = [
  #     tags["LastModified"],
  #   ]
  #
  #   # 新しいLAGを作成してから古いものを削除
  #   create_before_destroy = true
  # }
}


# ================================================================================
# Attributes Reference (Computed Only)
# ================================================================================
#
# 以下の属性はリソース作成後に参照可能です（入力には使用できません）:
#
# - arn
#   タイプ: string
#   説明: LAGのAmazon Resource Name (ARN)。
#   例: "arn:aws:directconnect:us-east-1:123456789012:dxlag/dxlag-fg5678gh"
#
# - id
#   タイプ: string
#   説明: LAGのID。
#   例: "dxlag-fg5678gh"
#   注意: このパラメータはoptional+computedですが、通常は指定せず
#         AWSが自動生成する値を使用します
#
# - has_logical_redundancy
#   タイプ: string
#   説明: LAGが同じアドレスファミリ（IPv4/IPv6）でセカンダリBGPピアを
#         サポートするかどうかを示します。
#   可能な値: "unknown", "yes", "no"
#
# - jumbo_frame_capable
#   タイプ: bool
#   説明: ジャンボフレーム（9001 MTU）がサポートされているかどうか。
#   例: true または false
#
# - owner_account_id
#   タイプ: string
#   説明: LAGを所有するAWSアカウントのID。
#   例: "123456789012"
#
# ================================================================================


# ================================================================================
# 補足情報とベストプラクティス
# ================================================================================
#
# 【LAGの仕組み】
# - Link Aggregation Control Protocol (LACP)を使用して複数の接続を集約
# - すべての接続は同じDirect Connectエンドポイントで終端する必要があります
# - LAG内のすべての接続は同じ帯域幅を使用する必要があります
# - すべての接続はActive/Activeモードで動作します
# - LAG設定はグループ内のすべての接続に適用されます
#
# 【サポートされる帯域幅と接続数の制限】
# - 1 Gbps または 10 Gbps: 最大4接続
# - 100 Gbps: 最大2接続
# - 400 Gbps: 最大2接続
# - LAG内の各接続はリージョン全体の接続制限にカウントされます
#
# 【必要な IAM 権限】
# このリソースを管理するには以下の権限が必要:
# - directconnect:CreateLag (作成時)
# - directconnect:DeleteLag (削除時)
# - directconnect:DescribeLags (読み取り時)
# - directconnect:TagResource (タグ付け時)
# - directconnect:UntagResource (タグ削除時)
# - directconnect:AssociateConnectionWithLag (接続の関連付け時)
#
# 【MACsecに関する考慮事項】
# - LAGを既存の接続から作成する場合、すべてのMACsecキーが接続から
#   関連付け解除され、LAGに再関連付けされます
# - 既存の接続をLAGに関連付ける場合、現在LAGに関連付けられている
#   MACsecキーが接続に関連付けられます
# - 常に単一のMACsecキーのみがすべてのLAGリンクで使用されます
# - 複数のMACsecキーのサポートはキーローテーション目的のみです
#
# 【高可用性のベストプラクティス】
# - 複数のDirect Connectロケーションを使用して冗長性を確保
# - 各ロケーション内で冗長なDirect Connect接続を持つ
# - LAGの最小運用接続数を設定して過負荷を防止
# - 複数のカスタマー/パートナールーターで冗長なDirect Connect接続を終端
#
# 【典型的な使用例】
#
# 1. 新しいLAGの作成（新規接続を使用）:
#    resource "aws_dx_lag" "new" {
#      name                  = "new-lag"
#      connections_bandwidth = "10Gbps"
#      location              = "EqDC2"
#    }
#
# 2. 既存の接続を使用したLAGの作成:
#    resource "aws_dx_lag" "from_existing" {
#      name                  = "migrated-lag"
#      connections_bandwidth = "10Gbps"
#      location              = "EqDC2"
#      connection_id         = aws_dx_connection.existing.id
#    }
#
# 3. 強制削除を有効にしたLAG:
#    resource "aws_dx_lag" "temp" {
#      name                  = "temporary-lag"
#      connections_bandwidth = "1Gbps"
#      location              = "EqDC2"
#      force_destroy         = true
#    }
#
# 4. タグ付きのLAG:
#    resource "aws_dx_lag" "tagged" {
#      name                  = "production-lag"
#      connections_bandwidth = "100Gbps"
#      location              = "EqDC2"
#
#      tags = {
#        Environment = "production"
#        Team        = "network-ops"
#        CostCenter  = "infra-001"
#      }
#    }
#
# 【関連リソース】
# - aws_dx_connection: Direct Connect接続の管理
# - aws_dx_connection_association: 接続とLAGの関連付け管理
# - aws_dx_gateway: Direct Connect ゲートウェイの管理
# - aws_dx_hosted_connection: ホスト接続の管理
# - aws_dx_private_virtual_interface: プライベート仮想インターフェース
# - aws_dx_public_virtual_interface: パブリック仮想インターフェース
# - aws_dx_transit_virtual_interface: トランジット仮想インターフェース
#
# 【エラーハンドリング】
# - DirectConnectClientException: 一般的なクライアントエラー
# - DirectConnectServerException: サーバー側のエラー
# - DuplicateLagException: 重複するLAG
# - TooManyTagsException: タグの数が多すぎる
#
# 【監視とロギング】
# - CloudWatchメトリクス:
#   * ConnectionState: LAGの接続状態
#   * ConnectionBpsEgress: 送信ビット/秒
#   * ConnectionBpsIngress: 受信ビット/秒
#   * ConnectionPpsEgress: 送信パケット/秒
#   * ConnectionPpsIngress: 受信パケット/秒
#
# 【参考リンク】
# - LAG概要:
#   https://docs.aws.amazon.com/directconnect/latest/UserGuide/lags.html
# - LAG作成:
#   https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-lag.html
# - CreateLag API:
#   https://docs.aws.amazon.com/directconnect/latest/APIReference/API_CreateLag.html
# - Direct Connect Locations:
#   https://aws.amazon.com/directconnect/locations/
# - MACsec設定:
#   https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-mac-sec-getting-started.html
#
# ================================================================================
