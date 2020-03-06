require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:request_params) { { access_token: access_token.token } }
    let(:method) { :get }
    let!(:questions) { create_list(:question, 2) }

    it_behaves_like 'API Authorizable'

    before { do_request method, api_path, params: request_params, headers: headers }

    it { expect(response).to be_successful }

    it 'returns list of 2 questions' do
      expect(json_response['questions'].count).to eq 2
    end

    include_examples 'public fields returnable' do
      let(:fields) { %w[title body created_at updated_at user_id] }
      let(:resource_response) { json_response['questions'][0] }
      let(:resource) { questions[0] }
    end

  end # desc GET /api/v1/questions

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_files, links: [build(:link)], comments: [build(:comment)]) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:request_params) { { access_token: access_token.token } }


    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { do_request :get, api_path, params: request_params, headers: headers }

    it { expect(response).to be_successful }

    let(:resource) { question }
    let(:private_fields) { %w[password encrypted_password] }

    it_behaves_like 'public fields returnable' do
      let(:fields) { %w[title body created_at updated_at] }
      let(:resource_response) { json_response['question'] }
    end

    include_examples 'private fields returnable' do
      let(:resource_response) { json_response['question']['user'] }
    end

    describe 'links' do
      let(:fields) { %w[url] }
      let(:resource_response) { json_response['question']['links'][0] }
      let(:resource) { question.links[0] }
      include_examples 'public fields returnable'
    end

    describe 'comments' do
      let(:fields) { %w[text created_at updated_at] }
      let(:resource_response) { json_response['question']['comments'][0] }
      let(:resource) { question.comments[0] }
      include_examples 'public fields returnable'
    end

    describe 'comments user' do
      let(:resource_response) { json_response['question']['comments'][0]['user'] }
      include_examples 'private fields returnable'
    end
  end # desc GET /api/v1/questions/:id

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question, answers: create_list(:answer, 2)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:request_params) { { access_token: access_token.token } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { do_request(:get, api_path, params: request_params, headers: headers) }

    it { expect(response).to be_successful }

    it 'returns right count questions' do
      expect(json_response['answers'].count).to eq 2
    end

    it 'returns all public attributes' do
      %w[body created_at updated_at user].each do |attr|
        expect(json_response['answers'][0]).to have_key(attr)
      end
    end

    it 'not returns private user attributes' do
      %w[password encrypted_password].each do |attr|
        expect(json_response['answers'][0]['user']).to_not have_key(attr)
      end
    end
  end  # desc GET /api/v1/questions/:id/answers

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions/" }
    let(:method) { :post }
    let(:request_params) { { access_token: access_token.token, question: question } }

    it_behaves_like 'API Authorizable'

    context 'successful create' do
      let(:question) { { title: 'MyTitle', body: 'MyBody' } }

      before { do_request(method, api_path, params: request_params, headers: headers) }

      it { expect(response).to be_successful }

      include_examples 'public fields returnable' do
        let(:fields) { %w[title body created_at updated_at] }
        let(:resource_response) { json_response['question'] }
        let(:resource) { Question.first }
      end
    end

    context 'tries create with errors' do
      let(:question) { { title: 'MyTitle', body: '' } }

      before { do_request(method, api_path, params: request_params, headers: headers) }

      it 'returns failed status' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        expect(json_response['errors']).to have_key('body')
      end
    end
  end # desc POST /api/v1/questions

  describe 'PATCH /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable' do
      let(:request_params) { { access_token: access_token.token, question: question } }
      let(:question) { create(:question) }
    end

    before { do_request method, api_path, params: request_params, headers: headers}

    context 'authorized' do
      let(:question) { create(:question, user: me) }
      let(:request_params) { {
        access_token: access_token.token,
        question: { title: 'ChangedTitle' }
      } }


      it 'returns success status' do
        expect(response).to be_successful
      end

      it 'unset attributes not be blank' do
        expect(json_response['question']['body']).to_not be_empty
      end

      include_examples 'public fields returnable' do
        let(:fields) { %w[title body created_at updated_at] }
        let(:resource_response) { json_response['question'] }
        let(:resource) { Question.find(question.id) }
      end
    end # authorized

    include_examples 'unauthorized resource' do
      let(:question) { create(:question) }
      let(:request_params) { { access_token: access_token.token } }
    end
  end # PATCH /api/v1/questions/:id

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }
    let(:request_params) { { access_token: access_token.token } }
    before { do_request method, api_path, params: request_params, headers: headers}

    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question) }
    end

    include_examples 'unauthorized resource' do
      let(:question) { create(:question) }
    end

    context 'authorized' do
      let(:question) { create(:question, user: me) }

      it 'returns successful status' do
        expect(response).to be_successful
      end

      it 'question not founded' do
        expect { Question.find(question.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      include_examples 'public fields returnable' do
        let(:fields) { %w[title body created_at updated_at] }
        let(:resource_response) { json_response['question'] }
        let(:resource) { question }
      end
    end # authorized
  end # DELETE /api/v1/questions/:id
end
