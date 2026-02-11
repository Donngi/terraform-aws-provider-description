#---------------------------------------------------------------
# AWS App Mesh Virtual Node
#---------------------------------------------------------------
#
# AWS App Meshのサービスメッシュ内に仮想ノードをプロビジョニングするリソースです。
# 仮想ノードは、Amazon ECSサービスやKubernetesデプロイメントなどの
# タスクグループへの論理的なポインターとして機能します。
# サービスディスカバリ情報やリスナー設定、バックエンドサービスへの接続設定を定義します。
#
# 注意: AWS App Meshは2026年9月30日にサポート終了予定です。
#
# AWS公式ドキュメント:
#   - Virtual nodes: https://docs.aws.amazon.com/app-mesh/latest/userguide/virtual_nodes.html
#   - CreateVirtualNode API: https://docs.aws.amazon.com/app-mesh/latest/APIReference/API_CreateVirtualNode.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_virtual_node
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appmesh_virtual_node" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: 仮想ノードの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  name = "my-virtual-node"

  # mesh_name (Required, Forces new resource)
  # 設定内容: 仮想ノードを作成するサービスメッシュの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  mesh_name = "my-mesh"

  # mesh_owner (Optional)
  # 設定内容: サービスメッシュ所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID
  # 省略時: 現在接続しているAWSプロバイダーのアカウントIDを使用
  mesh_owner = null

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
  # 仮想ノード仕様 (spec)
  #-------------------------------------------------------------

  # spec (Required)
  # 設定内容: 仮想ノードの仕様を定義します。
  # サービスディスカバリ、リスナー、バックエンド、ロギング設定などを含みます。
  spec {

    #-----------------------------------------------------------
    # バックエンド設定 (backend)
    #-----------------------------------------------------------

    # backend (Optional)
    # 設定内容: 仮想ノードがアウトバウンドトラフィックを送信するバックエンドを指定します。
    # 複数のバックエンドを設定可能です。
    backend {
      # virtual_service (Required)
      # 設定内容: バックエンドとして使用する仮想サービスを指定します。
      virtual_service {
        # virtual_service_name (Required)
        # 設定内容: バックエンドとして機能する仮想サービスの名前を指定します。
        # 設定可能な値: 1-255文字の文字列
        virtual_service_name = "backend-service.example.local"

        # client_policy (Optional)
        # 設定内容: バックエンドに対するクライアントポリシーを指定します。
        client_policy {
          # tls (Optional)
          # 設定内容: Transport Layer Security (TLS) クライアントポリシーを指定します。
          tls {
            # enforce (Optional)
            # 設定内容: ポリシーを強制するかどうかを指定します。
            # 設定可能な値:
            #   - true (デフォルト): TLSを強制
            #   - false: TLSを強制しない
            enforce = true

            # ports (Optional)
            # 設定内容: ポリシーを適用するポートを指定します。
            # 設定可能な値: ポート番号のセット
            # 省略時: すべてのポートに適用
            ports = [8080, 8443]

            # certificate (Optional)
            # 設定内容: クライアント証明書を指定します。
            # file または sds のいずれかを指定可能
            certificate {
              # file (Optional)
              # 設定内容: ローカルファイルからの証明書を指定します。
              file {
                # certificate_chain (Required)
                # 設定内容: 証明書チェーンのファイルパスを指定します。
                certificate_chain = "/path/to/certificate-chain.pem"

                # private_key (Required)
                # 設定内容: 秘密鍵のファイルパスを指定します。
                private_key = "/path/to/private-key.pem"
              }

              # sds (Optional)
              # 設定内容: Secret Discovery Service (SDS) からの証明書を指定します。
              # 関連機能: Envoy SDS
              #   - https://www.envoyproxy.io/docs/envoy/latest/configuration/security/secret#secret-discovery-service-sds
              # sds {
              #   # secret_name (Required)
              #   # 設定内容: SDSプロバイダーに要求するシークレットの名前を指定します。
              #   secret_name = "client-cert-secret"
              # }
            }

            # validation (Required)
            # 設定内容: TLS検証コンテキストを指定します。
            validation {
              # subject_alternative_names (Optional)
              # 設定内容: TLS検証コンテキストのSAN (Subject Alternative Names) を指定します。
              subject_alternative_names {
                # match (Required)
                # 設定内容: SANのマッチング条件を指定します。
                match {
                  # exact (Required)
                  # 設定内容: 完全一致させる値を指定します。
                  exact = ["backend-service.example.local"]
                }
              }

              # trust (Required)
              # 設定内容: TLS検証コンテキストの信頼設定を指定します。
              # acm, file, sds のいずれかを指定
              trust {
                # acm (Optional)
                # 設定内容: AWS Certificate Manager (ACM) の証明書による信頼を指定します。
                # acm {
                #   # certificate_authority_arns (Required)
                #   # 設定内容: 1つ以上のACM証明書認証機関のARNを指定します。
                #   certificate_authority_arns = [
                #     "arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"
                #   ]
                # }

                # file (Optional)
                # 設定内容: ローカルファイルからの証明書による信頼を指定します。
                file {
                  # certificate_chain (Required)
                  # 設定内容: 証明書チェーンのファイルパスを指定します。
                  # 設定可能な値: 1-255文字のパス文字列
                  certificate_chain = "/path/to/ca-certificate.pem"
                }

                # sds (Optional)
                # 設定内容: Secret Discovery Service (SDS) による信頼を指定します。
                # sds {
                #   # secret_name (Required)
                #   # 設定内容: SDSプロバイダーに要求するシークレットの名前を指定します。
                #   secret_name = "trust-bundle-secret"
                # }
              }
            }
          }
        }
      }
    }

    #-----------------------------------------------------------
    # バックエンドデフォルト設定 (backend_defaults)
    #-----------------------------------------------------------

    # backend_defaults (Optional)
    # 設定内容: バックエンドのデフォルト設定を指定します。
    # 個別のバックエンド設定がない場合にこの設定が適用されます。
    backend_defaults {
      # client_policy (Optional)
      # 設定内容: 仮想サービスバックエンドのデフォルトクライアントポリシーを指定します。
      # 構造は backend > virtual_service > client_policy と同じです。
      client_policy {
        tls {
          enforce = true
          ports   = null

          # certificate (Optional)
          # certificate {
          #   file {
          #     certificate_chain = "/path/to/default-certificate-chain.pem"
          #     private_key       = "/path/to/default-private-key.pem"
          #   }
          # }

          validation {
            # subject_alternative_names (Optional)
            # subject_alternative_names {
            #   match {
            #     exact = ["*.example.local"]
            #   }
            # }

            trust {
              file {
                certificate_chain = "/path/to/default-ca-certificate.pem"
              }
            }
          }
        }
      }
    }

    #-----------------------------------------------------------
    # リスナー設定 (listener)
    #-----------------------------------------------------------

    # listener (Optional)
    # 設定内容: 仮想ノードがインバウンドトラフィックを受信するリスナーを指定します。
    # 複数のリスナーを設定可能です。
    listener {
      #---------------------------------------------------------
      # ポートマッピング (port_mapping) - Required
      #---------------------------------------------------------

      # port_mapping (Required)
      # 設定内容: リスナーのポートマッピング情報を指定します。
      port_mapping {
        # port (Required)
        # 設定内容: リスナーがトラフィックを受信するポートを指定します。
        # 設定可能な値: 1-65535
        port = 8080

        # protocol (Required)
        # 設定内容: ポートマッピングで使用するプロトコルを指定します。
        # 設定可能な値:
        #   - "http": HTTPプロトコル
        #   - "http2": HTTP/2プロトコル
        #   - "tcp": TCPプロトコル
        #   - "grpc": gRPCプロトコル
        protocol = "http"
      }

      #---------------------------------------------------------
      # コネクションプール (connection_pool)
      #---------------------------------------------------------

      # connection_pool (Optional)
      # 設定内容: リスナーのコネクションプール情報を指定します。
      # プロトコルに応じて grpc, http, http2, tcp のいずれかを設定します。
      connection_pool {
        # http (Optional)
        # 設定内容: HTTPリスナーのコネクションプール設定を指定します。
        http {
          # max_connections (Required)
          # 設定内容: Envoyがアップストリームクラスタ内のすべてのホストと
          #           同時に確立できるアウトバウンドTCP接続の最大数を指定します。
          # 設定可能な値: 最小値1以上の整数
          max_connections = 100

          # max_pending_requests (Optional)
          # 設定内容: max_connections を超過した後にEnvoyがアップストリームクラスタに
          #           キューイングするリクエストの数を指定します。
          # 設定可能な値: 最小値1以上の整数
          max_pending_requests = 50
        }

        # grpc (Optional)
        # 設定内容: gRPCリスナーのコネクションプール設定を指定します。
        # grpc {
        #   # max_requests (Required)
        #   # 設定内容: Envoyがアップストリームクラスタ内のホスト間で
        #   #           同時にサポートできるインフライトリクエストの最大数を指定します。
        #   # 設定可能な値: 最小値1以上の整数
        #   max_requests = 100
        # }

        # http2 (Optional)
        # 設定内容: HTTP2リスナーのコネクションプール設定を指定します。
        # http2 {
        #   # max_requests (Required)
        #   # 設定内容: 同時インフライトリクエストの最大数を指定します。
        #   # 設定可能な値: 最小値1以上の整数
        #   max_requests = 100
        # }

        # tcp (Optional)
        # 設定内容: TCPリスナーのコネクションプール設定を指定します。
        # tcp {
        #   # max_connections (Required)
        #   # 設定内容: 最大アウトバウンドTCP接続数を指定します。
        #   # 設定可能な値: 最小値1以上の整数
        #   max_connections = 100
        # }
      }

      #---------------------------------------------------------
      # ヘルスチェック (health_check)
      #---------------------------------------------------------

      # health_check (Optional)
      # 設定内容: リスナーのヘルスチェック情報を指定します。
      health_check {
        # protocol (Required)
        # 設定内容: ヘルスチェックリクエストで使用するプロトコルを指定します。
        # 設定可能な値: "http", "http2", "tcp", "grpc"
        protocol = "http"

        # healthy_threshold (Required)
        # 設定内容: リスナーを正常と宣言するために必要な連続成功ヘルスチェック回数を指定します。
        # 設定可能な値: 正の整数
        healthy_threshold = 2

        # unhealthy_threshold (Required)
        # 設定内容: 仮想ノードを異常と宣言するために必要な連続失敗ヘルスチェック回数を指定します。
        # 設定可能な値: 正の整数
        unhealthy_threshold = 2

        # interval_millis (Required)
        # 設定内容: ヘルスチェック間の間隔（ミリ秒）を指定します。
        # 設定可能な値: 正の整数（ミリ秒）
        interval_millis = 5000

        # timeout_millis (Required)
        # 設定内容: ヘルスチェックからの応答を待機する時間（ミリ秒）を指定します。
        # 設定可能な値: 正の整数（ミリ秒）
        timeout_millis = 2000

        # path (Optional)
        # 設定内容: ヘルスチェックリクエストの宛先パスを指定します。
        # プロトコルが http または http2 の場合にのみ必要です。
        # 設定可能な値: 有効なURLパス
        path = "/health"

        # port (Optional)
        # 設定内容: ヘルスチェックリクエストの宛先ポートを指定します。
        # 省略時: リスナーの port_mapping で定義したポートを使用
        # 設定可能な値: 1-65535
        port = null
      }

      #---------------------------------------------------------
      # 外れ値検出 (outlier_detection)
      #---------------------------------------------------------

      # outlier_detection (Optional)
      # 設定内容: リスナーの外れ値検出情報を指定します。
      # 異常なホストを検出してトラフィックから除外するサーキットブレーカー機能です。
      outlier_detection {
        # max_server_errors (Required)
        # 設定内容: 排除に必要な連続5xxエラーの数を指定します。
        # 設定可能な値: 最小値1以上の整数
        max_server_errors = 5

        # max_ejection_percent (Required)
        # 設定内容: アップストリームサービスのロードバランシングプールから
        #           排除可能なホストの最大割合を指定します。
        # 設定可能な値: 0-100の整数
        # 注意: 値に関係なく、少なくとも1つのホストは排除されます。
        max_ejection_percent = 50

        # base_ejection_duration (Required)
        # 設定内容: ホストが排除される基本時間を指定します。
        base_ejection_duration {
          # unit (Required)
          # 設定内容: 時間の単位を指定します。
          # 設定可能な値: "ms" (ミリ秒), "s" (秒)
          unit = "s"

          # value (Required)
          # 設定内容: 時間の値を指定します。
          # 設定可能な値: 最小値0以上の整数
          value = 30
        }

        # interval (Required)
        # 設定内容: 排除スイープ分析の時間間隔を指定します。
        interval {
          # unit (Required)
          # 設定内容: 時間の単位を指定します。
          # 設定可能な値: "ms" (ミリ秒), "s" (秒)
          unit = "s"

          # value (Required)
          # 設定内容: 時間の値を指定します。
          # 設定可能な値: 最小値0以上の整数
          value = 10
        }
      }

      #---------------------------------------------------------
      # タイムアウト (timeout)
      #---------------------------------------------------------

      # timeout (Optional)
      # 設定内容: 各プロトコルのタイムアウト設定を指定します。
      timeout {
        # http (Optional)
        # 設定内容: HTTPリスナーのタイムアウト設定を指定します。
        http {
          # idle (Optional)
          # 設定内容: アイドルタイムアウトを指定します。
          # 接続がアイドル状態でいられる時間の上限を設定します。
          idle {
            # unit (Required)
            # 設定内容: 時間の単位を指定します。
            # 設定可能な値: "ms" (ミリ秒), "s" (秒)
            unit = "s"

            # value (Required)
            # 設定内容: 時間の値を指定します。
            # 設定可能な値: 最小値0以上の整数
            value = 300
          }

          # per_request (Optional)
          # 設定内容: リクエストごとのタイムアウトを指定します。
          per_request {
            unit  = "s"
            value = 30
          }
        }

        # grpc (Optional)
        # 設定内容: gRPCリスナーのタイムアウト設定を指定します。
        # grpc {
        #   idle {
        #     unit  = "s"
        #     value = 300
        #   }
        #   per_request {
        #     unit  = "s"
        #     value = 30
        #   }
        # }

        # http2 (Optional)
        # 設定内容: HTTP2リスナーのタイムアウト設定を指定します。
        # http2 {
        #   idle {
        #     unit  = "s"
        #     value = 300
        #   }
        #   per_request {
        #     unit  = "s"
        #     value = 30
        #   }
        # }

        # tcp (Optional)
        # 設定内容: TCPリスナーのタイムアウト設定を指定します。
        # tcp {
        #   idle {
        #     unit  = "s"
        #     value = 300
        #   }
        # }
      }

      #---------------------------------------------------------
      # TLS設定 (tls)
      #---------------------------------------------------------

      # tls (Optional)
      # 設定内容: リスナーのTransport Layer Security (TLS) プロパティを指定します。
      tls {
        # mode (Required)
        # 設定内容: TLSのモードを指定します。
        # 設定可能な値:
        #   - "DISABLED": TLSを無効化
        #   - "PERMISSIVE": TLSと非TLSトラフィックの両方を許可
        #   - "STRICT": TLSトラフィックのみを許可
        mode = "STRICT"

        # certificate (Required)
        # 設定内容: リスナーのTLS証明書を指定します。
        # acm, file, sds のいずれかを指定
        certificate {
          # acm (Optional)
          # 設定内容: AWS Certificate Manager (ACM) の証明書を指定します。
          # acm {
          #   # certificate_arn (Required)
          #   # 設定内容: ACM証明書のARNを指定します。
          #   certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
          # }

          # file (Optional)
          # 設定内容: ローカルファイルからの証明書を指定します。
          file {
            # certificate_chain (Required)
            # 設定内容: 証明書チェーンのファイルパスを指定します。
            # 設定可能な値: 1-255文字のパス文字列
            certificate_chain = "/path/to/server-certificate-chain.pem"

            # private_key (Required)
            # 設定内容: 秘密鍵のファイルパスを指定します。
            # 設定可能な値: 1-255文字のパス文字列
            private_key = "/path/to/server-private-key.pem"
          }

          # sds (Optional)
          # 設定内容: Secret Discovery Service (SDS) からの証明書を指定します。
          # sds {
          #   # secret_name (Required)
          #   # 設定内容: SDSプロバイダーに要求するシークレットの名前を指定します。
          #   secret_name = "server-cert-secret"
          # }
        }

        # validation (Optional)
        # 設定内容: TLS検証設定を指定します（mTLS用）。
        validation {
          # subject_alternative_names (Optional)
          # 設定内容: TLS検証コンテキストのSAN (Subject Alternative Names) を指定します。
          subject_alternative_names {
            match {
              exact = ["client.example.local"]
            }
          }

          # trust (Required)
          # 設定内容: TLS検証コンテキストの信頼設定を指定します。
          # file または sds を指定
          trust {
            # file (Optional)
            # 設定内容: ローカルファイルからの証明書による信頼を指定します。
            file {
              # certificate_chain (Required)
              # 設定内容: 証明書チェーンのファイルパスを指定します。
              # 設定可能な値: 1-255文字のパス文字列
              certificate_chain = "/path/to/client-ca-certificate.pem"
            }

            # sds (Optional)
            # 設定内容: Secret Discovery Service (SDS) による信頼を指定します。
            # sds {
            #   # secret_name (Required)
            #   # 設定内容: SDSプロバイダーに要求するシークレットの名前を指定します。
            #   secret_name = "client-trust-bundle-secret"
            # }
          }
        }
      }
    }

    #-----------------------------------------------------------
    # ロギング設定 (logging)
    #-----------------------------------------------------------

    # logging (Optional)
    # 設定内容: 仮想ノードのインバウンドおよびアウトバウンドアクセスロギング情報を指定します。
    logging {
      # access_log (Optional)
      # 設定内容: 仮想ノードのアクセスログ設定を指定します。
      access_log {
        # file (Optional)
        # 設定内容: 仮想ノードのアクセスログを書き込むファイルオブジェクトを指定します。
        file {
          # path (Required)
          # 設定内容: アクセスログを書き込むファイルパスを指定します。
          # 設定可能な値: 1-255文字のパス文字列
          # 標準出力にログを送信するには /dev/stdout を使用します。
          path = "/dev/stdout"

          # format (Optional)
          # 設定内容: ログのフォーマットを指定します。
          format {
            # text (Optional)
            # 設定内容: テキスト形式のログフォーマットを指定します。
            # 設定可能な値: 1-1000文字の文字列
            # text または json のいずれかを指定
            # text = "[%START_TIME%] \"%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%\" %RESPONSE_CODE%"

            # json (Optional)
            # 設定内容: JSON形式のログフォーマットを指定します。
            # 複数のキー/値ペアを指定可能です。
            json {
              # key (Required)
              # 設定内容: JSONのキーを指定します。
              # 設定可能な値: 1-100文字の文字列
              key = "timestamp"

              # value (Required)
              # 設定内容: JSONの値を指定します。
              # 設定可能な値: 1-100文字の文字列
              value = "%START_TIME%"
            }

            json {
              key   = "method"
              value = "%REQ(:METHOD)%"
            }

            json {
              key   = "path"
              value = "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
            }

            json {
              key   = "response_code"
              value = "%RESPONSE_CODE%"
            }
          }
        }
      }
    }

    #-----------------------------------------------------------
    # サービスディスカバリ設定 (service_discovery)
    #-----------------------------------------------------------

    # service_discovery (Optional)
    # 設定内容: 仮想ノードのサービスディスカバリ情報を指定します。
    # 仮想ノードがインバウンドトラフィックを受信しない場合は省略可能です。
    # リスナーを指定した場合は、サービスディスカバリ情報も指定する必要があります。
    service_discovery {
      # dns (Optional)
      # 設定内容: DNSによるサービスディスカバリを指定します。
      dns {
        # hostname (Required)
        # 設定内容: 仮想ノードのDNSホスト名を指定します。
        hostname = "my-service.example.local"

        # ip_preference (Optional)
        # 設定内容: この仮想ノードが使用する優先IPバージョンを指定します。
        # 設定可能な値:
        #   - "IPv6_PREFERRED": IPv6を優先
        #   - "IPv4_PREFERRED": IPv4を優先
        #   - "IPv4_ONLY": IPv4のみ
        #   - "IPv6_ONLY": IPv6のみ
        ip_preference = "IPv4_PREFERRED"

        # response_type (Optional)
        # 設定内容: 仮想ノードのDNS応答タイプを指定します。
        # 設定可能な値:
        #   - "LOADBALANCER": ロードバランサーモード
        #   - "ENDPOINTS": エンドポイントモード
        response_type = "LOADBALANCER"
      }

      # aws_cloud_map (Optional)
      # 設定内容: AWS Cloud Mapによるサービスディスカバリを指定します。
      # dns と aws_cloud_map は排他的です（どちらか一方のみ指定可能）。
      # aws_cloud_map {
      #   # namespace_name (Required)
      #   # 設定内容: 使用するAWS Cloud Map名前空間の名前を指定します。
      #   # 設定可能な値: 1-1024文字の文字列
      #   # aws_service_discovery_http_namespace リソースで設定します。
      #   namespace_name = "example-ns"
      #
      #   # service_name (Required)
      #   # 設定内容: 使用するAWS Cloud Mapサービスの名前を指定します。
      #   # 設定可能な値: 1-1024文字の文字列
      #   # aws_service_discovery_service リソースで設定します。
      #   service_name = "my-service"
      #
      #   # attributes (Optional)
      #   # 設定内容: インスタンスをフィルタリングするための属性マップを指定します。
      #   # インスタンス登録時に指定したカスタム属性で絞り込みができます。
      #   # 指定したすべてのキー/値ペアに一致するインスタンスのみが返されます。
      #   attributes = {
      #     stack = "blue"
      #   }
      # }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  # 一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-virtual-node"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 仮想ノードのID
#
# - arn: 仮想ノードのAmazon Resource Name (ARN)
#
# - created_date: 仮想ノードの作成日時
#
# - last_updated_date: 仮想ノードの最終更新日時
#
# - resource_owner: リソース所有者のAWSアカウントID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
