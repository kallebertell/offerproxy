require_relative '../../services/hashkey_calculator.rb'

module Services
  
  describe 'HashkeyCalculator' do

    it 'creates a correct hash' do 
      hash = HashkeyCalculator.build_hash({c: "val3", b: "val2", a: "val1"}, "key")
      expect(hash).to eq "f6fe486859b71d4ebb9af2170da27df706991f5b"
    end

  end

end