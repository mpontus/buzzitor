class Buzzitor::PageProcessor
  class << self
    def process(document, location)
      document = Nokogiri::HTML(document) unless \
        document.kind_of? Nokogiri::XML::Document

      location = URI(location) unless location.kind_of? URI

      # Remove script tags
      document.xpath('//script').each(&:remove)

      # Rewrite relative urls
      for attr in ['src', 'href'] do
        document.xpath("//*[@#{attr}]").each do |element|
          element[attr] = URI.join(location, element[attr]).to_s
        end
      end

      # Add target="_blank" to hyberlinks
      document.xpath('//a[@href]').each do |element|
        element['target'] = '_blank'
      end

      document.to_html
    end
  end
end
