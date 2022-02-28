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

function getaccount()
    resp = request(client, "/v2/account")
    js = JSON.parse(String(resp.body))
    unmarshal(Account, js)
end
