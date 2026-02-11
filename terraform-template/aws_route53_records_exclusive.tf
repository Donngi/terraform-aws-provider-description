################################################################################
# aws_route53_records_exclusive
################################################################################
# Terraform resource for maintaining exclusive management of resource record sets
# defined in an AWS Route53 hosted zone.
#
# 【重要な注意事項】
# - このリソースは指定されたホストゾーン内のレコードセットの排他的な管理権を取得します
# - 明示的に設定されていないレコードセットは削除されます
# - aws_route53_recordリソースと併用する場合は、同等のresource_record_set引数を
#   必ず含めてください（永続的なドリフトを防ぐため）
# - このリソースを削除してもホストゾーンからレコードセットは削除されません
#   （Terraformが調整を管理しなくなるだけです）
# - デフォルトのNSレコードとSOAレコードは定義に含めないでください
#   （含めると永続的なドリフトが発生します）
#
# Provider Version: 6.28.0
# Resource Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_records_exclusive

################################################################################
# Required Arguments
################################################################################

# zone_id - (必須) リソースレコードセットを含むホストゾーンのID
# Type: string
# Example: aws_route53_zone.example.zone_id
zone_id = "Z1234567890ABC"

################################################################################
# Optional Arguments
################################################################################

# resource_record_set - (オプション) ホストゾーンに関連付けられた全てのリソースレコードセットのリスト
# Type: set of objects
# Note: 以下のいずれかが必須: resource_records または alias_target
resource_record_set = [
  {
    ################################################################################
    # Required Fields (resource_record_set)
    ################################################################################

    # name - (必須) レコード名
    # Type: string
    # Example: "subdomain.example.com", "www.example.com"
    name = "subdomain.example.com"

    # type - (必須) レコードタイプ
    # Type: string
    # Valid values: A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT, TLSA, SSHFP, SVCB, HTTPS
    type = "A"

    ################################################################################
    # Optional Fields (resource_record_set)
    ################################################################################

    # ttl - (オプション、非エイリアスレコードの場合は必須) リソースレコードのキャッシュ有効期限（秒）
    # Type: number
    # Note: alias_targetを使用する場合は不要
    ttl = 300

    # resource_records - (オプション、非エイリアスレコードの場合は必須) リソースレコードの情報
    # Type: list of objects
    # Note: alias_targetとresource_recordsは排他的です（どちらか一方のみ指定）
    resource_records = [
      {
        # value - (必須) DNSレコード値
        # Type: string
        # Examples:
        # - Aレコード: "192.0.2.1"
        # - AAAAレコード: "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
        # - CNAMEレコード: "example.com"
        # - MXレコード: "10 mail.example.com"
        # - TXTレコード: "v=spf1 include:_spf.example.com ~all"
        value = "192.0.2.1"
      },
      {
        value = "192.0.2.2"
      }
    ]

    # alias_target - (オプション) エイリアスターゲットブロック
    # Type: list of objects
    # Note: resource_recordsとalias_targetは排他的です（どちらか一方のみ指定）
    # CloudFront、S3、ELB、Global Accelerator、Route 53ホストゾーンなどのAWSリソースを参照する場合に使用
    # alias_target = [
    #   {
    #     # dns_name - (必須) このホストゾーン内の別のリソースレコードセットのDNSドメイン名
    #     # Type: string
    #     # Examples:
    #     # - ELB: aws_elb.example.dns_name
    #     # - ALB/NLB: aws_lb.example.dns_name
    #     # - CloudFront: aws_cloudfront_distribution.example.domain_name
    #     # - S3: aws_s3_bucket.example.bucket_regional_domain_name
    #     dns_name = "example-lb-123456789.us-east-1.elb.amazonaws.com"
    #
    #     # evaluate_target_health - (必須) リソースレコードセットのヘルスチェックによってDNSクエリに応答するかどうかを決定
    #     # Type: bool
    #     # Note: リソースによって特別な要件があります
    #     # https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values.html#rrsets-values-alias-evaluate-target-health
    #     evaluate_target_health = true
    #
    #     # hosted_zone_id - (必須) CloudFront、S3、ELB、Global Accelerator、Route 53ホストゾーンのホストゾーンID
    #     # Type: string
    #     # Examples:
    #     # - ELB: aws_elb.example.zone_id
    #     # - ALB/NLB: aws_lb.example.zone_id
    #     # - CloudFront: Z2FDTNDATAQYW2（固定値）
    #     hosted_zone_id = "Z35SXDOTRQ7X7K"
    #   }
    # ]

    # set_identifier - (オプション) 同じ名前とタイプの組み合わせを持つ複数のリソースレコードセットを区別する識別子
    # Type: string
    # Note: cidr_routing_config、failover、geolocation、geoproximity_location、multivalue_answer、region、weightを使用する場合は必須
    # set_identifier = "primary"

    # failover - (オプション) フェイルオーバーリソースレコードのタイプ
    # Type: string
    # Valid values: PRIMARY, SECONDARY
    # Reference: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html
    # failover = "PRIMARY"

    # geolocation - (オプション) クエリの地理的発信元に基づいてRoute 53がDNSクエリに応答する方法を制御する地理的位置ブロック
    # Type: list of objects
    # geolocation = [
    #   {
    #     # continent_code - (オプション) 2文字の大陸コード
    #     # Type: string
    #     # Valid values: AF, AN, AS, EU, OC, NA, SA
    #     # Reference: http://docs.aws.amazon.com/Route53/latest/APIReference/API_GetGeoLocation.html
    #     continent_code = "EU"
    #
    #     # country_code - (オプション) 2文字の国コード
    #     # Type: string
    #     # Reference: ISO 3166-1 alpha-2
    #     # country_code = "US"
    #
    #     # subdivision_code - (オプション) 州または地域のサブディビジョンコード
    #     # Type: string
    #     # Note: 米国の州コード（例: "NY", "CA"）など
    #     # subdivision_code = "NY"
    #   }
    # ]

    # geoproximity_location - (オプション) 地理的近接性ロケーションブロック
    # Type: list of objects
    # Note: aws_region、coordinates、local_zone_groupのいずれか1つを指定
    # geoproximity_location = [
    #   {
    #     # aws_region - (オプション) DNSトラフィックが向けられるリソースのAWSリージョン
    #     # Type: string
    #     # Example: "us-east-1", "eu-west-1"
    #     aws_region = "us-east-1"
    #
    #     # bias - (オプション) Route 53がトラフィックをルーティングする地理的領域のサイズを増減
    #     # Type: number
    #     # Valid range: -99 to 99
    #     # - 正の値（1〜99）: 地理的領域を拡大
    #     # - 負の値（-99〜-1）: 地理的領域を縮小
    #     # Reference: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html
    #     # bias = 10
    #
    #     # coordinates - (オプション) 地理的近接性リソースレコードの座標
    #     # Type: list of objects
    #     # coordinates = [
    #     #   {
    #     #     # latitude - (必須) 地球表面の南北位置の座標
    #     #     # Type: string
    #     #     # Valid range: -90 to 90
    #     #     latitude = "40.7128"
    #     #
    #     #     # longitude - (必須) 地球表面の東西位置の座標
    #     #     # Type: string
    #     #     # Valid range: -180 to 180
    #     #     longitude = "-74.0060"
    #     #   }
    #     # ]
    #
    #     # local_zone_group - (オプション) AWSローカルゾーングループ
    #     # Type: string
    #     # Note: describe-availability-zones CLIコマンドを使用して特定のローカルゾーンのグループを識別
    #     # Reference: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-availability-zones.html
    #     # local_zone_group = "us-east-1-bos-1"
    #   }
    # ]

    # cidr_routing_config - (オプション) CIDRルーティング設定ブロック
    # Type: list of objects
    # cidr_routing_config = [
    #   {
    #     # collection_id - (必須) CIDRコレクションID
    #     # Type: string
    #     # Reference: aws_route53_cidr_collection リソース
    #     collection_id = aws_route53_cidr_collection.example.id
    #
    #     # location_name - (必須) CIDRコレクションのロケーション名
    #     # Type: string
    #     # Note: アスタリスク "*" を含むlocation_nameを使用してデフォルトCIDRレコードを作成可能
    #     # Reference: aws_route53_cidr_location リソース
    #     location_name = "office"
    #   }
    # ]

    # health_check_id - (オプション) このレコードを関連付けるヘルスチェック
    # Type: string
    # Example: aws_route53_health_check.example.id
    # health_check_id = "1234567890abc"

    # multi_value_answer - (オプション) マルチバリューアンサーレコードであることを示すフラグ
    # Type: bool
    # Note: trueに設定すると、複数のリソースにトラフィックをほぼランダムにルーティング
    # multivalue_answer = false

    # region - (オプション) このレコードセットが参照するリソースのAWSリージョン
    # Type: string
    # Note: レイテンシーベースルーティングで使用
    # Reference: http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-latency
    # region = "us-east-1"

    # weight - (オプション) 同じDNS名とタイプの組み合わせを持つリソースレコードセット間で、Route 53が応答する割合を決定する値
    # Type: number
    # Note: 加重ルーティングポリシーで使用
    # Valid range: 0 to 255
    # weight = 10

    # traffic_policy_instance_id - (オプション) Route 53がこのリソースレコードセットを作成したトラフィックポリシーインスタンスのID
    # Type: string
    # Note: トラフィックポリシーインスタンスに関連付けられたレコードセットを削除するには、DeleteTrafficPolicyInstance APIを使用
    # ChangeResourceRecordSets経由で削除された場合、トラフィックポリシーインスタンスは自動削除されず課金が継続
    # traffic_policy_instance_id = "1234567890abc"
  },

  # 基本的なAレコードの追加例
  {
    name = "www.example.com"
    type = "A"
    ttl  = 300
    resource_records = [
      {
        value = "203.0.113.1"
      }
    ]
  },

  # CNAMEレコードの例
  # {
  #   name = "blog.example.com"
  #   type = "CNAME"
  #   ttl  = 300
  #   resource_records = [
  #     {
  #       value = "example.com"
  #     }
  #   ]
  # },

  # MXレコードの例
  # {
  #   name = "example.com"
  #   type = "MX"
  #   ttl  = 300
  #   resource_records = [
  #     {
  #       value = "10 mail1.example.com"
  #     },
  #     {
  #       value = "20 mail2.example.com"
  #     }
  #   ]
  # },

  # TXTレコードの例
  # {
  #   name = "example.com"
  #   type = "TXT"
  #   ttl  = 300
  #   resource_records = [
  #     {
  #       value = "v=spf1 include:_spf.example.com ~all"
  #     }
  #   ]
  # },

  # エイリアスレコード（ELB）の例
  # {
  #   name = "app.example.com"
  #   type = "A"
  #   alias_target = [
  #     {
  #       dns_name               = aws_lb.example.dns_name
  #       hosted_zone_id         = aws_lb.example.zone_id
  #       evaluate_target_health = true
  #     }
  #   ]
  # },

  # 加重ルーティングの例
  # {
  #   name           = "weighted.example.com"
  #   type           = "A"
  #   ttl            = 60
  #   set_identifier = "weight-1"
  #   weight         = 70
  #   resource_records = [
  #     {
  #       value = "192.0.2.1"
  #     }
  #   ]
  # },
  # {
  #   name           = "weighted.example.com"
  #   type           = "A"
  #   ttl            = 60
  #   set_identifier = "weight-2"
  #   weight         = 30
  #   resource_records = [
  #     {
  #       value = "192.0.2.2"
  #     }
  #   ]
  # },

  # フェイルオーバールーティングの例
  # {
  #   name            = "failover.example.com"
  #   type            = "A"
  #   ttl             = 60
  #   set_identifier  = "primary"
  #   failover        = "PRIMARY"
  #   health_check_id = aws_route53_health_check.primary.id
  #   resource_records = [
  #     {
  #       value = "192.0.2.1"
  #     }
  #   ]
  # },
  # {
  #   name           = "failover.example.com"
  #   type           = "A"
  #   ttl            = 60
  #   set_identifier = "secondary"
  #   failover       = "SECONDARY"
  #   resource_records = [
  #     {
  #       value = "192.0.2.2"
  #     }
  #   ]
  # },

  # 地理的位置ルーティングの例
  # {
  #   name           = "geo.example.com"
  #   type           = "A"
  #   ttl            = 60
  #   set_identifier = "geo-us"
  #   geolocation = [
  #     {
  #       country_code = "US"
  #     }
  #   ]
  #   resource_records = [
  #     {
  #       value = "192.0.2.1"
  #     }
  #   ]
  # },
  # {
  #   name           = "geo.example.com"
  #   type           = "A"
  #   ttl            = 60
  #   set_identifier = "geo-eu"
  #   geolocation = [
  #     {
  #       continent_code = "EU"
  #     }
  #   ]
  #   resource_records = [
  #     {
  #       value = "192.0.2.2"
  #     }
  #   ]
  # },

  # レイテンシーベースルーティングの例
  # {
  #   name           = "latency.example.com"
  #   type           = "A"
  #   ttl            = 60
  #   set_identifier = "latency-us-east-1"
  #   region         = "us-east-1"
  #   resource_records = [
  #     {
  #       value = "192.0.2.1"
  #     }
  #   ]
  # },
  # {
  #   name           = "latency.example.com"
  #   type           = "A"
  #   ttl            = 60
  #   set_identifier = "latency-eu-west-1"
  #   region         = "eu-west-1"
  #   resource_records = [
  #     {
  #       value = "192.0.2.2"
  #     }
  #   ]
  # },
]

