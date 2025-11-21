module WinnegansFake
  class BskyAdapter
    def post(text: "Hello world!")
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

    private

    def client
      Minisky.new("api.bsky.app", "config/bluesky.yml")
    end
  end
end
