require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/zulip/settings.py') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /EXTERNAL_HOST = 'zulip\.localhost\.local'/ }
  its(:content) { should match /ZULIP_ADMINISTRATOR = 'zulip-admin\@localhost.\local'/ }
  its(:content) { should match /ADMIN_DOMAIN = 'localhost\.local'/ }
  its(:content) { should match /AUTHENTICATION_BACKENDS = \(\n  'zproject\.backends\.EmailAuthBackend',/ }
end

describe process("python") do
  it { should be_running }
  its(:user) { should eq "zulip" }
end

describe process("uwsgi") do
  it { should be_running }
  its(:user) { should eq "zulip" }
  its(:args) { should match /--ini \/etc\/zulip\/uwsgi\.ini/ }
end

describe process("nginx") do
  it { should be_running }
end

describe process("redis-server") do
  it { should be_running }
end

describe process("memcached") do
  it { should be_running }
end

describe process("postgres") do
  it { should be_running }
  its(:user) { should eq "postgres" }
end

describe process("nodejs") do
  it { should be_running }
end

describe process("epmd") do
  it { should be_running }
end

describe port(80) do
  it { should be_listening.on('0.0.0.0').with('tcp') }
end

describe port(443) do
  it { should be_listening.on('0.0.0.0').with('tcp') }
end
