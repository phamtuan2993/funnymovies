import React from 'react';
import { Spin } from 'antd';

import LoginForm from './LoginForm';
import { useCurrentUserContext } from '../contexts/CurrentUserContext';
import CurrentUserMenu from './CurrentUserMenu';

const CurrentUserActions = () => {
  const { currentUser, isFetchingCurrentUser } = useCurrentUserContext();

  if (isFetchingCurrentUser) return <Spin spinning />;

  return currentUser ? <CurrentUserMenu /> : <LoginForm />;
};

export default CurrentUserActions;
