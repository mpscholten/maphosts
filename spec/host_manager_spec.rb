require 'maphosts/host_manager'
require 'tempfile'

def fixture(name)
  File.join(File.dirname(__FILE__), 'fixtures', name.to_s)
end

describe HostManager, "#patch" do
  it "returns nil if no changes" do
    host_manager = HostManager.new(fixture(:example_hosts), [], 'tests', '127.0.0.1')
    expect(host_manager.patch).to eq(nil)
  end

  it "returns a file object if a patch needs to be applied" do
    host_manager = HostManager.new(fixture(:example_hosts), %w('example.lo'), 'tests', '127.0.0.1')
    expect(host_manager.patch).to be_a Hosts::File
  end

  it "migrates existing hosts to own section" do
    host_manager = HostManager.new(fixture(:example_hosts), %w(app.example.lo www.example.lo example.lo), 'tests', '127.0.0.1')
    expect(host_manager.patch.to_s).to eq(
      "127.0.0.1 localhost\n" +
      "\n" +
      "# -----BEGIN SECTION maphosts - tests-----\n" +
      "127.0.0.1 www.example.lo\n" + 
      "127.0.0.1 app.example.lo\n" + 
      "127.0.0.1 example.lo\n" +
      "# -----END SECTION maphosts - tests-----\n"
    )
  end

  it "updates hosts pointing to the wrong ip" do
    host_manager = HostManager.new(fixture(:hosts_wrong_ip), %w(www.example.lo), 'tests', '127.0.0.2')
    expect(host_manager.patch.to_s).to eq(
      "127.0.0.1 localhost\n" +
      "# -----BEGIN SECTION maphosts - tests-----\n" +
      "127.0.0.2 www.example.lo\n" + 
      "# -----END SECTION maphosts - tests-----\n"
    )
  end

  it "doesnt change existing hosts" do
    host_manager = HostManager.new(fixture(:big_hosts), %w(app.example.lo www.example.lo example.lo), 'tests', '127.0.0.1')
    expect(host_manager.patch.to_s).to eq(
      "# Some comment\n" +
      "127.0.0.1 localhost\n" +
      "::1       localhost\n" +
      "\n" +
      "# Some Stuff\n" +
      "192.0.0.1 myapp.lo\n" +
      "192.0.0.2 mydb.lo\n" +
      "\n" +
      "\n" +
      "# Some other stuff\n" +
      "127.0.0.1 helloworld.lo\n" +
      "# -----BEGIN SECTION maphosts - tests-----\n" +
      "127.0.0.1 app.example.lo\n" + 
      "127.0.0.1 www.example.lo\n" + 
      "127.0.0.1 example.lo\n" +
      "# -----END SECTION maphosts - tests-----\n"
    )
  end

  it "strips of whitespace at the end of file" do
    host_manager = HostManager.new(fixture(:whitespace_hosts), %w(www.example.lo app.example.lo), 'tests', '127.0.0.2')
    expect(host_manager.patch.to_s).to eq(
      "127.0.0.1 localhost\n" +
      "# -----BEGIN SECTION maphosts - tests-----\n" +
      "127.0.0.2 www.example.lo\n" + 
      "127.0.0.2 app.example.lo\n" + 
      "# -----END SECTION maphosts - tests-----\n"
    )
  end
end
