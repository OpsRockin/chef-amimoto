require 'ohai'

ohai = Ohai::System.new
ohai.all_plugins

if ['redhat'].include?(ohai.platform)
  include Chef::Mixin::ShellOut

  if ohai.memory[:total].to_i < 1000000
    unless ::File.exist?('/swapfile')
      Chef::Log.info "Create Swapfile"
      system('dd if=/dev/zero of=/swapfile bs=1024 count=2097152 && mkswap /swapfile')
      system('swapon /swapfile')
    end
  end

end

def mount_swap_file
  mount 'swapfile1' do
    action :enable
    mount_point 'none'
    pass 0
    device '/swapfile'
    fstype 'swap'
    only_if { ::File.exists?('/swapfile') }
  end
end
