class DiseasesController < ApplicationController
  before_action :set_disease, only: [:show, :set_active_status]

  def index
    if permitted_params.include?(:data_source)
      @diseases = Disease.where("lower(name) LIKE?", "%#{permitted_params[:data_source].downcase}%")
    else
      @diseases = Disease.all
    end
  end

  def show
  end

  def set_active_status
    # falsey values like boolean 'false', 'nil' evaluates to false
    is_active = !!params[:is_active] == true

    @disease.update_attribute(:is_active, is_active)
  end

  private
  def set_disease
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
