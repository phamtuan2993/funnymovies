import React from 'react';

const useResizeObserver = ({ resizeCallback, refElement }) => {
  React.useLayoutEffect(() => {
    if (refElement === null) return () => {};
    const resizeObserver = new ResizeObserver(entries => {
      if (entries.length > 0) {
        resizeCallback();
      }
    });

    resizeObserver.observe(refElement);

    return () => {
      resizeObserver.unobserve(refElement);
    };
  }, [resizeCallback, refElement]);
};

export default useResizeObserver;
