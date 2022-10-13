import Icon, {
  LikeOutlined,
  LikeFilled,
  DislikeOutlined,
  DislikeFilled,
  StarOutlined,
  StarFilled,
} from '@ant-design/icons';
import { List, Space, Typography } from 'antd';
import React from 'react';
import VirtualList from 'rc-virtual-list';

import { useMoviesContext } from '../contexts/MoviesContext';
import useResizeObserver from './hooks/useResizeObserver';

const IconText = ({ icon, text }) => (
  <Space>
    <Icon component={icon} />
    {text}
  </Space>
);

const MoviesList = () => {
  const { movies, fetchMovies, isFetchingMovies } = useMoviesContext();
  React.useEffect(fetchMovies, [fetchMovies]);

  const [containerHeight, setContainerHeight] = React.useState(0);

  const onScroll = React.useCallback(
    e => {
      if (!movies || isFetchingMovies || movies.isAtLastPage) return;

      if (
        e.currentTarget.scrollHeight - e.currentTarget.scrollTop ===
        containerHeight
      ) {
        fetchMovies({ pageIndex: movies.pageIndex + 1 });
      }
    },
    [movies, isFetchingMovies, containerHeight, fetchMovies]
  );

  const [listRef, setListRef] = React.useState(null);
  const resizeCallback = React.useCallback(() => {
    setContainerHeight(listRef.clientHeight);
  }, [listRef]);
  useResizeObserver({ refElement: listRef, resizeCallback });

  const virtualListRef = React.useRef();
  React.useLayoutEffect(() => {
    if (!movies) return;

    if (movies.pageIndex === 1) virtualListRef.current.scrollTo(0, 0);
  }, [movies]);

  return (
    <div style={{ height: '100%' }} ref={setListRef}>
      <List
        loading={isFetchingMovies}
        itemLayout="vertical"
        size="large"
        footer={null}
      >
        {containerHeight !== 0 && (
          <VirtualList
            ref={virtualListRef}
            data={movies?.items}
            height={containerHeight}
            itemHeight={500}
            itemKey="id"
            onScroll={onScroll}
          >
            {item => (
              <List.Item
                key={item.id}
                style={{
                  display: 'flex',
                  flexFlow: 'row wrap',
                  gap: 30,
                  maxHeight: containerHeight,
                }}
              >
                <iframe
                  style={{ aspectRatio: '16/9', height: 500 }} // 16:9
                  src={`https://www.youtube.com/embed/${item.embedded_id}`}
                  frameBorder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowFullScreen
                  title="Embedded youtube"
                />

                <List.Item.Meta
                  style={{
                    minWidth: 300,
                    maxHeight: 'fit-content',
                    minHeight: 200,
                  }}
                  title={
                    <div>
                      <Typography.Text strong style={{ color: 'red' }}>
                        {item.title}
                      </Typography.Text>
                      <br />
                      Shared by:{' '}
                      <Typography.Text strong>
                        {item.shared_by.email}
                      </Typography.Text>
                      <div style={{ display: 'flex', gap: 20 }}>
                        <IconText
                          icon={item.starred ? StarFilled : StarOutlined}
                          text="156"
                          key="start"
                        />
                        <IconText
                          icon={item.liked ? LikeFilled : LikeOutlined}
                          text="156"
                          key="like-count"
                        />
                        <IconText
                          icon={item.disliked ? DislikeFilled : DislikeOutlined}
                          text="156"
                          key="dislike-count"
                        />
                      </div>
                    </div>
                  }
                  description={
                    <p style={{ maxHeight: 250, overflow: 'auto' }}>
                      {item.description}
                    </p>
                  }
                />
              </List.Item>
            )}
          </VirtualList>
        )}
      </List>
    </div>
  );
};

export default MoviesList;
