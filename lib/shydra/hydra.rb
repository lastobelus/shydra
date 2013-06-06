=begin

  Scenarios:

  1. request that might return more than 250
    - limit: :none
    - adds callback that fetches another page if result size == SHOPIFY_API_MAX_LIMIT

  2. request that will return several pages that needs to be fast
  - use a hydra
  - does count first
  - queues request for each page, callback inserts into correct slot in result_array
  - if too many pages for api limit, fetch as many pages as possible, then sleep for some amount of time
  - time to sleep: requests-used-before-starting / API-LIMIT
  - at the end flatten the result_array 


  API LIMIT
  - memcached
  - cache {used: x, at: Time.now}
  - before starting hydra:
    - count requests
    - check cache
    - if at < TUNEABLE_PARAM (like, 20 seconds) & enough requests (including TUNEABLE_BUFFER)
      - run everything
    - do_run: run 1 request. update cache
      - if enough requests, run everything
      - else bail or sleep(time allowed)
      - after sleeping time allowed, goto: do_run
    - because requests may have callbacks that queue other requests, the run_loop has to go through this alogrithm every time it pulls a new batch of requests off
=end
module Shydra
  class Hydra < Typhoeus::Hydra


    def initialize(options = {})
      options[:max_concurrency] ||= Shydra.max_concurrency
      super(options)
    end



    def pause!
      @paused = true
    end

    def paused?
      @paused
    end

    def run
      @paused = false
      super
    end

    def dequeue
      return if paused?
      super
    end

  end
end
