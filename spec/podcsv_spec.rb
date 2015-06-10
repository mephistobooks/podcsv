require 'spec_helper'

describe PodCSV do

  before do
    #@test_csv = 'tas-3823_20150520.csv'
    #@test_csv = 'Station.csv'
    @test_csv = 'Station_20_000.csv'
    #@test_csv = 'Station_200_000.csv'
  end

  describe '::VERSION' do
    it 'has a version number' do
      expect(PodCSV::VERSION).not_to be nil
    end
  end

  describe '.read' do
    it 'loads CSV like CSV.read' do
      ret = PodCSV.read(__dir__+'/'+@test_csv)
      #expect(ret.size).to eq(22861)
      expect(ret.size).to eq(20_000)
      #expect(ret.size).to eq(200_000)

      # includes nil, parse double-quoted fields.
      expect(ret[-1].size).to eq(35)
    end
  end

  describe '.read with parser' do
    it 'set custom parser' do
      ary = PodCSV.read(__dir__+'/'+@test_csv, {},
                        lambda{|s| s.split(/"/) } )

      #expect(ary.size).to eq(22861)
      expect(ary.size).to eq(20_000)
      #expect(ary.size).to eq(200_000)

      # force separate comma, not includes nil.
      ret = ary[-1]
      #expect(ret).to eq([]) # to disp
      expect(ret.size).not_to eq(35)
      expect(ret.size).to eq(29)
    end
  end


end
