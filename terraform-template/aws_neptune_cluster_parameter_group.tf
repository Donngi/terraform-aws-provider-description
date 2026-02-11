#---------------------------------------------------------------
# Neptune Cluster Parameter Group
#---------------------------------------------------------------
#
# Amazon Neptuneクラスターのパラメータグループを作成する。
# パラメータグループは、クラスター内の全DBインスタンスに適用される
# データベース設定の「コンテナ」として機能する。
#
# パラメータグループファミリー:
#   - neptune1: エンジンバージョン1.2.0.0より前のバージョン向け
#   - neptune1.2: エンジンバージョン1.2.0.0以降向け（必須）
#
# パラメータの種類:
#   - 静的パラメータ: DBインスタンスの再起動後に有効
#   - 動的パラメータ: ほぼ即座に有効（一部のみ対応）
#
# AWS公式ドキュメント:
#   - Amazon Neptune parameter groups: https://docs.aws.amazon.com/neptune/latest/userguide/parameter-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_parameter_group" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # family (必須)
  # パラメータグループファミリー。
  # Neptuneエンジンバージョンとの互換性を定義する。
  # 設定可能な値:
  #   - "neptune1": エンジンバージョン1.2.0.0より前のデフォルトファミリー
  #   - "neptune1.2": エンジンバージョン1.2.0.0以降で必須
  # エンジンバージョン1.2.0.0以降にアップグレードする場合、
  # カスタムパラメータグループをneptune1.2ファミリーで再作成する必要がある。
  family = null # 例: "neptune1.2"

  # name (任意)
  # Neptuneクラスターパラメータグループの名前。
  # 省略した場合、Terraformがランダムでユニークな名前を割り当てる。
  # name_prefixと競合するため、どちらか一方のみ指定可能。
  # 変更時は新しいリソースが作成される（Forces new resource）。
  name = null # 例: "my-neptune-cluster-parameter-group"

  # name_prefix (任意)
  # 指定されたプレフィックスで始まるユニークな名前を作成する。
  # nameと競合するため、どちらか一方のみ指定可能。
  # 変更時は新しいリソースが作成される（Forces new resource）。
  name_prefix = null # 例: "my-neptune-"

  # description (任意)
  # Neptuneクラスターパラメータグループの説明。
  # 省略した場合、"Managed by Terraform"がデフォルト値として設定される。
  description = null # 例: "Custom parameter group for Neptune cluster"

  # region (任意)
  # このリソースが管理されるAWSリージョン。
  # 省略した場合、プロバイダー設定で指定されたリージョンが使用される。
  region = null # 例: "ap-northeast-1"

  #---------------------------------------------------------------
  # パラメータ設定
  #---------------------------------------------------------------

  # parameter (任意、複数指定可能)
  # Neptuneクラスターに適用するパラメータのリスト。
  # 複数のparameterブロックを指定可能。

  # 主要なNeptuneクラスターパラメータ:
  #   - neptune_enable_audit_log: 監査ログの有効化（0または1）
  #   - neptune_enable_slow_query_log: スロークエリログの有効化（動的パラメータ）
  #   - neptune_slow_query_log_threshold: スロークエリの閾値（ミリ秒、動的パラメータ）

  # parameter {
  #   # name (必須)
  #   # Neptuneパラメータの名前。
  #   name = "neptune_enable_audit_log"
  #
  #   # value (必須)
  #   # Neptuneパラメータの値。
  #   value = "1"
  #
  #   # apply_method (任意)
  #   # パラメータ変更の適用方法。
  #   # 設定可能な値:
  #   #   - "immediate": 即座に適用（動的パラメータのみ有効）
  #   #   - "pending-reboot": 次回の再起動時に適用（デフォルト）
  #   # 静的パラメータの場合、apply_methodに関係なく再起動が必要。
  #   apply_method = "pending-reboot"
  # }

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # tags (任意)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーを持つタグはプロバイダーレベルの設定を上書きする。
  tags = {
    # Name        = "example-neptune-cluster-parameter-group"
    # Environment = "production"
    # Project     = "example-project"
  }

  # tags_all (任意)
  # default_tagsを含むすべてのタグのマップ。
  # 通常は明示的に設定せず、Terraformが自動的に計算する。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能（設定不可）:
#
# id
#   - Neptuneクラスターパラメータグループ名。
#   - 参照: aws_neptune_cluster_parameter_group.this.id
#
# arn
#   - NeptuneクラスターパラメータグループのARN。
#   - 参照: aws_neptune_cluster_parameter_group.this.arn
#   - 形式: arn:aws:rds:<region>:<account-id>:cluster-pg:<name>
#
#---------------------------------------------------------------
