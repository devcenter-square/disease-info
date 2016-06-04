class DiseasesController < ApplicationController
  before_action :set_disease, only: [:show, :edit, :update, :destroy]
  def index
    @diseases = Disease.all
  end
end
