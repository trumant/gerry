# frozen_string_literal: true

module Gerry
  module Api
    module Request # :nodoc:
      class RequestError < StandardError
      end

      # Get the mapped options.
      #
      # @param [Array] or [Hash] options the query parameters.
      # @return [String] the mapped options.
      def map_options(options)
        if options.is_a?(Array)
          options.map { |v| "#{v}" }.join('&')
        elsif options.is_a?(Hash)
          options.map { |k,v| "#{k}=#{v.join(',')}" }.join('&')
        end
      end

      def options(body = nil, is_json = true)
        return {} unless body
        default_options = {
          headers: {
            'Content-Type' => is_json ? 'application/json' : 'text/plain'
          }
        }
        default_options[:body] = is_json ? body.to_json : body
        default_options
      end

      def get(url)
        response = self.class.get(auth_url(url))
        parse(response)
      end

      def auth_url(url)
        self.class.default_options[:basic_auth] ? "/a#{url}" : url
      end

      def put(url, body = nil, is_json = true)
        response = self.class.put(auth_url(url), options(body, is_json))
        parse(response)
      end

      def post(url, body, is_json = true)
        response = self.class.post(auth_url(url), options(body, is_json))
        parse(response)
      end

      def delete(url)
        self.class.delete(auth_url(url))
        parse(response)
      end

      private

      def parse(response)
        unless /2[0-9][0-9]/.match(response.code.to_s)
          raise_request_error(response)
        end
        unless response.body.size.zero?
          source = remove_magic_prefix(response.body)
          if source.lines.count == 1 && !source.start_with?('{') && !source.start_with?('[')
            # Work around the JSON gem not being able to parse top-level values, see
            # https://github.com/flori/json/issues/206.
            source.gsub!(/^"|"$/, '')
          else
            JSON.parse(source)
          end
        else
          nil
        end
      end

      def raise_request_error(response)
        raise RequestError.new("There was a request error! Response was: #{response.message}")
      end

      def remove_magic_prefix(response_body)
        # We need to strip the magic prefix from the first line of the response, see
        # https://gerrit-review.googlesource.com/Documentation/rest-api.html#output.
        # magic prefix: )]}
        response_body[4..-1].strip!
      end
    end
  end
end
