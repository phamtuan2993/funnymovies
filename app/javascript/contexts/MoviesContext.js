import React from 'react';

import extractResponse from '../utils/extractResponse';

const MoviesContext = React.createContext([]);
export const useMoviesContext = () => React.useContext(MoviesContext);

export const MoviesContextProvider = ({ children }) => {
  const [movies, setMovies] = React.useState(null);
  const [isFetchingMovies, setIsFetchingMovies] = React.useState(null);

  const fetchMovies = React.useCallback(
    ({ pageIndex = 1, itemsPerPage = 20 } = {}) => {
      const url = `api/v1/movies?page_index=${pageIndex}&items_per_page=${itemsPerPage}`;

      setIsFetchingMovies(true);

      fetch(url, {
        method: 'get',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
        },
      })
        .then(extractResponse)
        .then(newMovies =>
          setMovies(oldMovies => {
            if (!oldMovies || newMovies.pageIndex === 1) return newMovies;
            if (oldMovies.isAtLastPage) return oldMovies;

            return {
              ...newMovies,
              items: [...oldMovies.items, ...newMovies.items],
            };
          })
        )
        .catch(err => {
          console.error(`Error: ${err}`); // eslint-disable-line no-console
        })
        .finally(() => setIsFetchingMovies(false));
    },
    []
  );

  const value = React.useMemo(
    () => ({
      movies,
      setMovies,
      fetchMovies,
      isFetchingMovies,
    }),
    [isFetchingMovies, movies, fetchMovies]
  );

  return (
    <MoviesContext.Provider value={value}>{children}</MoviesContext.Provider>
  );
};
