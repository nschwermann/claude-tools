# GraphQL Query Patterns for Subgraphs

This reference provides common GraphQL query patterns for blockchain subgraph exploration.

## Pagination Patterns

### Basic Pagination
```graphql
query PaginatedQuery($first: Int!, $skip: Int!) {
  entities(first: $first, skip: $skip, orderBy: timestamp, orderDirection: desc) {
    id
    timestamp
    # ... other fields
  }
}
```

Variables:
```json
{
  "first": 100,
  "skip": 0
}
```

### Cursor-based Pagination
```graphql
query CursorPagination($first: Int!, $lastId: String!) {
  entities(first: $first, where: { id_gt: $lastId }, orderBy: id) {
    id
    # ... other fields
  }
}
```

## Filtering Patterns

### Time Range Queries
```graphql
query TimeRangeQuery($startTime: Int!, $endTime: Int!) {
  entities(
    where: {
      timestamp_gte: $startTime
      timestamp_lte: $endTime
    }
    orderBy: timestamp
    orderDirection: desc
  ) {
    id
    timestamp
    # ... other fields
  }
}
```

### Address-based Queries
```graphql
query UserActivity($userAddress: String!) {
  # Query by exact address
  transactions(where: { from: $userAddress }) {
    id
    to
    value
    timestamp
  }

  # Query by address (case-insensitive)
  accounts(where: { id: $userAddress }) {
    id
    balance
    # ... other fields
  }
}
```

### Complex Filters
```graphql
query ComplexFilter($minAmount: String!, $tokenAddress: String!) {
  swaps(
    where: {
      amountUSD_gte: $minAmount
      pair_: {
        token0: $tokenAddress
      }
    }
    first: 100
    orderBy: timestamp
    orderDirection: desc
  ) {
    id
    amountUSD
    timestamp
    pair {
      token0 { symbol }
      token1 { symbol }
    }
  }
}
```

## Aggregation Patterns

### Daily Aggregates
```graphql
query DailyStats($dayId: Int!) {
  dayData(id: $dayId) {
    id
    date
    dailyVolumeUSD
    dailyTxns
    totalLiquidityUSD
  }
}
```

### Sum and Count
```graphql
query Aggregations {
  protocol(id: "1") {
    totalValueLockedUSD
    txCount
    pairCount
    totalVolumeUSD
  }
}
```

## Relationship Navigation

### Nested Queries
```graphql
query NestedRelationships($pairId: String!) {
  pair(id: $pairId) {
    id
    token0 {
      id
      symbol
      name
      decimals
    }
    token1 {
      id
      symbol
      name
      decimals
    }
    reserve0
    reserve1
    totalSupply

    # Related entities
    swaps(first: 10, orderBy: timestamp, orderDirection: desc) {
      id
      timestamp
      amount0In
      amount1In
      amount0Out
      amount1Out
      amountUSD
    }
  }
}
```

## Performance Best Practices

### Limit Response Size
- Use `first` parameter to limit results (max typically 1000, recommended 100)
- Paginate large datasets using `skip` or cursor-based pagination
- Avoid querying all items in large collections

### Use Specific Fields
```graphql
# Good - only request needed fields
query EfficientQuery {
  tokens(first: 10) {
    id
    symbol
    name
  }
}

# Avoid - requesting unnecessary nested data
query IneffcientQuery {
  tokens(first: 10) {
    id
    symbol
    name
    pairs {
      swaps {
        # This can return massive amounts of data
      }
    }
  }
}
```

### Use Aggregated Fields
```graphql
# Good - use pre-aggregated data
query GoodAggregation($contractId: String!) {
  erc721Contract(id: $contractId) {
    holders          # Pre-calculated count
    stakedHolders    # Pre-calculated count
    totalSupply { value }
  }
}

# Avoid - counting individual records
query BadAggregation($contractId: String!) {
  erc721Tokens(where: { contract: $contractId }) {
    # Counting these manually is inefficient
    id
  }
}
```

## Common Query Scenarios

### Latest Activity
```graphql
query LatestActivity($limit: Int = 20) {
  transactions(
    first: $limit
    orderBy: timestamp
    orderDirection: desc
  ) {
    id
    timestamp
    blockNumber
    # ... transaction details
  }
}
```

### User Portfolio
```graphql
query UserPortfolio($userAddress: String!) {
  account(id: $userAddress) {
    id

    # ERC20 balances
    erc20Balances(where: { value_gt: "0" }) {
      token {
        id
        symbol
        name
      }
      value
    }

    # ERC721 (NFT) balances
    erc721Balances(where: { value_gt: "0" }) {
      contract {
        id
        name
        symbol
      }
      value
    }
  }
}
```

### Price and Volume Analysis
```graphql
query PriceVolume($pairAddress: String!, $days: Int = 7) {
  pair(id: $pairAddress) {
    token0 { symbol }
    token1 { symbol }
    token0Price
    token1Price
    volumeUSD
    reserveUSD

    # Daily historical data
    pairDayData(
      first: $days
      orderBy: date
      orderDirection: desc
    ) {
      date
      dailyVolumeUSD
      reserveUSD
    }
  }
}
```

## Error Handling

### Common GraphQL Errors

1. **Field doesn't exist**: Check schema with introspection
2. **Type mismatch**: Ensure variable types match schema (String vs Int vs BigInt)
3. **Query too complex**: Simplify nested queries or reduce `first` parameter
4. **Timeout**: Reduce query complexity or add more specific filters

### Debugging Queries

Use introspection to explore the schema:
```graphql
query IntrospectTypes {
  __schema {
    types {
      name
      kind
    }
  }
}

query IntrospectType($typeName: String!) {
  __type(name: $typeName) {
    name
    fields {
      name
      type {
        name
        kind
      }
    }
  }
}
```
