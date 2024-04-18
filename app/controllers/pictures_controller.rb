class PicturesController < ApplicationController
    before_action :authenticate_user!

    def index
        @pictures = Picture.all.shuffle
    end

    def update
        Picture.find(params[:id]).increment!(:point, 1)
    end
end
