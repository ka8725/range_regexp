require 'minitest/autorun'
require 'range_regexp'

describe RangeRegexp::Converter do
  describe '#convert' do
    def ensure_correct_conversion(range, regexp, options={})
      converter = RangeRegexp::Converter.new(range)
      assert_equal converter.convert(options), regexp
    end

    def ensure_match(options={})
      converter = RangeRegexp::Converter.new(options[:range])
      assert_equal options[:expected_result], (converter.convert(options.reject{|k, v| [:input, :range].include?(k)}) === options[:input])
    end

    it 'returns a range representation as a regexp' do
      ensure_correct_conversion(-9..9, /(-[1-9]|\d)/)
      ensure_correct_conversion(12..3456, /(1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6])/)
      ensure_correct_conversion(-2..0, /(-[1-2]|0)/)
      ensure_correct_conversion(-3..1, /(-[1-3]|[0-1])/)
    end

    it 'works as expected for reversed ranges' do
      ensure_correct_conversion(9..-9, /(-[1-9]|\d)/)
      ensure_correct_conversion(3456..12, /(1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6])/)
      ensure_correct_conversion(0..-2, /(-[1-2]|0)/)
      ensure_correct_conversion(1..-3, /(-[1-3]|[0-1])/)
    end

    it 'processes options correctly' do
      ensure_correct_conversion(-9..9, /^(-[1-9]|\d)$/, anchor:[:start, :end])
      ensure_correct_conversion(3456..12, /^(1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6])$/, anchor: [:start, :end])
      ensure_correct_conversion(0..-2, /^(-[1-2]|0)$/, anchor: [:start, :end])
      ensure_correct_conversion(1..-3, /^(-[1-3]|[0-1])$/, anchor: [:start, :end])

      ensure_correct_conversion(-9..9, /^(-[1-9]|\d)/, anchor: :start)
      ensure_correct_conversion(3456..12, /^(1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6])/, anchor: :start)
      ensure_correct_conversion(0..-2, /^(-[1-2]|0)/, anchor: :start)
      ensure_correct_conversion(1..-3, /^(-[1-3]|[0-1])/, anchor: :start)

      ensure_correct_conversion(-9..9, /(-[1-9]|\d)$/, anchor: :end)
      ensure_correct_conversion(3456..12, /(1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6])$/, anchor: :end)
      ensure_correct_conversion(0..-2, /(-[1-2]|0)$/, anchor: :end)
      ensure_correct_conversion(1..-3, /(-[1-3]|[0-1])$/, anchor: :end)
    end

    it 'evaluates strings against regular expression as expected in common cases' do
      ensure_match(range: -9..9, anchor: [:start, :end], input: '0', expected_result: true)
      ensure_match(range: -999..456, anchor: [:start, :end], input: '123', expected_result: true)
      ensure_match(range: -124..243, anchor: [:start, :end], input: '-123', expected_result: true)
      ensure_match(range: -9..9, anchor: [:start, :end], input: '10', expected_result: false)
    end

    it 'evaluates strings against regular expressions as expected in corner cases' do
      ensure_match(range: -10..10, anchor: [:start, :end], input: '-10', expected_result: true)
      ensure_match(range: -10..10, anchor: [:start, :end], input: '10', expected_result: true)
      ensure_match(range: -10...10, anchor: [:start, :end], input: '-10', expected_result: true)
      ensure_match(range: -10...10, anchor: [:start, :end], input: '9', expected_result: true)
    end

    it 'correctly refuses to match upper bound of exclusive range' do
      ensure_match(range: -10...10, anchor: [:start, :end], input: '10', expected_result: false)
    end

    it 'evaluates false when non numerical characters are used with full anchors' do
      ensure_match(range: -999..999, anchor: [:start, :end], input: 'a12', expected_result: false)
      ensure_match(range: -999..999, anchor: [:start, :end], input: '1a2', expected_result: false)
      ensure_match(range: -999..999, anchor: [:start, :end], input: '12a', expected_result: false)
    end
  end
end
