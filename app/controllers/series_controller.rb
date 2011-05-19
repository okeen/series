class SeriesController < ApplicationController
  # GET /series
  # GET /series.xml
  def index
    series = Serie.where(nil)
    series = series.with_letter(params[:letter]) unless params[:letter].blank?
    @series = series.all.paginate :page => params[:page], :per_page => 16

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @series }
    end
  end

  def home
    @series = Serie.all.paginate :page => params[:page], :per_page => 16

    respond_to do |format|
      format.html # index.html.erb
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
