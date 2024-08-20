class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]
  before_action :set_sponsor
 
  # GET /contacts
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  def show
    
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
   
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  def create
    @contact = @sponsor.contacts.build(contact_params)
   
      if @contact.save
          redirect_to @sponsor, notice: "Contact was successfully created."
      else
        render :new, status: :unprocessable_entity
      end

  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      redirect_to @sponsor, notice: "Contact was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
   
      respond_to do |format|
        format.html { redirect_to sponsor_path(@sponsor), notice: "Contact was successfully destroyed." }
        format.turbo_stream { flash.now[:notice] = "Contact was successfully destroyed." }
      end
  end

  private
    # Get Parent Sponsor
    # def set_parent
    #    if params.has_key?(:sponsor_id) 
    #     @sponsor = Sponsor.find(params[:sponsor_id])
        
    #    elsif  params.has_key?(:partner_id)  
    #     @partner = Partner.find(params[:partner_id])
       
    #    end  
    # end
    
    def set_sponsor
      @sponsor = Sponsor.find(params[:sponsor_id])
    end

    def set_partner
      @partner = Partner.find(params[:partner_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :prefix, :suffix, :nickname, :email, :phone, :mobile, :job_title, :department, :linked_in, :sponsor_id, :partner_id, :location, :organisation, :notes)
    end
end
