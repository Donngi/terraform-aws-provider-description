#---------------------------------------------------------------
# AWS WorkSpaces Workspace
#---------------------------------------------------------------
#
# Amazon WorkSpaces の個別ワークスペースをプロビジョニングするリソースです。
# ユーザーごとにクラウドデスクトップを割り当て、Windows または Linux の
# マネージドデスクトップ環境を提供します。
#
# AWS公式ドキュメント:
#   - WorkSpaces 管理ガイド: https://docs.aws.amazon.com/workspaces/latest/adminguide/
#   - WorkSpaces バンドル: https://docs.aws.amazon.com/workspaces/latest/adminguide/amazon-workspaces-bundles.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_workspace
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspaces_workspace" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # bundle_id (Required)
  # 設定内容: ワークスペースに使用するバンドルの識別子を指定します。
  # 設定可能な値: WorkSpaces バンドル ID（例: wsb-bh8rsxt14）
  # 注意: バンドルは OS、コンピュートタイプ、ストレージの組み合わせを定義します。
  #       aws_workspaces_bundle データソースで利用可能なバンドルを検索できます。
  bundle_id = "wsb-bh8rsxt14"

  # directory_id (Required)
  # 設定内容: ワークスペースを作成するディレクトリの識別子を指定します。
  # 設定可能な値: AWS Directory Service のディレクトリID（例: d-1234567890）
  # 注意: aws_workspaces_directory リソースで管理しているディレクトリ ID を参照します。
  directory_id = "d-1234567890"

  # user_name (Required)
  # 設定内容: ワークスペースを割り当てるユーザー名を指定します。
  # 設定可能な値: ディレクトリ内のユーザー名（最大 63 文字）
  # 注意: ディレクトリに存在するユーザー名を指定する必要があります。
  user_name = "johndoe"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # root_volume_encryption_enabled (Optional)
  # 設定内容: ルートボリューム（OS ドライブ）の暗号化を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ルートボリュームの暗号化を有効化
  #   - false (デフォルト): ルートボリュームの暗号化を無効化
  # 注意: 暗号化を有効にする場合は volume_encryption_key も指定する必要があります。
  root_volume_encryption_enabled = false

  # user_volume_encryption_enabled (Optional)
  # 設定内容: ユーザーボリューム（データドライブ）の暗号化を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ユーザーボリュームの暗号化を有効化
  #   - false (デフォルト): ユーザーボリュームの暗号化を無効化
  # 注意: 暗号化を有効にする場合は volume_encryption_key も指定する必要があります。
  user_volume_encryption_enabled = false

  # volume_encryption_key (Optional)
  # 設定内容: ボリューム暗号化に使用する KMS キーの ARN を指定します。
  # 設定可能な値: KMS 対称カスタマーマネージドキーの ARN
  # 省略時: AWS マネージドキーが使用されます。
  # 注意: root_volume_encryption_enabled または user_volume_encryption_enabled が
  #       true の場合に指定します。
  volume_encryption_key = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ワークスペースプロパティ設定
  #-------------------------------------------------------------

  # workspace_properties (Optional)
  # 設定内容: ワークスペースのコンピュートタイプ、ストレージ、実行モードなどのプロパティを定義します。
  # 省略時: バンドルのデフォルト設定が使用されます。
  workspace_properties {
    # compute_type_name (Optional)
    # 設定内容: ワークスペースのコンピュートタイプを指定します。
    # 設定可能な値:
    #   - "VALUE": 最小スペック（1 vCPU, 2 GB RAM）
    #   - "STANDARD": 標準スペック（2 vCPU, 4 GB RAM）
    #   - "PERFORMANCE": 高性能スペック（2 vCPU, 7.5 GB RAM）
    #   - "POWER": パワースペック（4 vCPU, 16 GB RAM）
    #   - "POWERPRO": パワープロスペック（8 vCPU, 32 GB RAM）
    #   - "GRAPHICS": GPU グラフィックスタイプ
    #   - "GRAPHICSPRO": GPU グラフィックスプロタイプ
    # 省略時: バンドルで定義されたコンピュートタイプを使用
    compute_type_name = "VALUE"

    # root_volume_size_gib (Optional)
    # 設定内容: ルートボリューム（OS ドライブ）のサイズを GiB 単位で指定します。
    # 設定可能な値: バンドルで定義された最小サイズ以上の整数値
    # 省略時: バンドルのデフォルトルートボリュームサイズを使用
    # 注意: ボリュームサイズは増加のみ可能で、縮小はできません。
    root_volume_size_gib = 80

    # running_mode (Optional)
    # 設定内容: ワークスペースの実行モードを指定します。
    # 設定可能な値:
    #   - "AUTO_STOP": 指定した非アクティブ時間後に自動停止（時間課金）
    #   - "ALWAYS_ON": 常時起動状態を維持（月額固定課金）
    # 省略時: "AUTO_STOP"
    # 関連機能: 実行モード管理
    #   コスト最適化のために AUTO_STOP、常時利用には ALWAYS_ON を選択します。
    running_mode = "AUTO_STOP"

    # running_mode_auto_stop_timeout_in_minutes (Optional)
    # 設定内容: AUTO_STOP モードでの非アクティブタイムアウト時間を分単位で指定します。
    # 設定可能な値: 60 の倍数（60 ～ 4320 分）
    # 省略時: 自動計算（60 分が一般的なデフォルト値）
    # 注意: running_mode が "AUTO_STOP" の場合のみ有効です。
    running_mode_auto_stop_timeout_in_minutes = 60

    # user_volume_size_gib (Optional)
    # 設定内容: ユーザーボリューム（データドライブ）のサイズを GiB 単位で指定します。
    # 設定可能な値: バンドルで定義された最小サイズ以上の整数値（10, 50, 100 GB など）
    # 省略時: バンドルのデフォルトユーザーボリュームサイズを使用
    # 注意: ボリュームサイズは増加のみ可能で、縮小はできません。
    user_volume_size_gib = 10
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: ワークスペース作成操作のタイムアウト時間を指定します。
  #   # 設定可能な値: "30m", "1h" などの時間フォーマット文字列
  #   create = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: ワークスペース更新操作のタイムアウト時間を指定します。
  #   # 設定可能な値: "30m", "1h" などの時間フォーマット文字列
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: ワークスペース削除操作のタイムアウト時間を指定します。
  #   # 設定可能な値: "30m", "1h" などの時間フォーマット文字列
  #   delete = "30m"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-workspace"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ワークスペースの識別子
#
# - computer_name: ワークスペースのコンピューター名
#
# - ip_address: ワークスペースに割り当てられた IP アドレス
#
# - state: ワークスペースの現在の状態
#          （AVAILABLE, ERROR, IMPAIRED, MAINTENANCE, PENDING,
#            REBOOTING, REBUILDING, RESTORING, STARTING,
#            STOPPED, STOPPING, SUSPENDED, TERMINATED, TERMINATING,
#            UNHEALTHY, UNKNOWN のいずれか）
#
# - tags_all: リソースに割り当てられた全タグのマップ
#             （プロバイダーレベルの default_tags を含む）
#---------------------------------------------------------------
