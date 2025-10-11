class MembersController < ApplicationController
  require "csv"
  before_action :set_club, only: [:edit, :update, :destroy, :show, :new, :create]
  before_action :set_member, only: [:edit, :update, :destroy, :show]
  

  def index
    # Start with all members, eager load club for better performance
    @members = Member.includes(:club).order(:last_name, :first_name)
  
    # --- Filters ---
    @members = @members.where(club_id: params[:club_id]) if params[:club_id].present?
    @members = @members.where(state: params[:state]) if params[:state].present?
    @members = @members.where(city: params[:city]) if params[:city].present?
    if params[:created_at].present?
      @members = @members.where("DATE(members.created_at) = ?", params[:created_at])
    end
  
    # --- Club list for filter dropdown ---
    @clubs = Club.order(:name).pluck(:name, :id)
  
    respond_to do |format|
      format.html
      format.xlsx do
        # No pagination — export full filtered list
        # Filters above apply automatically
        response.headers['Content-Disposition'] =
          "attachment; filename=members_export_#{Date.today}.xlsx"
      end
    end
  end
  

  def active_club_members
    # ✅ Find the most recent renewal year in the data (e.g. "2026" or "2025")
    latest_year = Club.where.not(renewal_years: nil).maximum(:renewal_years)

    # Load clubs for that year
    clubs = Club.where(renewal_years: latest_year).includes(:members)

    excluded    = %w[id na_team_id updated_at membership_type team_id]
    member_cols = Member.column_names - excluded
  
    club_map = {
      "club_name"           => :name,
      "club_city"           => :city,
      "club_state"          => :us_state,
      "club_renewal_years"  => :renewal_years
    }
  
    csv_data = CSV.generate(headers: true) do |csv|
      headers = club_map.keys + member_cols
      csv << headers
  
      clubs.order(:name).each do |club|
        club.members.order(:last_name, :first_name).each do |m|
          club_vals   = club_map.values.map { |attr| club.public_send(attr) }
          member_vals = member_cols.map { |c| m.public_send(c) }
          csv << (club_vals + member_vals)
        end
      end
    end
  
    send_data csv_data,
              filename: "active_club_members_export_#{Date.today}.csv",
              type: "text/csv"
  end

  # GET /members/1
  def show
  end

  # GET /members/new
  def new
   # @member = Member.new
     @member = @club.members.build
  end

  # GET /members/1/edit
  def edit
    @teams = Team.where(club_id: @club)
  end

  # POST /members
  def create
   @member = @club.members.build(member_params)

       if @member.save
         respond_to do |format|
                format.html { redirect_to member_path(@member), notice: "Record successfully created." }
                format.turbo_stream { flash.now[:notice] = "Member was successfully created." }
              end 
            else
         render :new, status: :unprocessable_entity
       end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
         redirect_to club_path(@club), notice: "Member was successfully updated."
       else
         render :edit, status: :unprocessable_entity
       end
  end

  # DELETE /members/1
  def destroy
     @member.destroy
     respond_to do |format|
        format.html { redirect_to club_path(@club), notice: "Member was successfully deleted." }
        format.turbo_stream { flash.now[:notice] = "Member was successfully deleted." }
      end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
#    def set_member
#      @member = Member.find(params[:id])
#    end
    
    def set_club
       @club = Club.find(params[:club_id])
    end
      
    def set_member
       @member = @club.members.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:na_team_id, :club_id, :team_id, :membership_type, :first_name, :last_name, :email, :phone,  :address, :city, :state, :zip,  :gender, :join_a_committee, :interested_in_coaching, :interested_in_umpiring, :interested_in_usa_team, :dob, :age_status, :engagement_status, :place_of_birth, :notes)
    end
end
