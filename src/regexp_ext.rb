#!/usr/bin/env ruby

require 'test/unit'

class Regexp
  def Regexp.build(*args)
    regexp = []
    args.each do |arg|
      if arg.kind_of?(Numeric)
        regexp << arg
      elsif arg.kind_of?(Range)
        raise "#{args} invalid, only numeric Range is allowed" unless arg.first.kind_of?(Numeric)
        regexp += arg.to_a
      else
        raise "#{arg} not a Numeric or Range"
      end
    end
    regexp.map! { |el| 
      case el
        when  1..9 then "(0?)#{el}"
        when  -9..-1 then "-(0?)#{el.abs}"
        else "#{el}"
      end
    }
    Regexp.compile("^(0?)(#{regexp.join("|")})$")
  end
end

class TestRegexpBuild < Test::Unit::TestCase

  def test_numerics_only
    m = Regexp.build(3,7,10)
    assert("3" =~ m)
    assert("10" =~ m)
    assert_nil("a" =~ m)
    assert_nil("111" =~ m)
  end

  def test_ranges_only
    m = Regexp.build(1..10)
    assert("2" =~ m)
    assert_nil("x" =~ m)
    assert_nil("42" =~ m)
  end

  def test_mixed
    m = Regexp.build(-2,1,10,22,50..100)
    assert("1" =~ m)
    assert("01" =~ m)
    assert("-2" =~ m)
    assert("-02" =~ m)
    assert("22" =~ m)
    assert("64" =~ m)
    assert_nil("0" =~ m)
    assert_nil("42" =~ m)
    assert_nil("155" =~ m)
  end

end

