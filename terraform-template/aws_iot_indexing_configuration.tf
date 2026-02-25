#---------------------------------------------------------------
# AWS IoT Indexing Configuration
#---------------------------------------------------------------
#
# AWS IoT Coreのフリートインデックス設定を管理するリソースです。
# モノ（Thing）とモノグループ（Thing Group）のインデックスを有効化し、
# IoT Coreのフリートインデックス機能でデバイスの検索や集計クエリを
# 実行できるようにします。
#
# AWS公式ドキュメント:
#   - フリートインデックス: https://docs.aws.amazon.com/iot/latest/developerguide/iot-indexing.html
#   - UpdateIndexingConfiguration API: https://docs.aws.amazon.com/iot/latest/apireference/API_UpdateIndexingConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_indexing_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_indexing_configuration" "example" {

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
  # モノグループインデックス設定
  #-------------------------------------------------------------

  # thing_group_indexing_configuration (Optional)
  # 設定内容: モノグループ（Thing Group）のインデックス設定を指定します。
  # 設定可能な値: 最大1ブロック
  # 省略時: モノグループインデックスが無効
  thing_group_indexing_configuration {

    # thing_group_indexing_mode (Required)
    # 設定内容: モノグループインデックスのモードを指定します。
    # 設定可能な値:
    #   - "OFF": インデックスを無効にします
    #   - "ON": インデックスを有効にします
    thing_group_indexing_mode = "ON"

    # custom_field (Optional)
    # 設定内容: インデックスに含めるカスタムフィールドを指定します。
    # 設定可能な値: 複数のcustom_fieldブロックを設定可能
    # 省略時: カスタムフィールドなし
    custom_field {
      # name (Optional)
      # 設定内容: カスタムフィールドの名前を指定します。
      # 設定可能な値: 有効なフィールド名（例: "thingGroupDescription"）
      # 省略時: フィールド名なし
      name = "thingGroupDescription"

      # type (Optional)
      # 設定内容: カスタムフィールドのデータ型を指定します。
      # 設定可能な値:
      #   - "Number": 数値型
      #   - "String": 文字列型
      #   - "Boolean": ブール型
      # 省略時: 型指定なし
      type = "String"
    }

    # managed_field (Optional)
    # 設定内容: インデックスに含めるマネージドフィールドを指定します。
    # 設定可能な値: 複数のmanaged_fieldブロックを設定可能
    # 省略時: マネージドフィールドなし
    managed_field {
      # name (Optional)
      # 設定内容: マネージドフィールドの名前を指定します。
      # 設定可能な値: AWSが定義する有効なマネージドフィールド名
      # 省略時: フィールド名なし
      name = "aws.thingGroupId"

      # type (Optional)
      # 設定内容: マネージドフィールドのデータ型を指定します。
      # 設定可能な値:
      #   - "Number": 数値型
      #   - "String": 文字列型
      #   - "Boolean": ブール型
      # 省略時: 型指定なし
      type = "String"
    }
  }

  #-------------------------------------------------------------
  # モノインデックス設定
  #-------------------------------------------------------------

  # thing_indexing_configuration (Optional)
  # 設定内容: モノ（Thing）のインデックス設定を指定します。
  # 設定可能な値: 最大1ブロック
  # 省略時: モノインデックスが無効
  thing_indexing_configuration {

    # thing_indexing_mode (Required)
    # 設定内容: モノインデックスのモードを指定します。
    # 設定可能な値:
    #   - "OFF": インデックスを無効にします
    #   - "REGISTRY": レジストリデータのみインデックスします
    #   - "REGISTRY_AND_SHADOW": レジストリとデバイスシャドウをインデックスします
    thing_indexing_mode = "REGISTRY_AND_SHADOW"

    # device_defender_indexing_mode (Optional)
    # 設定内容: AWS IoT Device DefenderのインデックスモードDefault値を指定します。
    # 設定可能な値:
    #   - "OFF": Device Defenderデータをインデックスしません
    #   - "VIOLATIONS": Device Defenderのバイオレーションデータをインデックスします
    # 省略時: "OFF"
    device_defender_indexing_mode = "OFF"

    # named_shadow_indexing_mode (Optional)
    # 設定内容: 名前付きシャドウのインデックスモードを指定します。
    # 設定可能な値:
    #   - "OFF": 名前付きシャドウをインデックスしません
    #   - "ON": 名前付きシャドウをインデックスします
    # 省略時: "OFF"
    named_shadow_indexing_mode = "OFF"

    # thing_connectivity_indexing_mode (Optional)
    # 設定内容: モノの接続性情報のインデックスモードを指定します。
    # 設定可能な値:
    #   - "OFF": 接続性情報をインデックスしません
    #   - "STATUS": 接続ステータスをインデックスします
    # 省略時: "OFF"
    thing_connectivity_indexing_mode = "STATUS"

    # custom_field (Optional)
    # 設定内容: インデックスに含めるカスタムフィールドを指定します。
    # 設定可能な値: 複数のcustom_fieldブロックを設定可能
    # 省略時: カスタムフィールドなし
    custom_field {
      # name (Optional)
      # 設定内容: カスタムフィールドの名前を指定します。
      # 設定可能な値: 有効なフィールド名（例: "shadow.name.myNamedShadow.temperature"）
      # 省略時: フィールド名なし
      name = "shadow.name.myNamedShadow.temperature"

      # type (Optional)
      # 設定内容: カスタムフィールドのデータ型を指定します。
      # 設定可能な値:
      #   - "Number": 数値型
      #   - "String": 文字列型
      #   - "Boolean": ブール型
      # 省略時: 型指定なし
      type = "Number"
    }

    # filter (Optional)
    # 設定内容: 名前付きシャドウのフィルター設定を指定します。
    # 設定可能な値: 最大1ブロック
    # 省略時: フィルターなし
    filter {
      # named_shadow_names (Optional)
      # 設定内容: インデックス対象とする名前付きシャドウ名のセットを指定します。
      # 設定可能な値: 名前付きシャドウ名の文字列セット
      # 省略時: 全ての名前付きシャドウをインデックス
      named_shadow_names = ["myNamedShadow"]
    }

    # managed_field (Optional)
    # 設定内容: インデックスに含めるマネージドフィールドを指定します。
    # 設定可能な値: 複数のmanaged_fieldブロックを設定可能
    # 省略時: マネージドフィールドなし
    managed_field {
      # name (Optional)
      # 設定内容: マネージドフィールドの名前を指定します。
      # 設定可能な値: AWSが定義する有効なマネージドフィールド名
      # 省略時: フィールド名なし
      name = "aws.thingName"

      # type (Optional)
      # 設定内容: マネージドフィールドのデータ型を指定します。
      # 設定可能な値:
      #   - "Number": 数値型
      #   - "String": 文字列型
      #   - "Boolean": ブール型
      # 省略時: 型指定なし
      type = "String"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意識別子
#
#---------------------------------------------------------------
