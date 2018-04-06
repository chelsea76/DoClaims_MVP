class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_claim
  # before_action :set_reservation, only: [:approve, :decline]

  def index
    @my_tasks = @claim.tasks.where(user_id: current_user.id)
    @other_tasks = @claim.tasks.where("user_id != #{current_user.id}")
  end

  def new
    @task = @claim.tasks.new
  end

  def edit
    @task = Task.find(params[:id])
    if @task.user_id != current_user.id
      flash[:error] = "You do not have access to edit this task"
      redirect_to claim_tasks_path(@claim)
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update_column(:user_id, params[:user_id]) if params[:user_id].present?
    if @task.update_attributes(task_update_params.merge!(updated_by: current_user.id))
      if params[:minutes_logged].present?
        @task.task_hours_logs.create(minutes_logged: params[:minutes_logged], user: current_user)
      end
      flash[:success] = "Task updated successfully"
      redirect_to claim_tasks_path(@claim)
    else
      flash[:errors] = @task.errors.full_messages
      render :edit
    end
  end

  def create
    @task = @claim.tasks.build(task_params.merge!(created_by: current_user.id, status: "open", RAG_status: 'R' ))
    if @task.save
      flash[:success] = "Task created successfully"
      redirect_to claim_tasks_path(@claim)
    else
      flash[:errors] = @task.errors.full_messages
      render :new
    end
  end

  def users
    users = User.where("fullname like '%#{params[:term]}%'").pluck(:fullname, :id)
    result = users.size > 0 ? users.inject([]) {|res, user| res << { label: user[0], value: user[0], id: user[1] }; res} : [{value: params[:term], label: "No Contacts Found"}]
    render json: result
  end

  def my_tasks
    @my_tasks = current_user.tasks.order(task_due: :asc)
  end

  private

  def task_params
    params.require(:task).permit(:task_type_id, :milestone, :title, :status, :description, :RAG_status, :deliverable_type, :task_due, :user_id, :created_by)
  end

  def task_update_params
    params.require(:task).permit(:status, :user_id, :updated_by)
  end

  def find_claim
    @claim = Claim.find(params[:claim_id])
  end  

end
