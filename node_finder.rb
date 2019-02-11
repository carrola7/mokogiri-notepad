module NokogiriNotepad
  class NodeFinder
    def initialize(doc)
      @doc = doc
    end

    def find_node_at(path, code=nil, tag_name=nil)
      begin
        nodes = @doc.remove_namespaces!.xpath(render(path))
      rescue NoMethodError
        return nil
      end

      if !(code || tag_name)
        node = nodes.first || nil
      else
        matching_nodes = nodes.select do |node|
                         return nil if node.nil?
                         node.children.to_s.try(:strip) == code
                       end
        return nil if matching_nodes.first.nil?
        return nil if matching_nodes.first.parent.at(".//#{tag_name}").nil?

        node = matching_nodes.first.parent.at(".//#{tag_name}")
      end
      node
    end

    def find_grouped_nodes_at(path, code=nil, tag_name=nil)
      begin
        nodes = @doc.remove_namespaces!.xpath(render(path))
      rescue NoMethodError
        return nil
      end

      return nil if nodes.empty?

      if !(code || tag_name)
        node = nodes.first || nil
      else
        matching_nodes = nodes.select do |node|
                         return nil if node.nil?
                         node.children.to_s.try(:strip) == code
                       end

        return nil if matching_nodes.first.nil?
        return nil if matching_nodes.first.parent.at(".//#{tag_name}").nil?

        nodes = matching_nodes.map do |node|
          node.parent.at(".//#{tag_name}")
        end
      end
      nodes
    end

    private

    def render(path)
      path.gsub(/\//, "//")
    end
  end
end