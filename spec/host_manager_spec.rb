require 'host_manager.rb'
require 'tempfile'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end

def fixture(name)
  File.join(File.dirname(__FILE__), 'fixtures', name.to_s)
end

describe HostManager, "#patch" do
  it "returns nil if no changes" do
    host_manager = HostManager.new(fixture(:example_hosts), [], 'tests', '127.0.0.1')
    host_manager.patch.should eq(nil)
  end

  it "migrates existing hosts to own section" do
    host_manager = HostManager.new(fixture(:example_hosts), %w(app.example.lo www.example.lo example.lo), 'tests', '127.0.0.1')
    host_manager.patch.to_s.should eq(
      "127.0.0.1 localhost\n" +
      "\n" +
      "# -----BEGIN SECTION maphosts - tests-----\n" +
      "127.0.0.1 www.example.lo\n" + 
      "127.0.0.1 app.example.lo\n" + 
      "127.0.0.1 example.lo\n" +
      "# -----END SECTION maphosts - tests-----"
    )
  end

  it "updates hosts pointing to the wrong ip" do
    hosts = Tempfile.new('hosts')

    begin
      hosts << (
        "127.0.0.1 localhost\n" +
        "# -----BEGIN SECTION maphosts - tests-----\n" +
        "127.0.0.1 www.example.lo\n" +
        "# -----END SECTION maphosts - tests-----\n"
      )
      hosts.rewind

      host_manager = HostManager.new(hosts.path, %w(www.example.lo), 'tests', '127.0.0.2')
      host_manager.patch.to_s.should eq(
        "127.0.0.1 localhost\n" +
        "# -----BEGIN SECTION maphosts - tests-----\n" +
        "127.0.0.2 www.example.lo\n" + 
        "# -----END SECTION maphosts - tests-----"
      )
    ensure
      hosts.close
      hosts.unlink
    end
  end
end
