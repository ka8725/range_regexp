require 'set'
require 'range_regexp/version'

module RangeRegexp
  class Converter
    def initialize(range)
      @min, @max = range.first, range.last
      @min, @max = @max, @min unless range.min

      @negative_subpatterns = []
      @positive_subpatterns = []

      init_negative_subpatterns
      init_positive_subpatterns
    end

    def convert(options = {})
      @regexp ||= begin
        anchor = Array(options.fetch(:anchor, {}))
        line_start_anchor = anchor.include?(:start) ? '^' : ''
        line_end_anchor = anchor.include?(:end) ? '$' : ''

        negative_subpatterns_only = arrays_diff(@negative_subpatterns, @positive_subpatterns).map do |pattern|
          "-#{pattern}"
        end
        positive_subpatterns_only = arrays_diff(@positive_subpatterns, @negative_subpatterns)
        intersected_subpatterns = (@positive_subpatterns & @negative_subpatterns).map do |pattern|
          "-?#{pattern}"
        end
        Regexp.new("#{line_start_anchor}#{(negative_subpatterns_only + intersected_subpatterns +
          positive_subpatterns_only).join('|')}#{line_end_anchor}")
      end
    end

    private

    def arrays_diff(a, b)
      a - (a & b)
    end

    def init_negative_subpatterns
      if @min < 0
        @negative_subpatterns = split_to_patterns(@max < 0 ? @max.abs : 1, @min.abs)
        @min = 0
      end
    end

    def init_positive_subpatterns
      if @max >= 0
        @positive_subpatterns = split_to_patterns(@min, @max)
      end
    end

    def split_to_patterns(min, max)
      subpatterns = []
      start = min
      split_to_ranges(min, max).each do |stop|
        subpatterns.push(range_to_pattern(start, stop))
        start = stop + 1
      end
      subpatterns
    end

    def split_to_ranges(min, max)
      stops = Set.new
      stops.add(max)

      nines_count = 1
      stop = fill_by_nines(min, nines_count)
      while min <= stop && stop < max
        stops.add(stop)
        nines_count += 1
        stop = fill_by_nines(min, nines_count)
      end

      zeros_count = 1
      stop = fill_by_zeros(max + 1, zeros_count) - 1
      while min < stop && stop <= max
        stops.add(stop)
        zeros_count += 1
        stop = fill_by_zeros(max + 1, zeros_count) - 1
      end
      stops.to_a.sort
    end

    def fill_by_nines(int, nines_count)
      "#{int.to_s[0...-nines_count]}#{'9' * nines_count}".to_i
    end

    def fill_by_zeros(int, zeros_count)
      int - int % 10 ** zeros_count
    end

    def range_to_pattern(start, stop)
      pattern = ''
      any_digit_count = 0

      start.to_s.split('').zip(stop.to_s.split('')).each do |(start_digit, stop_digit)|
        if start_digit == stop_digit
          pattern += start_digit
        elsif start_digit != '0' || stop_digit != '9'
          pattern += "[#{start_digit}-#{stop_digit}]"
        else
          any_digit_count += 1
        end
      end

      pattern += '\d' if any_digit_count > 0
      pattern += "{#{any_digit_count}}" if any_digit_count > 1

      pattern
    end
  end
end
