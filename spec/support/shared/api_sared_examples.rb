shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers, params: request_params ||= nil)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: {access_token: '1234'}, headers: headers)
      expect(response.status).to eq 401
    end
  end # unauthorized
end

shared_examples_for 'public fields returnable' do
  it 'returns public fields' do
    fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for 'private fields returnable' do
  it 'not returns private fields' do
    private_fields.each do |attr|
      expect(resource_response).to_not have_key(attr)
    end
  end
end

shared_examples_for 'unauthorized resource' do
  context 'unauthorized' do
    it 'returns bad status' do
      expect(response).to_not be_successful
    end
  end # unauthorized
end
