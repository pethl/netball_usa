# app/controllers/audits_controller.rb
class AuditsController < ApplicationController
  def index
    redirect_to raw_audits_path
  end
  def raw
    @versions = PaperTrail::Version.order(created_at: :desc)
  
    if params[:created_at].present?
      begin
        date = Date.parse(params[:created_at])
        @versions = @versions.where("created_at >= ?", date.beginning_of_day)
      rescue ArgumentError
        flash.now[:alert] = "Invalid date"
      end
    end
  
    @versions = @versions.limit(100)
  end

  def grouped
    versions = PaperTrail::Version.all
  
    if params[:created_at].present?
      begin
        date = Date.parse(params[:created_at])
        versions = versions.where("created_at >= ?", date.beginning_of_day)
      rescue ArgumentError
        flash.now[:alert] = "Invalid date format"
      end
    end
  
    @club_changes = versions
      .where(item_type: "Club")
      .order(item_id: :asc, created_at: :desc)
      .group_by(&:item_id)
  
    @member_changes = versions
      .where(item_type: "Member")
      .order(item_id: :asc, created_at: :desc)
      .group_by { |v| Member.find_by(id: v.item_id)&.club_id }

      @all_club_ids = ((@club_changes || {}).keys + (@member_changes || {}).keys).uniq.compact

  end


end