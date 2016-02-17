# Percent

## Introduction

This library contains a `Percentage` class to help manage percentages in your
Ruby program

For those using Rails, add 'percentize' to specify which fields you want to
be backed by `Percentage` objects and helpers.

If you find any problems with or have any questions about this library, feel
free to open a new issue. Also feel free to fork this project and contribute to
it.


## Installation

Add this line to your Gemfile:

    gem 'percent'

And then run:

    bundle install

Or, feel free to install it directly:

    gem install percent


## Usage

### `Percentage` class

What is a percentage object? Well, a percentage object contains a BigDecimal
that represents a percentage fraction and is accessible as `value`.

#### Initializing an object

You can initialize a percentage object with a `FixNum`, `Float`, `BigDecimal`,
or any other kind of number, number-formatted string, or even boolean values.

```ruby
# the below are all equivalent to 50%
# calling value on any of them will return a number equal to BigDecimal('0.5')
Percentage.new(50)
Percentage.new(0.50)
Percentage.new(BigDecimal('0.5'))
Percentage.new(Complex(0.5,0))
Percentage.new(Rational(1,2))

Percentage.new("50")
Percentage.new("50%")
Percentage.new("50.0%")
Percentage.new(".5")
Percentage.new("0.5")
Percentage.new("0.5E0")
Percentage.new("1/2")

# you can also pass a bool
Percentage.new(true)  # => 100%
Percentage.new(false) # => 0%
```

The `Percentage` class also provides two additional methods of initialization
which are a bit more consistent in how they translate different number types
into percentages. The first is `from_fraction`, which treats each number like a
fraction when converting it to percentage. It acts the same as the vanilla
`new` method, with the exception of integers and integer-formatted strings:

```ruby
Percentage.from_fraction(50.0) # => 5000%
Percentage.from_fraction(50)   # => 5000%
Percentage.from_fraction(1)    # => 100%
Percentage.from_fraction(0)    # => 0%

Percentage.from_fraction('50.0') # => 5000%
Percentage.from_fraction('50')   # => 5000%
Percentage.from_fraction('1')    # => 100%
Percentage.from_fraction('0')    # => 0%
```

The second additional initialization method is `from_amount`. This treats the
number like it's already a percentage, so it acts on each number the way `new`
acts on integers:

```ruby
# The below are all equivalent
Percentage.from_amount(50)
Percentage.from_amount(50.0)
Percentage.from_amount(BigDecimal(50))
Percentage.from_amount(Rational(100,2))

Percentage.from_amount("50")
Percentage.from_amount("50.0")
Percentage.from_amount('0.5E2')
Percentage.from_amount("200/4")
```

Note that all three methods, `new`, `from_amount`, and `from_fraction`,
treat strings in percent format, i.e. "50%", the same way.

#### Mathematical operations

The `Percentage` class also implements mathematical operations, and percentage
objects can be added, subtracted, multiplied, and divided.

```ruby
percentage = Percentage.new(25)

percentage + percentage # => 50%
percentage - percentage # => 0%
percentage * percentage # => 6.25%
percentage / percentage # => 100%
```

When on percentages and numbers, percentages are treated as floats.

```ruby
percentage = Percentage.new(25)

percentage + 10 # => 10.25
percentage - 10 # => -9.75
percentage * 10 # => 2.5
percentage / 10 # => 0.025

10 + percentage # => 10.25
10 - percentage # => 9.75
10 * percentage # => 2.5
10 / percentage # => 40.0
```

#### Comparions

Percentage objects can be compared to other percentages.

```ruby
percentage = Percentage.new(60)
percentage == percentage # => true
percentage > percentage  # => false
percentage < percentage  # => false
percentage >= percentage # => true
percentage <= percentage # => true

smaller = Percentage.new(40)
smaller == percentage
smaller >
```

#### Conversions

Percentage objects can be converted to most numeric formats. For
numeric conversions it converts to all but Integer as a fraction.

```ruby
percentage = Percentage.new(75)
percentage.to_i # => 75
percentage.to_c # => 0.75E0+0i
percentage.to_d # => 0.75E0
percentage.to_f # => 0.75
percentage.to_r # => (3/4)
```

If you'd like to convert to the percent amount, rather than fraction, for any
non-integer types, use the full name conversion methods.

```ruby
percentage = Percentage.new(75)
percentage.to_complex  # => 0.75E2+0i
percentage.to_decimal  # => 0.75E2
percentage.to_float    # => 75.0
percentage.to_rational # => 75/1
```

String conversions have a couple of caveats and options that allow them to be a
bit more diverse. There are four string conversion method:

```ruby
percentage = Percentage.new(75)
percentage.to_s      # => "75"
percentage.to_str    # => "0.75"
percentage.to_string # => "75%"
percentage.format    # => "75.0%"
```

The `to_s` and `to_string` methods outputs an integer if the percentage amount
is divisible by 100; otherwise they output the exact percentage amount as a
float. To do this, they utilize the `to_amount` method on the percentage object.

```ruby
Percentage.new(75).to_s   # => "75"
Percentage.new(75.0).to_s # => "75"
Percentage.new(75.5).to_s # => "75.5"

Percentage.new(75).to_string   # => "75%"
Percentage.new(75.0).to_string # => "75%"
Percentage.new(75.5).to_string # => "75.5%"

Percentage.new(75).to_amount   # => 75
Percentage.new(75.0).to_amount # => 75
Percentage.new(75.5).to_amount # => 75.5
```

The `format` method allows heavy customization of string output by allowing a
number of options to be passed to it.

