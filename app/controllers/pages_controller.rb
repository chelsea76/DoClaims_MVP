class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:search]


  def home
    @claims = Claim.where(active: true).limit(3)
  end

  def search

      @user_address = current_user.preferred_location
      @user = current_user


      # return only claims where 'min star rating' <= 'user star rating'

      # if there's a location search


      # if no location search


      # @arrUser = @user.to_a



    # STEP 1
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end

    # STEP 2
    if session[:loc_search] && session[:loc_search] != ""
      @claims_address = Claim.where(active: true).near(session[:loc_search], 20, order: 'distance')
    else
      @claims_address = Claim.where(active: true).near(@user_address, 20, order: 'distance')
    end
    #
    if @claims_address.empty?
      flash.now[:notice] = "No claims match search paramters"
      @claims_address = Claim.where(active: true).near(@user_address, 20, order: 'distance')
    end

    # STEP 3
    @search = @claims_address.ransack(params[:q])
    @claims = @search.result
    @arrClaims = @claims.to_a

    # if @claims.any?
    #   flash[:notice] = "Claims has something"
    # else
    #   flash[:notice] = "Claims is empty"
    #   # @claims_address = Claim.where(active: true).near(@user_address, 20, order: 'distance')
    # end

    # STEP 4 - removes claims where reservation exists within the start and end dates.
    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? &&  !params[:end_date].empty?)

      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @claims.each do |claim|

        not_available = claim.reservations.where(
          "((? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date))
          AND status = ?",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date,
          1
        ).limit(1)

        not_available_in_calendar = Calendar.where(
          "claim_id = ? AND status = ? AND day <= ? AND day >= ?",
          claim.id, 1, end_date, start_date
        ).limit(1)

          if not_available.length > 0 || not_available_in_calendar.length > 0
            @arrClaims.delete(claim)
          end
      end
    end
  end
end
