import axios from 'axios';
import { FINNHUB_API_KEY, FINNHUB_BASE_URL } from '../utils/constants';
import { Stock, News } from '../types';

export const getStockQuote = async (symbol: string): Promise<Stock | null> => {
  try {
    const response = await axios.get(
      `${FINNHUB_BASE_URL}/quote?symbol=${symbol}&token=${FINNHUB_API_KEY}`
    );
    
    return {
      symbol,
      currentPrice: response.data.c,
      change: response.data.d,
      percentChange: response.data.dp,
    };
  } catch (error) {
    console.error('Error fetching stock quote:', error);
    return null;
  }
};

export const getMarketNews = async (): Promise<News[]> => {
  try {
    const response = await axios.get(
      `${FINNHUB_BASE_URL}/news?category=general&token=${FINNHUB_API_KEY}`
    );
    
    return response.data.slice(0, 5).map((item: any) => ({
      headline: item.headline || '',
      summary: item.summary || '',
      url: item.url || '',
      source: item.source || '',
    }));
  } catch (error) {
    console.error('Error fetching market news:', error);
    return [];
  }
};