################################################################################
# Timeouts
################################################################################

# timeouts - (オプション) リソース作成・更新のタイムアウト設定
# Type: object
timeouts = {
  # create - (オプション) リソース作成のタイムアウト
  # Type: string
  # Format: 数値と単位のサフィックス（例: "30s", "2h45m"）
  # Valid units: s (秒), m (分), h (時間)
  # Default: 通常は自動設定
  create = "30m"

  # update - (オプション) リソース更新のタイムアウト
  # Type: string
  # Format: 数値と単位のサフィックス（例: "30s", "2h45m"）
  # Valid units: s (秒), m (分), h (時間)
  # Default: 通常は自動設定
  update = "30m"
}

################################################################################
# 使用例
################################################################################

# 例1: 基本的な使用方法（複数のAレコードを含むホストゾーンの排他的管理）
# resource "aws_route53_zone" "example" {
#   name          = "example.com"
#   force_destroy = true
# }
#
# resource "aws_route53_records_exclusive" "example" {
#   zone_id = aws_route53_zone.example.zone_id
#
#   resource_record_set = [
#     {
#       name = "subdomain.example.com"
#       type = "A"
#       ttl  = 30
#       resource_records = [
#         {
#           value = "127.0.0.1"
#         },
#         {
#           value = "127.0.0.27"
#         }
#       ]
#     }
#   ]
# }

