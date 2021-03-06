class ComentariosController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  respond_to :html, :json

  def index
    @comentarios = Comentario.all.where(user_id: current_user.id).page params[:page]
    if params[:q].present?
      @comentarios = @comentarios.where("titulo like :q", q: "%#{params[:q]}%").page params[:page]
    end
  end

  def show
    begin
      @comentario = Comentario.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to comentario_path
      flash[:alert] = "Este comentario No Existe"
    end
  end

  def new
    @comentario = Comentario.new
    respond_to do |f|
      f.html
      f.js
    end
  end

  def edit
    @comentario = Comentario.find(params[:id])
    respond_to do |f|
      f.html
      f.js
    end
  end

  def update
      @comentario = Comentario.find(params[:id])
      respond_to do |format|
        if @comentario.update(comentario_params)
          flash[:success]="Comentario Actualizado!"
          format.html {redirect_to @comentario}
          format.json {render :index, status: :created, location: @comentarios }
          format.js
        else
          flash[:alert]="Problemas Con La Grabacion"
          format.html {render :show}
          format.json {render json: @comentario.errors, status: :unprocessable_entity}
        end
      end
  end

  def create
    @comentario = current_user.comentarios.new(comentario_params)
    respond_to do |format|
      if @comentario.save!
        flash[:success]="Comentario Registrado!"
        format.html {redirect_to @comentario}
        format.json {render :index, status: :created, location: @comentario }
        format.js
      else
        flash[:alert]="Problemas Con La Grabacion"
        format.html {render :show}
        format.json {render json: @comentario.errors, status: :unprocessable_entity}
      end
    end

  end

  private
  def comentario_params
    params.require(:comentario).permit(:titulo, :descripccion)
  end
end
