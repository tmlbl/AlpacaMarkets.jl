module AlpacaMarkets

export Client,
       getaccount,
       bars,
       latest

using HTTP,
      URIs,
      JSON,
      Dates,
      Unmarshal,
      TimeSeries

# Alpaca API often encodes numbers as strings in the JSON. With these
# conversion functions Unmarshal.jl can cast those automatically
Unmarshal.Float64(s::String) = parse(Float64, s)
Unmarshal.Int64(s::String) = parse(Int64, s)

include("client.jl")
include("accounts.jl")
include("data.jl")

end # module
