#---------------------------------------------------------------
# Amazon GuardDuty IPSet
#---------------------------------------------------------------
#
# Amazon GuardDuty IPSetリソースを管理します。IPSetは、AWSインフラストラクチャと
# アプリケーションとの安全な通信のために信頼されるIPアドレスのリストです。
# GuardDutyは、IPSetに含まれるIPアドレスに対する検出結果を生成しません。
#
# 注意: 現在GuardDutyでは、メンバーアカウントのユーザーはIPSetのアップロードと
# 管理ができません。プライマリアカウントによってアップロードされたIPSetは、
# メンバーアカウントのGuardDuty機能に適用されます。
#
# AWS公式ドキュメント:
#   - GuardDuty IPSet管理: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-lists-create-activate.html
#   - CreateIPSet API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_CreateIPSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_ipset
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_ipset" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ (Required Parameters)
  #---------------------------------------------------------------

  # activate - GuardDutyがアップロードされたIPSetの使用を開始するかを指定
  # - true: IPSetを有効化し、GuardDutyがIPリストを使用開始
  # - false: IPSetを非アクティブ状態で作成（後で有効化可能）
  # Type: bool
  # Required: Yes
  activate = true

  # detector_id - GuardDutyディテクターの一意なID
  # - GuardDutyディテクターは、脅威検出を実行するサービスインスタンス
  # - 形式: 32文字の16進数文字列（例: 12abc34d567e8fa901bc2d34e56789f0）
  # - aws_guardduty_detector リソースから取得可能
  # Type: string
  # Required: Yes
  detector_id = "12abc34d567e8fa901bc2d34e56789f0"

  # format - IPSetを含むファイルのフォーマット
  # - TXT: プレーンテキスト形式（1行に1つのIPアドレスまたはCIDR）
  # - STIX: Structured Threat Information eXpression形式
  # - OTX_CSV: AlienVault Open Threat Exchange CSV形式
  # - ALIEN_VAULT: AlienVault形式
  # - PROOF_POINT: Proofpoint形式
  # - FIRE_EYE: FireEye形式
  # Type: string
  # Required: Yes
  # Valid Values: TXT | STIX | OTX_CSV | ALIEN_VAULT | PROOF_POINT | FIRE_EYE
  format = "TXT"

  # location - IPSetを含むファイルのURI
  # - S3バケットのオブジェクトURIを指定
  # - 形式: https://s3.amazonaws.com/bucket-name/object-key
  # - GuardDutyはこのS3オブジェクトを読み取る権限が必要
  # - 推奨: aws_s3_object リソースから動的に参照
  # Type: string
  # Required: Yes
  location = "https://s3.amazonaws.com/my-guardduty-bucket/trusted-ips.txt"

  # name - IPSetを識別するためのフレンドリーネーム
  # - このIPSetに含まれるIPアドレスに関連するすべての検出結果に表示される
  # - 小文字、大文字、数字、ダッシュ(-)、アンダースコア(_)が使用可能
  # - AWSアカウントとリージョン内で一意である必要がある
  # Type: string
  # Required: Yes
  name = "TrustedIPAddresses"

  #---------------------------------------------------------------
  # オプションパラメータ (Optional Parameters)
  #---------------------------------------------------------------

  # region - このリソースが管理されるリージョン
  # - 指定しない場合、プロバイダー設定のリージョンが使用される
  # - 通常はプロバイダー設定に依存するため明示的な指定は不要
  # Type: string
  # Optional: Yes
  # Computed: Yes (Default: Provider region)
  # region = "us-east-1"

  # tags - リソースに付与するタグのキーバリューマップ
  # - プロバイダーのdefault_tagsと統合される
  # - 同一キーの場合、リソースレベルのタグが優先される
  # - 用途: コスト配分、リソース管理、アクセス制御など
  # Type: map(string)
  # Optional: Yes
  tags = {
    Name        = "TrustedIPAddresses"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # 注意事項
  #---------------------------------------------------------------
  # 1. IPSetファイル形式:
  #    - TXT形式の場合、1行に1つのIPアドレスまたはCIDRブロック
  #    - 例: 10.0.0.0/8\n192.168.1.1\n
  #
  # 2. S3バケット権限:
  #    - GuardDutyサービスがS3オブジェクトを読み取れる必要がある
  #    - バケットポリシーまたはACLで適切な権限を設定
  #
  # 3. 有効化タイミング:
  #    - IPSetを有効化後、反映まで数分かかる場合がある
  #
  # 4. メンバーアカウント制限:
  #    - メンバーアカウントからIPSetのアップロード・管理は不可
  #    - プライマリアカウントで管理する必要がある
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - arn
#   GuardDuty IPSetのAmazon Resource Name (ARN)
#   Type: string
#   Example: arn:aws:guardduty:us-east-1:123456789012:detector/12abc34d567e8fa901bc2d34e56789f0/ipset/abcd1234
#
# - id
#   IPSetの一意な識別子
#   Type: string
#
# - tags_all
#   リソースに割り当てられた全タグ（プロバイダーのdefault_tagsを含む）
#   Type: map(string)
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# # S3バケットとオブジェクトの作成例
# resource "aws_s3_bucket" "ipset_bucket" {
#   bucket = "my-guardduty-ipset-bucket"
# }
#
# resource "aws_s3_bucket_acl" "ipset_bucket_acl" {
#   bucket = aws_s3_bucket.ipset_bucket.id
#   acl    = "private"
# }
#
# resource "aws_s3_object" "ipset_file" {
#   bucket  = aws_s3_bucket.ipset_bucket.id
#   key     = "trusted-ips.txt"
#   content = "10.0.0.0/8\n192.168.1.0/24\n"
# }
#
# # GuardDutyディテクターの作成例
# resource "aws_guardduty_detector" "primary" {
#   enable = true
# }
#
# # IPSetリソースの作成（動的参照を使用）
# resource "aws_guardduty_ipset" "trusted_ips" {
#   activate    = true
#   detector_id = aws_guardduty_detector.primary.id
#   format      = "TXT"
#   location    = "https://s3.amazonaws.com/${aws_s3_object.ipset_file.bucket}/${aws_s3_object.ipset_file.key}"
#   name        = "TrustedIPAddresses"
#
#   tags = {
#     Purpose = "Whitelist trusted IP ranges"
#   }
# }
#
#---------------------------------------------------------------
