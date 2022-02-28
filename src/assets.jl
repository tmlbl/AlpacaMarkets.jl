"""
The assets API serves as the master list of assets available for trade and data
consumption from Alpaca. Assets are sorted by asset class, exchange and symbol.
Some assets are only available for data consumption via Polygon, and are not
tradable with Alpaca. These assets will be marked with the flag tradable=false
"""
struct Asset
    name::String
    id::String
    class::String
    symbol::String
    exchange::String
    easy_to_borrow::Bool
    shortable::Bool
    status::String
    fractionable::Bool
    tradable::Bool
    marginable::Bool
end

"""
Get a list of assets
"""
function getassets()
    resp = request(client, "/v2/assets"; base=APCA_PAPER_API_URL)
    js = JSON.parse(String(resp.body))
    unmarshal(Vector{Asset}, js)
end

"""
Get an individual asset
"""
function getasset(symbol::Symbol)
    resp = request(client, "/v2/assets/$symbol"; base=APCA_PAPER_API_URL)
    js = JSON.parse(String(resp.body))
    unmarshal(Asset, js)
end

getasset(s::String) = getasset(Symbol(s))
