const APCA_PAPER_API_URL = "https://paper-api.alpaca.markets"
const APCA_LIVE_API_URL = "https://api.alpaca.markets"
const APCA_DATA_API_URL = "https://data.alpaca.markets"

function getbaseurl()
    if !haskey(ENV, "APCA_ENV") || ENV["APCA_ENV"] != "live"
        return APCA_PAPER_API_URL
    end
    APCA_LIVE_API_URL
end

struct Client
    key_id::String
    secret_key::String
end

Client() = Client(ENV["APCA_API_KEY_ID"], ENV["APCA_API_SECRET_KEY"])

global client = Client()

function headers(c::Client)
    return [
        ("APCA-API-KEY-ID", c.key_id),
        ("APCA-API-SECRET-KEY", c.secret_key),
    ]
end

function request(c::Client, resource::String,
    params::Dict{String,String}; verb="GET", base=APCA_PAPER_API_URL)

    uri = string(base, resource)
    if length(params) > 0
        uri = string(uri, "?", escapeuri(params))
    end

    println("$verb $uri")

    return HTTP.request(verb, uri; headers=headers(c))
end

function request(c::Client, resource::String; verb="GET", base=APCA_PAPER_API_URL)
    return request(c, resource, Dict{String,String}(); verb=verb, base=base)
end
