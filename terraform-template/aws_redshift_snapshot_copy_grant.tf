#---------------------------------------------------------------
# AWS Redshift Snapshot Copy Grant
#---------------------------------------------------------------
#
# Redshiftクラスターのスナップショットを別のリージョンにコピーする際に
# AWS KMSのカスタマーマスターキー(CMK)で暗号化するための許可を作成します。
# このリソースは、スナップショットのコピー先リージョンに作成する必要があり、
# クラスターが存在するリージョンには作成しないことに注意してください。
#
# 関連機能: Redshift スナップショットコピー機能
#   クラスター災害復旧(DR)やマルチリージョンバックアップのために、
#   自動スナップショットを別のリージョンにコピーできます。
#   このグラントにより、コピー先リージョンでKMSによる暗号化を行えます。
#
# AWS公式ドキュメント:
#   - Copying snapshots to another AWS Region: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html#cross-region-snapshot-copy
#   - Amazon Redshift Database Encryption: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_snapshot_copy_grant
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_snapshot_copy_grant" "example" {
  #-------------------------------------------------------------
  # グラント基本設定 (Required)
  #-------------------------------------------------------------

  # snapshot_copy_grant_name (Required, Forces new resource)
  # 設定内容: スナップショットコピーグラントを識別するためのわかりやすい名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 制約事項: この値を変更すると、リソースが削除されて再作成されます (Forces new resource)
  # 用途: Redshiftクラスターのsnapshot_copy設定で、このグラント名を参照して使用します。
  # 推奨事項: 環境名やリージョン情報を含む命名規則を使用することで管理しやすくなります。
  #           例: "my-cluster-snapshot-copy-grant-us-west-2"
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html#cross-region-snapshot-copy
  snapshot_copy_grant_name = "my-grant"

  #-------------------------------------------------------------
  # KMS暗号化設定 (Optional)
  #-------------------------------------------------------------

  # kms_key_id (Optional, Forces new resource)
  # 設定内容: グラントが適用されるカスタマーマスターキー(CMK)の一意の識別子を指定します。
  # 設定可能な値:
  #   - KMSキーID（例: "1234abcd-12ab-34cd-56ef-1234567890ab"）
  #   - KMSキーARN（例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"）
  # 省略時: AWSデフォルトのマスターキーが使用されます。
  # 制約事項:
  #   - この値を変更すると、リソースが削除されて再作成されます (Forces new resource)
  #   - 別のAWSアカウントのCMKを指定する場合は、キーARNを使用する必要があります。
  # 用途: コピー先リージョンでスナップショットを暗号化するためのKMSキーを指定します。
  # セキュリティ推奨事項:
  #   - 本番環境では、デフォルトキーではなくカスタマー管理のCMKを使用することを推奨します。
  #   - クロスアカウントでスナップショットをコピーする場合は、適切なKMSキーポリシーを設定してください。
  # 参考:
  #   - Amazon Redshift Database Encryption: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
  #   - AWS KMS Keys: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#master_keys
  kms_key_id = null

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 重要な注意事項:
  #   - このグラントは、スナップショットのコピー先リージョンに作成する必要があります。
  #   - クラスターが存在するリージョンには作成しないでください。
  # 用途: マルチリージョン構成でスナップショットコピーを実装する場合に、
  #       コピー先リージョンを明示的に指定できます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = null

  #-------------------------------------------------------------
  # タグ設定 (Optional)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト追跡、アクセス制御などに使用します。
  # タグ継承: プロバイダーのdefault_tagsブロックで定義されたタグと
  #           マッチするキーがある場合、このタグの値が優先されます。
  # 推奨事項:
  #   - Environment: 環境識別（例: "production", "staging"）
  #   - Application: アプリケーション名
  #   - ManagedBy: "Terraform" などの管理方法
  #   - CostCenter: コスト配分のためのコストセンター情報
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-grant"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スナップショットコピーグラントのAmazon Resource Name (ARN)
#        形式: arn:aws:redshift:<region>:<account-id>:snapshotcopygrant:<grant-name>
#
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#             プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Redshiftクラスターとの統合
#---------------------------------------------------------------
# resource "aws_redshift_cluster" "example" {
#   # ... その他の設定 ...
#
#   snapshot_copy {
#     destination_region = "us-east-2"
#     grant_name         = aws_redshift_snapshot_copy_grant.example.snapshot_copy_grant_name
#   }
# }
#---------------------------------------------------------------
