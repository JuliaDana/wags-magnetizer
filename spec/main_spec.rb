require_relative "../lib/magnetizer.rb"

describe "The magnetizer" do
  context "for a bad file" do
    it "should error on loading the magnetizer with a non-existant file" do
      file = "notafile"
      expect{Magnetizer::Magnetizer.new(file)}.to raise_error(RuntimeError)
    end

    it "should error on loading the magnetizer with a file of an unsupported language" do
      file = "spec/unsupported_language/hello.rb"
      expect{Magnetizer::Magnetizer.new(file, "Ruby")}.to raise_error(Magnetizer::UnsupportedLanguageError)
    end
  end
end

shared_examples "a correct magnetizer" do 
  before :each do
    @magnetizer = Magnetizer::Magnetizer.new(file, language)
  end
  
  it "should load the magnetizer" do
    expect(@magnetizer).to be_a(Magnetizer::Magnetizer)
  end

  it "prints the magnets in the old format" do
    pending "No comparison provided" unless magnet_output
    expect{@magnetizer.print_magnets}.to output(magnet_output).to_stdout
  end

  it "loads the magnets in the new data structure" do
    pending "No comparison provided" unless data_structure
    expect(@magnetizer.get_magnets).to eq(data_structure)
  end

  it "should serialize to json" do
    pending "No comparison provided" unless json_output
    expect(JSON.pretty_generate(@magnetizer.get_magnets)).to eq(json_output)
  end

  it "should serialize to yaml" do
    pending "No comparison provided" unless yaml_output
    expect(YAML.dump(@magnetizer.get_magnets)).to eq(yaml_output)
  end
end 

