using Test,
      AlpacaMarkets,
      Dates,
      JSON

@testset "DateTimes" begin
    js = JSON.parse("""
    {
        "created_at": "2021-03-16T18:38:01.942282Z",
        "updated_at": "2021-03-16T18:38:01.942282Z",
        "submitted_at": "2021-03-16T18:38:01.937734Z"
    }
    """)

    AlpacaMarkets.parsedatefield(js, "created_at")
    @test typeof(js["created_at"]) <: DateTime
    @test year(js["created_at"]) == 2021
    @test day(js["created_at"]) == 16
    @test minute(js["created_at"]) == 38
end

@testset "OrderInfo" begin
    data = """{
        "id": "61e69015-8549-4bfd-b9c3-01e75843f47d",
        "client_order_id": "eb9e2aaa-f71a-4f51-b5b4-52a6c565dad4",
        "created_at": "2021-03-16T18:38:01.942282Z",
        "updated_at": "2021-03-16T18:38:01.942282Z",
        "submitted_at": "2021-03-16T18:38:01.937734Z",
        "filled_at": null,
        "expired_at": null,
        "canceled_at": null,
        "failed_at": null,
        "replaced_at": null,
        "replaced_by": null,
        "replaces": null,
        "asset_id": "b0b6dd9d-8b9b-48a9-ba46-b9d54906e415",
        "symbol": "AAPL",
        "asset_class": "us_equity",
        "notional": "500",
        "qty": null,
        "filled_qty": "0",
        "filled_avg_price": null,
        "order_class": "",
        "order_type": "market",
        "type": "market",
        "side": "buy",
        "time_in_force": "day",
        "limit_price": null,
        "stop_price": null,
        "status": "accepted",
        "extended_hours": false,
        "legs": null,
        "trail_percent": null,
        "trail_price": null,
        "hwm": null
      }"""

    # js = JSON.parse(data)
    # info = AlpacaMarkets.unmarshal(OrderInfo, js)
    # @test info.id == "61e69015-8549-4bfd-b9c3-01e75843f47d"
    # @test info.client_order_id == "eb9e2aaa-f71a-4f51-b5b4-52a6c565dad4"
    # @test typeof(info.created_at) <: DateTime
end
