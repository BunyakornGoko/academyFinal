class QuestsController < ApplicationController
  before_action :set_quest, only: [:destroy, :toggle_status]

  # GET /quests or /quests.json
  def index
    @quests = Quest.all
  end

  # GET /quests/new
  def new
    @quest = Quest.new
  end

  # POST /quests or /quests.json
  def create
    @quest = Quest.new(quest_params)

    respond_to do |format|
      if @quest.save
        format.html { redirect_to quests_url, notice: "Quest was successfully created." }
        format.json { render :show, status: :created, location: @quest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quests/1 or /quests/1.json
  def destroy
    @quest.destroy!

    respond_to do |format|
      format.html { redirect_to quests_path, status: :see_other, notice: "Quest was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_status
    @quest.toggle_status!
    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: turbo_stream.replace(
          @quest,
          partial: "quests/quest_card",
          locals: { quest: @quest }
        )
      }
      format.html { redirect_to quests_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quest
      @quest = Quest.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def quest_params
      params.require(:quest).permit(:name, :status)
    end
end
