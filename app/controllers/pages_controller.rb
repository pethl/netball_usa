class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only:[:educator_sign_up, :goodbye]
     
  

  def goodbye
    # renders app/views/pages/goodbye.html.erb    
    flash.clear # <- Use clear not discard
  end

  def home
  # -----------------------------
  # Netball Educator stats
  # -----------------------------
  @created_last_7_days  = NetballEducator.where("created_at > ?", Time.now - 7.days).count
  @created_last_30_days = NetballEducator.where("created_at > ?", Time.now - 30.days).count
  @created_this_year    = NetballEducator.where("created_at > ?", Time.now.beginning_of_year).count

  # -----------------------------
  # People stats
  # NOTE: @scorers and @operations are later overwritten by US Open transfer stats.
  # -----------------------------
  @people_usa_umpires            = Person.where(role: "Umpire", region: "US & Canada").count
  @people_international_umpires  = Person.where(role: "Umpire", region: "International").count
  @people_scorers    = Person.where(role: "Scorer").count
  @people_trainers   = Person.where(role: "Trainer").count
  @people_coaches    = Person.where(role: "Coach").count
  @people_operations = Person.where(role: "Operations").count

  # -----------------------------
  # User/account stats
  # -----------------------------
  @admins        = User.where(role: 0, account_active: true).count
  @support_staff = User.where.not(role: [0, 2, 12]).where(account_active: true).count
  @teamleads     = User.where(role: 2, account_active: true).count
  @na_people     = User.where(role: 12, account_active: true).count

  # -----------------------------
  # Event stats
  # -----------------------------
  @events_this_year           = Event.where("date > ?", Time.now.beginning_of_year)
  @events_this_year_by_status = @events_this_year.group_by { |t| t.status }

  @events_next_year           = Event.where("date > ?", Time.now.end_of_year)
  @events_next_year_by_status = @events_next_year.group_by { |t| t.status }

  # -----------------------------
# US Open transfer stats
# -----------------------------
us_open_transfers =
  Transfer
    .joins(:event)
    .where(events: { id: current_us_open_event.id })

    @us_open_operations  = us_open_transfers.where(role: "Operations").count
    @us_open_umpires     = us_open_transfers.where(role: "US Umpire").count
    @us_open_int_umpires = us_open_transfers.where(role: "Int Umpire").count
    @us_open_scorers     = us_open_transfers.where(role: "Scorer").count
    @us_open_medics      = us_open_transfers.where(role: "Medic").count


  # -----------------------------
  # Membership and grants
  # -----------------------------
  @total_members = Member.all.count + IndividualMember.all.count
  @grants_submitted_this_year = Grant.where("date_submitted > ?", Time.now.beginning_of_year).count

  @opportunities = Opportunity.all.order(status: :asc)
  @opportunities_by_status = @opportunities.group_by { |t| t.status }

  @grants_applying_for = Grant.where(apply: true).order(status: :desc)
  # @grants_sub = Grant.all.order(status: :asc)
  @grants_by_status = @grants_applying_for.group_by { |t| t.status }

  # -----------------------------
  # Follow-up card stats
  # -----------------------------
  @follow_up_stats = FollowUp.group(:lead_type).count

  # -----------------------------
  # Media card stats
  # -----------------------------
  @media_stats = Medium.group(:media_type).count

  # -----------------------------
  # Equipment card stats
  # -----------------------------
  @total_sales  = Equipment.where(status: "Sale").count
  @total_quotes = Equipment.where(status: "Quote").count

  @equipment_sales_stats =
    Equipment
      .where(status: "Sale")
      .where(sale_date: 3.years.ago.beginning_of_year..Time.current.end_of_year)
      .group("EXTRACT(YEAR FROM sale_date)")
      .select(
        "EXTRACT(YEAR FROM sale_date) AS year",
        "COUNT(*) AS sales_count",
        "COALESCE(SUM(purchase_amount), 0) AS total_purchase"
      )
      .order("year DESC")

  # Equipment quote stats
  quote_scope = Equipment.where(status: "Quote")

  @total_quotes       = quote_scope.count
  @total_quote_amount = quote_scope.sum(:quote_amount)

  # -----------------------------
  # Netball Academy card stats
  # -----------------------------
  subscription_order =
    Reference
      .where(active: true, group: "subscription_plan")
      .pluck(:value)
      .sort_by { |v| v.to_f }

  @netball_academy_active_stats =
    NetballAcademy
      .where(status: "Active")
      .select(
        "COALESCE(NULLIF(TRIM(subscribed_plans), ''), 'Unknown') AS course",
        "COUNT(*) FILTER (WHERE amount > 0) AS paid_count",
        "COUNT(*) FILTER (WHERE amount IS NULL OR amount <= 0) AS unpaid_count",
        "COALESCE(SUM(amount), 0) AS total_amount"
      )
      .group("course")

  @netball_academy_active_stats =
    @netball_academy_active_stats.sort_by do |s|
      index = subscription_order.index(s.course)
      index.nil? || s.course == "Unknown" ? Float::INFINITY : index
    end

  inactive_scope = NetballAcademy.where(status: "Inactive")

  @netball_academy_inactive_summary = {
    count: inactive_scope.count,
    total_amount: inactive_scope.sum(:amount).to_f
  }

  # -----------------------------
  # Filing card stats
  # -----------------------------
  today = Date.current
  month_range = today.beginning_of_month..today.end_of_month

  @dashboard_month = today.month
  @dashboard_year  = today.year

  @dashboard_occurrences =
    FilingOccurrence
      .joins(:filing)
      .includes(:filing)
      .where(due_date: month_range)
      .where(
        "filings.active = TRUE
        OR filing_occurrences.due_date < filings.paused_at"
      )
      .order(:due_date)

  @dashboard_month_total =
  @dashboard_occurrences.sum { |o| o.filing.cost.to_f }
end

  
  def educator_sign_up
    @netball_educator = NetballEducator.new
  end

  def membership_landing
    @member_type, @membership_record = detect_membership_type
  
    case @member_type
    when "Club"
      @club = @membership_record
      @needs_renewal = renewal_required?(@club)
      @renewal_response = @club&.renewal_response
  
    when "Individual"
      @individual_member = @membership_record
      @needs_renewal = renewal_required_individual?(@individual_member)
      @renewal_response = @individual_member&.renewal_response
  
    else
      @needs_renewal = false
      @renewal_response = nil
    end
  end

  def na_people
    @person = Person.find_by(email: current_user.email)
  end
  
  private

    def get_users
       @users = User.all
    end
    
    # Only allow a list of trusted parameters through.
    def educator_params
      params.require(:educator).permit(:first_name, :last_name, :email, :phone, :school_name, :city, :state, :educator_notes, :mgmt_notes, :user_id)
    end
    
    def detect_membership_type
      if (individual = IndividualMember.find_by(user_id: current_user.id))
        return ["Individual", individual]
      elsif (club = Club.find_by(user_id: current_user.id))
        return ["Club", club]
      else
        return ["None", nil]
      end
    end
    
    def renewal_required?(club)
      today = Date.today
      renewal_start = Date.new(today.year, 2, 1)
    
      today >= renewal_start &&
      !(club.renewal_years || "").split(",").map(&:to_i).include?(today.year)
    end
    
    def renewal_required_individual?(individual)
      return false if individual.nil?
    
      # 🛡️ NEW users created this year should NOT need to renew
      return false if individual.created_at.year == Date.today.year
    
      current_year = Date.today.year
      renewed_years = (individual.renewal_years || "").split(",").map(&:to_i)
    
      !renewed_years.include?(current_year)
    end
    
end
    
