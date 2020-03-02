require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login (question.user) }

      it 'new answer with Link' do
        post :create, params: { question_id: question, answer: { body: 'MyTitle', links_attributes: [name: 'agasfds', url: 'https://sfags.ru/'] } }, format: :js
        expect(assigns(:answer).links.first).to be_a(Link)
      end

      context 'is valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: {
                   question_id: question, answer: { body: 'MyTitle' }, format: :js
                 } }.to change(Answer, :count).by(1)
        end

        it 'new question belongs to answer' do
          post :create, params: { question_id: question, answer: { body: 'MyTitle' } }, format: :js
          expect(assigns(:answer).question).to eq question
        end

        it 'redirect to question after save' do
          post :create, params: { question_id: question, answer: { body: 'MyTitle' } }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'is invalid attributes' do
        it 'saves a new answer in the database' do
          expect do
            post :create, params: { question_id: question, answer: { body: '' } }, format: :js
          end.to_not change(Answer, :count)
        end

        it 're-render new view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'guest user' do
      it 'tries to save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: { body: 'Text' } }, format: :js }
               .to_not change(Answer, :count)
      end

      it 'redirect to login page' do
        post :create, params: { question_id: question, answer: { body: 'Text' } }, format: :js

        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer) }

    context 'from guest' do
      it 'user can not updates answer' do
        patch :update, params: { id: answer, answer: { body: 'New Body' } }, format: :js
        expect(answer.reload.body).to_not eq 'New Body'
      end

      it 'redirect to login' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js

        expect(response.status).to eq 401
      end
    end

    context 'from not owner user' do
      before { login(user) }

      it 'return status 403' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response.status).to eq 403
      end

      it 'content not changed' do
        patch :update, params: { id: answer, answer: { body: 'NewBodyFromAlien' } }, format: :js
        expect(assigns(:answer).body).to_not match('NewBodyFromAlien')
      end
    end

    context 'is valid attributes' do
      before { login(answer.user) }
      let!(:link) { create(:link, linkable: answer) }

      it 'updates attributes for @answer' do
        patch :update, params: { id: answer, answer: { body: 'MyBody2' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'MyBody2'
      end

      it 'answer link is instance of Link' do
        patch :update, params: { id: answer, answer: { body: 'MyTitle', links_attributes: [id: link, name: 'agasfds', url: 'https://ru/'] } }, format: :js

        expect(assigns(:answer).links.first).to be_a(Link)
      end

      it 'redirected to answers' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'is invalid attributes' do
      before { login(answer.user) }

      it 'unupdates attributes for @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(assigns(:answer)).to match(answer)
      end

      it 're-render show question view' do
        patch :update, params: { id: answer, answer: { body: '' } }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer)}

    context 'guest user' do
      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to login' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response.status).to eq 401
      end
    end

    context 'not owner' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end

    context 'from owner' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answer) { create(:answer)}
    context 'for the author of the question' do

      before do
        login(answer.question.user)
      end

      it 'assigns the requested answer to @answer' do
        patch :best, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq answer
     end

      it 'changes answer attributes' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'renders best' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'for not the author of the question' do
      let(:not_author) { create(:user) }

      before do
        login(not_author)
        patch :best, params: { id: answer }, format: :js
      end

      it 'does not change answer' do
        answer.reload

        expect(answer).to_not be_best
      end

      it 'return status 403' do
        expect(response.status).to eq 403
      end
    end

    context 'for unauthenticated user' do
      before { patch :best, params: { id: answer, answer: { best: true } } }

      it 'does not change answer' do
        answer.reload

        expect(answer).to_not be_best
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
