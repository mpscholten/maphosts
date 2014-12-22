require 'host_manager.rb'
require 'tempfile'

def fixture(name)
  File.join(File.dirname(__FILE__), 'fixtures', name.to_s)
end

describe HostManager, "#patch" do
  it "returns nil if no changes" do
    host_manager = HostManager.new(fixture(:example_hosts), [], 'tests', '127.0.0.1')
    expect(host_manager.patch).to eq(nil)
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
      "# -----END SECTION maphosts - tests-----"
    )
  end

  it "updates hosts pointing to the wrong ip" do
    host_manager = HostManager.new(fixture(:hosts_wrong_ip), %w(www.example.lo), 'tests', '127.0.0.2')
    expect(host_manager.patch.to_s).to eq(
      "127.0.0.1 localhost\n" +
      "# -----BEGIN SECTION maphosts - tests-----\n" +
      "127.0.0.2 www.example.lo\n" + 
      "# -----END SECTION maphosts - tests-----"
    )
  end
end
