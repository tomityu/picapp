class Master::PicturesController < ApplicationController
    before_action :authenticate_master_user!
    require 'rubygems'
    require 'zip'

    def index
        @pictures = Picture.all
    end

    def download
        ::Zip::OutputStream.open(Rails.root.join('tmp', 'pictures.zip')) do |out|
            Picture.includes(:user).with_attached_file.each do |picture|
                out.put_next_entry("#{picture.user.name}_#{picture.file.filename}.jpg")
                picture.file.download { |chunk| out.write(chunk) }
            end
        end
        send_file(Rails.root.join('tmp', 'pictures.zip'))
        # redirect_to master_dashboard_path
    end
end
