import React from 'react';
import { TextField, Box } from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';

interface SearchBarProps {
  onSearch: (query: string) => void;
}

export const SearchBar: React.FC<SearchBarProps> = ({ onSearch }) => {
  return (
    <Box sx={{ p: 2 }}>
      <TextField
        fullWidth
        placeholder="Search stocks..."
        onChange={(e) => onSearch(e.target.value)}
        InputProps={{
          startAdornment: <SearchIcon sx={{ mr: 1, color: 'action.active' }} />,
        }}
      />
    </Box>
  );
};