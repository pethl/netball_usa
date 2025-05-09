  class PaymentsController < ApplicationController
    before_action :set_payment, only: %i[ show edit update destroy ]
    load_and_authorize_resource
    
    # GET /payments
    def index
      @payments = Payment.where.not(club_id: nil)
                         .order(payment_year: :desc, payment_received_date: :desc)
    end

    # GET /payments
    def index_indiv
      @individual_payments = Payment.includes(:individual_member)
                                    .where.not(individual_member_id: nil)
                                    .order(payment_year: :desc, payment_received_date: :desc)
    end

    # GET /payments/1
    def show
    end

    # GET /payments/new
    def new
      @payment = Payment.new
    end

    # GET /payments/1/edit
    def edit
    end

    # POST /payments
    def create
      @payment = Payment.new(payment_params)
      @payment.payment_recorded_by_id = current_user.id

      if @payment.save
        redirect_to @payment, notice: "Payment was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /payments/1
    def update
      if @payment.update(payment_params)
        redirect_to @payment, notice: "Payment was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /payments/1
    def destroy
      @payment.destroy
      redirect_to payments_url, notice: "Payment was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_payment
        @payment = Payment.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def payment_params
        params.require(:payment).permit(:payment_type, :club_id, :individual_member_id, :payment_recorded_by_id, :payment_received_date, :payment_transaction_reference, :payment_year, :amount, :payment_notes)
      end
  end
