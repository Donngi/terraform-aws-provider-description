#---------------------------------------------------------------
# MemoryDB Parameter Group (aws_memorydb_parameter_group)
#---------------------------------------------------------------
#
# Amazon MemoryDBクラスターに適用するパラメータグループをプロビジョニングします。
# パラメータグループは、MemoryDBクラスターのエンジン実行時設定を管理するために使用され、
# メモリ使用量、アイテムサイズ、その他のエンジン固有のパラメータを制御します。
#
# AWS公式ドキュメント:
#   - Parameter groups: https://docs.aws.amazon.com/memorydb/latest/devguide/parametergroups.html
#   - Parameter management: https://docs.aws.amazon.com/memorydb/latest/devguide/parametergroups.management.html
#   - Creating a parameter group: https://docs.aws.amazon.com/memorydb/latest/devguide/parametergroups.creating.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_parameter_group" "this" {
  #---------------------------------------------------------------
  # 必須パラメータ (Required)
  #---------------------------------------------------------------

  # family - パラメータグループファミリー
  # (Required, Forces new resource)
  # パラメータグループが使用できるエンジンバージョンを指定します。
  # この値は、パラメータグループを関連付けるMemoryDBクラスターの
  # エンジンバージョンと互換性がある必要があります。
  # 変更すると新しいリソースが作成されます。
  #
  # 使用可能な値の例:
  #   - "memorydb_redis6" - Valkey/Redis OSS 6.x 互換
  #   - "memorydb_redis7" - Valkey/Redis OSS 7.x 互換
  #   - "memorydb_valkey7" - Valkey 7.x
  family = "memorydb_redis7"

  #---------------------------------------------------------------
  # 任意パラメータ (Optional)
  #---------------------------------------------------------------

  # name - パラメータグループ名
  # (Optional, Forces new resource)
  # パラメータグループの名前を指定します。
  # 省略した場合、Terraformがランダムな一意の名前を生成します。
  # name_prefixと同時に指定することはできません。
  # 変更すると新しいリソースが作成されます。
  #
  # 命名規則:
  #   - ASCII文字で始まる必要があります
  #   - ASCII文字、数字、ハイフンのみ使用可能
  #   - 1〜255文字
  #   - 連続するハイフン(--)は使用不可
  #   - ハイフンで終わることはできません
  name = "example-parameter-group"

  # name_prefix - パラメータグループ名のプレフィックス
  # (Optional, Forces new resource)
  # 指定したプレフィックスで始まる一意の名前を作成します。
  # nameと同時に指定することはできません。
  # 変更すると新しいリソースが作成されます。
  #
  # 使用例:
  #   name_prefix = "myapp-" → "myapp-abc123xyz" のような名前が生成される
  # name_prefix = "example-"

  # description - パラメータグループの説明
  # (Optional, Forces new resource)
  # パラメータグループの説明を指定します。
  # 省略した場合、デフォルトで "Managed by Terraform" が設定されます。
  # 変更すると新しいリソースが作成されます。
  description = "Example MemoryDB parameter group"

  # region - リソース管理リージョン
  # (Optional)
  # このリソースを管理するAWSリージョンを指定します。
  # 省略した場合、プロバイダー設定で指定されたリージョンが使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags - リソースタグ
  # (Optional)
  # リソースに割り当てるタグのマップを指定します。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはここで定義された値で上書きされます。
  tags = {
    Name        = "example-parameter-group"
    Environment = "development"
  }

  #---------------------------------------------------------------
  # ネストブロック: parameter
  #---------------------------------------------------------------

  # parameter - パラメータ設定ブロック
  # (Optional)
  # MemoryDBパラメータを設定します。
  # 指定されていないパラメータは、ファミリーのデフォルト値にフォールバックします。
  # 複数のparameterブロックを指定できます。
  #
  # 利用可能なパラメータはエンジンバージョンによって異なります。
  # デフォルトパラメータグループは変更できません。カスタム値を使用する場合は
  # カスタムパラメータグループを作成する必要があります。

  parameter {
    # name - パラメータ名
    # (Required)
    # 設定するパラメータの名前を指定します。
    name = "activedefrag"

    # value - パラメータ値
    # (Required)
    # パラメータに設定する値を指定します。
    value = "yes"
  }

  # 追加のパラメータ設定例:
  # parameter {
  #   name  = "maxmemory-policy"
  #   value = "volatile-lru"
  # }

  # parameter {
  #   name  = "notify-keyspace-events"
  #   value = "KEA"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能な読み取り専用属性です:
#
# arn - パラメータグループのAmazon Resource Name (ARN)
#   例: arn:aws:memorydb:ap-northeast-1:123456789012:parametergroup/example-parameter-group
#
# id - パラメータグループの識別子（nameと同じ値）
#
# tags_all - プロバイダーの default_tags で定義されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# 既存のMemoryDBパラメータグループは以下のコマンドでインポートできます:
#
#   terraform import aws_memorydb_parameter_group.example my-parameter-group
#
# パラメータグループ名を指定してインポートします。
#
#---------------------------------------------------------------
