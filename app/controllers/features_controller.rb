class FeaturesController < ApplicationController
  respond_to :json
  before_action :set_project, only: [:index, :create]
  before_action :set_feature, only: [:show]

  def index
    @features = @project.features
    respond_with @project.features
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_feature
    @feature = Feature.find(params[:id])
  end
end
