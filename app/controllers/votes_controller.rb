class VotesController < ApplicationController
  def create
    @vote = Vote.new(params[:vote])
    @vote.save
  end
end
