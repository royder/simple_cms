class SectionsController < ApplicationController

  layout 'admin'

  def index
    @sections = Section.sorted
  end

  def show
    @section = Section.find(params[:id])
  end

  def new
    @section = Section.new(:name => 'Default')
  end

  def create
    @section = Section.new(section_params)
    if @section.save
      flash[:notice] = 'Section created successfully.'
      redirect_to(:action => 'index')
    else
      render('create')
    end
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update(section_params)
      flash[:notice] = 'Section updated successfully.'
      redirect_to(:action => 'show', :id => @section.id)
    else
      render('edit')
    end
  end

  def delete
    @section = Section.find(params[:id])
  end

  def destroy
    section = Section.find(params[:id]).destroy
    flash[:notice] = "Section #{section.name} deleted successfully."
    redirect_to(:action => 'index')
  end

  private

    def section_params
      # same as using params[:sections], except that it:
      # - raises an error if :sections is not present
      # - allows listed attributes to be mass assigned
      params.require(:section).permit(:page_id, :name, :position, :visible, :content_type, :content)
    end

end
