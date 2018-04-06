class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

  def create
    claim = Claim.find(params[:claim_id])

    if current_user == claim.user
      flash[:alert] = "You cannot book your own property!"
    elsif current_user.stripe_id.blank?
      flash[:alert] = "Please update your payment method!"
      return redirect_to payment_method_path
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      special_dates = claim.calendars.where(
        "status = ? AND day BETWEEN ? AND ? AND price <> ?",
        0, start_date, end_date, claim.price
      )

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.claim = claim
      @reservation.price = claim.price
      # @reservation.total = claim.price * days
      # @reservation.save

      @reservation.total = claim.price * (days - special_dates.count)
      special_dates.each do |date|
          @reservation.total += date.price
      end      

      if @reservation.Waiting!
        if claim.Request?
          flash[:notice] = "Reservation request sent successfully!"
        else
          charge(claim, @reservation)
        end
      else
        flash[:alert] = "Cannot make reservation!"
      end

    end
    redirect_to claim
  end

  def your_trips
    @trips = current_user.reservations.order(start_date: :asc)
  end

  def your_reservations
    @claims = current_user.claims
  end

  def approve
    charge(@reservation.claim, @reservation)
    redirect_to your_reservations_path
  end

  def decline
    @reservation.Declined!
    redirect_to your_reservations_path
  end  

  def send_sms(claim, reservation)
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: '+61429567240',
      to: claim.user.phone_number,
      body: "#{reservation.user.fullname} booked your '#{claim.listing_name}'"
    )
  end

  private


    def charge(claim, reservation)   
      if !reservation.user.stripe_id.blank?
        customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
        charge = Stripe::Charge.create(
          :customer => customer.id,
          :amount => reservation.total * 100,
          :description => claim.listing_name,
          :currency => "usd",
          :destination => {
            :amount => reservation.total * 80, # 80% of the total amount goes to the Host
            :account => claim.user.merchant_id # Host's Stripe customer ID
          }
        )
        
        if charge 
          reservation.Approved!
          ReservationMailer.send_email_to_guest(reservation.user, claim).deliver_later if reservation.user.setting.enable_email
          send_sms(claim, reservation) if claim.user.setting.enable_sms          

          flash[:notice] = "Reservation created successfully!"
        else
          reservation.Declined!
          flash[:alert] = "Cannot charge with this payment method!"
        end
      else
          reservation.Declined! # to be tidied up in later lesson... I hope!
          flash[:alert] = "Cannot charge with this payment method 2!"
      end
    rescue Stripe::CardError => e
      reservation.declined!
      flash[:alert] = e.message
    end


    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
