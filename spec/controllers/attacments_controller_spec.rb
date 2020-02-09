require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question, :with_files) }
  let!(:user) { create(:user) }
  let(:author) { question.user }

  describe 'DELETE #destroy' do

    context 'resource author' do
      before do
        login(author)
      end

      it 'attachment deletes' do
        expect { delete :destroy, params: { id: question.files[0].id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'render template destroy ' do
        delete :destroy, params: { id: question.files[0].id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not owner resource' do
      before do
        login(user)
      end

      it 'attachment deletes' do
        expect { delete :destroy, params: { id: question.files[0].id }, format: :js }.to_not change(question.files, :count)
      end

      it 'render unauthorize status ' do
        delete :destroy, params: { id: question.files[0].id }, format: :js
        
        expect(response).to have_http_status 403
      end
    end

    context 'guest' do
      it 'attachment deletes' do
        expect { delete :destroy, params: { id: question.files[0].id }, format: :js }.to_not change(question.files, :count)
      end

      it 'render unauthorize status ' do
        delete :destroy, params: { id: question.files[0].id }, format: :js

        expect(response).to have_http_status 401
      end
    end
  end

end
