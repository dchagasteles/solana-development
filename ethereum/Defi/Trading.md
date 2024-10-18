========================================================

# Spot Trading

- buy or sell crypto assets immediately
- you have direct onwership of cryptocurrency
- based on orderbook

========================================================

# Margin Trading

- Spot Trading + Leverage

- market: OrderBook (Spot Market)
- BTC/USDT (real 2 asset)
- marketPrice = spot price

========================================================

# Future Trading

- futures are contracts that represent valut of currency.
- you do not owner underlying cryptocurrency when purchase a future contract.
- instead, you own contract under which you agreed to buy/sell at

- market: spot market
- BTC/USDC (only one USDC asset)
- Liquidation
- marketPrice = index price
- Mark Price = latest ordered price

========================================================

# Perpetual Trading

- Same with General Future Trading
- But no expiration or settlement of Perpetual Contracts.
- Use `Funding` for convergence between Perpetual Contract and Mark Price.

## Mark Price

To avoid market manipulation & ensure that Perpetual Contract is price-matched to the Spot Price, utilize `Mark Price` to calculate PnL for all traders

## Fundling

- if `FundlyingRate` is positive, long pay to short (and vice in versa)
- calculated based on differecen between perpetual contract price & spot price
- when bull market, fundingRate is positive and tends to rise (and vice in versa)
- formula
  `Funding Amount = Nominal Value of Positions * Funding Rate`
  `(Nominal Value of Positions = Mark Price * Size of a Contract)`

==========================================

# Spot VS Future

## Leverage

- No levearge on Spot, but support on Future

## Profit

- In spot, you earn when price rises
- In future, use long/short position to get profies when both price goes up or down

## Liquidity

- Future market liquidity > spot market liquidity

## Price

- `Spot Price`: price for all txs in spot market
- Futuer Price: prevailing spot price + future premium (future premium can be positive or negative)

https://www.binance.com/en/support/faq/what-are-the-differences-between-spot-trading-and-futures-trading-360033162052

==========================================

# Position

- Long: belives will rise & buy now
- Short: believes will drop & sell now

==========================================

# Order Types

## Take-profit (T/P)

limit orders that are closed when a specified profit level is reached

## TP Order

limit orders that are closed when reached to specific profit level

## Stop Losse:

orders that will buy/sell when reaches to the specific price
