import React, { useEffect, useState } from 'react';
import { List, ListItem, ListItemText, Typography, Box } from '@mui/material';
import { News } from '../types';
import { getMarketNews } from '../services/finnhubService';

export const NewsFeed: React.FC = () => {
  const [news, setNews] = useState<News[]>([]);

  useEffect(() => {
    const loadNews = async () => {
      const newsData = await getMarketNews();
      setNews(newsData);
    };
    loadNews();
  }, []);

  return (
    <Box>
      <Typography variant="h6" sx={{ p: 2 }}>
        Latest News
      </Typography>
      <List>
        {news.map((item, index) => (
          <ListItem key={index} divider>
            <ListItemText
              primary={item.headline}
              secondary={item.source}
              primaryTypographyProps={{
                noWrap: true,
                style: { marginBottom: 4 }
              }}
            />
          </ListItem>
        ))}
      </List>
    </Box>
  );
};