#---------------------------------------------------------------
# EC2 Image Builder ライフサイクルポリシー
#---------------------------------------------------------------
#
# EC2 Image Builderのライフサイクルポリシーをプロビジョニングするリソースです。
# ライフサイクルポリシーは、Image Builderで作成したAMIやコンテナイメージの
# 自動廃止・削除ルールを定義し、古くなったリソースを定期的にクリーンアップします。
# フィルター条件（年齢・数量）や除外ルール（タグ・共有状態）を組み合わせて
# 柔軟なライフサイクル管理を実現します。
#
# AWS公式ドキュメント:
#   - Image Builder ライフサイクルポリシー: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-lifecycle.html
#   - ライフサイクルポリシーの管理: https://docs.aws.amazon.com/imagebuilder/latest/userguide/life-cycle-policy-manage.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_lifecycle_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_lifecycle_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ライフサイクルポリシーの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  name = "example-lifecycle-policy"

  # execution_role (Required)
  # 設定内容: ライフサイクルポリシーを実行するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールには、イメージリソースを廃止・削除するための適切な権限が必要です。
  #       Image Builderのライフサイクル管理に必要なポリシーをアタッチしてください。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-lifecycle-prereq.html
  execution_role = "arn:aws:iam::123456789012:role/imagebuilder-lifecycle-role"

  # resource_type (Required)
  # 設定内容: ライフサイクルポリシーの対象リソースタイプを指定します。
  # 設定可能な値:
  #   - "AMI_IMAGE": AMIイメージを対象とします
  #   - "CONTAINER_IMAGE": コンテナイメージを対象とします
  resource_type = "AMI_IMAGE"

  # description (Optional)
  # 設定内容: ライフサイクルポリシーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしでポリシーが作成されます。
  description = "Example lifecycle policy for AMI image management"

  # status (Optional)
  # 設定内容: ライフサイクルポリシーのステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED" (デフォルト): ポリシーが有効で、スケジュールに従って実行されます
  #   - "DISABLED": ポリシーが無効で、自動実行が停止されます
  # 省略時: ENABLED として扱われます。
  status = "ENABLED"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # リソース選択設定
  #-------------------------------------------------------------

  # resource_selection (Required, max_items: 1)
  # 設定内容: ライフサイクルポリシーの対象リソースを選択する条件を定義します。
  # 注意: tag_map と recipe のどちらかを指定する必要があります。
  resource_selection {
    # tag_map (Optional)
    # 設定内容: 対象リソースを選択するためのタグのマップを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: タグによるフィルタリングは行われません。recipe を指定する必要があります。
    # 注意: tag_map と recipe は併用可能です。
    tag_map = {
      Environment = "development"
    }

    # recipe (Optional)
    # 設定内容: 対象リソースを選択するためのレシピ条件を指定します。
    # 省略時: レシピによるフィルタリングは行われません。tag_map を指定する必要があります。
    # 注意: tag_map と recipe は併用可能です。複数のレシピを指定できます。
    recipe {
      # name (Required)
      # 設定内容: 対象とするレシピの名前を指定します。
      # 設定可能な値: 有効なImage Builderレシピ名
      name = "example-image-recipe"

      # semantic_version (Required)
      # 設定内容: 対象とするレシピのセマンティックバージョンを指定します。
      # 設定可能な値: セマンティックバージョン形式（例: "1.0.0", "1.x.x", "x.x.x"）
      # 注意: ワイルドカード（x）を使用して、マイナーバージョンやパッチバージョンを
      #       まとめて対象にすることができます。
      semantic_version = "1.x.x"
    }
  }

  #-------------------------------------------------------------
  # ポリシー詳細設定
  #-------------------------------------------------------------

  # policy_detail (Required)
  # 設定内容: ライフサイクルポリシーの詳細ルールを定義します。複数指定できます。
  # 注意: 各 policy_detail には filter と action が必要です。
  policy_detail {
    #-----------------------------------------------------------------
    # フィルター設定
    #-----------------------------------------------------------------

    # filter (Required, max_items: 1)
    # 設定内容: ライフサイクルアクションをトリガーするためのフィルター条件を定義します。
    # 注意: フィルターに一致したリソースに対して action が実行されます。
    filter {
      # type (Required)
      # 設定内容: フィルタータイプを指定します。
      # 設定可能な値:
      #   - "AGE": リソースの年齢（経過日数）に基づいてフィルタリングします
      #   - "COUNT": リソースの数量に基づいてフィルタリングします
      type = "AGE"

      # value (Required)
      # 設定内容: フィルターの閾値を指定します。
      # 設定可能な値:
      #   - type = "AGE" の場合: unit で指定した単位での経過時間（正の整数）
      #   - type = "COUNT" の場合: 保持するリソースの最大数（正の整数）
      value = 30

      # unit (Optional)
      # 設定内容: type = "AGE" の場合に使用する時間の単位を指定します。
      # 設定可能な値:
      #   - "DAYS": 日数
      #   - "WEEKS": 週数
      #   - "MONTHS": 月数
      #   - "YEARS": 年数
      # 省略時: type = "AGE" の場合は必須です。type = "COUNT" の場合は不要です。
      unit = "DAYS"

      # retain_at_least (Optional)
      # 設定内容: type = "AGE" の場合に、フィルター条件を満たしていても最低限保持する
      #           リソースの数を指定します。
      # 設定可能な値: 正の整数
      # 省略時: 最低保持数の制限なし。フィルター条件に一致したすべてのリソースが対象となります。
      # 注意: type = "COUNT" の場合は使用できません。
      retain_at_least = 5
    }

    #-----------------------------------------------------------------
    # アクション設定
    #-----------------------------------------------------------------

    # action (Required, max_items: 1)
    # 設定内容: フィルター条件に一致したリソースに対して実行するアクションを定義します。
    action {
      # type (Required)
      # 設定内容: 実行するアクションのタイプを指定します。
      # 設定可能な値:
      #   - "DELETE": リソースを削除します
      #   - "DEPRECATE": リソースを非推奨としてマークします（AMI_IMAGE のみ）
      #   - "DISABLE": リソースを無効化します（AMI_IMAGE のみ）
      type = "DEPRECATE"

      # include_resources (Optional, max_items: 1)
      # 設定内容: アクションの対象に含めるリソースタイプを指定します。
      # 省略時: デフォルトのリソースタイプに対してアクションが実行されます。
      # 注意: type = "DELETE" の場合のみ有効です。
      # include_resources {
      #   # amis (Optional)
      #   # 設定内容: AMIをアクション対象に含めるかを指定します。
      #   # 設定可能な値: true / false
      #   # 省略時: サービスのデフォルト値が適用されます。
      #   amis = true
      #
      #   # snapshots (Optional)
      #   # 設定内容: EBSスナップショットをアクション対象に含めるかを指定します。
      #   # 設定可能な値: true / false
      #   # 省略時: サービスのデフォルト値が適用されます。
      #   snapshots = true
      #
      #   # containers (Optional)
      #   # 設定内容: コンテナイメージをアクション対象に含めるかを指定します。
      #   # 設定可能な値: true / false
      #   # 省略時: サービスのデフォルト値が適用されます。
      #   containers = true
      # }
    }

    #-----------------------------------------------------------------
    # 除外ルール設定
    #-----------------------------------------------------------------

    # exclusion_rules (Optional, max_items: 1)
    # 設定内容: ライフサイクルアクションから除外するリソースの条件を定義します。
    # 省略時: 除外ルールなしでアクションが実行されます。
    exclusion_rules {
      # tag_map (Optional)
      # 設定内容: 除外対象を指定するためのタグのマップを指定します。
      # 設定可能な値: キーと値のペアのマップ
      # 省略時: タグによる除外は行われません。
      tag_map = {
        ExcludeFromLifecycle = "true"
      }

      # amis (Optional, max_items: 1)
      # 設定内容: AMIに固有の除外条件を定義します。
      # 省略時: AMI固有の除外条件なし。
      # 注意: resource_type = "AMI_IMAGE" の場合のみ有効です。
      amis {
        # is_public (Optional)
        # 設定内容: パブリック共有されているAMIをアクションから除外するかを指定します。
        # 設定可能な値:
        #   - true: パブリック共有AMIをアクション対象から除外します
        #   - false: パブリック共有AMIをアクション対象に含めます
        # 省略時: サービスのデフォルト値が適用されます。
        is_public = true

        # regions (Optional)
        # 設定内容: 除外対象のリージョンのリストを指定します。
        # 設定可能な値: AWSリージョンコードのリスト（例: ["us-east-1", "ap-northeast-1"]）
        # 省略時: リージョンによる除外は行われません。
        regions = ["us-east-1"]

        # shared_accounts (Optional)
        # 設定内容: 除外対象となる共有先のAWSアカウントIDのリストを指定します。
        # 設定可能な値: AWSアカウントIDのリスト（例: ["123456789012", "987654321098"]）
        # 省略時: 共有アカウントによる除外は行われません。
        shared_accounts = ["123456789012"]

        # tag_map (Optional)
        # 設定内容: AMI固有の除外タグマップを指定します。
        # 設定可能な値: キーと値のペアのマップ
        # 省略時: AMI固有のタグによる除外は行われません。
        tag_map = {
          Production = "true"
        }

        # last_launched (Optional, max_items: 1)
        # 設定内容: 最後に起動してからの経過時間に基づいてAMIを除外する条件を定義します。
        # 省略時: 最終起動時間による除外は行われません。
        # 関連機能: 最終起動時間による除外
        #   最近起動されたAMIを誤って削除・非推奨化しないよう保護します。
        last_launched {
          # unit (Required)
          # 設定内容: 最終起動からの経過時間の単位を指定します。
          # 設定可能な値:
          #   - "DAYS": 日数
          #   - "WEEKS": 週数
          #   - "MONTHS": 月数
          #   - "YEARS": 年数
          unit = "DAYS"

          # value (Required)
          # 設定内容: 最終起動からの経過時間の閾値を指定します。
          # 設定可能な値: 正の整数
          # 注意: この値より最近に起動されたAMIはアクションから除外されます。
          value = 7
        }
      }
    }
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
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-lifecycle-policy"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ライフサイクルポリシーのAmazon Resource Name (ARN)
#
# - arn: ライフサイクルポリシーのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
