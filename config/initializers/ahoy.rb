class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true JavaScript tracking
Ahoy.api = false

# beter user agent parsing
Ahoy.user_agent_parser = :device_detector
Ahoy.job_queue = :low_priority
