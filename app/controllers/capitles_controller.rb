class CapitlesController < ApplicationController
  before_filter :load_parent_serie

  # GET /capitles
  # GET /capitles.xml
  def index
    @capitles = Capitle.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @capitles }
    end
  end

  # GET /capitles/1
  # GET /capitles/1.xml
  def show
    @capitle = @serie.capitles.for_season(params[:season]).
                where(:order => params[:capitle_order]).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @capitle }
    end
  end

  private

  def load_parent_serie
    if not params[:serie_title].blank?
      @serie = Serie.titled(params[:serie_title]).first
    end
  end
end
