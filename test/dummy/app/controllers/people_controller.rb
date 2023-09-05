class PeopleController < ApplicationController
  before_action :set_tenant
  around_action :switch_to_tenant
  before_action :set_person, only: %i[show edit update destroy]

  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/1
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to [@tenant, @person], notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      redirect_to [@tenant, @person], notice: "Person was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy
    redirect_to tenant_people_url(@tenant), notice: "Person was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find params[:id]
  end

  def set_tenant
    @tenant = Tenant.find params[:tenant_id]
  end

  def switch_to_tenant
    Landlord.switch_to(@tenant) { yield }
  end

  # Only allow a list of trusted parameters through.
  def person_params
    params.require(:person).permit(:name, :email)
  end
end
