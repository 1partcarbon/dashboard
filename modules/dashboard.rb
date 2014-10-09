module Dashboard
  class InvalidEndpointError < StandardError
      def message
        "JSON is invalid, try checking your url and Json file"
      end
  end

  class InvalidURIError < StandardError
    def message
      "URL is invalid"
    end
  end
end
