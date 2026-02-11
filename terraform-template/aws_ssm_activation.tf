#---------------------------------------------------------------
# SSM Activation
#---------------------------------------------------------------
#
# AWS Systems Manager (SSM) のアクティベーションコードを作成し、オンプレミスサーバーや
# 仮想マシンをマネージドインスタンスとして登録できるようにします。
# これにより、EC2インスタンス以外のサーバーもSSM Run Commandなどの機能で
# 管理できるようになります。
#
# AWS公式ドキュメント:
#   - Systems Manager ハイブリッドアクティベーション: https://docs.aws.amazon.com/systems-manager/latest/userguide/activations.html
#   - マネージドインスタンスの設定: https://docs.aws.amazon.com/systems-manager/latest/userguide/managed_instances.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_activation
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_activation" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # マネージドインスタンスにアタッチするIAMロールのARNまたは名前
  # このロールには、SSMエージェントがAWSサービスと通信するための権限が必要です
  # 通常、AmazonSSMManagedInstanceCoreポリシーをアタッチします
  # 例: "arn:aws:iam::123456789012:role/SSMServiceRole"
  # 型: string
  iam_role = "arn:aws:iam::123456789012:role/SSMServiceRole"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # アクティベーションの説明
  # マネージドインスタンスの用途や目的を記載します
  # 例: "Production web servers in on-premises datacenter"
  # 型: string
  description = null

  # アクティベーションの有効期限
  # RFC3339形式のUTCタイムスタンプで指定します
  # 指定しない場合、リソース作成から24時間後が期限となります
  # この期限までにアクティベーションコードを使用してインスタンスを登録する必要があります
  # 例: "2026-12-31T23:59:59Z"
  # 型: string
  expiration_date = null

  # リソースID
  # 通常は指定不要です（自動生成されます）
  # 明示的に指定する場合のみ使用してください
  # 型: string
  id = null

  # 登録されるマネージドインスタンスのデフォルト名
  # 指定しない場合、SSMが自動的に名前を生成します
  # 登録後にSSMコンソールやCLIで表示される識別名として使用されます
  # 例: "on-prem-web-server"
  # 型: string
  name = null

  # このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # 例: "ap-northeast-1"
  # 型: string
  region = null

  # このアクティベーションで登録可能なマネージドインスタンスの最大数
  # デフォルトは1インスタンスです
  # 複数のサーバーを登録する場合は、必要な数を指定してください
  # 例: 10
  # 型: number
  registration_limit = null

  # リソースに付与するタグのマップ
  # コスト管理や運用管理のためのメタデータとして使用します
  # provider設定でdefault_tagsが設定されている場合、それらと統合されます
  # 例: { Environment = "production", Team = "infrastructure" }
  # 型: map(string)
  tags = {}

  # すべてのタグ（プロバイダーのdefault_tagsを含む）
  # 通常は指定不要です（自動的に計算されます）
  # 明示的に上書きする場合のみ使用してください
  # 型: map(string)
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の出力属性）
#---------------------------------------------------------------
# このリソースは以下の属性を出力します（computed only）:
#
# - activation_code (string)
#     システムがアクティベーション処理時に生成するコード
#     マネージドインスタンスの登録時にactivation_idと共に使用します
#     セキュリティ上重要な情報のため、適切に管理してください
#
# - expired (bool)
#     現在のアクティベーションが期限切れかどうかを示すフラグ
#     true: 期限切れ、false: 有効
#
# - registration_count (number)
#     このアクティベーションを使用して現在登録されているマネージドインスタンスの数
#     registration_limitに達すると、新規登録はできなくなります
#
#---------------------------------------------------------------
