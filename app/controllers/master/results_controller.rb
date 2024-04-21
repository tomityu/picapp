class Master::ResultsController < ApplicationController
    before_action :authenticate_master_user!

    def show
    end

    def new
        @pictures = Picture.includes(:user).order(point: :desc)
    end

    def create
        Picture.all.update(spesial_reward: false)
        Picture.find(params[:id]).update!(spesial_reward: true)
    end

    def presentation
        pictures = Picture.includes(:user).order(point: :desc).limit(3)
        @first = pictures.first
        @second = pictures.second
        @third = pictures.third
        @special = Picture.includes(:user).find_by(spesial_reward: true)
    end
end
