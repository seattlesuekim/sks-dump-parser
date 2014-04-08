require 'sks_parser.rb'
describe SksParser::StateMachine do
  it "returns the expected hash" do
    mockdump = []
    File.open('support/mockdump.pgp').each do |line|
      mockdump << line.chomp.gsub(/\t/, '')
    end
    STDERR.puts("mockdump is #{mockdump}")
    expect(SksParser::StateMachine.get_dump_hash_from(mockdump)).to eq({'681D3A753B6C249E' =>{:user =>'Laura Schmitz <laura.schmitz87@icloud.com>',:sigs => ['681D3A753B6C249E']}})
  end
end
