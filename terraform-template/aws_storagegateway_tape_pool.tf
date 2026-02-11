#---------------------------------------------------------------
# AWS Storage Gateway Tape Pool
#---------------------------------------------------------------
#
# AWS Storage Gateway のカスタムテープールを管理するリソースです。
# テープールは、仮想テープがバックアップアプリケーションからイジェクトされた際に
# アーカイブされるストレージクラスを定義します。
#
# テープールの主なユースケース:
#   1. コスト最適化: アーカイブ先のストレージクラス (Glacier / Deep Archive) を指定
#   2. コンプライアンス: テープ保持ロックによりデータの不変性を確保
#   3. ガバナンス: 特定のIAM権限を持つユーザーのみがロックを解除可能
#
# AWS公式ドキュメント:
#   - Storage Gateway テープアーカイブ: https://docs.aws.amazon.com/storagegateway/latest/tgw/archiving-tapes.html
#   - テープ保持ロック: https://docs.aws.amazon.com/storagegateway/latest/tgw/tape-retention-lock.html
#   - Storage Gateway API リファレンス: https://docs.aws.amazon.com/storagegateway/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_tape_pool
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_tape_pool" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # pool_name (Required)
  # 設定内容: 新しいカスタムテープールの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: テープールを識別するための名前
  # 関連機能: Storage Gateway テープールの管理
  #   テープールはバックアップアプリケーションからイジェクトされたテープの
  #   アーカイブ先を制御するために使用されます。
  #   - https://docs.aws.amazon.com/storagegateway/latest/tgw/archiving-tapes.html
  pool_name = "example"

  # storage_class (Required)
  # 設定内容: カスタムテープールに関連付けるストレージクラスを指定します。
  # 設定可能な値:
  #   - "GLACIER": S3 Glacier Flexible Retrieval。取得時間は数分〜数時間
  #   - "DEEP_ARCHIVE": S3 Glacier Deep Archive。最も低コストだが取得に12時間以上
  # 用途: バックアップアプリケーションからテープをイジェクトすると、
  #       テープはこのプールに対応するストレージクラスに直接アーカイブされます
  # 関連機能: S3 Glacier ストレージクラス
  #   コストと取得時間のトレードオフに基づいて選択してください。
  #   - https://docs.aws.amazon.com/storagegateway/latest/tgw/archiving-tapes.html
  storage_class = "GLACIER"

  #-------------------------------------------------------------
  # テープ保持ロック設定
  #-------------------------------------------------------------

  # retention_lock_type (Optional)
  # 設定内容: テープ保持ロックのモードを指定します。
  # 設定可能な値:
  #   - "NONE" (デフォルト): 保持ロックなし。テープは自由に削除可能
  #   - "GOVERNANCE": ガバナンスモード。特定のIAM権限を持つアカウントが保持ロックを解除可能
  #   - "COMPLIANCE": コンプライアンスモード。rootアカウントを含む全ユーザーがロック解除不可
  # 注意: COMPLIANCEモードは一度設定すると変更できません。慎重に選択してください
  # 関連機能: テープ保持ロック
  #   データの不変性を確保し、規制要件 (SEC 17a-4(f)、CFTC、FINRA等) に準拠可能。
  #   - https://docs.aws.amazon.com/storagegateway/latest/tgw/tape-retention-lock.html
  retention_lock_type = "NONE"

  # retention_lock_time_in_days (Optional)
  # 設定内容: テープ保持ロックの期間を日数で指定します。
  # 設定可能な値: 0〜36500 (最大100年)
  # 省略時のデフォルト: 0 (ロックなし)
  # 注意: retention_lock_typeが"GOVERNANCE"または"COMPLIANCE"の場合に設定
  # 関連機能: テープ保持ロック期間
  #   指定した期間中はテープを削除できません。コンプライアンス要件に応じて設定。
  #   - https://docs.aws.amazon.com/storagegateway/latest/tgw/tape-retention-lock.html
  retention_lock_time_in_days = 0

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-tape-pool"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テープールのAmazon Resource Name (ARN)
#   例: arn:aws:storagegateway:us-east-1:123456789012:tapepool/pool-12345678
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
