#---------------------------------------------------------------
# Amazon DocumentDB Cluster Parameter Group
#---------------------------------------------------------------
#
# Amazon DocumentDB のクラスターパラメータグループを管理するリソースです。
# クラスターパラメータグループには、クラスター内の全インスタンスに適用される
# エンジン設定パラメータのコレクションが含まれます。
#
# デフォルトのパラメータグループ (default.docdb3.6 等) は直接変更できないため、
# カスタムパラメータグループを作成して設定を変更する必要があります。
# パラメータには動的 (dynamic) と静的 (static) の2種類があり、
# 静的パラメータの変更にはインスタンスの再起動が必要です。
#
# AWS公式ドキュメント:
#   - DocumentDB クラスターパラメータグループ: https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups.html
#   - パラメータの変更: https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups-parameters.html
#   - CreateDBClusterParameterGroup API: https://docs.aws.amazon.com/documentdb/latest/developerguide/API_CreateDBClusterParameterGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdb_cluster_parameter_group" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # family (Required, Forces new resource)
  # 設定内容: DocumentDB クラスターパラメータグループのファミリー名を指定します。
  # 設定可能な値:
  #   - "docdb3.6": DocumentDB 3.6 互換
  #   - "docdb4.0": DocumentDB 4.0 互換
  #   - "docdb5.0": DocumentDB 5.0 互換
  # 注意: この値を変更すると、リソースが強制的に再作成されます
  # 関連機能: DocumentDB パラメータグループファミリー
  #   ファミリーはDocumentDBエンジンのバージョンに対応しています。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups.html
  family = "docdb5.0"

  #-------------------------------------------------------------
  # 識別設定
  #-------------------------------------------------------------

  # name (Optional, Computed, Forces new resource)
  # 設定内容: DocumentDB クラスターパラメータグループの名前を指定します。
  # 設定可能な値: 英数字とハイフンを使用した一意の名前
  # 省略時: Terraform がランダムな一意の名前を自動生成します
  # 注意:
  #   - name_prefix と競合します。どちらか一方のみ指定可能
  #   - この値を変更すると、リソースが強制的に再作成されます
  # 関連機能: DocumentDB クラスターパラメータグループの命名
  #   名前は小文字で保存されます。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups.html
  name = "example-docdb-cluster-parameter-group"

  # name_prefix (Optional, Computed, Forces new resource)
  # 設定内容: 指定したプレフィックスで始まる一意の名前を自動生成します。
  # 設定可能な値: 任意の文字列プレフィックス
  # 省略時: name が指定されていない場合、Terraform がデフォルトのプレフィックスを使用
  # 注意:
  #   - name と競合します。どちらか一方のみ指定可能
  #   - この値を変更すると、リソースが強制的に再作成されます
  # 用途: 複数環境で同じ設定を使用する場合や、一意性を自動保証したい場合に有用
  # name_prefix = "example-"

  # description (Optional, Forces new resource)
  # 設定内容: DocumentDB クラスターパラメータグループの説明を指定します。
  # 設定可能な値: 任意の説明文字列
  # 省略時: "Managed by Terraform" がデフォルト値として設定されます
  # 注意: この値を変更すると、リソースが強制的に再作成されます
  # 用途: パラメータグループの目的や用途を記録するために使用
  description = "Custom DocumentDB cluster parameter group for example application"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定で指定されたリージョンを使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: DocumentDB クラスターに適用するパラメータのリストを指定します。
  # 用途: デフォルト値から変更したいエンジン設定を指定
  # 注意:
  #   - システムデフォルト値に設定すると、インポートされたリソースで差分が表示される場合があります
  #   - パラメータの値は文字列として指定する必要があります
  # 関連機能: DocumentDB クラスターパラメータ
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups-parameters.html

  # TLS接続の設定例
  parameter {
    # name (Required)
    # 設定内容: DocumentDB パラメータの名前を指定します。
    # 設定可能な値: 有効なDocumentDBパラメータ名
    # 主要なパラメータ:
    #   - "tls": TLS/SSL接続の有効/無効
    #   - "audit_logs": 監査ログの有効/無効
    #   - "change_stream_log_retention_duration": Change Streamのログ保持期間
    #   - "ttl_monitor": TTL Monitor機能の有効/無効
    name = "tls"

    # value (Required)
    # 設定内容: DocumentDB パラメータの値を指定します。
    # 設定可能な値: パラメータによって異なります (文字列として指定)
    #   - "tls": "enabled" または "disabled"
    #   - "audit_logs": "enabled" または "disabled"
    #   - "change_stream_log_retention_duration": 数値 (時間)
    #   - "ttl_monitor": "enabled" または "disabled"
    value = "enabled"

    # apply_method (Optional)
    # 設定内容: パラメータ変更の適用方法を指定します。
    # 設定可能な値:
    #   - "immediate": 変更を即座に適用 (動的パラメータのみ)
    #   - "pending-reboot": 次回のインスタンス再起動時に適用 (デフォルト)
    # 注意:
    #   - 静的 (ApplyType: static) パラメータは "pending-reboot" を指定する必要があります
    #   - 動的 (ApplyType: dynamic) パラメータは両方の値を使用可能
    # 関連機能: パラメータ適用タイミング
    #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/cluster_parameter_groups-parameters.html
    apply_method = "pending-reboot"
  }

  # 監査ログの設定例
  parameter {
    name         = "audit_logs"
    value        = "enabled"
    apply_method = "immediate"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/tagging.html
  tags = {
    Name        = "example-docdb-cluster-parameter-group"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  # tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。DocumentDB クラスターパラメータグループ名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DocumentDB クラスターパラメータグループ名
#
# - arn: DocumentDB クラスターパラメータグループの Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
