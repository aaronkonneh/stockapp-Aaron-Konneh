export interface Stock {
  symbol: string;
  currentPrice: number;
  change: number;
  percentChange: number;
}

export interface News {
  headline: string;
  summary: string;
  url: string;
  source: string;
}