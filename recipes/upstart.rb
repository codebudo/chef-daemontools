
template "/etc/init/svscan.conf" do
  source "svscan.conf.erb"
  owner "root"
  group "root"
  mode "0755"
end

bash "restart_daemontools" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   (initctl reload-configuration && initctl start svscan)
  EOH
  not_if "pgrep svscan"
end
