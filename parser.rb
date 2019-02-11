require 'nokogiri'
require 'nikkou'
require_relative 'node_finder'
require_relative 'custom_errors'

module NokogiriNotepad
  class Parser
    attr_accessor :accepted_extensions
    attr_reader :file_path, :single_targets, :multiple_targets

    def initialize(file_path, single_targets, multiple_targets, extensions = nil)
      @file_path = file_path
      @single_targets = single_targets
      @multiple_targets = multiple_targets
      @accepted_extensions = [".xml"]
      add_extensions(extensions) if extensions
      validate_input
      doc = load_nokogiri_doc file_path
      @node_finder = NodeFinder.new doc
      initialize_data
      doc = nil
      @node_finder = nil
    end
    
    def extensions
      @accepted_extensions
    end

    private

    def add_extensions(extensions)
      raise ExtensionArgumentMustBeArray unless extensions.kind_of?(Array)
      extensions.each do |ext| 
        raise ExtensionElementsMustBeStrings unless ext.kind_of? String
        @accepted_extensions << ext
      end
    end

    def validate_input
      validate_file_path
      validate_targets
    end

    def validate_file_path
      raise InvalidFileName, "#{file_path} is too long" unless file_path.length < 255
      raise InvalidFileName unless File.file?(file_path)
      raise InvalidExtension unless extension_valid?
    end

    def validate_targets
      raise InvalidDataTypeForTargets unless single_targets.kind_of?(Hash)
      raise InvalidDataTypeForTargets unless multiple_targets.kind_of?(Hash)

    end

    def load_nokogiri_doc(file_path)
      Nokogiri::XML(File.open(file_path))
    end

    def initialize_data
      initialize_single_target_data
      initialize_multiple_target_data
    end

    def initialize_single_target_data
      @single_targets.each do |key, path|
        self.instance_variable_set("@#{key}", data_at_attr(key))
        create_method(key) { self.instance_variable_get("@#{key}") }
      end
    end

    def data_at_attr(target)
      path = @single_targets[target]
      node = @node_finder.find_node_at(*path)
      node.nil? ? nil : node.content.strip
    end

    def initialize_multiple_target_data
      @multiple_targets.each do |key, path|
        self.instance_variable_set("@#{key}", multiple_data_at_attr(key))
        create_method(key) { self.instance_variable_get("@#{key}") }
      end
    end

    def multiple_data_at_attr(target)
      path = @multiple_targets[target]
      nodes = @node_finder.find_grouped_nodes_at(*path)
      return nil if nodes.nil? || nodes.empty?
      nodes.map do |node|
        node.nil? ? nil : node.content.strip
      end
    end

    def create_method(name, &block)
      self.class.send(:define_method, name, &block)
    end

    def extension_valid?
      accepted_extensions.include? File.extname(file_path)
    end
  end
end