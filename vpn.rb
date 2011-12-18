dep 'L2TP IPSec VPN' do
  requires 'openswan configured', 'openswan booting on startup'
  requires 'xl2tpd configured'
  requires 'ppp configured'
end

dep 'openswan.managed' do
  requires 'lsof.managed'
  provides 'ipsec'
end

dep 'xl2tpd.managed' do
end

dep 'ppp.managed' do
  provides 'pppd'
end

dep 'openswan booting on startup' do
  met? {
    not Dir.glob('/etc/rc*/*ipsec').empty?
  }
  meet {
    #TODO: Refactor
    `sudo update-rc.d ipsec defaults`
  }
end

dep 'lsof.managed' do
end

dep 'openswan configured' do
  requires 'openswan.managed'
  define_var :server_ip, :default => Utilities.local_ip
  met? {
    Babushka::Renderable.new('/etc/ipsec.conf').from?(dependency.load_path.parent / 'vpn/ipsec.conf.erb') and
    Babushka::Renderable.new('/etc/ipsec.secrets').from?(dependency.load_path.parent / 'vpn/ipsec.secrets.erb') and
    Babushka::Renderable.new('/etc/ipsec.d/l2tp-psk.conf').from?(dependency.load_path.parent / 'vpn/l2tp-psk.conf.erb') and
    Babushka::Renderable.new('/etc/sysctl.d/30-openswan-network-config.conf').from?(dependency.load_path.parent / 'vpn/openswan.conf.erb')
  }
  meet {
    render_erb 'vpn/ipsec.conf.erb', :to => '/etc/ipsec.conf', :sudo => true
    render_erb 'vpn/ipsec.secrets.erb', :to => '/etc/ipsec.secrets', :sudo => true
    render_erb 'vpn/l2tp-psk.conf.erb', :to => '/etc/ipsec.d/l2tp-psk.conf', :sudo => true
    render_erb 'vpn/openswan.conf.erb', :to => '/etc/sysctl.d/30-openswan-network-config.conf', :sudo => true
  }
end

dep 'xl2tpd configured' do
  requires 'xl2tpd.managed', 'iptables masquerade'
  met? {
    Babushka::Renderable.new('/etc/xl2tpd/xl2tpd.conf').from?(dependency.load_path.parent / 'vpn/xl2tpd.conf.erb')
  }
  meet {
    render_erb 'vpn/xl2tpd.conf.erb', :to => '/etc/xl2tpd/xl2tpd.conf', :sudo => true
  }
end

dep 'ppp configured' do
  requires 'ppp.managed'
  met? {
    Babushka::Renderable.new('/etc/ppp/options.xl2tpd').from?(dependency.load_path.parent / 'vpn/ppp-options.xl2tpd.erb') and
    Babushka::Renderable.new('/etc/ppp/chap-secrets').from?(dependency.load_path.parent / 'vpn/chap-secrets.erb')
  }
  meet {
    render_erb 'vpn/ppp-options.xl2tpd.erb', :to => '/etc/ppp/options.xl2tpd', :sudo => true
    render_erb 'vpn/chap-secrets.erb', :to => '/etc/ppp/chap-secrets', :sudo => true
  }
end

dep 'iptables masquerade' do
  met? {
    Babushka::Renderable.new('/etc/init.d/masquerade').from?(dependency.load_path.parent / 'vpn/masquerade.erb') and
    File.executable?('/etc/init.d/masquerade') and
    not Dir.glob('/etc/rc*/*masquerade').empty?
  }
  meet {
    render_erb 'vpn/masquerade.erb', :to => '/etc/init.d/masquerade', :sudo => true
    File.chmod 0755, '/etc/init.d/masquerade'
    #TODO: Refactor
    `sudo update-rc.d masquerade defaults`
  }
end
