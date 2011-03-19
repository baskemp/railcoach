module ApplicationHelper
  # Returns an array with role names
  def roles_on_project?(user_id, project_id)
    user = User.find(user_id)
    roles = user.memberships.find(:project_id => project_id).roles
    roles.each { |r| r.name.collect }
  end

  # Timon Vonk
  # Easilly creates an auth url for a network, takes a network as a string. Would be cool if it read omniauth config instead for whitelisting
  def user_auth_helper_path(network)
    # openid needs an url, oauth doesn't
    # network => { :method, :url }
    allowed_networks = {
      :google => {:method => :open_id, :url => "https://www.google.com/accounts/o8/id" }
    }

    if allowed_networks.has_key?(network)
      if allowed_networks[network][:method] == :open_id
        user_omniauth_authorize_path(allowed_networks[network][:method], :openid_url => allowed_networks[network][:url])
      else
        user_omniauth_authorize_path(allowed_networks[network][:method])
      end
    else
      raise 'Unkown authentication method'
    end
  end
end
