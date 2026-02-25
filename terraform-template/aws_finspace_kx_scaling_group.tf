#---------------------------------------
# AWS FinSpace Kx Scaling Group
#---------------------------------------
# FinSpaceのKxスケーリンググループを管理するリソース
# Managed kdbクラスターの自動スケーリングと可用性を制御
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_scaling_group
#
# NOTE: このテンプレートは実際の運用に合わせて適切に変更してください

#-------
# 基本設定
#-------

resource "aws_finspace_kx_scaling_group" "example" {
  # スケーリンググループ名
  # 設定内容: スケーリンググループの一意な識別名
  # 制約事項: 環境内で一意である必要がある
  name = "my-tf-kx-scalinggroup"

  # 環境ID
  # 設定内容: スケーリンググループを作成するKdb環境の一意な識別子
  # 参照方法: aws_finspace_kx_environment.example.id
  environment_id = "env-12345678"

  # アベイラビリティゾーンID
  # 設定内容: リクエストされたリージョンのアベイラビリティゾーン識別子
  # 設定可能な値: use1-az1, use1-az2, use1-az3 など（リージョンに応じたAZ ID）
  # 注意事項: AZ名ではなくAZ IDを指定する必要がある
  availability_zone_id = "use1-az2"

  # ホストタイプ
  # 設定内容: FinSpace Managed kdbクラスターを配置するスケーリンググループホストのメモリとCPU容量
  # 設定可能な値: kx.sg.4xlarge, kx.sg1.16xlarge, kx.sg1.24xlarge など
  # 選定基準: ワークロードの要件に応じて適切なインスタンスタイプを選択
  host_type = "kx.sg.4xlarge"

  #-------
  # オプション設定
  #-------

  # リージョン設定
  # 設定内容: リソースが管理されるリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 用途: マルチリージョン構成でリソースごとにリージョンを明示的に指定する場合
  region = "us-east-1"

  #-------
  # タグ設定
  #-------

  # リソースタグ
  # 設定内容: スケーリンググループに付与するタグのキーバリューマッピング
  # 制約事項: 最大50個のタグを設定可能
  # 注意事項: プロバイダーのdefault_tagsと重複するキーは上書きされる
  tags = {
    Name        = "example-scaling-group"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------
  # タイムアウト設定
  #-------

  timeouts {
    # 作成タイムアウト
    # 設定内容: リソースの作成操作のタイムアウト時間
    # 省略時: デフォルトのタイムアウト値が使用される
    # 形式: "30m", "1h" などの時間文字列
    # create = "30m"

    # 更新タイムアウト
    # 設定内容: リソースの更新操作のタイムアウト時間
    # 省略時: デフォルトのタイムアウト値が使用される
    # 形式: "30m", "1h" などの時間文字列
    # update = "30m"

    # 削除タイムアウト
    # 設定内容: リソースの削除操作のタイムアウト時間
    # 省略時: デフォルトのタイムアウト値が使用される
    # 形式: "30m", "1h" などの時間文字列
    # delete = "30m"
  }
}

#-------
# Attributes Reference
#-------
# このリソースは以下の属性をエクスポートします:
#
# - arn: KxスケーリンググループのARN識別子
# - clusters: スケーリンググループで現在アクティブなManaged kdbクラスターのリスト
# - created_timestamp: スケーリンググループが作成されたタイムスタンプ（ミリ秒単位のエポック時間）
# - last_modified_timestamp: スケーリンググループが最後に更新されたタイムスタンプ（秒単位のエポック時間）
# - status: スケーリンググループのステータス（CREATING/CREATE_FAILED/ACTIVE/UPDATING/UPDATE_FAILED/DELETING/DELETE_FAILED/DELETED）
# - status_reason: 失敗状態が発生した場合のエラーメッセージ
# - tags_all: リソースに割り当てられたすべてのタグ（プロバイダーのdefault_tagsから継承されたものを含む）
#
# 参照例:
# - aws_finspace_kx_scaling_group.example.arn
# - aws_finspace_kx_scaling_group.example.status
# - aws_finspace_kx_scaling_group.example.clusters
