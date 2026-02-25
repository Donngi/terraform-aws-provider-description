#---------------------------------------------------------------
# AWS MemoryDB Parameter Group
#---------------------------------------------------------------
#
# Amazon MemoryDB for Redisのパラメータグループをプロビジョニングするリソースです。
# パラメータグループはクラスタ上のエンジンのランタイム設定を管理する仕組みであり、
# メモリ使用量やアイテムサイズなどのパラメータを制御します。
# ファミリーバージョンに対応したパラメータグループをクラスタに関連付けることで、
# エンジン動作をカスタマイズできます。
#
# AWS公式ドキュメント:
#   - MemoryDB パラメータグループ: https://docs.aws.amazon.com/memorydb/latest/devguide/parametergroups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_parameter_group" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # family (Required, Forces new resource)
  # 設定内容: パラメータグループが使用できるエンジンバージョンのファミリーを指定します。
  # 設定可能な値:
  #   - "memorydb_redis6": Redis 6.x 系
  #   - "memorydb_redis7": Redis 7.x 系
  #   - "memorydb_valkey7": Valkey 7.x 系
  # 参考: https://docs.aws.amazon.com/memorydb/latest/devguide/parametergroups.html
  family = "memorydb_redis7"

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: パラメータグループの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "my-parameter-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: パラメータグループ名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

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
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: パラメータグループの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: "Managed by Terraform"
  description = "My MemoryDB parameter group"

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: 適用するMemoryDBパラメータのセットを指定します。
  #           ここで指定されていないパラメータはファミリーのデフォルト値にフォールバックします。
  # 関連機能: MemoryDB パラメータグループ
  #   Redis/Valkeyエンジンの動作をカスタマイズするパラメータを設定します。
  #   - https://docs.aws.amazon.com/memorydb/latest/devguide/parametergroups.html
  parameter {

    # name (Required)
    # 設定内容: パラメータの名前を指定します。
    # 設定可能な値: 有効なMemoryDBパラメータ名（例: "activedefrag", "maxmemory-policy"）
    name = "activedefrag"

    # value (Required)
    # 設定内容: パラメータの値を指定します。
    # 設定可能な値: パラメータに応じた文字列値
    value = "yes"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-parameter-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: nameと同じ値
#
# - arn: パラメータグループのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
