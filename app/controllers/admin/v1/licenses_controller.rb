module Admin::V1
  class LicensesController < ApiController
    before_action :load_license, only: [:show, :update, :destroy]

    def index
      game_licenses = License.where(game_id: params[:game_id])
      @loading_service = Admin::ModelLoadingService.new(game_licenses, searchable_params)
      @loading_service.call
    end

    def show; end

    def create
      @license = License.new(game_id: params[:game_id])
      @license.attributes = license_params
      save_license!
    end

    def update
      @license.attributes = license_params
      save_license!
    end

    def destroy
      @license.destroy!
    rescue
      render_error(fields: @license.errors.messages)
    end

    private

    def license_params
      return {} unless params.has_key?(:license)
      params.require(:license).permit(:id, :key, :platform, :status)
    end

    def load_license
      @license = License.find(params[:id])
    end

    def searchable_params
      params.permit({ search: :key }, { order: {} }, :page, :length)
    end

    def save_license!
      @license.save!
      render :show
    rescue
      render_error(fields: @license.errors.messages)
    end
  end
end