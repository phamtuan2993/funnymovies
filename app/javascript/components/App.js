import React from 'react';

import Routes from '../routes/index';
import { CurrentUserContextProvider } from '../contexts/CurrentUserContext';
import { MoviesContextProvider } from '../contexts/MoviesContext';

export default () => (
  <CurrentUserContextProvider>
    <MoviesContextProvider>
      <Routes />
    </MoviesContextProvider>
  </CurrentUserContextProvider>
);
