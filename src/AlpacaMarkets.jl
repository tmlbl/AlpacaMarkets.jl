module AlpacaMarkets

export Client,
       getaccount,
       bars,
       latest

using HTTP,
      URIs,
      JSON,
      Dates,
      Unmarshal

struct Client
    key_id::String
    secret_key::String
end

Client() = Client(ENV["APCA_API_KEY_ID"], ENV["APCA_API_SECRET_KEY"])

function headers(c::Client)
    return [
        ("APCA-API-KEY-ID", c.key_id),
        ("APCA-API-SECRET-KEY", c.secret_key),
    ]
end

function request(c::Client, resource::String,
    params::Dict{String,String}; verb="GET", base="https://paper-api.alpaca.markets")

    uri = string(base, resource)
    if length(params) > 0
        uri = string(uri, "?", escapeuri(params))
    end

    println("$verb $uri")

    return HTTP.request(verb, uri; headers=headers(c))
end

function request(c::Client, resource::String; verb="GET", base="https://paper-api.alpaca.markets")
    return request(c, resource, Dict{String,String}(); verb=verb, base=base)
end

struct Account
    id::String
    account_number::String
    status::String
    currency::String
    cash::Float64
    portfolio_value::Float64
    pattern_day_trader::Bool
    trade_suspended_by_user::Bool
    trading_blocked::Bool
    transfers_blocked::Bool
    account_blocked::Bool
    created_at::String
    shorting_enabled::Bool
    long_market_value::Float64
    short_market_value::Float64
    equity::Float64
    last_equity::Float64
    multiplier::Int64
    buying_power::Float64
    initial_margin::Float64
    maintenance_margin::Float64
    sma::Float64
    daytrade_count::Int
    last_maintenance_margin::Float64
    daytrading_buying_power::Float64
    regt_buying_power::Float64
end

Base.show(io::IO, a::Account) = print(io, "Account($(a.id))")

Unmarshal.Float64(s::String) = parse(Float64, s)
Unmarshal.Int64(s::String) = parse(Int64, s)

function getaccount(c::Client)
    resp = request(c, "/v2/account")
    js = JSON.parse(String(resp.body))
    unmarshal(Account, js)
end

function bars(c::Client, symbol::Symbol, start::DateTime, timeframe::String)
    resp = request(c, "/v2/stocks/$symbol/bars", Dict{String,String}(
        "start" => "$(start)Z",
        "timeframe" => "$timeframe",
    ); base="https://data.alpaca.markets")
    JSON.parse(String(resp.body))
end

struct Trade
    t::DateTime
    x::String
    p::Float64
    s::Int64
    c::Vector{String}
    i::Int64
    z::String
end

struct TradeInfo
    symbol::Symbol
    trade::Trade
end

"""
Gets the most recent trade for the given symbol
"""
function latest(c::Client, s::Symbol)
    resp = request(c, "/v2/stocks/$s/trades/latest"; base="https://data.alpaca.markets")
    js = JSON.parse(String(resp.body))
    js["trade"]["t"] = js["trade"]["t"][1:23]
    unmarshal(TradeInfo, js)
end

end # module
