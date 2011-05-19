class CapitlesController < ApplicationController
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
    @capitle = Capitle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @capitle }
    end
  end

  # GET /capitles/new
  # GET /capitles/new.xml
  def new
    @capitle = Capitle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @capitle }
    end
  end

  # GET /capitles/1/edit
  def edit
    @capitle = Capitle.find(params[:id])
  end

  # POST /capitles
  # POST /capitles.xml
  def create
    @capitle = Capitle.new(params[:capitle])

    respond_to do |format|
      if @capitle.save
        format.html { redirect_to(@capitle, :notice => 'Capitle was successfully created.') }
        format.xml  { render :xml => @capitle, :status => :created, :location => @capitle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @capitle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /capitles/1
  # PUT /capitles/1.xml
  def update
    @capitle = Capitle.find(params[:id])

    respond_to do |format|
      if @capitle.update_attributes(params[:capitle])
        format.html { redirect_to(@capitle, :notice => 'Capitle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @capitle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /capitles/1
  # DELETE /capitles/1.xml
  def destroy
    @capitle = Capitle.find(params[:id])
    @capitle.destroy

    respond_to do |format|
      format.html { redirect_to(capitles_url) }
      format.xml  { head :ok }
    end
  end
end
