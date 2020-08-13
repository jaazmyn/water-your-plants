class GenerateNotificationJob < ApplicationJob
  queue_as :default

  def perform
    plants = Plant.all
    plants.each do |plant|
      next unless plant.watering_events

      last_watering_event = WateringEvent.where(plant: plant).order("date DESC").first[:date]
      next_watering_event = last_watering_event + plant.watering_interval
      Notification.create(date: Date.today, plant: plant) if next_watering_event == Date.today
    end
  end
end
