class SeriesController < ApplicationController
  # GET /series
  # GET /series.xml
  def index
    @series = Serie.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @series }
    end
  end

  # GET /series/1
  # GET /series/1.xml
  def show
    @series = Serie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @series }
    end
  end

 
end
