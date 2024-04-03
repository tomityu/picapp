class Master::DashboardController < ApplicationController
    before_action :authenticate_master_user!

    def index
    end
end
