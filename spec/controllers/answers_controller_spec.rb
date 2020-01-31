require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns the requested Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'is valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: {
                 question_id: question, answer: { body: 'MyTitle' }
               } }.to change(Answer, :count).by(1)
      end

      it 'new question belongs to answer' do
        post :create, params: { question_id: question, answer: { body: 'MyTitle' } }
        expect(assigns(:answer).question).to eq question
      end

      it 'redirect to question after save' do
        post :create, params: { question_id: question, answer: { body: 'MyTitle' } }
        expect(response).to redirect_to assigns(:answer).question
      end
    end # context

    context 'is invalid attributes' do
      it 'saves a new question in the database' do
        expect do
          post :create, params: { question_id: question, answer: { body: '' } }
        end.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