```ruby
percentage = Percentage.from_amount(66.66)
percentage.format                             # => "66.66%"
percentage.format(percent_sign: true)         # => "66.66%"
percentage.format(percent_sign: false)        # => "66.66"
percentage.format(as_decimal: true)           # => "0.6666"
percentage.format(rounded: true)              # => "67%"
percentage.format(no_decimal: true)           # => "66%"
percentage.format(no_decimal_if_whole: true)  # => "66.66%"
percentage.format(space_before_sign: true)    # => "66.66 %"
```

Multiple options can be passed to `format`, but a lot of them don't necessarily
make sense when passed together, such as `as_decimal: true` and `no_decimal:
true`, since that will return "0" for any number between 0% and 99%. So instead,
a few options have precedence over others. Namely, passing `as_decimal` ignores
all the other options, and `rounded`, `no_decimal`, and `no_decimal_if_whole`
are used in that order.

```ruby
percentage = Percentage.from_amount(66.66)

# uses each option and returns => "67 "
percentage.format(percent_sign: false, rounded: true, space_before_sign: true)

# uses both options and returns => "66 %"
percentage.format(no_decimal: true, space_before_sign: true)

# uses only as_decimal and returns => "0.6666"
percentage.format(percent_sign: false, as_decimal: true, no_decimal: true)

# uses only rounded and returns => "67%"
percentage.format(no_decimal_if_whole: true, no_decimal: true, rounded: true)

# uses only no_decimal and returns => "66%"
percentage.format(no_decimal_if_whole: true, no_decimal: true)
```

### `percentize` attribute

For those of you also using Rails, you can use turn any decimal attribute into a
percentage using the `percentize` method. If you're not using Rails, feel free
to skip this section!

#### Simple example

To percentize an attribute, just `percentize` before the name of that attribute.
As an example, let's say we have a Survey model and we have
`percent_complete_fraction` as a decimal (i.e. 0.10 is 10%). If we want to
handle it using a `Percentage` object instead:

```ruby
class Survey < ActiveRecord::Base

    percentize :percent_complete_fraction

end
```

With this line of code, a survey object will now have an attribute called
`percent_complete` which is a `Percentage` object. The percentage attribute is
created automatically by removing the `_fraction` suffix from the column name.
Note also that right now that suffix is necessary to create a percentage
attribute.

Assigning a value to the percentage attribute uses the `Percentage` class's
`from_amount` method to generate the percentage. Keep this in mind when
assigning not-integer numbers and strings with decimal points to your attribute

```ruby
# the following are all equivalent to 10%
survey.percent_complete = 10
survey.percent_complete = "10"
survey.percent_complete = 10.0
survey.percent_complete = "10.0"
survey.percent_complete = Rational(100, 10)
survey.percent_complete = "100/10"
survey.percent_complete = BigDecimal.new(10)
survey.percent_complete = "0.1E2"
survey.percent_complete = Complex(10, 0)
survey.percent_complete = Percentage.new(10)
survey.percent_complete = Percentage.from_amount(10.0)
survey.percent_complete = Percentage.from_fraction(0.1)
```

#### Allow nil values

If you want to allow nil and/or blank values to a percentized field, you can use
the `:allow_nil` parameter:

```ruby
# in Survey model
percentize :optional_fraction, allow_nil: true

# in change function in migration
add_percentage :survey, :optional, amount: { null: true, default: nil }

# now blank assignments are permitted
survey.optional = nil
survey.save # returns without error
survey.optional # => nil
survey.optional_fraction # => nil
```

The default value for `:allow_nil` is false

#### Numericality validation options

By default, `percentize` makes sure the percentage is greater than 0 and
less than 100, but passing any
[numericality validation options](http://guides.rubyonrails.org/active_record_validations.html#numericality)
will override that.

```ruby
percentize :in_a_weird_range_fraction, allow_nil: true,
  numericality: { greater_than: -10, less_than: 200 }
```

This will ensure that the percentage is between -10% and 200%. Similarly, you
pass validation for the actual `fraction` column. The below code snippet will
also ensure that the percentage is between -10% and 200%:

```ruby
percentize :in_fraction_range_fraction, allow_nil: true,
  fraction_numericality: { greater_than: -0.1, less_than: 2.0 }
```

If you'd like, you can also skip validatons entirely for the attribute:

```ruby
percentize :sans_validation_fraction, disable_validation: true
```

You can also skip validations independent of each other:

```ruby
percentize :sans_frac_validate_fraction, numericality: false
```


#### Migration helpers

If you want to add a percent complete field to a surveys table, you can use the
`add_percentage` helper. There are multiple ways to do this:

```ruby
class AddPercentCompleteToSurveys < ActiveRecord::Migration
  def change
    add_percentage :surveys, :percent_complete

    # OR

    change_table :surveys do |t|
      t.percentage :percent_complete
    end
  end
end
```

You can also remove a percentage column:

```ruby
class RemovePercentCompleteFromSurveys < ActiveRecord::Migration
  def change
    remove_percentage :surveys, percent_complete
  end
end
```

Or create a new table with a percentage column:

```ruby
class CreateJobTrackers < ActiveRecord::Migration
  def change
    create_table :job_trackers do |t
      # other columns
      t.percentage :percent_complete
    end
  end
end
```

Note that all of these generate a `decimal` column where the percentage is stored as a
fraction, so you can pass any options that a decimal column or any standard
column uses to these methods, like `precision`, `default`, `null`, etc.


## Todo

- Allow other suffixes besides 'fraction' for columns
- Add options for preventing strings and/or bools from being passed to a
  percentage object
