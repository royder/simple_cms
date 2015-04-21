class SubjectsController < ApplicationController

  layout 'admin'

  def index
    # Getting subjects using sorted scope
    @subjects = Subject.sorted
  end

  def show
    @subject = Subject.find(params[:id])
  end

  def new
    @subject = Subject.new({:name => 'Default'}) # allows us to set default values for the objects attributes
  end

  def create
    # Instantiate, Save, Succeed -> Redirect, Fail -> show form with values
    @subject = Subject.new(subject_params) 
    if @subject.save
      flash[:notice] = 'Subject created successfully.'
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
    @subject = Subject.find(params[:id])
  end

  def update
    # Find object, Save, Succeed -> Redirect, Fail -> show form with values
    @subject = Subject.find(params[:id])
    if @subject.update_attributes(subject_params)
      flash[:notice] = 'Subject updated successfully.'
      redirect_to(:action => 'show', :id => @subject.id)
    else
      render('edit')
    end
  end

  def delete
    @subject = Subject.find(params[:id])
  end

  def destroy
    subject = Subject.find(params[:id]).destroy
    flash[:notice] = "Subject '#{subject.name}' deleted successfully."
    redirect_to(:action => 'index')
  end

  private

    def subject_params
      # same as using params[:subject], except that it:
      # - raises an error if :subject is not present
      # - allows listed attributes to be mass-assigned
      params.require(:subject).permit(:name, :position, :visible)
    end

end
