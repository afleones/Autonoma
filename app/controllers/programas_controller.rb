class ProgramasController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :authenticate_role_user, except: [:index , :show]

  def index
    @programas = Programa.all
    if params[:q].present?
      @programas = @programas.where("nombre ilike :q", q: "%#{params[:q]}%")
    end
  end

  def new
    @programa = Programa.new
  end

  def show
    @programa = Programa.find(params[:id])
  end

  def edit
    @programa = Programa.find(params[:id])
  end

  #PUT /programa/:id
  def update
    if @user.has_role? :Admin
      @programa = Programa.find_by id: params[:id]
      if @programa.update(programa_params)
        flash[:success]="Programa Actualizado!"
        render :show
      else
        flash[:alert] = "Problemas con la grabación!"
        render :edit
      end
    else
      flash[:info]="No tiene permisos para acceder a esa vista!"
      render :edit
    end
  end

  def destroy
    if @user.has_role? :Admin
      @programa = Programa.find(params[:id])
      flash[:alert]="Programa Eliminada!"
      @programa.destroy
      redirect_to :action => :index
    end
  end

  def create
    if @user.has_role? :Admin
         @programa = Programa.new(programa_params)
      if @programa.save!
        flash[:success]="Programa Registrada!"
        render :show
      else
        flash[:alert]="Problemas con la grabación!"
        render :new
      end
    else
      flash[:info]="No tiene permisos para acceder a esa vista!"
      render :index
    end
  end

  private
  def programa_params
    params.require(:programa).permit(:nombre)
  end

  def authenticate_role_user
    @user = User.find(current_user.id)
    if @user.has_role? :Admin
    else
      flash[:info]="No tiene permisos para acceder a esa vista!"
      redirect_to programas_path(@programa)
    end
  end
end