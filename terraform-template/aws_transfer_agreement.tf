#---------------------------------------------------------------
# AWS Transfer Family AS2 Agreement
#---------------------------------------------------------------
#
# AWS Transfer FamilyのAS2プロトコルを使用したファイル転送のための
# Agreementリソースをプロビジョニングします。
# AgreementはTransfer FamilyサーバーとAS2プロセス間のファイル・メッセージ
# 転送関係を定義し、EDI（電子データ交換）文書の安全な交換を可能にします。
#
# AWS公式ドキュメント:
#   - CreateAgreement API: https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
#   - AWS Transfer Family for AS2: https://docs.aws.amazon.com/transfer/latest/userguide/as2-for-transfer-family.html
#   - UpdateAgreement API: https://docs.aws.amazon.com/transfer/latest/APIReference/API_UpdateAgreement.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_agreement
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_agreement" "example" {
  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # access_role (Required)
  # 設定内容: StartFileTransferリクエストで指定されたファイルロケーションの
  #          親ディレクトリへの読み書きアクセスを提供するIAMロールのARN。
  # 設定可能な値: 有効なIAM RoleのARN
  # 関連機能: AS2メッセージの送受信に必要なS3バケットへのアクセス権限を持つ
  #          ロールを指定します。ロールにはS3への読み書き権限が必要です。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
  access_role = "arn:aws:iam::123456789012:role/TransferFamilyAS2Role"

  #-------------------------------------------------------------
  # ディレクトリ設定
  #-------------------------------------------------------------

  # base_directory (Required)
  # 設定内容: AS2プロトコルを使用して転送されるファイルのランディングディレクトリ。
  # 設定可能な値: S3バケット内の有効なパス（例: /DOC-EXAMPLE-BUCKET/home/mydirectory）
  # 関連機能: 受信したファイルはこのディレクトリに保存され、送信するファイルは
  #          このディレクトリから取得されます。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
  base_directory = "/my-bucket/as2/incoming"

  #-------------------------------------------------------------
  # プロファイル設定
  #-------------------------------------------------------------

  # local_profile_id (Required)
  # 設定内容: AS2ローカルプロファイルの一意な識別子。
  # 設定可能な値: aws_transfer_profileリソースで作成したprofile_id
  # 関連機能: ローカルプロファイルは自組織のAS2設定（証明書、署名・暗号化設定など）を
  #          定義します。Transfer Familyサーバー側のプロファイルを指定します。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
  local_profile_id = "p-1234567890abcdef0"

  # partner_profile_id (Required)
  # 設定内容: AS2パートナープロファイルの一意な識別子。
  # 設定可能な値: aws_transfer_profileリソースで作成したprofile_id
  # 関連機能: パートナープロファイルは取引先のAS2設定（証明書、AS2識別子など）を
  #          定義します。AS2メッセージの送受信相手の設定を指定します。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
  partner_profile_id = "p-0987654321fedcba0"

  #-------------------------------------------------------------
  # サーバー設定
  #-------------------------------------------------------------

  # server_id (Required)
  # 設定内容: このAgreementが使用するTransfer Familyサーバーの一意な識別子。
  # 設定可能な値: aws_transfer_serverリソースで作成したserver_id
  # 関連機能: AS2対応のTransfer Familyサーバーを指定します。
  #          このサーバーがAgreementの基盤となります。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
  server_id = "s-1234567890abcdef0"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: Agreementの説明。
  # 設定可能な値: 任意の文字列
  # 関連機能: このAgreementの目的や取引先に関する情報を記載します。
  #          AWS Configのルール（transfer-agreement-description）では、
  #          コンプライアンスのために説明の設定が推奨されています。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
  #   - https://docs.aws.amazon.com/config/latest/developerguide/transfer-agreement-description.html
  description = "Partner X社とのEDI文書交換用Agreement"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョン。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップ。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #          コスト配分、リソース管理、セキュリティポリシーの適用に使用します。
  #          プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #          一致するキーを持つタグは、このリソースで定義されたものが優先されます。
  #   - https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateAgreement.html
  tags = {
    Environment = "production"
    Partner     = "CompanyX"
    Project     = "EDI-Integration"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - agreement_id (string)
#   AS2 Agreementの一意な識別子。
#   Transfer Family APIやCLI操作で使用します。
#   例: a-1234567890abcdef0
#
# - arn (string)
#   AgreementのAmazon Resource Name (ARN)。
#   IAMポリシーやタグベースのアクセス制御で使用します。
#   例: arn:aws:transfer:us-east-1:123456789012:agreement/s-1234567890abcdef0/a-1234567890abcdef0
#
# - status (string)
#   Agreementのステータス（ACTIVE または INACTIVE）。
#   ACTIVEの場合のみファイル転送が可能です。
#   UpdateAgreement APIで状態を変更できます。
#
