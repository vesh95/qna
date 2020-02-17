module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[voteup votedown revote]
  end

  def voteup
    unless current_user&.author?(@votable) && current_user&.voted?(@votable)
      @votable.vote_up(current_user)

      render_json
    end
  end

  def votedown
    unless current_user&.author?(@votable) && current_user&.voted?(@votable)
      @votable.vote_down(current_user)

      render_json
    end
  end

  def revote
    @votable.vote_out(current_user)

    render_json
  end


  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json
    render json: {
      id: @votable.id,
      rating: @votable.rating,
      klass: @votable.class.to_s
    }
  end
end
