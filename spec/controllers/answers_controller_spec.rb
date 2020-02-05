require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login (question.user) }

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
        post :create, params: { question_id: question, answer: { body: 'Text' } }

        expect(request).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer) }

    context 'from guest' do
      it 'user can not updates answer' do
        patch :update, params: { id: answer, answer: { body: 'New Body' } }
        expect(answer.reload.body).to_not eq 'New Body'
      end

      it 'redirect to login' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'from not owner user' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'redirect to question page' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end

      it 'content not changed' do
        patch :update, params: { id: answer, answer: { body: 'NewBodyFromAlien' } }
        expect(assigns(:answer).body).to_not match('NewBodyFromAlien')
      end
    end

    context 'is valid attributes' do
      before { login(answer.user) }

      it 'updates attributes for @answer' do
        patch :update, params: { id: answer, answer: { body: 'MyBody2' } }
        answer.reload

        expect(answer.body).to eq 'MyBody2'
      end

      it 'redirected to answers' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }

        expect(response).to redirect_to answer.question
      end
    end

    context 'is invalid attributes' do
      before { login(answer.user) }

      it 'unupdates attributes for @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }

        expect(assigns(:answer)).to match(answer)
      end

      it 're-render show question view' do
        patch :update, params: { id: answer, answer: { body: '' } }

        expect(response).to render_template :edit
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
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'not owner' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to question show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to answer.question
      end
    end

    context 'from owner' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to answer.question
      end
    end
  end
end
