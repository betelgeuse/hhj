require 'factory_girl_rails'

class CallsController < ApplicationController

  def index
  end

  def new
    organ = Organ.find params[:organ_id]
    @call  = organ.calls.build
    respond_to do |format|
      format.fragment
    end
  end

  def create # create a new call for applications
    call_params = params[:call] || {}
    call = FactoryGirl.create :call, call_params.merge(organ: Organ.find(params[:organ_id]))

    respond_to do |format|
      format.json { render json: call.to_json }
      format.html { redirect_to action: :show, id: call._id }
    end
  end

  def show # return a single call for applications
    @call = Call.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @call }
      format.fragment { render "show", formats: ['html'], layout: false }
    end
  end

  def edit # form for modifing an existing call
    @call = Call.find(params[:id])
    respond_to do |format|
      format.fragment { render "new" }
    end
  end

  def update # modify an existing call
  end

  def destroy # delete an call
  end

end
