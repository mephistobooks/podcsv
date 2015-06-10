require 'spec_helper'


describe PodArray do

  before do
    @pa_1 = PodArray.new(
      [ [3,2,4].to_csv.chomp,
        [2,1,3].to_csv.chomp, ]
    )
    @exp_1 =  [
      ['3','2','4'],
      ['2','1','3'],
    ]

  end

  describe '#initialize' do
    it 'can initialize with an array' do
      pa = PodArray.new( [3,2,4] )

      expect(pa).to eq([3,2,4])
      expect(pa.class).to eq(PodArray)

      expect(@pa_1.class).to eq(PodArray)
      #expect(PodArray::PARSER_DEFAULT.call("a,b,c",{})).to eq(['a', 'b', 'c', ])
      expect(pa._lazy_parser_default.call("a,b,c")).to eq(['a', 'b', 'c', ])
    end
  end

  describe '#[range] and _cache' do
    it 'can access via basic methods and do cache' do
      pa = PodArray.new( [3,2,4] )
  
      expect(pa._cache).to eq({})
      expect(pa[1]).to eq(2)
      expect(pa.last).to eq(4)
  
      expect(pa[1..2]).to eq([2,4])
      expect(pa[1..2].class).to eq(PodArray)
  
      expect(pa[0..2]).to eq([3,2,4])
      expect(pa[1..2].class).to eq(PodArray)
  
      #
      expect(pa._cache).to eq({ 0 => 3, 1 => 2, 2 => 4, })
  
      expect(pa.first).to eq(3)
      expect(pa.first.class).to eq(Fixnum)
  
      expect(pa.last).to eq(4)
      expect(pa.last.class).to eq(Fixnum)
  
      expect(pa.index(2)).to eq(4)
      expect(pa.index(2).class).to eq(Fixnum)
  
      expect(pa._cache).to eq({ 0 => 3, 1 => 2, 2 => 4, })
    end
  end

  #
  describe '#parse and #reverse' do
    it 'can parse CSV strings and reverse elements' do
      rev = @pa_1.reverse
      expect(rev).to eq( [ '2,1,3', '3,2,4', ] )
      expect(rev._cache).to eq({})

      #
      rev[0]
      expect(rev.class).to eq(PodArray)
      expect(rev).to eq( [ ['2','1','3'], '3,2,4' ] )
      expect(rev._cache).to eq({0 => ['2','1','3']})

      #
      rrg = @pa_1.reverse[0..1]
      expect(rrg.class).to eq(PodArray)
      expect(rrg).to eq([ ['2','1','3'], ['3','2','4'], ])
      expect(rrg._cache).to eq({0 => ['2','1','3'], 1 => ['3','2','4'], })
    end
  end

  describe '#each' do
    it 'has each iterator' do

      # before each operation.
      expect(@pa_1).not_to eq(@exp_1)

      #
      pae = @pa_1.each
      expect(pae.class).to eq(Enumerator)

      tmp = 0
      ret = pae.each{|e|
        tmp += e.last.to_i
      }
      expect(tmp).to eq(7)
      expect(ret.class).to eq(PodArray)

      # after each operation.
      expect(@pa_1).to eq(@exp_1)
      expect(@pa_1[0]).to eq(@exp_1[0])
      expect(@pa_1[1]).to eq(@exp_1[1])
      expect(@pa_1[-1]).to eq(@exp_1[1])
    end
  end

  describe '#map' do
    it 'has map' do
      pa = PodArray.new(
        [ [3,2,4].to_csv.chomp,
          [2,1,3].to_csv.chomp, ]
      )

      ret = pa.map{|e|
        expect(e.class).to eq(Array)
        e
      }
      expect(ret.class).to eq(Array)
    end
  end

  describe '#select' do
    it 'has select' do
      pa = PodArray.new(
        [ [3,2,4].to_csv.chomp,
          [2,1,3].to_csv.chomp, ]
      )

      ret = pa.select{|e|
        expect(e.class).to eq(Array)
        e[0].to_i > 2
      }

      expect(ret.class).to eq(PodArray)
      expect(ret).to eq([['3','2','4']])
    end
  end

end
