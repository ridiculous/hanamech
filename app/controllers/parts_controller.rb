class PartsController < ApplicationController
  before_action :set_part, only: [:show, :edit, :update, :destroy]

  # GET /parts
  # GET /parts.json
  def index
    if current_user.luna?
      respond_to do |format|
        format.html do
          @parts = Part.order("#{lowered_column} #{sort_direction}, id DESC").page(params[:page]).per_page(Constants::PER_PAGE)
        end
        format.json do
          render json: Part.all_as_json
        end
      end
    else
      redirect_to(logout_path)
    end
  end

  # GET /parts/1
  # GET /parts/1.json
  def show
  end

  # GET /parts/new
  def new
    @part = Part.new
  end

  # GET /parts/1/edit
  def edit
  end

  # POST /parts
  # POST /parts.json
  def create
    @part = Part.new(part_params)
    authorize! :create, @part

    respond_to do |format|
      if @part.save
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render action: 'show', status: :created, location: @part }
      else
        format.html { render action: 'new' }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parts/1
  # PATCH/PUT /parts/1.json
  def update
    authorize! :update, @part
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parts/1
  # DELETE /parts/1.json
  def destroy
    authorize! :destroy, @part
    if @part.destroy
      redirect_to parts_path, notice: 'Part deleted'
    else
      redirect_to part_path(@part), alert: "Part cannot be deleted because it's used by a workorder"
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_part
    @part = Part.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def part_params
    params[:part].permit(:name, :price)
  end

  def sort_column
    super('name')
  end
end
