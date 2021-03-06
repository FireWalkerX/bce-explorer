module BceExplorer
  module Route
    # Helpers to build links
    module Helpers
      ROUTE_METHODS = %w(address block tx)

      ROUTE_METHODS.each do |method|
        define_method "to_#{method}", proc { |id| url("/#{method}/#{id}") }
      end

      ROUTE_METHODS.each do |method|
        define_method \
          "link_to_#{method}",
          proc { |id| "<a href='#{url("/#{method}/#{id}")}'>#{id}</a>" }
      end

      def link_to_tx_short(id)
        "<a href='#{url("/tx/#{id}")}'>#{shorten_tx(id)}</a>"
      end

      def link_to(link)
        "<a href='#{link}'>#{link}</a>"
      end
    end
  end

  module View
    # Helpers to format data in views
    module Helpers
      def partial(page, options = {})
        haml page.to_sym, options.merge!(layout: false)
      end

      def shorten_tx(txhash)
        "#{txhash[0..9]}..."
      end

      def coin_amount(value)
        sprintf('%0.08f', value.abs)
      end

      def coin_percent(coins)
        @_money_supply ||= @client.money_supply
        sprintf('%0.02f', (coins.abs / @_money_supply) * 100.0)
      end

      def coin_tag
        @coin_info['Tag']
      end

      def human_time(tim)
        Time.at(tim.to_i).strftime('%F %H:%M')
      end

      def time_ago(tim)
        seconds = Time.now.to_i - tim.to_i
        if seconds < 60
          'just now'
        else
          str = time_ago_minutes(seconds / 60)
          str ||= human_time(tim)
          str
        end
      end

      private

      def time_ago_minutes(minutes)
        if minutes == 1
          'a minute ago'
        else
          if minutes < 60
            "#{minutes} minutes ago"
          else
            time_ago_hours(minutes / 60)
          end
        end
      end

      def time_ago_hours(hours)
        if hours == 1
          'an hour ago'
        else
          if hours < 24
            "#{hours} hours ago"
          else
            time_ago_days(hours / 24)
          end
        end
      end

      def time_ago_days(days)
        'some days ago' if days <= 7
      end
    end
  end
end
