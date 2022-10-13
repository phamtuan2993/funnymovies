import React from 'react';
import { Layout, Typography } from 'antd';

import CurrentUserActions from './CurrentUserActions';

const { Header } = Layout;

export default () => {
  return (
    <Header>
      <div
        style={{
          display: 'inline-flex',
          alignItems: 'center',
          width: '100%',
          justifyContent: 'space-between',
        }}
      >
        <div style={{ display: 'inline-flex', alignItems: 'center' }}>
          <div className="logo" />
          <Typography.Title level={1} style={{ color: 'white', margin: 0 }}>
            Funny Movies
          </Typography.Title>
        </div>

        <CurrentUserActions />
      </div>
    </Header>
  );
};
