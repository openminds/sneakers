service "nginx"

# include_recipe "apt"

# apt_repository "nginx" do
#   uri "http://nginx.org/packages/debian"
#   distribution "squeeze"
#   components ["nginx"]
#   key "http://nginx.org/packages/keys/nginx_signing.key"
#   action :add
# end

package "nginx"

include_recipe "nginx::configuration"
include_recipe "nginx::proxy"
