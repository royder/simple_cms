class PagesController < ApplicationController

  layout 'admin'

  def index
    @pages = Page.sorted
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new({:name => 'Default'})
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      flash[:notice] = 'Page created successfully.'
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_params)
      flash[:notice] = 'Page updates successfully.'
      redirect_to(:action => 'show', :id => @page.id)
    else
      render('edit')
    end
  end

  def delete
    @page = Page.find(params[:id])
  end

  def destroy
    page = Page.find(params[:id]).destroy
    flash[:notice] = "Page '#{page.name}' deleted successfully."
    redirect_to(:action => 'index')
  end

  private

    def page_params
      # same as using params[:page], except that it:
      # - raises an error if :page is not present
      # - allows listed attributes to be mass assigned
      params.require(:page).permit(:subject_id, :name, :permalink, :position, :visible)
    end

end
