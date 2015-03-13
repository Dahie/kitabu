require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"

require "kitabu"
require "pathname"

SPECDIR = Pathname.new(File.dirname(__FILE__))
TMPDIR = SPECDIR.join("tmp")

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|r| require r}

# Disable the bundle install command.
# TODO: Figure out the best way of doing it so.
class Kitabu::Generator < Thor::Group
  def bundle_install
  end
end

RSpec.configure do |config|
  config.include(SpecHelper)
  config.include(Matchers)

  cleaner = proc do
    [
      TMPDIR,
      SPECDIR.join("support/mybook/output/mybook.pdf"),
      SPECDIR.join("support/mybook/output/mybook.epub"),
      SPECDIR.join("support/mybook/output/mybook.html")
    ].each do |i|
      FileUtils.rm_rf(i) if File.exist?(i)
    end

    Dir.chdir File.expand_path('../..', __FILE__)
  end

  config.before(&cleaner)
  config.after(&cleaner)
  config.before { FileUtils.mkdir_p(TMPDIR) }
end
