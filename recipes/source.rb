#
# Cookbook Name:: daemontools
# Recipe:: source
#
# Copyright 2010-2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

bash "install_daemontools" do
  user "root"
  cwd "/usr/local/src"
  code <<-EOH
    (cd /usr/local/src; curl -O http://cr.yp.to/daemontools/daemontools-0.76.tar.gz)
    (cd /usr/local/src; tar zxvf daemontools-0.76.tar.gz)
    (cd /usr/local/src/admin/daemontools-0.76; perl -pi -e 's/extern int errno;/\#include <errno.h>/' src/error.h)
    (cd /usr/local/src/admin/daemontools-0.76; package/compile)
    (cd /usr/local/src/admin/daemontools-0.76; mv command/* #{node['daemontools']['bin_dir']}/)
    EOH
  not_if {::File.exists?("#{node['daemontools']['bin_dir']}/svscan")}
end

directory node['daemontools']['service_dir'] do
  owner "root"
  group "root"
  mode  "755"
end

if node[:platform_family] == "centos" && node[:platform_version].to_f >= 6.0
  include_recipe "daemontools::upstart"
else
  include_recipe "daemontools::inittab"
end

