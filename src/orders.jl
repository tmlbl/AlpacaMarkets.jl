# struct Order
#     symbol::String
#     # number of shares to trade
#     qty::Int
#     # dollar amount to trade - does not work with qty
#     notional::Float64
#     # buy, sell
#     side::String
#     # market, limit, stop, stop_limit, trailing_stop
#     type::String
#     # day, gtc, opg, cls, ioc, fok
#     time_in_force::String
#     # required if type is limit or stop_limit
#     limit_price::String
#     # required if type is stop or stop_limit
#     stop_price::String
#     # this or trail_percent is required if type is trailing_stop
#     trail_price::String
#     trail_percent::String
#     # If true, order will be eligible to execute in premarket/afterhours.
#     # Only works with type limit and time_in_force day.
#     extended_hours::Bool
#     # A unique identifier for the order. Automatically generated if not sent.
#     client_order_id::String
#     # simple, bracket, oco or oto
#     order_class::String
#     # take_profit
#     # stop_loss
# end

module OrderSide
    Buy = "buy"
    Sell = "sell"
end

module OrderType
    Market = "market"
    Limit = "limit"
    Stop = "stop"
    StopLimit = "stop_limit"
    TrailingStop = "trailing_stop"
end

module TimeInForce
    Day = "day"
    GoodTilCanceled = "gtc"
    MarketOpen = "opg"
    MarketClose = "cls"
    ImmediateOrCancel = "ioc"
    FillOrKill = "fok"
end

abstract type Order end

struct SimpleOrder <: Order
    symbol::String
    qty::Int
    side::String
    type::String
    time_in_force::String
end

MarketBuy(symbol::String, qty::Int) = SimpleOrder(symbol, qty, OrderSide.Buy, OrderType.Market, TimeInForce.Day)

struct OrderInfo
    id::String
    client_order_id::String
    created_at::DateTime
    updated_at::DateTime
    submitted_at::DateTime
end

parsedatefield(js::Dict{String,Any}, key::String) = begin
    js[key] = DateTime(js[key][1:23])
end

parseorderinfo(js::Dict{String,Any}) = begin
    js["client_order_id"]
end

function placeorder(order::Order)
    body = JSON.json(order)
    show(body)
    resp = request(client, "/v2/orders", Dict{String,String}(); verb="POST", body=body)
    resp
end