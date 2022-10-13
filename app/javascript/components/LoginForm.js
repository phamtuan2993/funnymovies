import { Button, Form, Input } from 'antd';
import React from 'react';

import { useCurrentUserContext } from '../contexts/CurrentUserContext';

const LoginForm = () => {
  const formRef = React.useRef();
  const { setCurrentUser } = useCurrentUserContext();

  const onFinish = React.useCallback(
    values => {
      if (!values.email || !values.password) return;

      const url = 'api/v1/auth/login_or_sign_up';
      fetch(url, {
        method: 'post',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(values),
      })
        .then(data => {
          if (data.ok) {
            return data.json();
          }
          throw new Error('Network error.');
        })
        .then(({ data }) => {
          setCurrentUser(data);
        })
        .catch(err => console.error(`Error: ${err}`)); // eslint-disable-line no-console
    },
    [setCurrentUser]
  );

  return (
    <Form ref={formRef} layout="inline" onFinish={onFinish}>
      <Form.Item name="email">
        <Input placeholder="email" />
      </Form.Item>

      <Form.Item name="password" type="password">
        <Input placeholder="password" />
      </Form.Item>

      <Form.Item style={{ marginRight: 0 }}>
        <Button type="primary" htmlType="submit">
          Login/Register
        </Button>
      </Form.Item>
    </Form>
  );
};

export default LoginForm;
