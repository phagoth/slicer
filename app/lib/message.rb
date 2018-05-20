class Message
  class << self

    def not_found(record = 'record')
      "Sorry, #{record} not found."
    end

    def invalid_credentials
      'Invalid credentials'
    end

    def invalid_token
      'Invalid token'
    end

    def missing_token
      'Missing token'
    end

    def unauthorized
      'Unauthorized request'
    end

    def account_created
      'Account created successfully'
    end

    def account_not_created
      'Account could not be created'
    end

    def expired_token
      'Sorry, your token has expired. Please login to continue.'
    end

    def finish_less_than_start
      'Finish should be greater than Start'
    end

    def finish_exceeds_duration
      'Finish should be less than video duration'
    end
  end
end