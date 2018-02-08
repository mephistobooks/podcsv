#
#
#
require 'csv'


class PodArray < Array

  #PARSER_DEFAULT = lambda{|s,opt| CSV.parse_line(s,opt)}
  #PARSER_DEFAULT = lambda{|s| CSV.parse_line(s,@opt)}
  #PARSER_DEFAULT = lambda{|s| CSV.parse_line(s,@opt.to_h)}

  def initialize(args)
    super

    # we can also distinguish which are cached by the type of elements
    # (String or not).
    # But the advantage of having cache structure is that
    # we can know which are the cached elements without traversing
    # whole array.
    #
    @_cache = {}
    if args.class == self.class
      @_cache = args._cache
    end

    # opt for CSV.parse.
    # default is {}, which means that dont change the default behaviour
    # of CSV.parse_line.
    #@opt = {}
    @_lazy_parser_default = lambda{|s| CSV.parse_line(s)}

    #
    #
    #
    #@_lazy_parser = lambda{|x,o| CSV.parse(x,o).first}
    @_lazy_parser = @_lazy_parser_default

  end

  def cached?(i)
    not(@_cache[i].nil?)
  end
  attr_reader   :_cache
  attr_reader   :_lazy_parser_default
  attr_accessor :_lazy_parser
  #attr_accessor :opt

  #
  def [](args)
    ret = nil

    # .
    if args.is_a?(Integer)
      tmp = super

      # cache function.
      if self.cached?(args)

        # do nothing.

      else
        #tmp = super
        #$stderr.puts "*tmp (class:#{tmp.class}):#{tmp}"
        if tmp.class == String

          #@_cache[args] = @_lazy_parser.call(tmp, @opt)
          @_cache[args] = @_lazy_parser.call(tmp)
             self[args] = @_cache[args]

        else
          @_cache[args] = tmp unless self.cached?(args)
        end
      end

      #$stderr.puts "_cache[#{args}]: #{@_cache[args]}"
      @_cache[args]   # return the value of self[args].
      #self[args]
      #self[args] = @_cache[args]

    elsif args.is_a?(Range)
      # Range, etc.
      # $stderr.puts "[INFO] access for #{args} (#{args.class})."

      # copy partial array.
      #idxs = Array(args)
      #pary = idxs.map{|ii| self[ii]}
      b = args.begin
      e = args.end
      e += self.size if args.max.nil?
      rr = unless args.exclude_end?
             b..e
           else
             b...e
           end
      #$stderr.puts "{#{self.class}##{__method__}} args: #{args} / rr: #{rr}"

      pary = super(args)
      ret = PodArray.new(
        # Integer
        pary
      )
      # $stderr.puts "{#{self.class}##{__method__}}"+
      #   " @_cache in ret: #{ret.instance_eval{@_cache}}"+
      #   " (#{ret.instance_eval{@_cache}.class})}"

      # copy partial cache.
      ret.instance_eval{ @_cache = {} }
      _cache.keys.each do |k|
        tmp_k = (k>=0)? k : self.size+k
        val = _cache[k]
        # $stderr.puts "{#{self.class}##{__method__}}"+
        #   " k: #{k}, tmp_k: #{tmp_k} val: #{val} (#{_cache[k]})"

        if rr.include? tmp_k
          new_k = k - b
          ret.instance_eval{ @_cache[new_k] = val }
        end
      end

      ret
    else
      raise "Not yet implemented for #{args.class}"
    end
  end

  def index(x)
    #$stderr.puts "#{self.class}##{__method__} (#{x.class})"
    self[x]
  end

  def first
    #$stderr.puts "#{self.class}##{__method__} ()"
    # self.index(0)
    self[0]
  end

  def last
    #$stderr.puts "#{self.class}##{__method__} ()"
    self[self.size-1]
  end

  def reverse
    #$stderr.puts "#{self.class}##{__method__} ()"
    ret = PodArray.new(super)
    #$stderr.puts "#{self.class}##{__method__} ret: #{ret.class}"
    #$stderr.puts "#{self.class}##{__method__} ret.first: #{ret.first.class}"

    ret
  end

  #
  def each
    s = self
    a = Array(s.to_a)   # cast to Array.

    #$stderr.puts "s: #{s.class}"
    #$stderr.puts "a: #{a.class}"
    #pp a

    # do cache.
    a.each.with_index {|_,i|
      # $stderr.puts "i: #{i}"
      self[i]   # do cache.
      yield(self[i]) if block_given?
    }

    # return
    if block_given?
      self
    else
      self.to_enum
    end
  end

  def map
    tmp = self.each
    ret = []

    tmp.each{|e|
      ret << yield(e) if block_given?
    }

    # return
    if block_given?
      ret
    else
      tmp
    end

  end

  def select
    tmp = self.each
    ret = []

    tmp.each{|e|
      # $stderr.puts "#{e} (#{e.class})"
      if block_given?
        ret << e if yield(e)
      end
    }

    # return
    if block_given?
      PodArray.new(ret)
    else
      tmp
    end

  end


end


#
#
#
class PodCSV

  #
  # ==== Return
  #
  def self.read( file, opt_file = {}, line_parser = nil )
    #@opt_csv = opt_csv
    ret = PodArray.new( File.open(file,opt_file).read.split(/\n/) )
    #ret.opt = @opt_csv
    ret._lazy_parser = line_parser unless line_parser.nil?
    ret
  end
end

require 'podcsv/version'


####
