import React from 'react';
import ReactDOM from 'react-dom/client';

import App from '../components/App';

import('antd/dist/antd.css');

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('root');
  // Create a root.
  const root = ReactDOM.createRoot(container);

  // Initial render
  root.render(<App />);
});
