# PodCSV another lazy solution for `csv`

podcsv.gem provides fast access to big CSV file such as several 10 thousand
records. This introduces two classes: Parse-on-demand CSV and Array (PodCSV,
PodArray) and is around 10 times faster than library default 'csv'. You can
also randomly access to the elements (records).

This gem may be useful if you use only very small part (fg. 1 %) of records
in big CSV.


## 1. Benchmark

```
$ bundle exec rake bm

# of records
csv: 40000
podcsv: 40000

Benchmark
read:
Rehearsal --------------------------------------------
csv        4.780000   0.090000   4.870000 (  5.135495)
podcsv     0.270000   0.040000   0.310000 (  0.319921)
----------------------------------- total: 5.180000sec

               user     system      total        real
csv        4.650000   0.070000   4.720000 (  5.041622)
podcsv     0.240000   0.030000   0.270000 (  0.272924)

access:
Rehearsal --------------------------------------------
csv        4.620000   0.060000   4.680000 (  4.919373)
podcsv     0.400000   0.030000   0.430000 (  0.460540)
----------------------------------- total: 5.110000sec

               user     system      total        real
csv        4.660000   0.100000   4.760000 (  4.921194)
podcsv     0.360000   0.020000   0.380000 (  0.399690)
```

### 1.1. Trick

This gem defines two classes: `PodCSV` and `PodArray`.
PodCSV does not parse any strings on reading CSV file and just returns an
array (PodArray).

When you access elements (records) of that array via `[]`, `each`, etc.,
strings are parsed and changed into fields (PodArray cache mechanism).


## 2. Installation

Add this line to your application's Gemfile:

```ruby
gem 'podcsv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install podcsv


## 3. Usage

### (1) Load CSV

Same as `CSV.read`.

```
ret = PodCSV.read( file [, opt_file] )
```

### (2) Access records

Same as Array: `[]`, `each`, `first, last`, etc.

```
ret = PodCSV.read( file [, opt_file] )
puts ret[-1]
```


### (3) Custom Line Parser

```
ary = PodCSV.read( file, {},
                   lambda{|s| s.split(/"/) } )
```


## 4. Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## 5. Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mephistobooks/podcsv.


## 6. License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

