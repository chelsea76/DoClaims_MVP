class TasksController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_reservation, only: [:approve, :decline]

  def index
    @claim = Claim.find(params[:claim_id])
    # @tasks = Task.where(claim_id: claim.id)
  end


  def create
    @claim = Claim.find(params[:claim_id])

    @task = current_user.tasks.build(task_params)
    @task.claim = claim
    @task.save

    redirect_back(fallback_location: request.referer, notice: "Saved...")
  end

  def my_tasks
    @my_tasks = current_user.tasks.order(task_due: :asc)
  end



  private
    def task_params
      params.require(:task).permit(:task_type, :task_name, :task_description, :deliverable_type, :task_due)
    end

end
