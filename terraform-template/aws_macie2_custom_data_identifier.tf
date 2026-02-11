#---------------------------------------------------------------
# AWS Macie2 Custom Data Identifier
#---------------------------------------------------------------
#
# Amazon Macieのカスタムデータ識別子をプロビジョニングするリソースです。
# カスタムデータ識別子は、Amazon S3オブジェクト内の機密データを検出するために
# 定義する一連の基準です。正規表現パターン、キーワード、無視ワードを組み合わせて、
# 組織固有の機密データ（従業員ID、社内コード、固有の知的財産など）を検出できます。
#
# 重要な注意事項:
#   - カスタムデータ識別子は作成後に変更できません（不変性により監査履歴を保証）
#   - 作成前にテストすることを強く推奨します（TestCustomDataIdentifier APIを使用）
#   - デフォルトでは全ての検出結果に「Medium」重大度が割り当てられます
#
# AWS公式ドキュメント:
#   - カスタムデータ識別子の作成: https://docs.aws.amazon.com/macie/latest/user/cdis-create.html
#   - カスタムデータ識別子の概要: https://docs.aws.amazon.com/macie/latest/user/custom-data-identifiers.html
#   - CreateCustomDataIdentifier API: https://docs.aws.amazon.com/macie/latest/APIReference/custom-data-identifiers.html
#   - 設定オプション: https://docs.aws.amazon.com/macie/latest/user/cdis-options.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_custom_data_identifier
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_macie2_custom_data_identifier" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Computed)
  # 設定内容: カスタムデータ識別子の名前を指定します。
  # 設定可能な値: 最大128文字の文字列
  # 省略時: Terraformが自動生成した名前が付与されます
  # 注意事項: 名前には機密データを含めないでください。アカウント内の他のユーザーが
  #           実行できるアクションに応じて、名前にアクセスできる可能性があります
  # 参考: https://docs.aws.amazon.com/macie/latest/user/cdis-create.html
  name = "employee-id-identifier"

  # name_prefix (Optional, Computed)
  # 設定内容: カスタムデータ識別子の名前プレフィックスを指定します。
  # 設定可能な値: 文字列（Terraformが一意の名前を生成する際のプレフィックス）
  # 省略時: プレフィックスなしで名前が生成されます
  # 用途: 複数の類似したカスタムデータ識別子を作成する際に、
  #       一貫した命名規則を適用したい場合に使用します
  # 競合: nameとname_prefixは同時に指定できません
  name_prefix = null

  # description (Optional)
  # 設定内容: カスタムデータ識別子の説明を指定します。
  # 設定可能な値: 最大512文字の文字列
  # 省略時: 説明なしで作成されます
  # 推奨事項: このカスタムデータ識別子が検出する機密データの種類と目的を明確に記述します
  # 注意事項: 説明には機密データを含めないでください
  # 参考: https://docs.aws.amazon.com/macie/latest/user/cdis-create.html
  description = "Detects employee IDs with format: F-12345678 or P-87654321"

  #-------------------------------------------------------------
  # 検出基準設定
  #-------------------------------------------------------------

  # regex (Optional)
  # 設定内容: 検出するテキストパターンを定義する正規表現を指定します。
  # 設定可能な値: 最大512文字の正規表現文字列
  # サポート範囲: PCRE（Perl Compatible Regular Expressions）ライブラリの
  #              パターン構文のサブセットをサポート
  # サポート外: バックリファレンス、キャプチャグループ、条件付きパターン、
  #            埋め込みコード、グローバルパターンフラグ、再帰パターン、
  #            肯定/否定の先読み/後読みアサーション
  # 例: 従業員ID検出用の正規表現
  #     - "[A-Z]-\\d{8}" : 大文字1文字-ハイフン-8桁の数字
  #     - "\\b[A-Z]{2}\\d{6}\\b" : 大文字2文字+6桁の数字
  # 注意事項: 作成前にTestCustomDataIdentifier APIでテストすることを強く推奨します
  # 参考: https://docs.aws.amazon.com/macie/latest/user/cdis-options.html#cdis-detection-criteria
  regex = "[A-Z]-\\d{8}"

  # keywords (Optional)
  # 設定内容: 正規表現にマッチしたテキストの近接位置に存在する必要がある
  #          文字列（キーワード）のリストを指定します。
  # 設定可能な値: 最大50個のキーワード（各3〜90文字のUTF-8文字列）
  # 省略時: キーワード条件なしで検出が行われます
  # 動作: テキストが正規表現にマッチし、かつキーワードのいずれかがmaximum_match_distance内に
  #       存在する場合のみ結果に含まれます
  # 大文字小文字: キーワードは大文字小文字を区別しません（case insensitive）
  # 用途: 誤検出（false positive）を減らし、検出精度を向上させます
  # 例: ["employee", "employee ID", "staff number", "社員番号"]
  # 参考: https://docs.aws.amazon.com/macie/latest/user/cdis-create.html
  keywords = [
    "employee",
    "employee ID",
    "staff",
  ]

  # ignore_words (Optional)
  # 設定内容: 検出結果から除外する文字列（無視ワード）のリストを指定します。
  # 設定可能な値: 最大10個の無視ワード（各4〜90文字のUTF-8文字列）
  # 省略時: 無視ワード条件なしで検出が行われます
  # 動作: テキストが正規表現にマッチしても、無視ワードのいずれかが含まれる場合は
  #       結果から除外されます
  # 大文字小文字: 無視ワードは大文字小文字を区別します（case sensitive）
  # 用途: 特定の既知の誤検出パターンや例示用のデータを除外します
  # 例: ["example", "sample", "test", "dummy"]
  # 注意: キーワードとは異なり、大文字小文字を厳密に区別することに注意してください
  # 参考: https://docs.aws.amazon.com/macie/latest/user/cdis-create.html
  ignore_words = [
    "example",
    "sample",
  ]

  # maximum_match_distance (Optional, Computed)
  # 設定内容: キーワードの末尾と正規表現にマッチしたテキストの末尾との間に
  #          存在できる最大文字数を指定します。
  # 設定可能な値: 1〜300文字
  # 省略時: デフォルトで50文字が適用されます
  # 動作: テキストが正規表現にマッチし、かつキーワードがこの距離内に存在する場合のみ
  #       結果に含まれます
  # 用途: キーワードとマッチテキストの近接性を制御し、検出精度を調整します
  # 例: maximum_match_distance = 20 の場合、
  #     "employee ID: F-12345678" は検出されます（距離が20文字未満）
  #     "employee ... （50文字以上の間隔） ... F-12345678" は検出されません
  # 推奨: データの構造と形式に基づいて適切な値をテストして決定してください
  # 参考: https://docs.aws.amazon.com/macie/latest/user/cdis-create.html
  maximum_match_distance = 50

  #-------------------------------------------------------------
  # タグ設定 (Optional)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: カスタムデータ識別子に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグ）
  # 省略時: タグなしで作成されます
  # 用途: リソースの識別、分類、管理を目的、所有者、環境などの基準で行います
  # 推奨事項: 組織のタグ付け戦略に従って、適切なタグを設定してください
  # 参考: https://docs.aws.amazon.com/macie/latest/user/tagging-resources.html
  tags = {
    Environment = "Production"
    DataType    = "EmployeeID"
    Compliance  = "Internal"
  }

  #-------------------------------------------------------------
  # リージョン設定 (Optional, Computed)
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # 用途: マルチリージョン環境で、特定のリージョンにカスタムデータ識別子を
  #       作成する必要がある場合に使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 注意: カスタムデータ識別子の作成には、正規表現の検証とテストが含まれるため、
    #       複雑な正規表現の場合は時間がかかる可能性があります
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: カスタムデータ識別子の一意な識別子
#       形式: カスタムデータ識別子ID（例: abc12345-1234-5678-90ab-cdef12345678）
#
# - arn: カスタムデータ識別子のAmazon Resource Name (ARN)
#       形式: arn:aws:macie2:region:account-id:custom-data-identifier/identifier-id
#       用途: IAMポリシーや他のAWSサービスでの参照に使用
#
# - created_at: カスタムデータ識別子が作成された日時
#       形式: RFC3339形式のタイムスタンプ（例: 2024-01-15T10:30:45Z）
#
# - tags_all: リソースに割り当てられているすべてのタグ（プロバイダーの
#            default_tagsで設定されたタグを含む）
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のカスタムデータ識別子をTerraformの管理下にインポートできます:
#
# $ terraform import aws_macie2_custom_data_identifier.example abc12345-1234-5678-90ab-cdef12345678
#---------------------------------------------------------------
# 1. 従業員ID検出の例:
#    正規表現: [A-Z]-\d{8}
#    キーワード: ["employee", "employee ID", "staff"]
#    用途: "F-12345678" や "P-87654321" 形式の従業員IDを検出
#
# 2. カスタム商品コード検出の例:
#    正規表現: PROD-[A-Z]{2}-\d{6}
#    キーワード: ["product", "item", "SKU"]
#    用途: "PROD-AB-123456" 形式の商品コードを検出
#
# 3. 社内機密文書番号検出の例:
#    正規表現: CONF-\d{4}-[A-Z]{3}
#    キーワード: ["confidential", "classified", "restricted"]
#    無視ワード: ["example", "template", "sample"]
#    用途: "CONF-2024-ABC" 形式の機密文書番号を検出（サンプルを除外）
#
