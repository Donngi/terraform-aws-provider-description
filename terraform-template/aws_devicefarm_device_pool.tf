#-------
# AWS Device Farm Device Pool
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-14
#
# 用途: AWS Device Farmでテスト実行時に使用するデバイスのセットを定義
# 概要: プロジェクト内でモバイルアプリのテストを実行する際に、対象とする
#       デバイスをルールベースで選択するためのデバイスプール
# 主な機能:
#   - ルールベースでのデバイス選択（OS、メーカー、モデル等）
#   - 動的デバイスプール（ルール条件に合致するデバイスを自動選択）
#   - 静的デバイスプール（特定のARNで指定）
#   - 最大デバイス数の制限設定
# 関連リソース:
#   - aws_devicefarm_project: デバイスプールが所属するプロジェクト
#   - aws_devicefarm_test_grid_project: テストグリッドプロジェクト
#   - aws_devicefarm_upload: テスト用アップロードファイル
# 公式ドキュメント:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_device_pool
#   - https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateDevicePool.html
#   - https://docs.aws.amazon.com/devicefarm/latest/developerguide/how-to-create-device-pool.html
#
# NOTE: Device FarmはAWSの米国西部（オレゴン）リージョン（us-west-2）でのみ利用可能です。
#       他のリージョンでは使用できないため、プロバイダー設定で明示的にus-west-2を指定する必要があります。
#-------

