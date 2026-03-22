class DiseasesController < ApplicationController
  before_action :set_disease, only: [:show]
  before_action :set_disease_exact, only: [:set_active_status]

  def index
    if permitted_params.include?(:data_source)
      @diseases = Disease.where("lower(name) LIKE ?", "%#{Disease.sanitize_sql_like(permitted_params[:data_source].downcase)}%")
    else
      @diseases = Disease.all
    end
  end

  def show
  end

  def set_active_status
    is_active = ActiveModel::Type::Boolean.new.cast(params[:is_active]) || false

    @disease.update(is_active: is_active)
  end

  def show_attr
    column = permitted_params[:attribute].downcase
    disease = permitted_params[:disease].downcase
    if valid?(column)
      @disease_attr = Disease.select(column.to_sym).where("lower(name) LIKE ?", "%#{Disease.sanitize_sql_like(disease)}%").first
    else
      render json: {}, status: :not_found
    end
  end

  private
  def set_disease
    @disease = Disease.where("lower(name) LIKE ?", "%#{Disease.sanitize_sql_like(permitted_params[:disease].downcase)}%").first
  end

  def set_disease_exact
    @disease = Disease.find_by("lower(name) = ?", permitted_params[:disease].downcase)
  end

  def permitted_params
    params.permit(:disease, :data_source, :attribute)
  end

  def valid?(column)
    Disease.column_names.include? column
  end
end
