class Buzzitor::PageComparator
  class << self
    def compare(old, new, focus = '//body[1]')
      old, new = [old, new].map do |content|
        noko = Nokogiri::HTML(content)
        noko.xpath('//body')[0]
      end
      old_text_nodes, new_text_nodes = [old,new].map do |body|
        collect_text_nodes(body)
      end
      if old_text_nodes.count != new_text_nodes.count
        return false
      end
      old_text_nodes.zip(new_text_nodes) do |a, b|
        return false if a.text != b.text
      end
      return true
    end

    def collect_text_nodes(element)
      text_nodes = []
      if element.is_a? Nokogiri::XML::Element
        child = element.child
        while child
          text_nodes.concat collect_text_nodes(child)
          child = child.next_sibling
        end
      elsif element.is_a? Nokogiri::XML::Text
        return [element]
      end
      return text_nodes
    end
  end
end
