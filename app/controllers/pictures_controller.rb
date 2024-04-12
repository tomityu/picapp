class PicturesController < ApplicationController
    before_action :authenticate_user!

    def index
        @pictures = current_user.pictures
    end
end
