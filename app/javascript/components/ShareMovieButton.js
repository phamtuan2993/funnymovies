import React from 'react';
import { Button, Form, Input, Modal } from 'antd';

import extractResponse from '../utils/extractResponse';
import { useMoviesContext } from '../contexts/MoviesContext';

const ShareMovieForm = ({ onSubmitDone }) => {
  const formRef = React.useRef();
  const [error, setError] = React.useState(null);

  const { fetchMovies } = useMoviesContext();

  React.useEffect(() => {
    if (!error || !formRef.current) return;

    formRef.current.setFields([
      {
        name: 'url',
        errors: [error],
      },
    ]);
  }, [error, formRef]);

  React.useEffect(() => {
    formRef.current.resetFields();
  }, []);

  const onFinish = React.useCallback(
    values => {
      const url = 'api/v1/movies';
      fetch(url, {
        method: 'post',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(values),
      })
        .then(extractResponse)
        .then(() => {
          fetchMovies();
          onSubmitDone();
        })
        .catch(err => {
          setError(err.message);
          console.error(`Error: ${err}`); // eslint-disable-line no-console
        });
    },
    [onSubmitDone, fetchMovies]
  );

  return (
    <Form ref={formRef} layout="horizontal" onFinish={onFinish}>
      <Form.Item
        name="url"
        label="Youtube URL:"
        rules={[{ required: true, message: 'Required' }]}
      >
        <Input />
      </Form.Item>

      <Form.Item>
        <Button type="primary" htmlType="submit">
          Share
        </Button>
      </Form.Item>
    </Form>
  );
};

const ShareMovieButton = () => {
  const [visible, setVisible] = React.useState(false);

  const showModal = React.useCallback(() => setVisible(true), []);
  const closeModal = React.useCallback(() => setVisible(false), []);

  return (
    <>
      <Button type="primary" onClick={showModal}>
        Share a movie
      </Button>

      {visible && (
        <Modal
          title="Share a Youtube movie"
          open
          onCancel={closeModal}
          footer={null}
        >
          <ShareMovieForm onSubmitDone={closeModal} />
        </Modal>
      )}
    </>
  );
};

export default ShareMovieButton;
