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

  def show_attr
    if valid?(permitted_params[:attribute].downcase)
      @disease_attr = Disease.where("lower(name) LIKE?", "%#{permitted_params[:disease].downcase}%").select("id, #{permitted_params[:attribute].downcase}").first
    else
      render json: {} , status: :not_found
    end
  end

  def permitted_params
    params.permit(:disease, :data_source, :attribute)
  end

  private

  def valid?(column)
    if Disease.column_names.include?(column) or ["created_at", "update_at"].include?(column)
      attr = true
    else
      attr = false
    end
    attr
  end
end
