class SampleWordsController < ApplicationController
  before_action :set_sample_word, only: %i[ show edit update destroy ]

  # GET /sample_words
  def index
    authorize! :read, @sample_words
    @sample_words = SampleWord.all
  end

  # GET /sample_words/1
  def show
  end

  # GET /sample_words/new
  def new
    @sample_word = SampleWord.new
  end

  # GET /sample_words/1/edit
  def edit
  end

  # POST /sample_words
  def create
    @sample_word = SampleWord.new(sample_word_params)

    if @sample_word.save
      redirect_to @sample_word, notice: "Sample word was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sample_words/1
  def update
    if @sample_word.update(sample_word_params)
      redirect_to @sample_word, notice: "Sample word was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sample_words/1
  def destroy
    @sample_word.destroy
    redirect_to sample_words_url, notice: "Sample word was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample_word
      @sample_word = SampleWord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sample_word_params
      params.require(:sample_word).permit(:category, :title, :desc)
    end
end
