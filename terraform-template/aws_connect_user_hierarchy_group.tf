#---------------------------------------
# AWS Connect ユーザー階層グループ
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: 本テンプレートはAWS Provider 6.28.0のスキーマから生成されています
#
# 用途: Amazon Connectインスタンス内でユーザーを組織階層で管理するための階層グループを作成
# 特徴:
#   - 最大5階層までのユーザー組織構造をサポート
#   - 親グループを指定して階層構造を構築可能
#   - ユーザーの権限管理やルーティング設定に利用可能
# 関連リソース:
#   - aws_connect_instance: Connectインスタンス本体
#   - aws_connect_user: 階層グループに所属するユーザー
# 公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/connect_user_hierarchy_group
#---------------------------------------

resource "aws_connect_user_hierarchy_group" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: Connectインスタンスの識別子（Amazon Connectコンソールまたは既存インスタンスから取得）
  # 形式: インスタンスID（例: aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee）
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

  # 設定内容: 階層グループの表示名（Connectコンソールやレポートに表示される名前）
  # 制約: 最大256文字、スペースおよび特殊文字利用可能
  name = "Sales Team"

  #---------------------------------------
  # 階層構造設定
  #---------------------------------------
  # 設定内容: 親階層グループのID（このグループを階層の下位レベルに配置する場合に指定）
  # 用途: 多階層の組織構造を構築する際に使用（例: 部門 > チーム > サブチーム）
  # 省略時: ルートレベルの階層グループとして作成される
  parent_group_id = "12345678-1234-1234-1234-123456789012"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 用途: マルチリージョン環境での明示的なリージョン指定
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与する任意のキー・バリューペア
  # 用途: リソース管理、コスト配分、検索フィルタリング
  tags = {
    Environment = "production"
    Department  = "Sales"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# 以下の属性がリソース作成後に参照可能:
#
# arn                  - 階層グループのARN（例: arn:aws:connect:us-east-1:123456789012:instance/xxx/agent-group/yyy）
# hierarchy_group_id   - 階層グループの一意な識別子（UUID形式）
# level_id            - 階層レベルの識別子（レベル1～5のいずれか）
# id                  - Terraform内部で使用されるリソース識別子（instance_id:hierarchy_group_id形式）
# hierarchy_path      - 階層パス情報（各レベルのarn、id、nameを含むオブジェクト構造）
#   - level_one       - 第1階層（最上位）の情報
#   - level_two       - 第2階層の情報
#   - level_three     - 第3階層の情報
#   - level_four      - 第4階層の情報
#   - level_five      - 第5階層（最下位）の情報
# tags_all            - デフォルトタグを含む全てのタグ
#
# 参照例:
# output "hierarchy_group_arn" {
#   value = aws_connect_user_hierarchy_group.example.arn
# }
