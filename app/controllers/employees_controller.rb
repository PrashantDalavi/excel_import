class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render :layout => false }
    end
  end

  def prepare_import    
  end

  def bulk_upload
    file = params[:file]
    @success = []
    @errors = []
    file_ext = File.extname(file.original_filename)
    if (file_ext == (".xls" || ".xlsx")) 
      spreadsheet = (file_ext == ".xls") ? Roo::Excel.new(file.path, file_warning: :ignore) : Roo::Excelx.new(file.path, file_warning: :ignore)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        begin
          binding.pry
          name = spreadsheet.row(i)[0]
          gender = spreadsheet.row(i)[1]
          email = spreadsheet.row(i)[2]
          age = spreadsheet.row(i)[3].to_i
          contact = spreadsheet.row(i)[4].to_i
          company_id = Company.where("company_name LIKE ?", "%#{spreadsheet.row(i)[5]}%").first.id rescue nil
          employee = {:name=>name, :gender=>gender, :email=>email, :age=>age, :contact_no=>contact.to_s, :company_id=> company_id}
          employee_imported = Employee.new(employee)
          if employee_imported.save
            @success << {:employee_imported=>employee_imported.as_json, :message=>["success"]}
          else
            @errors << {:employee_imported=>employee_imported.as_json, :message=>employee_imported.errors.full_messages.join(','), :row_no => i}
          end
        rescue Exception => e
          @errors << {:row_no => i, :message=>"#{e}"}
        end
      end
    else
      flash[:alert] = "Please upload xls/xlsx file."
      return redirect_to prepare_import_employees_path
    end 
    return render 'prepare_import'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:name, :gender, :email, :age, :contact_no, :company_id)
    end
end
