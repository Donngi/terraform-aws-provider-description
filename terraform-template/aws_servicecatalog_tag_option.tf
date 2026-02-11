#---------------------------------------------------------------
# AWS Service Catalog Tag Option
#---------------------------------------------------------------
#
# AWS Service Catalogのタグオプションをプロビジョニングするリソースです。
# タグオプションはAWS Service Catalogで管理されるキー・値のペアで、
# プロビジョニング済み製品に適用されるAWSタグのテンプレートとして機能します。
# ポートフォリオや製品と関連付けることで、一貫したタグ分類を強制し、
# 適切なタグ付けを実現します。
#
# AWS公式ドキュメント:
#   - AWS Service Catalog TagOption Library: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/tagoptions.html
#   - Managing TagOptions: https://docs.aws.amazon.com/servicecatalog/latest/adminguide/tagoptions-manage.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_tag_option
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_tag_option" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # key (Required)
  # 設定内容: タグオプションのキーを指定します。
  # 設定可能な値: 文字列
  # 関連機能: AWS Service Catalog TagOption
  #   タグオプションはキー・値のペアでAWS Service Catalogで管理され、
  #   製品のプロビジョニング時にAWSタグとして適用されるテンプレートとして機能します。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/tagoptions.html
  key = "Environment"

  # value (Required)
  # 設定内容: タグオプションの値を指定します。
  # 設定可能な値: 文字列
  # 関連機能: AWS Service Catalog TagOption
  #   タグオプションの値は、製品起動時にユーザーが選択できる定義済みオプションとして
  #   使用されます。複数のタグオプションを定義することで、ユーザーに許可された値のみを
  #   選択させることができます。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/tagoptions.html
  value = "Production"

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # active (Optional)
  # 設定内容: タグオプションがアクティブかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): タグオプションはアクティブで使用可能
  #   - false: タグオプションは非アクティブ化され、製品起動時に使用不可
  # 省略時: true
  # 関連機能: TagOption アクティブ化/非アクティブ化
  #   タグオプションを非アクティブ化することで、ポートフォリオや製品との関連付けを
  #   保持したまま一時的に使用を停止できます。間欠的に使用されるタグや特殊な状況下で
  #   のみ使用されるタグの管理に有用です。
  #   - https://docs.aws.amazon.com/servicecatalog/latest/adminguide/tagoptions-manage.html
  active = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト期間を指定します。
  # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
  timeouts {
    # create (Optional)
    # 設定内容: タグオプション作成操作のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # read (Optional)
    # 設定内容: タグオプション読み取り操作のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    read = null

    # update (Optional)
    # 設定内容: タグオプション更新操作のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    update = null

    # delete (Optional)
    # 設定内容: タグオプション削除操作のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: タグオプションの識別子（例: tag-pjtvagohlyo3m）
#
# - owner: タグオプションを作成した所有者アカウントのAWSアカウントID
#---------------------------------------------------------------
