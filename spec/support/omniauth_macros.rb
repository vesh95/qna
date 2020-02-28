module OmniauthMacros
  def github_mock
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '11',
      info: {
        nickname: 'gituser',
        email: 'git@github'
      }
    )
  end

  def vkontakte_mock
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '12',
      'info' => { email: nil }
    )
  end
end