#-------
# 基本設定
#-------
resource "aws_devicefarm_device_pool" "example" {
  # デバイスプール名
  # 設定内容: プロジェクト内で一意となるデバイスプールの識別名
  # 制約事項: プロジェクト内で一意である必要がある
  # 例: "Android-High-End-Devices", "iOS-Latest-Models", "Cross-Platform-Pool"
  name = "example-device-pool"

  # プロジェクトARN
  # 設定内容: デバイスプールを作成するDevice FarmプロジェクトのARN
  # 形式: arn:aws:devicefarm:us-west-2:123456789012:project:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  # 注意事項: Device Farmはus-west-2リージョンのみで利用可能
  project_arn = aws_devicefarm_project.example.arn

  #-------
  # デバイス選択ルール
  #-------
  # ルール1: プラットフォーム指定
  # 設定内容: デバイスをOSプラットフォームで絞り込み
  rule {
    # デバイス属性
    # 設定可能な値:
    #   - APPIUM_VERSION: Appiumのバージョン
    #   - ARN: デバイスのARN（静的プール用）
    #   - AVAILABILITY: デバイスの可用性ステータス
    #   - FLEET_TYPE: フリートタイプ（PRIVATE/PUBLIC）
    #   - FORM_FACTOR: フォームファクター（PHONE/TABLET）
    #   - INSTANCE_ARN: インスタンスARN
    #   - INSTANCE_LABELS: インスタンスラベル
    #   - MANUFACTURER: 製造元（Samsung、Apple等）
    #   - MODEL: デバイスモデル名
    #   - OS_VERSION: OSバージョン
    #   - PLATFORM: プラットフォーム（ANDROID/IOS）
    #   - REMOTE_ACCESS_ENABLED: リモートアクセス有効化状態
    #   - REMOTE_DEBUG_ENABLED: リモートデバッグ有効化状態（非推奨）
    attribute = "PLATFORM"

    # 比較演算子
    # 設定可能な値:
    #   - EQUALS: 完全一致
    #   - NOT_IN: リストに含まれない
    #   - IN: リストに含まれる
    #   - GREATER_THAN: より大きい（数値・バージョン比較）
    #   - GREATER_THAN_OR_EQUALS: 以上（数値・バージョン比較）
    #   - LESS_THAN: より小さい（数値・バージョン比較）
    #   - LESS_THAN_OR_EQUALS: 以下（数値・バージョン比較）
    #   - CONTAINS: 部分一致
    # 注意事項: 属性によって使用可能な演算子が異なる
    operator = "EQUALS"

    # 比較値
    # 設定内容: 属性との比較に使用する値（JSON文字列形式）
    # 形式: ダブルクォートでエスケープされた文字列（例: "\"ANDROID\""）
    # PLATFORM値: "ANDROID" または "IOS"
    value = "\"ANDROID\""
  }

  # ルール2: 可用性指定
  # 設定内容: 利用可能なデバイスのみを選択
  rule {
    attribute = "AVAILABILITY"
    operator  = "EQUALS"

    # AVAILABILITY値:
    #   - AVAILABLE: 利用可能
    #   - HIGHLY_AVAILABLE: 高可用性
    #   - BUSY: 使用中
    #   - TEMPORARY_NOT_AVAILABLE: 一時的に利用不可
    value = "\"AVAILABLE\""
  }

  # ルール3: フォームファクター指定（例）
  # rule {
  #   attribute = "FORM_FACTOR"
  #   operator  = "IN"
  #   # IN演算子の場合は配列形式で複数値指定可能
  #   # 値: "PHONE" または "TABLET"
  #   value = "[\"PHONE\"]"
  # }

  # ルール4: OSバージョン範囲指定（例）
  # rule {
  #   attribute = "OS_VERSION"
  #   operator  = "GREATER_THAN_OR_EQUALS"
  #   # Androidバージョン例: "10.0", "11.0", "12.0"
  #   # iOSバージョン例: "14.0", "15.0", "16.0"
  #   value = "\"10.0\""
  # }

  # ルール5: 製造元指定（例）
  # rule {
  #   attribute = "MANUFACTURER"
  #   operator  = "IN"
  #   # Android: Samsung, Google, Huawei, LG, Motorola等
  #   # iOS: Apple
  #   value = "[\"Samsung\", \"Google\"]"
  # }

  #-------
  # オプション設定
  #-------
  # デバイスプールの説明
  # 設定内容: デバイスプールの目的や用途を説明するテキスト
  # 省略時: 説明なし
  # 推奨事項: ルール条件の概要や使用目的を明記
  description = "Android devices with high availability for automated testing"

  # 最大デバイス数
  # 設定内容: デバイスプールに含めるデバイスの最大数
  # 省略時: ルールに合致する全デバイスが選択される
  # 重要事項: 並列実行数や予算に応じて設定を推奨（課金対象となるため）
  # 例: 並列実行数5の場合は5を設定
  max_devices = 10

  #-------
  # リージョン設定
  #-------
  # リソース管理リージョン
  # 設定内容: Device Farmリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 制約事項: Device Farmはus-west-2リージョンのみで利用可能
  region = "us-west-2"

  #-------
  # タグ設定
  #-------
  # リソースタグ
  # 設定内容: デバイスプールに付与する任意のKey-Valueペア
  # 用途: コスト配分、リソース管理、アクセス制御等
  # 省略時: タグなし（プロバイダーのdefault_tagsは継承される）
  tags = {
    Name        = "example-device-pool"
    Environment = "development"
    ManagedBy   = "terraform"
    Platform    = "Android"
  }
}

#-------
# Attributes Reference (参照可能な属性)
#-------
# 以下の属性は、リソース作成後に参照可能な読み取り専用の値です。
# 参照方法: aws_devicefarm_device_pool.example.属性名
#
# - arn (string)
#     デバイスプールのARN（Amazon Resource Name）
#     形式: arn:aws:devicefarm:us-west-2:123456789012:devicepool:project-id/pool-id
#     用途: IAMポリシー、他リソースからの参照等
#
# - id (string)
#     デバイスプールのID（ARNと同じ値）
#     用途: Terraformの内部識別子、データソース参照等
#
# - type (string)
#     デバイスプールのタイプ
#     値: "CURATED"（管理対象）または "PRIVATE"（プライベート）
#     自動設定: AWS側で自動判定
#
# - tags_all (map of string)
#     リソースに割り当てられた全タグのマップ
#     内容: 明示的に設定したタグ + プロバイダーのdefault_tags
#     用途: タグの完全なリスト取得
#-------
