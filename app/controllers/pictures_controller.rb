class PicturesController < ApplicationController
    before_action :authenticate_user!

    def index
        @picture = current_user.pictures.first
    end
end
