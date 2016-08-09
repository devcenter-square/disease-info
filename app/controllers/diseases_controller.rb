class DiseasesController < ApplicationController

  def index
    if permitted_params.include?(:data_source)
      @diseases = Disease.where("lower(name) LIKE?", "%#{permitted_params[:data_source].downcase}%")
    else
      @diseases = Disease.all
    end
  end

  def show
    @disease = Disease.where("lower(name) LIKE?", "%#{permitted_params[:disease].downcase}%").first
  end

  def permitted_params
    params.permit(:disease, :data_source)
  end
end
