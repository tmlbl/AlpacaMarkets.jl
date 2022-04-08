function bars2series(js::Dict{String,Any})
    times = map(x -> parse(DateTime, x["t"][1:19]), js["bars"])
    values = zeros(Float64, length(js["bars"]), 5)

    for (i, b) in enumerate(js["bars"])
        values[i, 1] = b["o"]
        values[i, 2] = b["h"]
        values[i, 3] = b["l"]
        values[i, 4] = b["c"]
        values[i, 5] = b["v"]
    end

    TimeArray(times, values, Symbol[:Open, :High, :Low, :Close, :Volume], js["symbol"])
end

"""
Retrieve candle-format historical data for a symbol
"""
function ohlc(symbol::Symbol, start::DateTime, timeframe::String)
    resp = request(client, "/v2/stocks/$symbol/bars", Dict{String,String}(
        "start" => "$(start)Z",
        "timeframe" => "$timeframe",
    ); base=APCA_DATA_API_URL)
    bars2series(JSON.parse(String(resp.body)))
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
function latest(s::Symbol)
    resp = request(client, "/v2/stocks/$s/trades/latest"; base=APCA_DATA_API_URL)
    js = JSON.parse(String(resp.body))
    # Truncate the timestamp to get it to parse
    js["trade"]["t"] = js["trade"]["t"][1:23]
    unmarshal(TradeInfo, js)
end
