/**
 * リソース: aws_ec2_managed_prefix_list
 *
 * マネージドプレフィックスリストを管理します。プレフィックスリストは、CIDR ブロックのセットを定義し、
 * セキュリティグループルールやルートテーブルエントリで参照できます。
 *
 * ユースケース:
 * - VPC CIDR ブロックの集約管理
 * - セキュリティグループルールの簡素化（複数の CIDR を一つのリストで管理）
 * - ルートテーブルでの複数ネットワークの一括管理
 *
 * 注意事項:
 * - インラインエントリを持つマネージドプレフィックスリストと、aws_ec2_managed_prefix_list_entry リソースを併用すると競合が発生します
 * - max_entries で指定した数値は、このプレフィックスリストを参照するリソース（セキュリティグループなど）のルール数としてカウントされます
 * - 例: max_entries=20 のプレフィックスリストをセキュリティグループで参照すると、20 ルールとしてカウントされます
 * - AWS マネージドプレフィックスリスト（com.amazonaws. で始まる）は作成できません
 *
 * Provider バージョン: 6.28.0
 * Terraform AWS Provider ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list
 * AWS API ドキュメント: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateManagedPrefixList.html
 */

resource "aws_ec2_managed_prefix_list" "example" {
  # ┌──────────────────────────────────────────────────────────────────────────┐
  # │ 必須パラメータ                                                              │
  # └──────────────────────────────────────────────────────────────────────────┘

  /**
   * name - (必須) プレフィックスリストの名前
   *
   * このリソースの名前を指定します。
   *
   * 制約事項:
   * - `com.amazonaws` で始まる名前は使用できません（AWS マネージドプレフィックスリスト用に予約済み）
   * - 同一リージョン内で一意である必要があります
   *
   * 例:
   * - "All VPC CIDR-s"
   * - "Production-VPC-CIDRs"
   * - "office-networks"
   *
   * タイプ: string
   */
  name = "All VPC CIDR-s"

  /**
   * address_family - (必須・変更時リソース再作成) アドレスファミリー
   *
   * このプレフィックスリストのアドレスファミリーを指定します。
   *
   * 有効な値:
   * - "IPv4" - IPv4 CIDR ブロックを格納
   * - "IPv6" - IPv6 CIDR ブロックを格納
   *
   * 注意: 作成後の変更はリソースの再作成を伴います
   *
   * タイプ: string
   */
  address_family = "IPv4"

  /**
   * max_entries - (必須) 最大エントリ数
   *
   * このプレフィックスリストに格納できる最大エントリ数を指定します。
   *
   * 重要な考慮事項:
   * - このプレフィックスリストを参照するリソース（セキュリティグループなど）では、
   *   この数値がルール数としてカウントされます
   * - 例: max_entries=20 のプレフィックスリストをセキュリティグループルールで参照すると、
   *   セキュリティグループの 20 ルール分を消費します
   * - 後から増やすことは可能ですが、減らす場合は現在のエントリ数以下にはできません
   * - 最大値は 1000 まで設定可能
   *
   * ベストプラクティス:
   * - 将来の拡張を見越して余裕を持った値を設定
   * - ただし、参照元リソースのルール数制限も考慮する
   *
   * タイプ: number
   */
  max_entries = 5

  # ┌──────────────────────────────────────────────────────────────────────────┐
  # │ オプションパラメータ                                                         │
  # └──────────────────────────────────────────────────────────────────────────┘

  /**
   * entry - (オプション) プレフィックスリストエントリ
   *
   * プレフィックスリストに含める CIDR ブロックエントリを定義します。
   *
   * 構造:
   * - cidr        - (必須) CIDR ブロック（例: "10.0.0.0/16", "2001:db8::/32"）
   * - description - (オプション) エントリの説明
   *
   * 重要な注意事項:
   * - 異なるエントリ間で CIDR ブロックが重複することは可能ですが、
   *   全く同じ CIDR を複数のエントリに含めることはできません
   * - API の制限により、既存エントリの description のみを更新する場合、
   *   一時的にエントリを削除して再追加する必要があります
   * - このブロックと aws_ec2_managed_prefix_list_entry リソースを併用すると競合します
   *
   * インライン管理 vs 個別リソース管理:
   * - entry ブロックを使用する場合: すべてのエントリをこのリソース内で管理（推奨）
   * - aws_ec2_managed_prefix_list_entry を使用する場合: entry ブロックは定義しない
   *
   * タイプ: set(object({
   *   cidr        = string
   *   description = optional(string)
   * }))
   */
  entry {
    cidr        = "10.0.0.0/16"
    description = "Primary VPC CIDR"
  }

  entry {
    cidr        = "10.1.0.0/16"
    description = "Secondary VPC CIDR"
  }

  /**
   * tags - (オプション) リソースタグ
   *
   * このプレフィックスリストに割り当てるタグのマップ。
   *
   * provider の default_tags 設定ブロックが存在する場合、
   * 同じキーを持つタグはここで定義したものがプロバイダレベルの設定を上書きします。
   *
   * ベストプラクティス:
   * - Environment, Owner, Purpose などの標準タグを設定
   * - コスト配分タグを活用してコスト追跡を実施
   * - 命名規則に従ったタグキーを使用
   *
   * タイプ: map(string)
   */
  tags = {
    Name        = "example-prefix-list"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  /**
   * region - (オプション) リージョン
   *
   * このリソースを管理するリージョンを指定します。
   *
   * 指定しない場合は、プロバイダ設定で指定されたリージョンがデフォルトで使用されます。
   *
   * 使用例:
   * - マルチリージョン構成で特定のリソースを特定リージョンに配置する場合
   * - プロバイダのデフォルトリージョンと異なるリージョンにリソースを作成する場合
   *
   * 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
   *
   * タイプ: string
   */
  # region = "us-west-2"
}

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ Attributes Reference（読み取り専用属性）                                      │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * 以下の属性は、リソース作成後に参照可能です（出力値として使用可能）:
 *
 * - id         - プレフィックスリストの ID（例: "pl-0123456abcabcabc1"）
 * - arn        - プレフィックスリストの ARN
 *                形式: "arn:aws:ec2:region:account-id:prefix-list/prefix-list-id"
 * - owner_id   - このプレフィックスリストを所有する AWS アカウントの ID
 * - version    - プレフィックスリストの最新バージョン番号
 *                エントリを追加・削除するたびにインクリメントされます
 * - tags_all   - リソースに割り当てられたすべてのタグのマップ
 *                プロバイダの default_tags から継承されたタグも含まれます
 *
 * 使用例:
 * output "prefix_list_id" {
 *   value = aws_ec2_managed_prefix_list.example.id
 * }
 *
 * output "prefix_list_arn" {
 *   value = aws_ec2_managed_prefix_list.example.arn
 * }
 *
 * output "prefix_list_version" {
 *   value = aws_ec2_managed_prefix_list.example.version
 * }
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ Import（既存リソースのインポート）                                            │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * 既存のマネージドプレフィックスリストは、プレフィックスリスト ID を使用してインポートできます:
 *
 * terraform import aws_ec2_managed_prefix_list.example pl-0123456abcabcabc1
 *
 * インポート後の注意事項:
 * - インポートされたリソースの現在の設定を確認し、Terraform コードと一致させる必要があります
 * - entry ブロックの順序が異なる場合、plan で差分が表示される可能性があります
 * - tags は完全に同期されるため、既存タグが削除される可能性があります（要確認）
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ 使用例: セキュリティグループでの参照                                          │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * マネージドプレフィックスリストをセキュリティグループルールで参照する例:
 *
 * resource "aws_security_group" "example" {
 *   name        = "example-sg"
 *   description = "Example security group using prefix list"
 *   vpc_id      = aws_vpc.example.id
 *
 *   ingress {
 *     description     = "Allow traffic from managed prefix list"
 *     from_port       = 443
 *     to_port         = 443
 *     protocol        = "tcp"
 *     prefix_list_ids = [aws_ec2_managed_prefix_list.example.id]
 *   }
 * }
 *
 * この場合、プレフィックスリストに含まれるすべての CIDR ブロックからのアクセスが許可されます。
 * max_entries=5 の場合、セキュリティグループでは 5 ルール分としてカウントされます。
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ 使用例: ルートテーブルでの参照                                                │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * マネージドプレフィックスリストをルートテーブルで参照する例:
 *
 * resource "aws_route" "example" {
 *   route_table_id         = aws_route_table.example.id
 *   destination_prefix_list_id = aws_ec2_managed_prefix_list.example.id
 *   gateway_id             = aws_internet_gateway.example.id
 * }
 *
 * プレフィックスリストに含まれるすべての CIDR ブロックへのルートが作成されます。
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ 使用例: IPv6 プレフィックスリスト                                             │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * IPv6 アドレスファミリーを使用したプレフィックスリストの例:
 *
 * resource "aws_ec2_managed_prefix_list" "ipv6_example" {
 *   name           = "IPv6 VPC CIDRs"
 *   address_family = "IPv6"
 *   max_entries    = 3
 *
 *   entry {
 *     cidr        = "2001:db8::/32"
 *     description = "Example IPv6 CIDR"
 *   }
 *
 *   entry {
 *     cidr        = "2001:db8:1::/48"
 *     description = "Another IPv6 CIDR"
 *   }
 *
 *   tags = {
 *     Name = "ipv6-prefix-list"
 *   }
 * }
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ 使用例: 動的エントリ（VPC CIDR の参照）                                       │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * VPC リソースの CIDR ブロックを動的に参照する例:
 *
 * resource "aws_vpc" "example" {
 *   cidr_block = "10.0.0.0/16"
 *
 *   tags = {
 *     Name = "example-vpc"
 *   }
 * }
 *
 * resource "aws_vpc_ipv4_cidr_block_association" "example" {
 *   vpc_id     = aws_vpc.example.id
 *   cidr_block = "10.1.0.0/16"
 * }
 *
 * resource "aws_ec2_managed_prefix_list" "vpc_cidrs" {
 *   name           = "All VPC CIDR-s"
 *   address_family = "IPv4"
 *   max_entries    = 5
 *
 *   entry {
 *     cidr        = aws_vpc.example.cidr_block
 *     description = "Primary VPC CIDR"
 *   }
 *
 *   entry {
 *     cidr        = aws_vpc_ipv4_cidr_block_association.example.cidr_block
 *     description = "Secondary VPC CIDR"
 *   }
 *
 *   tags = {
 *     Environment = "production"
 *   }
 * }
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ ベストプラクティス                                                           │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * 1. エントリ管理方法の選択:
 *    - 静的で変更頻度が低い場合: entry ブロックでインライン管理
 *    - 動的で頻繁に変更する場合: aws_ec2_managed_prefix_list_entry リソースで個別管理
 *    - 両方を混在させないこと（競合が発生します）
 *
 * 2. max_entries の設定:
 *    - 将来の拡張を考慮して余裕を持った値を設定
 *    - 参照元リソース（セキュリティグループなど）のルール数上限も確認
 *    - セキュリティグループの場合、デフォルトで 60 ルールまで（インバウンド + アウトバウンド）
 *
 * 3. 命名規則:
 *    - 用途や環境を識別しやすい名前を使用
 *    - com.amazonaws プレフィックスは使用不可
 *    - 例: "prod-vpc-cidrs", "office-networks", "partner-ips"
 *
 * 4. CIDR の管理:
 *    - 重複する CIDR ブロックは許可されますが、同一 CIDR の重複は不可
 *    - description を活用して各エントリの目的を明確に記載
 *    - CIDR の追加・削除時はバージョンが自動的にインクリメントされます
 *
 * 5. タグ戦略:
 *    - Environment, Owner, Purpose などの標準タグを一貫して使用
 *    - コスト配分タグを設定してコスト追跡を実施
 *    - プロバイダの default_tags を活用して共通タグを自動適用
 *
 * 6. セキュリティ考慮事項:
 *    - 最小権限の原則に従い、必要な CIDR のみを含める
 *    - 定期的にエントリを見直し、不要な CIDR を削除
 *    - プレフィックスリストの変更履歴をバージョンで追跡可能
 *
 * 7. マルチリージョン構成:
 *    - プレフィックスリストはリージョナルリソースです
 *    - 複数リージョンで同じプレフィックスリストが必要な場合は、各リージョンで個別に作成
 *    - region パラメータを使用してリージョンを明示的に指定可能
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ トラブルシューティング                                                        │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * よくある問題と解決策:
 *
 * 1. エントリの競合エラー:
 *    問題: "ConflictException: Entry already exists"
 *    原因: 同じ CIDR を複数のエントリに指定している
 *    解決: 各 CIDR は一つのエントリにのみ含める
 *
 * 2. max_entries の制約エラー:
 *    問題: "InvalidParameterValue: Max entries cannot be less than current entries"
 *    原因: max_entries を現在のエントリ数より小さい値に変更しようとしている
 *    解決: 先にエントリを削除してから max_entries を減らす
 *
 * 3. セキュリティグループルール数の上限エラー:
 *    問題: "RulesPerSecurityGroupLimitExceeded"
 *    原因: プレフィックスリストの max_entries がセキュリティグループのルール数上限を超えている
 *    解決: max_entries を減らすか、セキュリティグループのルール数を削減
 *
 * 4. name の重複エラー:
 *    問題: "InvalidPrefixListName.Duplicate"
 *    原因: 同一リージョンに同じ名前のプレフィックスリストが既に存在
 *    解決: 一意の名前を使用する
 *
 * 5. インポート時の差分:
 *    問題: インポート後に terraform plan で差分が表示される
 *    原因: entry ブロックの順序が異なる、またはタグの不一致
 *    解決: terraform state show で現在の状態を確認し、コードを調整
 *
 * 6. description のみの更新が失敗:
 *    問題: description を変更しても反映されない
 *    原因: API の制限により、一時的にエントリを削除して再追加する必要がある
 *    解決: Terraform が自動的に処理しますが、一時的にエントリが削除されることに注意
 */

# ┌──────────────────────────────────────────────────────────────────────────┐
# │ 関連リソース                                                                │
# └──────────────────────────────────────────────────────────────────────────┘

/**
 * 関連する Terraform リソース:
 *
 * - aws_ec2_managed_prefix_list_entry
 *   個別のプレフィックスリストエントリを管理（entry ブロックの代替）
 *   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list_entry
 *
 * - aws_security_group_rule
 *   プレフィックスリストを参照するセキュリティグループルールを作成
 *   prefix_list_ids パラメータで参照
 *   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
 *
 * - aws_route
 *   プレフィックスリストを参照するルートテーブルエントリを作成
 *   destination_prefix_list_id パラメータで参照
 *   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
 *
 * - aws_vpc
 *   VPC の CIDR ブロックをプレフィックスリストエントリとして参照可能
 *   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
 *
 * - aws_vpc_ipv4_cidr_block_association
 *   セカンダリ IPv4 CIDR ブロックをプレフィックスリストエントリとして参照可能
 *   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association
 *
 * Data Sources:
 * - aws_ec2_managed_prefix_list
 *   既存のマネージドプレフィックスリスト情報を取得
 *   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list
 *
 * - aws_ec2_managed_prefix_lists
 *   複数のマネージドプレフィックスリストを検索
 *   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_lists
 */
