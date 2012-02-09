module HasManyTrackers

  def self.included(model)
    model.instance_eval do
      has_many :trackers
      after_create :create_trackers # Defined by model.
      after_destroy :destroy_trackers
    end
  end

  private

  def destroy_trackers
    self.trackers.destroy_all
  end

end
