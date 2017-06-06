class AdvertismentController < ApplicationController
  def index
    @advertisment = Advertisment.all
  end

  def show
    @advertisment = Advertisment.find(params[:id])
  end

  def new
    @advertisment = Advertisment.new
  end

  def create
    @advertisment = Advertisment.new
    @advertisment.title = params[:advertisment][:title]
    @advertisment.copy = params[:advertisment][:copy]
    @advertisment.price = params[:advertisment][:price]

    if @advertisment.save
      flash[:notice] = "Advertisement was saved"
      redirect_to @advertisment
    else
      flash[:error] = "There was an error saving the advertisment. Please try again"
      render :new
    end
  end
end
