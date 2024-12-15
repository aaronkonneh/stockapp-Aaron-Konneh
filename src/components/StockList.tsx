import React from 'react';
import { List, ListItem, ListItemText, Box, Typography, Divider } from '@mui/material';
import { Stock } from '../types';
import { formatPrice, formatChange, formatPercentage } from '../utils/formatters';

interface StockListProps {
  stocks: Stock[];
}

export const StockList: React.FC<StockListProps> = ({ stocks }) => {
  if (stocks.length === 0) {
    return (
      <Box p={3}>
        <Typography color="text.secondary" align="center">
          No stocks found
        </Typography>
      </Box>
    );
  }

  return (
    <List sx={{ width: '100%', bgcolor: 'background.paper' }}>
      {stocks.map((stock, index) => (
        <React.Fragment key={stock.symbol}>
          <ListItem>
            <ListItemText
              primary={
                <Typography variant="h6" component="span">
                  {stock.symbol}
                </Typography>
              }
              secondary={formatPrice(stock.currentPrice)}
            />
            <Box textAlign="right">
              <Typography
                color={stock.change >= 0 ? 'success.main' : 'error.main'}
                variant="body1"
              >
                {formatChange(stock.change)}
              </Typography>
              <Typography
                variant="body2"
                color={stock.percentChange >= 0 ? 'success.main' : 'error.main'}
              >
                {formatPercentage(stock.percentChange)}
              </Typography>
            </Box>
          </ListItem>
          {index < stocks.length - 1 && <Divider />}
        </React.Fragment>
      ))}
    </List>
  );
};