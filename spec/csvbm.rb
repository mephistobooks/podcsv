require 'csv'
require 'benchmark'
require "podcsv"


#
#FILE='Station_200_000.csv'
FILE=__dir__+'/Station_40_000.csv'
OPT={
  #:force_quotes => true,
  :encoding => 'utf-8:utf-8',
  :col_sep => ',',
}

def csv_read( file, opt )
  CSV.read( file, opt )
end

def podcsv_read( file, opt )
  #fh = File.open( file, opt )
  #fh.read.split(/\n/)
  PodCSV.read( file, {}, lambda{|e| CSV.parse_line(e, opt)} )
end

def csv_read_0
  csv_read( FILE, OPT )
end

def podcsv_read_0
  podcsv_read( FILE, OPT )
end

def read_n_access_last
  a = yield
  ret = []
  #puts "a: #{a.class}"
  #puts "a: #{a.reverse.class}"
  a.reverse[0..399].each{|e|
    ret << e
    #puts "e: #{e}"
    #puts "x: #{x}"
  }
  ret
end

def csv_read_n_access_last_0
  read_n_access_last{ csv_read( FILE, OPT ) }
end

def podcsv_read_n_access_last_0
  read_n_access_last{ podcsv_read( FILE, OPT ) }
end


####
puts "# of records"
puts "   csv: #{csv_read(FILE,OPT).size}"
puts "podcsv: #{podcsv_read(FILE, nil).size}"
#puts csv_read_n_access_last_0
#puts podcsv_read_n_access_last_0


n = 1
puts ""
puts "Benchmark"
puts "read:"
Benchmark.bmbm(8) do |x|
  x.report('csv') { n.times{ csv_read_0 } }
  x.report('podcsv') { n.times{ podcsv_read_0 } }
end

puts ""
puts "access:"
Benchmark.bmbm(8) do |x|
  x.report('csv') { n.times{ csv_read_n_access_last_0 } }
  x.report('podcsv') { n.times{ podcsv_read_n_access_last_0 } }
end

#### endof filename: csv.rb
