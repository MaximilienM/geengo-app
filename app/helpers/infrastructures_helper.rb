module InfrastructuresHelper
  
  # distance is passed in km
  def distance_in_meters_or_km(distance)
    
    distance = distance.to_f
    
    if distance < 1
      "#{(distance * 1000).round(0)} m"
    else
      "#{(distance).round(1)} km"
    end
  end
  
  def golf_infrastructure_path(*args)
    infrastructure_path args
  end
  
end
