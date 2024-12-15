export const formatPrice = (price: number): string => {
  return `$${price.toFixed(2)}`;
};

export const formatChange = (change: number): string => {
  const prefix = change >= 0 ? '+' : '';
  return `${prefix}${change.toFixed(2)}`;
};

export const formatPercentage = (percentage: number): string => {
  const prefix = percentage >= 0 ? '+' : '';
  return `${prefix}${percentage.toFixed(2)}%`;
};