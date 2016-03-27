require "lib/magnetizer.rb"

describe "The magnetizer" do
  context "for a bad file" do
    it "should error on loading the magnetizer with a non-existant file" do
      file = "notafile"
      expect{Magnetizer.new(file)}.to raise_error(RuntimeError)
    end

    it "should error on loading the magnetizer with a file of an unsupported language" do
      pending "Not yet implemented"

      file = "spec/unsupported_language/hello.py"
      expect{Magnetizer.new(file)}.to raise_error(UnsupportedLanguageError)
    end
  end
end

shared_examples "a correct magnetizer" do 
  it "should load the magnetizer" do
    expect(Magnetizer.new(file)).to be_a(Magnetizer)
  end

  it "prints the magnets in the old format" do
    magnetizer = Magnetizer.new(file)
    expect{magnetizer.print_magnets}.to output(magnet_output).to_stdout
  end

  it "loads the magnets in the new data structure" do
    magnetizer = Magnetizer.new(file)
    expect(magnetizer.get_magnets).to eq(data_structure)
  end

  it "should serialize to json" do
    magnetizer = Magnetizer.new(file)
    expect(JSON.pretty_generate(magnetizer.get_magnets)).to eq(json_output)
  end

  it "should serialize to xml" do
    pending "Not yet implemented"

    magnetizer = Magnetizer.new(file)
    expect(magnetizer.get_magnets.to_xml).to eq(xml_output)
  end
end 

