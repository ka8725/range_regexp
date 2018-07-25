require 'minitest/autorun'
require 'range_regexp'

describe RangeRegexp::Converter do
  describe '#convert' do
    def ensure_correct_conversion(range, regexp, options={})
      converter = RangeRegexp::Converter.new(range)
      assert_equal converter.convert(options), regexp
    end

    it 'returns a range representation as a regexp' do
      ensure_correct_conversion(-9..9, /-[1-9]|\d/)
      ensure_correct_conversion(12..3456, /1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6]/)
      ensure_correct_conversion(-2..0, /-[1-2]|0/)
      ensure_correct_conversion(-3..1, /-[1-3]|[0-1]/)
    end
    
    it 'works as expected for reversed ranges' do
      ensure_correct_conversion(9..-9, /-[1-9]|\d/)
      ensure_correct_conversion(3456..12, /1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6]/)
      ensure_correct_conversion(0..-2, /-[1-2]|0/)
      ensure_correct_conversion(1..-3, /-[1-3]|[0-1]/)
    end

    it 'processes options correctly' do
      ensure_correct_conversion(-9..9, /^-[1-9]|\d$/, anchor: :start_and_end)
      ensure_correct_conversion(3456..12, /^1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6]$/, anchor: :start_and_end)
      ensure_correct_conversion(0..-2, /^-[1-2]|0$/, anchor: :start_and_end)
      ensure_correct_conversion(1..-3, /^-[1-3]|[0-1]$/, anchor: :start_and_end)

      ensure_correct_conversion(-9..9, /^-[1-9]|\d/, anchor: :start)
      ensure_correct_conversion(3456..12, /^1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6]/, anchor: :start)
      ensure_correct_conversion(0..-2, /^-[1-2]|0/, anchor: :start)
      ensure_correct_conversion(1..-3, /^-[1-3]|[0-1]/, anchor: :start)

      ensure_correct_conversion(-9..9, /-[1-9]|\d$/, anchor: :end)
      ensure_correct_conversion(3456..12, /1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6]$/, anchor: :end)
      ensure_correct_conversion(0..-2, /-[1-2]|0$/, anchor: :end)
      ensure_correct_conversion(1..-3, /-[1-3]|[0-1]$/, anchor: :end)
    end
  end
end
