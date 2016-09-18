class Buzzitor::PageProcessor
  class << self
    include Rails.application.routes.url_helpers

    def process(document, location)
      document = Nokogiri::HTML(document) unless \
        document.kind_of? Nokogiri::XML::Document

      # Remove script tags
      document.xpath('//script').each(&:remove)

      # Rewrite relative urls
      for attr in ['src', 'href'] do
        document.xpath("//*[@#{attr}]").each do |element|
          begin
            element[attr] = Addressable::URI.join(location, element[attr]).to_s
          rescue Addressable::URI::InvalidURIError
            Rails.logger.error "Error while rewriting url #{element[attr]} "\
                               "for base location #{location}"
          end
        end
      end

      # Add target="_blank" to hyberlinks
      document.xpath('//a[@href]').each do |element|
        element['target'] = '_blank'
      end

      # Proxy assets through our redirect
      for attr in ['src', 'href'] do
        document.xpath("//head[1]//*[@#{attr}]").each do |element|
          element[attr] = proxy_url(to: element[attr])
        end
      end

      document.to_html
    end
  end
end
