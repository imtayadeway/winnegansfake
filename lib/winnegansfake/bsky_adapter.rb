module WinnegansFake
  class BskyAdapter
    def post(text:)
      logger.info(component: self.class.name, at: __method__, text: text) do
        client.post_request(
          "com.atproto.repo.createRecord",
          {
            repo: bsky.user.did,
            collection: 'app.bsky.feed.post',
            record: {
              text: text,
              createdAt: Time.now.iso8601,
              langs: ["en"]
            }
          }
        )
      end
      true
    rescue Minisky::Error => e
      data = {}
      data[:status] = e.status if e.respond_to?(:status)
      data[:data] = e.data if e.respond_to(:data)
      logger.error({component: self.class.name, at: __method__, message: e.message}.merge(data))
      false
    end

    private

    def client
      Minisky.new("api.bsky.app", "config/bluesky.yml")
    end
  end
end
