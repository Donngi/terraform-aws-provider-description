# Generated: 2026-01-18
# Provider Version: 6.28.0
# 注意: このテンプレートは生成時点の情報です。最新の仕様は公式ドキュメントを確認してください。

# AWS MediaLive Inputリソース
# AWS MediaLive Inputを作成・管理します。
#
# Terraform公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_input

resource "aws_medialive_input" "example" {
  # name - (Required) Inputの名前。
  name = "example-medialive-input"

  # input_security_groups - (Required) Inputセキュリティグループのリスト。
  # 入力ソースからのアクセスを制御するセキュリティグループのIDです。
  input_security_groups = ["sg-12345678"]

  # type - (Required) AWS Elemental MediaLiveがサポートする異なるタイプのInput。
  # 有効な値の例: UDP_PUSH, RTP_PUSH, RTMP_PUSH, RTMP_PULL, URL_PULL, MP4_FILE,
  #               MEDIACONNECT, INPUT_DEVICE, AWS_CDI, TS_FILE など
  type = "UDP_PUSH"

  # region - (Optional) このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  region = "us-east-1"

  # role_arn - (Optional) このInputが作成中および作成後に引き受けるロールのARN。
  # MediaConnectフローやVPCインプットなど、特定のInputタイプで必要になります。
  role_arn = "arn:aws:iam::123456789012:role/MediaLiveAccessRole"

  # tags - (Optional) リソースに割り当てるタグのマップ。
  tags = {
    Environment = "production"
    Purpose     = "live-streaming"
  }

  # destinations - (Optional) PUSHタイプのInputの宛先設定。
  # UDP_PUSH、RTP_PUSH、RTMP_PUSHなどのプッシュタイプのInputで使用します。
  destinations {
    # stream_name - (Required) RTMPストリームがプッシュされる場所の一意の名前。
    stream_name = "stream1"
  }

  destinations {
    stream_name = "stream2"
  }

  # input_devices - (Optional) デバイスの設定。
  # AWS Elemental Linkデバイスを使用する場合に設定します。
  # input_devices {
  #   # id - (Required) デバイスの一意ID。
  #   id = "hd-12345678"
  # }

  # media_connect_flows - (Optional) MediaConnect Flowsのリスト。
  # INPUT_DEVICEタイプではなくMEDIACONNECTタイプのInputで使用します。
  # media_connect_flows {
  #   # flow_arn - (Required) MediaConnect FlowのARN。
  #   flow_arn = "arn:aws:mediaconnect:us-east-1:123456789012:flow:1-ABCD1234EFGH5678:example-flow"
  # }

  # sources - (Optional) PULLタイプのInputのソースURL。
  # URL_PULL、RTMP_PULL、MP4_FILE、TS_FILEなどのプルタイプのInputで使用します。
  # sources {
  #   # url - (Required) ストリームがプルされるURL。
  #   url = "rtmp://example.com/live/stream"
  #
  #   # username - (Required) Inputソースのユーザー名。
  #   username = "user"
  #
  #   # password_param - (Required) EC2 Parameter Storeからパスワードを抽出するために使用するキー。
  #   password_param = "/medialive/input/password"
  # }

  # vpc - (Optional) プライベートVPC Inputの設定。
  # VPC内でMediaLive Inputを使用する場合に設定します。
  # vpc {
  #   # subnet_ids - (Required) 同じVPCからの2つのVPCサブネットIDのリスト。
  #   # 冗長性のため、2つの異なるアベイラビリティゾーンのサブネットを指定します。
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #
  #   # security_group_ids - (Optional) Inputにアタッチする最大5つのEC2 VPCセキュリティグループIDのリスト。
  #   # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます。
  #   security_group_ids = ["sg-12345678"]
  # }

  # timeouts - タイムアウト設定
  timeouts {
    # create - (Optional) リソース作成のタイムアウト。
    create = "30m"

    # update - (Optional) リソース更新のタイムアウト。
    update = "30m"

    # delete - (Optional) リソース削除のタイムアウト。
    delete = "30m"
  }
}
