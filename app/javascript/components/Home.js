import { Layout } from 'antd';
import React from 'react';

import Header from './Header';
import MoviesList from './MoviesList';

const { Content, Footer } = Layout;

export default () => (
  <Layout className="layout" style={{ height: '100vh' }}>
    <Header />
    <Content style={{ padding: '50px 50px 0' }}>
      <div className="site-layout-content">
        <MoviesList />
      </div>
    </Content>
    <Footer style={{ textAlign: 'center' }}>FunnyMovies ©2022.</Footer>
  </Layout>
);
