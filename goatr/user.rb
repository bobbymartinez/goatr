module Goatr
  class User < Hashie::Mash
    class NotFoundError < StandardError; end

    def self.find(id)
      storage = Goatr::Storage::User.new
      u = storage.fetch(id)
      if u.present?
        new(u)
      else
        u = Goatr::Clients::Slack::User.by_id(id)
        if u.present?
          storage.cache(id, u)
          new(u)
        else
          nil
        end
      end
    end

    def username
      profile['email'].gsub('@bigcommerce.com','')
    end

    def email
      profile['email']
    end

    def first_name
      profile['first_name']
    end

    def last_name
      profile['last_name']
    end

    def title
      profile['title']
    end

    def phone
      profile['phone']
    end
  end
end
