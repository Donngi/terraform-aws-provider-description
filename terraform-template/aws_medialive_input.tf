#---------------------------------------------------------------
# AWS MediaLive Input
#---------------------------------------------------------------
#
# Amazon MediaLive の入力（Input）をプロビジョニングするリソースです。
# 入力はMediaLiveチャンネルがコンテンツを受け取るためのエンドポイントを定義します。
# サポートされる入力タイプには、UDP、RTP、RTMP、HLS、MediaConnect、
# Elemental Link、MP4、TS、IMGなどがあります。
#
# AWS公式ドキュメント:
#   - MediaLive 入力の概要: https://docs.aws.amazon.com/medialive/latest/ug/inputs.html
#   - 入力の作成: https://docs.aws.amazon.com/medialive/latest/ug/create-input.html
#   - 入力タイプ一覧: https://docs.aws.amazon.com/medialive/latest/ug/inputs-supported-containers-and-codecs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_input
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_medialive_input" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 入力の名前を指定します。
  # 設定可能な値: 任意の文字列。MediaLiveコンソール上で識別するために使用されます。
  name = "example-input"

  # type (Required)
  # 設定内容: 入力のタイプを指定します。
  # 設定可能な値:
  #   "UDP_PUSH"          - UDPプッシュ入力。アップストリームシステムがUDPストリームをプッシュする。
  #   "RTP_PUSH"          - RTPプッシュ入力。アップストリームシステムがRTPストリームをプッシュする。
  #   "RTMP_PUSH"         - RTMPプッシュ入力。アップストリームシステムがRTMPストリームをプッシュする。
  #   "RTMP_PULL"         - RTMPプル入力。MediaLiveがRTMPソースからコンテンツをプルする。
  #   "URL_PULL"          - URLプル入力（HLS等）。MediaLiveがURLからコンテンツをプルする。
  #   "MP4_FILE"          - MP4ファイル入力。S3バケットのMP4ファイルを参照する。
  #   "MEDIACONNECT"      - AWS MediaConnect入力。MediaConnectフローからコンテンツを受け取る。
  #   "INPUT_DEVICE"      - Elemental Link デバイス入力。
  #   "AWS_CDI"           - AWS CDI（Cloud Digital Interface）入力。
  #   "TS_FILE"           - Transport Streamファイル入力。
  #   "MULTICAST"         - マルチキャスト入力。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/inputs-supported-containers-and-codecs.html
  type = "RTP_PUSH"

  #-------------------------------------------------------------
  # セキュリティグループ設定
  #-------------------------------------------------------------

  # input_security_groups (Optional)
  # 設定内容: 入力に関連付けるMediaLive入力セキュリティグループのIDリストを指定します。
  # 設定可能な値: aws_medialive_input_security_groupリソースのIDのリスト
  # 省略時: セキュリティグループなし
  # 注意: RTPおよびRTMPプッシュ入力（VPCを使用しない場合）に必要です。
  #       VPC入力、MediaConnect入力、Elemental Link入力には不要です。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/working-with-input-security-groups.html
  input_security_groups = [aws_medialive_input_security_group.example.id]

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: MediaLiveが入力を作成・管理する際に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN文字列
  # 省略時: AWSがデフォルトのサービスロールを使用
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/role-and-remember-arn.html
  role_arn = null

  #-------------------------------------------------------------
  # 送信先設定（プッシュ型入力用）
  #-------------------------------------------------------------

  # destinations (Optional)
  # 設定内容: プッシュ型入力（RTMP_PUSH等）の送信先設定を指定します。
  # 設定可能な値: stream_nameを含むブロックのセット。2つまで指定可能（冗長化のため）。
  # 省略時: 送信先なし
  # 注意: RTMP_PUSH入力でのみ使用します。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/rtmp-push.html
  destinations {
    # stream_name (Required)
    # 設定内容: RTMPストリームの送信先ストリーム名を指定します。
    # 設定可能な値: 任意の文字列。アップストリームシステムがコンテンツをプッシュする際のストリームキーとして使用。
    stream_name = "example-stream"
  }

  #-------------------------------------------------------------
  # ソース設定（プル型入力用）
  #-------------------------------------------------------------

  # sources (Optional)
  # 設定内容: プル型入力（RTMP_PULL、URL_PULL等）のソース設定を指定します。
  # 設定可能な値: url、username、password_paramを含むブロックのセット。2つまで指定可能（冗長化のため）。
  # 省略時: ソースなし
  # 注意: RTMP_PULLやURL_PULL等のプル型入力でのみ使用します。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/rtmp-pull.html
  sources {
    # url (Required)
    # 設定内容: メディアソースのURLを指定します。
    # 設定可能な値: 有効なURL文字列（例: rtmp://203.0.113.0/live, https://example.com/stream.m3u8）
    url = "rtmp://203.0.113.0/live"

    # username (Required)
    # 設定内容: ソースにアクセスするためのユーザー名を指定します。
    # 設定可能な値: 任意の文字列
    username = "example-user"

    # password_param (Required)
    # 設定内容: ソースへのアクセスに使用するパスワードが格納されたAWS Systems Manager
    #           Parameter StoreのパラメータパスをARNまたは名前で指定します。
    # 設定可能な値: AWS SSM Parameter Storeのパラメータパス（例: /medialive/password）
    # 注意: パスワードは直接指定せず、SSM Parameter Storeを経由して安全に参照してください。
    # 参考: https://docs.aws.amazon.com/medialive/latest/ug/requirements-for-ec2.html
    password_param = "/medialive/input/password"
  }

  #-------------------------------------------------------------
  # MediaConnect設定
  #-------------------------------------------------------------

  # media_connect_flows (Optional)
  # 設定内容: AWS MediaConnectフローの設定を指定します。
  # 設定可能な値: flow_arnを含むブロックのセット。2つまで指定可能（冗長化のため）。
  # 省略時: MediaConnectフローなし
  # 注意: type = "MEDIACONNECT" の場合に使用します。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/input-create-cdi-vpc.html
  media_connect_flows {
    # flow_arn (Required)
    # 設定内容: AWS MediaConnectフローのARNを指定します。
    # 設定可能な値: 有効なMediaConnect FlowのARN文字列
    flow_arn = "arn:aws:mediaconnect:ap-northeast-1:123456789012:flow:1-example"
  }

  #-------------------------------------------------------------
  # デバイス設定
  #-------------------------------------------------------------

  # input_devices (Optional)
  # 設定内容: 入力に関連付けるElemental Linkデバイスの設定を指定します。
  # 設定可能な値: idを含むブロックのセット。2つまで指定可能（冗長化のため）。
  # 省略時: デバイスなし
  # 注意: type = "INPUT_DEVICE" の場合に使用します。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/input-create-elemental-link.html
  input_devices {
    # id (Required)
    # 設定内容: Elemental LinkデバイスのIDを指定します。
    # 設定可能な値: 有効なElemental LinkデバイスのID文字列
    id = "hd-12345678"
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc (Optional)
  # 設定内容: 入力をVPC内に作成するためのVPC設定を指定します。
  # 設定可能な値: subnet_idsを含む単一ブロック
  # 省略時: VPC外（パブリック）の入力として作成
  # 注意: VPC入力はプッシュ型のRTPおよびRTMP入力に対応しています。
  #       作成後はVPC設定を変更できません。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/inputs-vpc.html
  vpc {
    # subnet_ids (Required)
    # 設定内容: 入力エンドポイントを配置するサブネットのIDリストを指定します。
    # 設定可能な値: 有効なサブネットIDのリスト。2つ指定することで冗長化できます。
    # 注意: 異なるアベイラビリティーゾーンのサブネットを指定することを推奨します。
    subnet_ids = [
      "subnet-0123456789abcdef0",
      "subnet-0123456789abcdef1",
    ]

    # security_group_ids (Optional)
    # 設定内容: VPCの入力エンドポイントに適用するセキュリティグループのIDリストを指定します。
    # 設定可能な値: 有効なVPCセキュリティグループIDのリスト。最大5つまで指定可能。
    # 省略時: デフォルトのVPCセキュリティグループを使用
    security_group_ids = [
      "sg-0123456789abcdef0",
    ]
  }

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: 入力に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-input"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "5m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "5m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "5m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 入力のID
#
# - arn: 入力のAmazon Resource Name (ARN)
#
# - attached_channels: この入力が現在アタッチされているチャンネルIDのリスト
#
# - input_class: 入力クラス（STANDARD または SINGLE_PIPELINE）
#
# - input_partner_ids: パートナー入力のIDリスト（冗長入力ペアの場合）
#
# - input_source_type: 入力ソースのタイプ（STATIC または DYNAMIC）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
