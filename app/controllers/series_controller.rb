class SeriesController < ApplicationController
  # GET /series
  # GET /series.xml
  def index
    series = Serie.where(nil)
    series = series.with_letter(params[:letter]) unless params[:letter].blank?
    @series = series.all
    #paginar si no es filtrado por letra
    @series = @series.paginate :page => params[:page], :per_page => 16 if params[:letter].blank?

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
    @serie = Serie.titled(params[:id]).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @series }
    end
  end

 
end
