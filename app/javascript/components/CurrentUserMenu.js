import React from 'react';
import { Button, Typography, Form } from 'antd';

import { useCurrentUserContext } from '../contexts/CurrentUserContext';
import ShareMovieButton from './ShareMovieButton';

const CurrentUserMenu = () => {
  const { currentUser, setCurrentUser } = useCurrentUserContext();

  const signOut = React.useCallback(() => {
    const url = 'api/v1/auth/sign_out';
    fetch(url, {
      method: 'delete',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then(data => {
        if (data.ok) {
          setCurrentUser(null);
        }
        throw new Error('Network error.');
      })
      .catch(err => console.error(`Error: ${err}`)); // eslint-disable-line no-console
  }, [setCurrentUser]);

  return (
    <Form layout="inline">
      <Form.Item name="email">
        <Typography.Title level={4} style={{ color: 'white', margin: 0 }}>
          Welcome {currentUser.email}
        </Typography.Title>
      </Form.Item>

      <Form.Item name="password" type="password">
        <ShareMovieButton />
      </Form.Item>

      <Form.Item style={{ marginRight: 0 }}>
        <Button type="primary" onClick={signOut}>
          Logout
        </Button>
      </Form.Item>
    </Form>
  );
};

export default CurrentUserMenu;
