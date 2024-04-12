class Master::PicturesController < ApplicationController
    before_action :authenticate_master_user!

    def index
        @pictures = Picture.all
    end
end
