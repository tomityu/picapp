class Master::DashboardsController < ApplicationController
    before_action :authenticate_master_user!

    def show
    end
end
