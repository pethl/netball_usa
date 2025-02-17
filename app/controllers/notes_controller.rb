class NotesController < ApplicationController
    before_action :set_club
    before_action :set_note, only: [:edit, :update, :destroy]
  
    def new
      @note = @club.notes.new
    end
  
    def create
      @note = @club.notes.new(note_params)
      if @note.save
        redirect_to club_path(@club), notice: 'Note was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
     
      if @note.update(note_params)
        redirect_to club_path(@club), notice: 'Note was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy

        if @note.destroy
        logger.debug "Note deleted successfully."
        redirect_to club_path(@club), notice: 'Note was successfully deleted.'
        else
        logger.debug "Failed to delete note: #{@note.errors.full_messages.join(', ')}"
        redirect_to club_path(@club), alert: 'Failed to delete the note.'
        end
    end
  
    private
  
    def set_club
      @club = Club.find(params[:club_id])
    end
  
    def set_note
      @note = @club.notes.find(params[:id])
    end
  
    def note_params
      params.require(:note).permit(:body, :status)
    end
  end