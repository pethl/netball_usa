class TaemsController < ApplicationController
    before_action :set_taem, only: [:show, :edit, :update, :destroy]

    def index
      @taems = Taem.all
    end
  
    def show
    end
  
    def new
      @taem = Taem.new
    end
  
    def create
      @taem = Taem.new(taem_params)
  
      if @taem.save
        respond_to do |format|
            format.html { redirect_to taems_path, notice: "Taem was successfully created." }
            format.turbo_stream
          end
        else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @taem.update(taem_params)
        redirect_to taems_path, notice: "Taem was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @taem.destroy
      respond_to do |format|
        format.html { redirect_to taems_path, notice: "Taem was successfully destroyed." }
        format.turbo_stream
      end
    end
  
    private
  
    def set_taem
      @taem = Taem.find(params[:id])
    end
  
    def taem_params
      params.require(:taem).permit(:name)
    end
end
