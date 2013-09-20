include_recipe 'nginx::configuration'
include_recipe 'nginx::proxy'

package 'nginx'

service 'nginx' do
	action [ :enable, :start ]
end
