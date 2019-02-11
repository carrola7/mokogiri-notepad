require_relative "tc_helper"

class BasicTest < Minitest::Test
  def setup
    @file_path = "#{File.dirname(__FILE__)}/test_files/xslplanes.1.xml"
    @doc = Nokogiri::XML(File.open(@file_path))
    @file_path2 = "#{File.dirname(__FILE__)}/test_files/xslplanes.2.xml"
    @doc2 = Nokogiri::XML(File.open(@file_path2))
    @file_path3 = "#{File.dirname(__FILE__)}/test_files/xslplanes.3.xml"
    @doc3 = Nokogiri::XML(File.open(@file_path3))
  end

  def test_initialize_node_finder
    node_finder = NokogiriNotepad::NodeFinder.new @doc
    assert_equal(NokogiriNotepad::NodeFinder, node_finder.class)
  end

  def test_initialize_node_finder_with_invalid_doc
    node_finder = NokogiriNotepad::NodeFinder.new nil 
    assert_equal(NokogiriNotepad::NodeFinder, node_finder.class)
  end

  def test_find_node_at_when_doc_is_nil
    node_finder = NokogiriNotepad::NodeFinder.new nil
    node = node_finder.find_node_at 'path'
    assert_nil(node)
  end

  def test_find_grouped_nodes_at_when_doc_is_nil
    node_finder = NokogiriNotepad::NodeFinder.new nil
    node = node_finder.find_grouped_nodes_at 'path'
    assert_nil(node)
  end

  def test_find_node_when_invalid_path_given
    node_finder = NokogiriNotepad::NodeFinder.new @doc
    node = node_finder.find_node_at 'path'
    assert_nil(node)
  end

  def test_find_grouped_node_at_when_invalid_path_given
    node_finder = NokogiriNotepad::NodeFinder.new @doc
    node = node_finder.find_grouped_nodes_at 'path'
    assert_nil(node)
  end

  def test_find_node_at_returns_expected_string
    node_finder = NokogiriNotepad::NodeFinder.new @doc
    node = node_finder.find_node_at "/plane/make"
    assert_equal("Cessna", node.content.strip)
  end

  def test_find_node_at_returns_expected_string_when_code_and_tagname_given
    node_finder = NokogiriNotepad::NodeFinder.new @doc2
    node = node_finder.find_node_at "/planes/plane/foo", "four", "color"
    assert_equal("Blue", node.content.strip)
  end

  def test_find_node_at_when_invalid_code_and_tag_name_given
    node_finder = NokogiriNotepad::NodeFinder.new @doc2
    node = node_finder.find_node_at '/planes/plane/foo', 'path', 'path'
    assert_nil(node)
  end

  def test_find_node_at_when_all_args_are_invalid
    node_finder = NokogiriNotepad::NodeFinder.new @doc2
    node = node_finder.find_node_at 'path', 'path', 'path'
    assert_nil(node)
  end

  def test_find_grouped_nodes_at_when_invalid_code_and_tag_name_given
    node_finder = NokogiriNotepad::NodeFinder.new @doc2
    node = node_finder.find_grouped_nodes_at '/planes/plane/foo', 'path', 'path'
    assert_nil(node)
  end

  def test_find_grouped_nodes_at_when_all_args_are_invalid
    node_finder = NokogiriNotepad::NodeFinder.new @doc2
    node = node_finder.find_grouped_nodes_at 'path', 'path', 'path'
    assert_nil(node)
  end

  def test_find_grouped_nodes_at_when_all_args_are_invalid
    node_finder = NokogiriNotepad::NodeFinder.new @doc2
    node = node_finder.find_grouped_nodes_at 'path', 'path', 'path'
    assert_nil(node)
  end

  def test_find_grouped_nodes_at_when_valid_path
    node_finder = NokogiriNotepad::NodeFinder.new @doc3
    nodes = node_finder.find_grouped_nodes_at '/planes/plane/year'
    nodes = nodes.map { |n| n.nil? ? nil : n.content.strip}
    assert_equal(["1977", "1975", "1960", "1956", "1977_2", "1975_2", "1960_2", "1956_2"], nodes)
  end

  def test_find_grouped_nodes_at_when_valid_args
    node_finder = NokogiriNotepad::NodeFinder.new @doc3
    nodes = node_finder.find_grouped_nodes_at '/planes/plane/foo', 'four', 'color'
    nodes = nodes.map { |n| n.nil? ? nil : n.content.strip}
    assert_equal(["Blue", "Blue_2"], nodes)
  end
end