# 例2: レコードセットを許可しない（全てのレコードを削除）
# resource "aws_route53_records_exclusive" "disallow_all" {
#   zone_id = aws_route53_zone.example.zone_id
#   # resource_record_setブロックを指定しない場合、全てのレコードが削除されます
#   # （デフォルトのNS/SOAレコードを除く）
# }

# 例3: エイリアスレコードを使用した高度な設定
# resource "aws_lb" "example" {
#   name               = "example-lb"
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = aws_subnet.public[*].id
# }
#
# resource "aws_route53_records_exclusive" "with_alias" {
#   zone_id = aws_route53_zone.example.zone_id
#
#   resource_record_set = [
#     {
#       name = "app.example.com"
#       type = "A"
#       alias_target = [
#         {
#           dns_name               = aws_lb.example.dns_name
#           hosted_zone_id         = aws_lb.example.zone_id
#           evaluate_target_health = true
#         }
#       ]
#     }
#   ]
# }

# 例4: 複数のルーティングポリシーを組み合わせた設定
# resource "aws_route53_health_check" "primary" {
#   fqdn              = "primary.example.com"
#   port              = 80
#   type              = "HTTP"
#   resource_path     = "/health"
#   failure_threshold = 3
#   request_interval  = 30
# }
#
# resource "aws_route53_records_exclusive" "advanced" {
#   zone_id = aws_route53_zone.example.zone_id
#
#   resource_record_set = [
#     # 基本的なAレコード
#     {
#       name = "www.example.com"
#       type = "A"
#       ttl  = 300
#       resource_records = [
#         {
#           value = "203.0.113.1"
#         }
#       ]
#     },
#     # 加重ルーティング
#     {
#       name           = "weighted.example.com"
#       type           = "A"
#       ttl            = 60
#       set_identifier = "weight-1"
#       weight         = 70
#       resource_records = [
#         {
#           value = "192.0.2.1"
#         }
#       ]
#     },
#     {
#       name           = "weighted.example.com"
#       type           = "A"
#       ttl            = 60
#       set_identifier = "weight-2"
#       weight         = 30
#       resource_records = [
#         {
#           value = "192.0.2.2"
#         }
#       ]
#     },
#     # フェイルオーバールーティング
#     {
#       name            = "failover.example.com"
#       type            = "A"
#       ttl             = 60
#       set_identifier  = "primary"
#       failover        = "PRIMARY"
#       health_check_id = aws_route53_health_check.primary.id
#       resource_records = [
#         {
#           value = "192.0.2.1"
#         }
#       ]
#     },
#     {
#       name           = "failover.example.com"
#       type           = "A"
#       ttl            = 60
#       set_identifier = "secondary"
#       failover       = "SECONDARY"
#       resource_records = [
#         {
#           value = "192.0.2.2"
#         }
#       ]
#     }
#   ]
# }
