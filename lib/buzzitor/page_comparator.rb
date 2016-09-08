class Buzzitor::PageComparator
  class << self
    def compare(old, new)
      contents = [old, new].map do |content| 
        noko = Nokogiri::HTML(content)
        noko.xpath('//body[1]')[0].to_xhtml
      end
      contents[0] == contents[1]
    end
  end
end
