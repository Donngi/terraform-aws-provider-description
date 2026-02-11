#---------------------------------------------------------------
# AWS CloudWatch Logs Transformer
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsのトランスフォーマーをプロビジョニングするリソースです。
# ログトランスフォーマーは、ログ取り込み時にログイベントを変換・正規化し、
# 一貫性のある構造化されたJSON形式に変換します。
# 複数のAWSサービスからの異なる形式のログを標準化し、検索やアラート作成を簡素化します。
#
# AWS公式ドキュメント:
#   - CloudWatch Logs Transformation: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatch-Logs-Transformation.html
#   - Create and manage log transformers: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatch-Logs-Transformation-Create.html
#   - PutTransformer API: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutTransformer.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_transformer
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_transformer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # log_group_arn (Required)
  # 設定内容: トランスフォーマーを設定するロググループのARNを指定します。
  # 設定可能な値: 有効なCloudWatch LogsロググループのフルARN
  # 注意: トランスフォーマーはStandardログクラスのロググループに対してのみ作成可能です。
  log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/lambda/my-function"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # トランスフォーマー設定
  #-------------------------------------------------------------

  # transformer_config (Required)
  # 設定内容: トランスフォーマーの設定を指定します。
  # 少なくとも1つ、最大20個までのプロセッサを含める必要があります。
  # プロセッサは指定された順序でログイベントに適用されます。
  # 注意: 最初のプロセッサはパーサー（parse_*系）である必要があります。
  transformer_config {

    #-----------------------------------------------------------
    # パーサープロセッサ
    # ログイベントを解析して構造化します。
    #-----------------------------------------------------------

    # add_keys (Optional)
    # 設定内容: ログイベントに新しいキーと値のペアを追加します。
    # メタデータ（accountId、regionなど）の追加に使用します。
    # 最小1個、最大5個のエントリを含める必要があります。
    add_keys {
      entry {
        # key (Required)
        # 設定内容: ログイベントに追加する新しいエントリのキーを指定します。
        key = "accountId"

        # value (Required)
        # 設定内容: ログイベントに追加する新しいエントリの値を指定します。
        value = "123456789012"

        # overwrite_if_exists (Optional)
        # 設定内容: キーが既にログイベントに存在する場合に値を上書きするかを指定します。
        # 設定可能な値:
        #   - true: 既存の値を上書き
        #   - false (デフォルト): 既存の値を保持
        overwrite_if_exists = false
      }
    }

    # copy_value (Optional)
    # 設定内容: ログイベント内で値をコピーします。
    # 最小1個、最大5個のエントリを含める必要があります。
    copy_value {
      entry {
        # source (Required)
        # 設定内容: コピー元のキーを指定します。
        source = "original_field"

        # target (Required)
        # 設定内容: コピー先のキーを指定します。
        target = "copied_field"

        # overwrite_if_exists (Optional)
        # 設定内容: コピー先のキーが既に存在する場合に値を上書きするかを指定します。
        # 設定可能な値:
        #   - true: 既存の値を上書き
        #   - false (デフォルト): 既存の値を保持
        overwrite_if_exists = false
      }
    }

    # csv (Optional)
    # 設定内容: ログイベントからCSV（カンマ区切り値）を解析してカラムに変換します。
    # 構造化されていないCSV形式のログを構造化されたJSON形式に変換します。
    csv {
      # source (Optional)
      # 設定内容: 解析対象のCSV値を持つログイベント内のフィールドのパスを指定します。
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"

      # delimiter (Optional)
      # 設定内容: CSVログイベントで各カラムを区切る文字を指定します。
      # 設定可能な値: 任意の1文字
      # 省略時: カンマ (,) が使用されます。
      delimiter = ","

      # quote_character (Optional)
      # 設定内容: データの1カラムのテキスト修飾子として使用される文字を指定します。
      # 設定可能な値: 任意の1文字
      # 省略時: 二重引用符 (") が使用されます。
      quote_character = "\""

      # columns (Optional)
      # 設定内容: 変換後のログイベントでカラムに使用する名前を指定します。
      # 設定可能な値: 文字列のリスト
      # 省略時: デフォルトのカラム名 [column_1, column_2, ...] が使用されます。
      columns = ["timestamp", "level", "message"]
    }

    # date_time_converter (Optional)
    # 設定内容: 日時文字列を指定した形式に変換します。
    # 異なるタイムゾーンやフォーマットの日時データを標準化します。
    date_time_converter {
      # source (Required)
      # 設定内容: 日時変換を適用するキーを指定します。
      source = "timestamp"

      # target (Required)
      # 設定内容: 変換結果を格納するJSONフィールドを指定します。
      target = "converted_timestamp"

      # match_patterns (Required)
      # 設定内容: sourceフィールドと照合するパターンのリストを指定します。
      # 設定可能な値: 日時パターンの文字列リスト（Javaの日時パターン形式）
      match_patterns = ["yyyy-MM-dd'T'HH:mm:ss.SSSZ"]

      # source_timezone (Optional)
      # 設定内容: ソースフィールドのタイムゾーンを指定します。
      # 設定可能な値: 有効なタイムゾーン識別子（例: UTC, Asia/Tokyo, America/New_York）
      # 省略時: UTC が使用されます。
      source_timezone = "UTC"

      # target_format (Optional)
      # 設定内容: ターゲットフィールドの変換後のデータに使用する日時形式を指定します。
      # 設定可能な値: Javaの日時パターン形式
      # 省略時: yyyy-MM-dd'T'HH:mm:ss.SSS'Z が使用されます。
      target_format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"

      # target_timezone (Optional)
      # 設定内容: ターゲットフィールドのタイムゾーンを指定します。
      # 設定可能な値: 有効なタイムゾーン識別子
      # 省略時: UTC が使用されます。
      target_timezone = "Asia/Tokyo"

      # locale (Optional)
      # 設定内容: ソースフィールドのロケールを指定します。
      # 設定可能な値: Javaロケール識別子（例: en_US, ja_JP）
      # 省略時: locale.ROOT が使用されます。
      locale = "en_US"
    }

    # delete_keys (Optional)
    # 設定内容: ログイベントからエントリを削除します。
    # 不要なフィールドやセンシティブなデータを除外する際に使用します。
    delete_keys {
      # with_keys (Required)
      # 設定内容: 削除するキーを指定します。
      # 設定可能な値: 文字列のリスト
      with_keys = ["sensitive_field", "unnecessary_data"]
    }

    # grok (Optional)
    # 設定内容: パターンマッチングを使用して非構造化データを解析・構造化します。
    # 正規表現ベースのパターンで複雑なログ形式を解析します。
    grok {
      # match (Required)
      # 設定内容: ログイベントと照合するgrokパターンを指定します。
      # 設定可能な値: grokパターン構文に従った文字列
      match = "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}"

      # source (Optional)
      # 設定内容: 解析対象の値を持つログイベント内のフィールドのパスを指定します。
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"
    }

    # list_to_map (Optional)
    # 設定内容: キーフィールドを含むオブジェクトのリストをターゲットキーのマップに変換します。
    # リスト形式のデータを検索しやすいマップ構造に変換します。
    list_to_map {
      # source (Required)
      # 設定内容: マップに変換されるオブジェクトのリストを持つログイベント内のキーを指定します。
      source = "items"

      # key (Required)
      # 設定内容: 生成されたマップのキーとして抽出されるフィールドのキーを指定します。
      key = "id"

      # target (Optional)
      # 設定内容: 生成されたマップを保持するフィールドのキーを指定します。
      # 省略時: sourceフィールドが置き換えられます。
      target = "items_map"

      # value_key (Optional)
      # 設定内容: ソースオブジェクトから抽出して生成されたマップの値に入れる値を指定します。
      # 省略時: ソースリストの元のオブジェクトが生成されたマップの値に入れられます。
      value_key = "value"

      # flatten (Optional)
      # 設定内容: リストを単一項目にフラット化するかを指定します。
      # 設定可能な値:
      #   - true: リストをフラット化
      #   - false (デフォルト): フラット化しない
      # 注意: trueの場合、flattened_elementの指定が必須です。
      flatten = false

      # flattened_element (Optional)
      # 設定内容: flattenがtrueの場合、保持する要素を指定します。
      # 設定可能な値:
      #   - "first": 最初の要素を保持
      #   - "last": 最後の要素を保持
      # 注意: flattenがtrueの場合のみ必須です。
      flattened_element = null
    }

    # lower_case_string (Optional)
    # 設定内容: 文字列を小文字に変換します。
    # データの正規化やケース非依存の検索に使用します。
    lower_case_string {
      # with_keys (Required)
      # 設定内容: 小文字に変換するフィールドのキーを指定します。
      # 設定可能な値: 文字列のリスト
      with_keys = ["user_name", "hostname"]
    }

    # move_keys (Optional)
    # 設定内容: あるフィールドから別のフィールドにキーを移動します。
    # 最小1個、最大5個のエントリを含める必要があります。
    move_keys {
      entry {
        # source (Required)
        # 設定内容: 移動元のキーを指定します。
        source = "old_field"

        # target (Required)
        # 設定内容: 移動先のキーを指定します。
        target = "new_field"

        # overwrite_if_exists (Optional)
        # 設定内容: 移動先のキーが既に存在する場合に値を上書きするかを指定します。
        # 設定可能な値:
        #   - true: 既存の値を上書き
        #   - false (デフォルト): 既存の値を保持
        overwrite_if_exists = false
      }
    }

    # parse_cloudfront (Optional)
    # 設定内容: CloudFront配信ログを解析し、フィールドを抽出してJSON形式に変換します。
    # CloudFrontの標準ログフォーマットを構造化されたJSONに変換します。
    parse_cloudfront {
      # source (Optional)
      # 設定内容: 解析するソースフィールドを指定します。
      # 設定可能な値: "@message" のみ
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"
    }

    # parse_json (Optional)
    # 設定内容: JSON形式のログイベントを解析します。
    # JSON文字列を構造化されたオブジェクトに変換します。
    parse_json {
      # source (Optional)
      # 設定内容: 解析するログイベント内のフィールドのパスを指定します。
      # 設定可能な値: ログイベント内の有効なフィールドパス
      # 省略時: @message が使用されます。
      source = "@message"

      # destination (Optional)
      # 設定内容: 解析されたキーと値のペアを配置する場所を指定します。
      # 省略時: ルートノードの下に配置されます。
      destination = null
    }

    # parse_key_value (Optional)
    # 設定内容: 指定されたフィールドをキーと値のペアに解析します。
    # キー=値形式のログをJSON形式に変換します。
    parse_key_value {
      # source (Optional)
      # 設定内容: 解析するログイベント内のフィールドのパスを指定します。
      # 設定可能な値: ログイベント内の有効なフィールドパス
      # 省略時: @message が使用されます。
      source = "@message"

      # destination (Optional)
      # 設定内容: 抽出されたキーと値のペアを配置する宛先フィールドを指定します。
      # 省略時: ルートノードの下に配置されます。
      destination = null

      # field_delimiter (Optional)
      # 設定内容: 元のログイベント内でキーと値のペア間で使用されるフィールド区切り文字列を指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: アンパサンド (&) が使用されます。
      field_delimiter = "&"

      # key_value_delimiter (Optional)
      # 設定内容: 変換されたログイベント内で各ペアのキーと値の間で使用される区切り文字列を指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: 等号 (=) が使用されます。
      key_value_delimiter = "="

      # key_prefix (Optional)
      # 設定内容: すべての変換されたキーに追加されるプレフィックスを指定します。
      # 設定可能な値: 任意の文字列
      key_prefix = null

      # non_match_value (Optional)
      # 設定内容: キーと値のペアが正常に分割されない場合に結果の値フィールドに挿入する値を指定します。
      # 設定可能な値: 任意の文字列
      non_match_value = null

      # overwrite_if_exists (Optional)
      # 設定内容: 宛先キーが既に存在する場合に値を上書きするかを指定します。
      # 設定可能な値:
      #   - true: 既存の値を上書き
      #   - false (デフォルト): 既存の値を保持
      overwrite_if_exists = false
    }

    # parse_postgres (Optional)
    # 設定内容: RDS for PostgreSQL配信ログを解析し、フィールドを抽出してJSON形式に変換します。
    # PostgreSQLの標準ログフォーマットを構造化されたJSONに変換します。
    parse_postgres {
      # source (Optional)
      # 設定内容: 解析するソースフィールドを指定します。
      # 設定可能な値: "@message" のみ
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"
    }

    # parse_route53 (Optional)
    # 設定内容: Route 53配信ログを解析し、フィールドを抽出してJSON形式に変換します。
    # Route 53の標準ログフォーマットを構造化されたJSONに変換します。
    parse_route53 {
      # source (Optional)
      # 設定内容: 解析するソースフィールドを指定します。
      # 設定可能な値: "@message" のみ
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"
    }

    # parse_to_ocsf (Optional)
    # 設定内容: ログイベントを解析してOpen Cybersecurity Schema Framework (OCSF)イベントに変換します。
    # セキュリティログをOCSF標準形式に変換します。
    parse_to_ocsf {
      # event_source (Required)
      # 設定内容: ログイベントを生成するサービスまたはプロセスを指定します。
      # 設定可能な値:
      #   - "CloudTrail": AWS CloudTrailログ
      #   - "Route53Resolver": Route 53 Resolverログ
      #   - "VPCFlow": VPCフローログ
      #   - "EKSAudit": EKS監査ログ
      #   - "AWSWAF": AWS WAFログ
      event_source = "CloudTrail"

      # ocsf_version (Required)
      # 設定内容: 変換されたログイベントに使用するOCSFスキーマのバージョンを指定します。
      # 設定可能な値:
      #   - "V1.1": OCSFバージョン1.1
      ocsf_version = "V1.1"

      # source (Optional)
      # 設定内容: 解析するソースフィールドを指定します。
      # 設定可能な値: "@message" のみ
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"
    }

    # parse_vpc (Optional)
    # 設定内容: Amazon VPC配信ログを解析し、フィールドを抽出してJSON形式に変換します。
    # VPCフローログを構造化されたJSONに変換します。
    parse_vpc {
      # source (Optional)
      # 設定内容: 解析するソースフィールドを指定します。
      # 設定可能な値: "@message" のみ
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"
    }

    # parse_waf (Optional)
    # 設定内容: AWS WAF配信ログを解析し、フィールドを抽出してJSON形式に変換します。
    # WAFログを構造化されたJSONに変換します。
    parse_waf {
      # source (Optional)
      # 設定内容: 解析するソースフィールドを指定します。
      # 設定可能な値: "@message" のみ
      # 省略時: ログメッセージ全体が処理されます。
      source = "@message"
    }

    # rename_keys (Optional)
    # 設定内容: ログイベント内のキーの名前を変更します。
    # フィールド名を標準化するために使用します。
    # 最小1個、最大5個のエントリを含める必要があります。
    rename_keys {
      entry {
        # key (Required)
        # 設定内容: 名前を変更するキーを指定します。
        key = "old_name"

        # rename_to (Required)
        # 設定内容: キーの新しい名前を指定します。
        rename_to = "new_name"

        # overwrite_if_exists (Optional)
        # 設定内容: 宛先キーが既に存在する場合に値を上書きするかを指定します。
        # 設定可能な値:
        #   - true: 既存の値を上書き
        #   - false (デフォルト): 既存の値を保持
        overwrite_if_exists = false
      }
    }

    # split_string (Optional)
    # 設定内容: 区切り文字を使用してフィールドを文字列の配列に分割します。
    # カンマ区切りなどの文字列を配列に変換します。
    # 最小1個、最大10個のエントリを含める必要があります。
    split_string {
      entry {
        # source (Required)
        # 設定内容: 分割するフィールドのキーを指定します。
        source = "tags"

        # delimiter (Required)
        # 設定内容: 文字列エントリを分割する区切り文字を指定します。
        # 設定可能な値: 任意の文字列
        delimiter = ","
      }
    }

    # substitute_string (Optional)
    # 設定内容: キーの値を正規表現と照合し、すべての一致を置換文字列で置き換えます。
    # パターンマッチングによる文字列の置換に使用します。
    # 最小1個、最大10個のエントリを含める必要があります。
    substitute_string {
      entry {
        # source (Required)
        # 設定内容: 変更するキーを指定します。
        source = "message"

        # from (Required)
        # 設定内容: 置換される正規表現文字列を指定します。
        # 設定可能な値: 有効な正規表現パターン
        from = "ERROR"

        # to (Required)
        # 設定内容: fromの各一致に対して置換される文字列を指定します。
        to = "WARN"
      }
    }

    # trim_string (Optional)
    # 設定内容: 文字列から先頭と末尾の空白を削除します。
    # データのクリーンアップと正規化に使用します。
    trim_string {
      # with_keys (Required)
      # 設定内容: トリムするフィールドのキーを指定します。
      # 設定可能な値: 文字列のリスト
      with_keys = ["user_input", "description"]
    }

    # type_converter (Optional)
    # 設定内容: 指定されたキーに関連付けられた値の型を指定された型に変換します。
    # 文字列から数値、ブール値などへの型変換に使用します。
    # 最小1個、最大5個のエントリを含める必要があります。
    type_converter {
      entry {
        # key (Required)
        # 設定内容: 値の型を変換するキーを指定します。
        key = "status_code"

        # type (Required)
        # 設定内容: フィールド値を変換する型を指定します。
        # 設定可能な値:
        #   - "integer": 整数型
        #   - "double": 倍精度浮動小数点型
        #   - "string": 文字列型
        #   - "boolean": ブール型
        type = "integer"
      }
    }

    # upper_case_string (Optional)
    # 設定内容: 文字列を大文字に変換します。
    # データの正規化やケース非依存の検索に使用します。
    upper_case_string {
      # with_keys (Required)
      # 設定内容: 大文字に変換するフィールドのキーを指定します。
      # 設定可能な値: 文字列のリスト
      with_keys = ["country_code", "status"]
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは追加の読み取り専用属性をエクスポートしません。
# log_group_arnとregionは設定値がそのまま参照可能です。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意
#---------------------------------------------------------------
# 1. トランスフォーマーは最小1個、最大20個のプロセッサで構成されます。
# 2. 最初のプロセッサは必ずパーサー（parse_*系）である必要があります。
# 3. 変換は取り込み時に実行され、元のログと変換後のログが両方保存されます。
# 4. 変換後のログは元のログより大きくなる可能性があり、ストレージコストに影響します。
# 5. 変換エラーは@transformationErrorシステムフィールドに記録されます。
# 6. トランスフォーマーはStandardログクラスのロググループに対してのみ作成可能です。
# 7. ログレベルのトランスフォーマーはアカウントレベルのトランスフォーマーを上書きします。
#---------------------------------------------------------------
