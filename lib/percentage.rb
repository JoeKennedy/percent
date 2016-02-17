require 'bigdecimal'
require 'bigdecimal/util'

class Percentage < Numeric
  def initialize(val = 0, options = {})
    val = 0.0            if !val
    val = 1.0            if val == true
    val = val.to_r       if val.is_a?(String) && val['/']
    val = val.to_f       if val.is_a?(Complex) || val.is_a?(Rational)
    val = val.to_i       if val.is_a?(String) && !val['.']
    val = val.to_d / 100 if val.is_a?(Integer) || (val.is_a?(String) && val['%'])
    val = val.value      if val.is_a? self.class

    @value = val.to_d
  end

  ###
  # Attributes
  ###
  def value
    @value ||= 0
  end

  ###
  # Convert percentage to different number formats
  ###
  def to_i; (self.value * 100).to_i; end
  def to_c; self.value.to_c; end
  def to_d; self.value.to_d; end
  def to_f; self.value.to_f; end
  def to_r; self.value.to_r; end

  ###
  # Convert percentage fraction to percent amount
  ###
  def to_complex;  (self.value * 100).to_c; end
  def to_decimal;  (self.value * 100).to_d; end
  def to_float;    (self.value * 100).to_f; end
  def to_rational; (self.value * 100).to_r; end

  ###
  # String conversion methods
  ###
  def to_s;      self.to_amount.to_s; end
  def to_str;    self.to_f.to_s;      end
  def to_string; self.to_s + '%';     end

  def format(options = {})
    # set defaults; all other options default to false
    options[:percent_sign] = options.fetch :percent_sign, true

    if options[:as_decimal]
      return self.to_str
    elsif options[:rounded]
      string = self.to_float.round.to_s
    elsif options[:no_decimal]
      string = self.to_i.to_s
    elsif options[:no_decimal_if_whole]
      string = self.to_s
    else
      string = self.to_float.to_s
    end

    string += ' ' if options[:space_before_sign]
    string += '%' if options[:percent_sign]
    return string
  end

  ###
  # Additional conversion methods
  ###
  def to_amount
    (int = self.to_i) == (float = self.to_float) ? int : float
  end

  def inspect
    "#<#{self.class.name}:#{self.object_id}, #{self.value.inspect}>"
  end

  ###
  # Comparisons
  ###
  def == other
    self.eql?(other) || self.to_f == other
  end

  def eql? other
    self.class == other.class && self.value == other.value
  end

  def <=> other
    self.to_f <=> other.to_f
  end

  ###
  # Mathematical operations
  ###
  [:+, :-, :/, :*].each do |operator|
    define_method operator do |other|
      case other
      when Percentage
        new_value = self.value.public_send(operator, other.value)
        self.class.new new_value
      else
        self.value.to_f.public_send(operator, other)
      end
    end
  end

  ###
  # Additional initialization methods
  ###
  def self.from_fraction(val = 0, options = {})
    val = val.to_i if val.is_a?(String) && !(val['/'] || val['%'] || val['.'])
    val = val.to_d if val.is_a?(Integer)

    self.new val, options
  end

  def self.from_amount(val = 0, options = {})
    val = val.to_r  if val.is_a?(String) && val['/']
    val = val.to_d  if val.is_a?(String)
    val = val / 100 if val.is_a?(Numeric) && !val.integer?

    self.new val, options
  end
end
