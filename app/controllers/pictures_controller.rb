class PicturesController < ApplicationController
    # before_action :authenticate_user!

    def index
        @pictures = Picture.all
    end
end
