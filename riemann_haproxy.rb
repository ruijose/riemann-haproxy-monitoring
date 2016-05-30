require 'csv'
require 'riemann/client'
require 'trollop'

class HaproxyStatus
  attr_accessor :uri, :interval, :page, :riemann
  def initialize
    args = command_line_args
    @uri = args[:url]
    @interval = args[:interval]
    @page = args[:page]
  end

  def sent_riemann_events
    while true
      riemann_client
      get_haproxy_csv
      extracted_metrics = get_csv_lines(0)
      load_balancer_stats = get_csv_lines(1)

      extracted_metrics.zip(load_balancer_stats) do |key,value|
        if params.values.include?(key)
          send_riemann_event(key, value)
        end
      end
      sleep(interval.to_i)
    end
  end


  private

  def get_csv_lines(line_number)
    CSV.read("metrics.csv")[line_number]
  end

  def command_line_args
    Trollop::options do
      opt :url, "Riemann server url", :type => :string
      opt :interval, "Stats page", :type => :string
      opt :page, "Haproxy stats page", :type => :string
    end
  end

  def riemann_client
    @riemann ||= Riemann::Client.new host: uri, port: 5555, timeout: 5
  end

  def send_riemann_event(service, metric)
    riemann << {
      host: "haproxy load balancer",
      service: "haprxy lb #{service}",
      metric: metric.to_f,
      tags: ["haproxy", "#{service}"]
    }
  end

  def get_haproxy_csv
    cmd = "curl --silent '#{page}' > 'metrics.csv'"
    system(cmd)
  end

  def params
    {
      :request_rate => "req_rate",
      :response_errors => "hrsp_4xx",
      :ok_responses => "hrsp_2xx",
      :bad_responses => "hrsp_5xx",
    }
  end
end

HaproxyStatus.new.sent_riemann_events
