#---------------------------------------------------------------
# AWS Cost Explorer Cost Category
#---------------------------------------------------------------
#
# AWS Cost Explorerのコストカテゴリをプロビジョニングするリソースです。
# コストカテゴリを使用すると、AWSのコストを意味のあるカテゴリにグループ化する
# ルールを作成でき、組織内部のビジネス構造にマッピングすることができます。
#
# AWS公式ドキュメント:
#   - Cost Categories概要: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/manage-cost-categories.html
#   - Split Charge Rules: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/splitcharge-cost-categories.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_cost_category
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ce_cost_category" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コストカテゴリの一意の名前を指定します。
  # 設定可能な値: 一意の文字列
  # 注意: コストカテゴリ名はアカウント内で一意である必要があります。
  name = "TeamCostCategory"

  # rule_version (Required)
  # 設定内容: コストカテゴリのルールスキーマバージョンを指定します。
  # 設定可能な値:
  #   - "CostCategoryExpression.v1": 現在サポートされているバージョン
  rule_version = "CostCategoryExpression.v1"

  #-------------------------------------------------------------
  # デフォルト値設定
  #-------------------------------------------------------------

  # default_value (Optional)
  # 設定内容: どのルールにもマッチしなかった場合に使用するデフォルト値を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: ルールにマッチしないコストはカテゴリ化されません。
  default_value = "Other"

  # effective_start (Optional)
  # 設定内容: コストカテゴリの適用開始日時を指定します。
  # 設定可能な値: ISO 8601形式の日時文字列（例: "2024-01-01T00:00:00Z"）
  # 省略時: 現在の月の開始時から適用されます。
  # 注意: コストカテゴリは月初めから有効になります。月の途中で作成・更新した場合、
  #       変更は自動的にその月の初めからのコストと使用量に適用されます。
  effective_start = null

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: コストを分類するためのルールを定義します。
  # 説明: 少なくとも1つのルールが必要です。ルールは上から順に評価されます。
  # 関連機能: Cost Categories
  #   ルールを使用してコストを意味のあるカテゴリにグループ化できます。
  #   - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/manage-cost-categories.html

  # ルール例1: アカウント名による分類（Regular Rule）
  rule {
    # value (Optional)
    # 設定内容: このルールにマッチしたコストに割り当てるカテゴリ値を指定します。
    # 設定可能な値: 任意の文字列
    value = "Production"

    # type (Optional)
    # 設定内容: ルールタイプを指定します。
    # 設定可能な値:
    #   - "REGULAR" (デフォルト): 静的に定義されたカテゴリ値を追加します。
    #   - "INHERITED_VALUE": ディメンション値から動的にカテゴリ値を継承します。
    type = "REGULAR"

    # rule (Optional)
    # 設定内容: コストを分類するための条件式を定義します。
    rule {
      # dimension (Optional)
      # 設定内容: 特定のディメンションに基づいてフィルタリングします。
      dimension {
        # key (Optional)
        # 設定内容: フィルタリングに使用するディメンションキーを指定します。
        # 設定可能な値:
        #   - "LINKED_ACCOUNT_NAME": アカウント名
        #   - "LINKED_ACCOUNT": アカウントID
        #   - "SERVICE": AWSサービス
        #   - "REGION": リージョン
        #   - "USAGE_TYPE": 使用タイプ
        #   - "RECORD_TYPE": レコードタイプ（チャージタイプ）
        #   - "BILLING_ENTITY": 請求エンティティ
        key = "LINKED_ACCOUNT_NAME"

        # values (Optional)
        # 設定内容: フィルタリングする値のリストを指定します。
        # 設定可能な値: 文字列のセット
        values = ["-prod"]

        # match_options (Optional)
        # 設定内容: 値のマッチング方法を指定します。
        # 設定可能な値:
        #   - "EQUALS": 完全一致
        #   - "ABSENT": 値が存在しない
        #   - "STARTS_WITH": 前方一致
        #   - "ENDS_WITH": 後方一致
        #   - "CONTAINS": 部分一致
        #   - "CASE_SENSITIVE": 大文字小文字を区別
        #   - "CASE_INSENSITIVE": 大文字小文字を区別しない
        # デフォルト: "EQUALS", "CASE_SENSITIVE"
        match_options = ["ENDS_WITH"]
      }
    }
  }

  # ルール例2: 複数条件による分類（AND条件）
  rule {
    value = "Staging"
    type  = "REGULAR"

    rule {
      and {
        dimension {
          key           = "LINKED_ACCOUNT_NAME"
          values        = ["-stg"]
          match_options = ["ENDS_WITH"]
        }
      }
      and {
        dimension {
          key           = "REGION"
          values        = ["ap-northeast-1"]
          match_options = ["EQUALS"]
        }
      }
    }
  }

  # ルール例3: 複数条件による分類（OR条件）
  rule {
    value = "Development"
    type  = "REGULAR"

    rule {
      or {
        dimension {
          key           = "LINKED_ACCOUNT_NAME"
          values        = ["-dev"]
          match_options = ["ENDS_WITH"]
        }
      }
      or {
        dimension {
          key           = "LINKED_ACCOUNT_NAME"
          values        = ["-test"]
          match_options = ["ENDS_WITH"]
        }
      }
    }
  }

  # ルール例4: NOT条件による分類
  rule {
    value = "NonProduction"
    type  = "REGULAR"

    rule {
      not {
        dimension {
          key           = "LINKED_ACCOUNT_NAME"
          values        = ["-prod"]
          match_options = ["ENDS_WITH"]
        }
      }
    }
  }

  # ルール例5: コストカテゴリによるフィルタリング
  rule {
    value = "EngineeringTotal"
    type  = "REGULAR"

    rule {
      # cost_category (Optional)
      # 設定内容: 別のコストカテゴリの値に基づいてフィルタリングします。
      # 用途: 階層的なコストカテゴリ構造を構築する際に使用します。
      cost_category {
        # key (Optional)
        # 設定内容: フィルタリングに使用するコストカテゴリ名を指定します。
        key = "Team"

        # values (Optional)
        # 設定内容: フィルタリングするコストカテゴリ値のリストを指定します。
        values = ["Engineering", "Platform"]

        # match_options (Optional)
        # 設定内容: 値のマッチング方法を指定します。
        match_options = ["EQUALS"]
      }
    }
  }

  # ルール例6: タグによるフィルタリング
  rule {
    value = "TaggedProjects"
    type  = "REGULAR"

    rule {
      # tags (Optional)
      # 設定内容: コスト配分タグに基づいてフィルタリングします。
      tags {
        # key (Optional)
        # 設定内容: タグキーを指定します。
        key = "Project"

        # values (Optional)
        # 設定内容: フィルタリングするタグ値のリストを指定します。
        values = ["ProjectA", "ProjectB"]

        # match_options (Optional)
        # 設定内容: 値のマッチング方法を指定します。
        match_options = ["EQUALS"]
      }
    }
  }

  # ルール例7: 継承値ルール（Inherited Value）
  rule {
    # type (Optional)
    # 設定内容: INHERITED_VALUEを指定すると、ディメンション値から動的にカテゴリ値を継承します。
    type = "INHERITED_VALUE"

    # inherited_value (Optional)
    # 設定内容: 動的にカテゴリ値を継承するための設定を定義します。
    inherited_value {
      # dimension_name (Optional)
      # 設定内容: 値を継承するディメンション名を指定します。
      # 設定可能な値:
      #   - "LINKED_ACCOUNT_NAME": アカウント名から値を継承
      #   - "TAG": タグ値から継承
      dimension_name = "TAG"

      # dimension_key (Optional)
      # 設定内容: dimension_nameが"TAG"の場合、継承元のタグキーを指定します。
      # 用途: 例えば"teams"タグを指定すると、alpha, beta, gammaなどのタグ値が
      #       動的にコストカテゴリ値として使用されます。
      dimension_key = "Environment"
    }
  }

  #-------------------------------------------------------------
  # スプリットチャージルール設定
  #-------------------------------------------------------------

  # split_charge_rule (Optional)
  # 設定内容: 共有コストをコストカテゴリ値間で分割するルールを定義します。
  # 説明: データ転送コスト、エンタープライズサポート、運用コストなど、
  #       複数のチームやビジネスユニットで共有されるコストを分割する際に使用します。
  # 関連機能: Split Charge Rules
  #   共有コストを分割して、各ターゲットに割り当てることができます。
  #   - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/splitcharge-cost-categories.html
  # 注意: 最大10個のスプリットチャージルールを定義できます。
  #       ソースとして使用された値はターゲットとして使用できません（逆も同様）。

  split_charge_rule {
    # source (Required)
    # 設定内容: 分割したい共有コストのコストカテゴリ値を指定します。
    # 設定可能な値: 既存のコストカテゴリ値
    source = "SharedInfrastructure"

    # targets (Required)
    # 設定内容: コストを分割する先のコストカテゴリ値を指定します。
    # 設定可能な値: 既存のコストカテゴリ値のセット
    # 注意: ターゲットに指定された値は、他のスプリットチャージルールでソースとして使用できません。
    targets = ["Production", "Staging", "Development"]

    # method (Required)
    # 設定内容: コストの分割方法を指定します。
    # 設定可能な値:
    #   - "PROPORTIONAL": 各ターゲットのコスト比率に基づいて比例配分
    #   - "FIXED": 定義された割合に基づいて固定配分（parameterブロックが必要）
    #   - "EVEN": すべてのターゲットに均等配分
    method = "PROPORTIONAL"

    # parameter (Optional)
    # 設定内容: FIXEDメソッドを使用する場合の分割パラメータを定義します。
    # 説明: methodが"FIXED"の場合のみ必要です。
    # parameter {
    #   # type (Optional)
    #   # 設定内容: パラメータタイプを指定します。
    #   type = "ALLOCATION_PERCENTAGES"
    #
    #   # values (Optional)
    #   # 設定内容: 各ターゲットへの割り当て割合を指定します。
    #   # 注意: targetsの順序に対応し、合計が100になる必要があります。
    #   values = ["50", "30", "20"]
    # }
  }

  # FIXEDメソッドを使用したスプリットチャージルールの例
  split_charge_rule {
    source  = "EnterpriseSupportCosts"
    targets = ["Production", "Staging"]
    method  = "FIXED"

    parameter {
      type   = "ALLOCATION_PERCENTAGES"
      values = ["70", "30"]
    }
  }

  # EVENメソッドを使用したスプリットチャージルールの例
  split_charge_rule {
    source  = "DataTransferCosts"
    targets = ["Production", "Staging", "Development"]
    method  = "EVEN"
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
  tags = {
    Name        = "TeamCostCategory"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コストカテゴリのAmazon Resource Name (ARN)
#
# - effective_end: コストカテゴリの終了日時
#
# - id: コストカテゴリの一意のID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
