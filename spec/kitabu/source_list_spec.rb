require 'spec_helper'

describe Kitabu::SourceList do
  let(:root) { SPECDIR.join("support/mybook") }
  let(:format) { Kitabu::Exporter::HTML.new(root) }
  let(:entries) { source_list.entries }
  let(:source) { root.join("text") }
  let(:relative) { entries.collect {|e| e.to_s.gsub(/^#{Regexp.escape(source.to_s)}\//, "")} }
  subject(:source_list) { Kitabu::SourceList.new(root) }

  describe '#source_directory' do
    context 'source_directory defined in configuration' do
      it 'defaults uses defined directory' do
        allow(Kitabu).to receive(:config)
          .and_return({ source_directory: 'source' })
        expect(source_list.source).to eq(root.join('source'))
      end
    end

    context "source_directory not defined in configuration" do
      it 'defaults to "text"' do
        expect(source_list.source).to eq(root.join('text'))
      end
    end
  end

  context "when filtering entries" do
    it "skips dot directories" do
      expect(relative).not_to include(".")
      expect(relative).not_to include("..")
    end

    it "skips dot files" do
      expect(relative).not_to include(".gitkeep")
    end

    it "skips files that start with underscore" do
      expect(relative).not_to include("_00_Introduction.md")
    end

    it "skips other files" do
      expect(relative).not_to include("CHANGELOG.md")
      expect(relative).not_to include("TOC.md")
    end

    it "returns only first-level entries" do
      expect(relative).not_to include("03_With_Directory/Some_Chapter.md")
    end

    it "returns entries" do
      expect(relative.first).to eq("01_Markdown_Chapter.md")
      expect(relative.second).to eq("02_ERB_Chapter.md.erb")
      expect(relative.third).to eq("03_With_Directory")
      expect(relative.fourth).to be_nil
    end
  end
end
