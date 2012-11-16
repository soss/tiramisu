class VotesController < ApplicationController
  def create
    @vote = Vote.new(params[:vote])
    @vote.save

    render :json => { :status => :ok }
  end
end
