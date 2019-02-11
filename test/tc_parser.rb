require_relative "tc_helper"

class BasicTest < Minitest::Test
  def setup
    @file_path = "#{File.dirname(__FILE__)}/test_files/xslplanes.1.xml"
    @file_path2 = "#{File.dirname(__FILE__)}/test_files/xslplanes.2.xml"
    @file_path3 = "#{File.dirname(__FILE__)}/test_files/xslplanes.3.xml"
    @file_path4 = "#{File.dirname(__FILE__)}/test_files/xslplanes.1.xmx"
    @long_file_path = "#{File.dirname(__FILE__)}/test_files/xslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanesxslplanes.xml"

    @single_targets = { "year" => ["/plane/year"], "make" => ["/plane/make"] }
    @single_targets2 = { "color" => ["/planes/plane/foo", "four", "color"], "model" => ["/planes/plane/foo", "two", "model"] }
    @multiple_targets = { "multiple_year" => ["/plane/year"], "multiple_make" => ["/plane/make"] }
    @multiple_targets2 = { "multiple_color" => ["/planes/plane/foo", "four", "color"], "multiple_model" => ["/planes/plane/foo", "three", "model"] }
  end

  def test_initializing_with_invalid_xml_file
    invalid_path = "#{File.dirname(__FILE__)}/test_files/invalid.xml"
    parser = NokogiriNotepad::Parser.new(invalid_path, @single_targets, @multiple_targets)
    assert_nil(parser.year)
    assert_nil(parser.make)
  end

  def test_inititalizing_with_valid_extension_adds_extensions_to_accepted_extensions
    extensions = [".foo", ".bar"]
    parser = NokogiriNotepad::Parser.new(@file_path, @single_targets, @multiple_targets, extensions)
    assert_equal(parser.extensions, [".xml", ".foo", ".bar"])
  end

  def test_inititalizing_with_invalid_extension_raises_error
    extensions = ".foo"
    assert_raises NokogiriNotepad::ExtensionArgumentMustBeArray do
      NokogiriNotepad::Parser.new(@file_path, @single_targets, @multiple_targets, extensions)
    end
  end

  def test_initializing_with_invalid_extension_objects_raises_error
    extensions = [[".foo"]]
    assert_raises NokogiriNotepad::ExtensionElementsMustBeStrings do
      NokogiriNotepad::Parser.new(@file_path, @single_targets, @multiple_targets, extensions)
    end
  end

  def test_initializing_with_invalid_single_targets_raises_error
    assert_raises NokogiriNotepad::InvalidDataTypeForTargets do
      NokogiriNotepad::Parser.new(@file_path, "foo", @multiple_targets)
    end
  end

  def test_initializing_with_invalid_multiple_targets_raises_error
    assert_raises NokogiriNotepad::InvalidDataTypeForTargets do
      NokogiriNotepad::Parser.new(@file_path, @single_targets, "foo")
    end
  end

  def test_initializing_with_long_file_path_raises_error
    assert_raises NokogiriNotepad::InvalidFileName do
      NokogiriNotepad::Parser.new(@long_file_path, @single_targets, @multiple_targets)
    end
  end

  def test_parser_has_correct_attributes
    parser = NokogiriNotepad::Parser.new(@file_path, @single_targets, @multiple_targets)
    assert_equal(parser.year, "1977")
    assert_equal(parser.make, "Cessna")
  end

  def test_parser_has_correct_attributes_for_single_targets
    parser = NokogiriNotepad::Parser.new(@file_path, @single_targets, @multiple_targets)
    assert_equal(parser.year, "1977")
    assert_equal(parser.make, "Cessna")
  end

  def test_parser_has_correct_attributes_for_single_targets_with_targeted_node
    parser = NokogiriNotepad::Parser.new(@file_path2, @single_targets2, @multiple_targets)
    assert_equal(parser.color, "Blue")
    assert_equal(parser.model, "Apache")
  end

  def test_parser_has_correct_attributes_for_multiple_targets
    parser = NokogiriNotepad::Parser.new(@file_path2, @single_targets, @multiple_targets)
    assert_equal(parser.multiple_year, ["1977", "1975", "1960", "1956"])
    assert_equal(parser.multiple_make, ["Cessna", "Piper", "Cessna", "Piper"])
  end

  def test_parser_has_correct_attributes_for_multiple_targets_with_targeted_node
    parser = NokogiriNotepad::Parser.new(@file_path3, @single_targets, @multiple_targets2)
    assert_equal(parser.multiple_color, ["Blue", "Blue_2"])
    assert_equal(parser.multiple_model, ["Centurian", "Centurian_2"])
  end

  def test_parser_throws_error_if_initialized_with_invalid_extension_file
    assert_raises NokogiriNotepad::InvalidExtension do
      parser = NokogiriNotepad::Parser.new(@file_path4, @single_targets, @multiple_targets2)
    end
  end

  def test_parser_has_correct_attributes_when_extension_defined
    def test_parser_has_correct_attributes_for_single_targets
      parser = NokogiriNotepad::Parser.new(@file_path4, @single_targets, @multiple_targets, [".xmx"])
      assert_equal(parser.year, "1977")
      assert_equal(parser.make, "Cessna")
    end
  end
  
end