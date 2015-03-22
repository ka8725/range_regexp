require 'minitest/autorun'
require 'range_regexp'

describe RangeRegexp::Converter do
  describe '#convert' do
    def ensure_correct_convertation(range, regexp)
      converter = RangeRegexp::Converter.new(range)
      assert_equal converter.convert, regexp
    end

    it 'returns a range representation as a regexp' do
      ensure_correct_convertation(-9..9, /-[1-9]|\d/)
      ensure_correct_convertation(12..3456, /1[2-9]|[2-9]\d|[1-9]\d{2}|[1-2]\d{3}|3[0-3]\d{2}|34[0-4]\d|345[0-6]/)
      ensure_correct_convertation(-2..0, /-[1-2]|0/)
      ensure_correct_convertation(-3..1, /-[1-3]|[0-1]/)
    end
  end
end
