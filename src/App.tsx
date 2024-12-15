import React, { useEffect, useState } from 'react';
import { Container, Grid, Paper, useMediaQuery, useTheme, Box, AppBar, Toolbar, Typography } from '@mui/material';
import { StockList } from './components/StockList';
import { NewsFeed } from './components/NewsFeed';
import { SearchBar } from './components/SearchBar';
import { Stock } from './types';
import { getStockQuote } from './services/finnhubService';
import { DEFAULT_STOCKS } from './utils/constants';

export default function App() {
  const [defaultStocks, setDefaultStocks] = useState<Stock[]>([]);
  const [searchResults, setSearchResults] = useState<Stock[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));

  useEffect(() => {
    const loadStocks = async () => {
      const stocks = await Promise.all(
        DEFAULT_STOCKS.map(symbol => getStockQuote(symbol))
      );
      setDefaultStocks(stocks.filter((stock): stock is Stock => stock !== null));
    };
    loadStocks();

    // Refresh stocks every minute
    const interval = setInterval(loadStocks, 60000);
    return () => clearInterval(interval);
  }, []);

  const handleSearch = async (query: string) => {
    if (!query) {
      setIsSearching(false);
      setSearchResults([]);
      return;
    }

    setIsSearching(true);
    const stock = await getStockQuote(query.toUpperCase());
    setSearchResults(stock ? [stock] : []);
  };

  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            Stocks App
          </Typography>
        </Toolbar>
      </AppBar>
      <Container maxWidth="lg" sx={{ py: 4 }}>
        <Grid container spacing={3}>
          <Grid item xs={12} md={8}>
            <Paper elevation={3} sx={{ height: '100%' }}>
              <SearchBar onSearch={handleSearch} />
              <StockList stocks={isSearching ? searchResults : defaultStocks} />
            </Paper>
          </Grid>
          {(!isMobile || !isSearching) && (
            <Grid item xs={12} md={4}>
              <Paper elevation={3} sx={{ height: '100%' }}>
                <NewsFeed />
              </Paper>
            </Grid>
          )}
        </Grid>
      </Container>
    </Box>
  );
}