import React from 'react';

import extractResponse from '../utils/extractResponse';

const CurrentUserContext = React.createContext([]);
export const useCurrentUserContext = () => React.useContext(CurrentUserContext);

export const CurrentUserContextProvider = ({ children }) => {
  const [currentUser, setCurrentUser] = React.useState(null);
  const [isFetchingCurrentUser, setIsFetchingCurrentUser] =
    React.useState(null);

  const fetchCurrentUser = React.useCallback(() => {
    const url = 'api/v1/auth/current_user';
    setIsFetchingCurrentUser(true);
    fetch(url, {
      method: 'get',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then(extractResponse)
      .then(setCurrentUser)
      .catch(err => {
        console.error(`Error: ${err}`); // eslint-disable-line no-console
      })
      .finally(() => setIsFetchingCurrentUser(false));
  }, []);

  const value = React.useMemo(
    () => ({
      currentUser,
      setCurrentUser,
      fetchCurrentUser,
      isFetchingCurrentUser,
    }),
    [isFetchingCurrentUser, currentUser, fetchCurrentUser]
  );

  React.useLayoutEffect(fetchCurrentUser, [fetchCurrentUser]);

  return (
    <CurrentUserContext.Provider value={value}>
      {children}
    </CurrentUserContext.Provider>
  );
};
