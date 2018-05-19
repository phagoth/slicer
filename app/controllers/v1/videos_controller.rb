module V1
  class VideosController < ApplicationController
    before_action :set_video, only: [:show, :destroy]

    # GET /videos
    def index
      @videos = current_user.videos.all

      render json: @videos
    end

    # GET /videos/1
    def show
      render json: @video
    end

    # POST /videos
    def create
      @video = current_user.videos.new(video_params)

      if @video.save
        render json: @video, status: :created, location: @video
      else
        render json: @video.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /videos/1
    def update
      if @video.update(video_params)
        render json: @video
      else
        render json: @video.errors, status: :unprocessable_entity
      end
    end

    # DELETE /videos/1
    def destroy
      @video.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = current_user.videos.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_params
      params.require(:video).permit(:file)
    end
  end
end
