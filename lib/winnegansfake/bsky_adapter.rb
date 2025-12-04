module WinnegansFake
  class BskyAdapter
    def post(text:)
      logger.measure_info(component: self.class.name, at: __method__, text: text) do
        client.post_request(
          "com.atproto.repo.createRecord",
          {
            repo: client.user.did,
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
      @client ||= BskyClient.new
    end

    def logger
      WinnegansFake.logger
    end
  end
end
