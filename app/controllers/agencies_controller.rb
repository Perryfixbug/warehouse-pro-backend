class AgenciesController < ApplicationController
  # GET /agencies or /agencies.json
  def index
    agencies = Search::AgencySearch.new(params, Agency.all).call
    render json: {
      status: "success",
      data: agencies
    }, status: :ok
  end

  def show
    if agency
      render json: {
        status: "success",
        data: agency
      }, status: :ok
    else  
      render json: {
        status: "error"
      }, status: :not_found
    end
  end

  # POST /agencies or /agencies.json
  def create
    agency = Agency.new(agency_params)

    if agency.save
      render json: {
        status: "success",
        data: agency
      }, status: :created
    else
      render json: {
        status: "error",
        error: agency.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agencies/1 or /agencies/1.json
  def update
    if agency.update(agency_params)
      render json: {
        status: "success",
        data: agency
      }, status: :ok
    else
      render json: {
        status: "error",
        error: agency.errors
      }, status: :unprocessable_entity
    end
  end

  # DELETE /agencies/1 or /agencies/1.json
  def destroy
    if agency.destroy
      render json: {
        status: "success",
        data: "Delete successfully! "
      }, status: :ok
    else
      render json: {
        status: "error",
        error: agency.errors
      }, status: :unprocessable_entity
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def agency
    @_agency ||= Agency.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def agency_params
    params.require(:agency).permit(:name, :location, :phone, :email)
  end
end
