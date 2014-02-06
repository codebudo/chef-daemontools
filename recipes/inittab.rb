
svdir_line = "# daemontools \nSV:123456:respawn:#{node['daemontools']['bin_dir']}/svscanboot"

execute "echo '#{svdir_line}' >> /etc/inittab" do
  not_if "grep '#{svdir_line}' /etc/inittab"
end

# start it the first time
#execute "#{node['daemontools']['bin_dir']}/svscanboot &"  do
  #not_if "pgrep svscanboot"
#end
