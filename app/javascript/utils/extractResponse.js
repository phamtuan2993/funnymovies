const extractErrorCodeAndMessage = error => {
  if (error.code > 499)
    return `Server error(${error.code}): Please contact our developer for help`;

  if (error.code > 399)
    return `Request error(${error.code}): ${error.errors[0].message}`;

  console.log({ error }); // eslint-disable-line no-console
  return `Network error(${error.code}): Please check your internet connection`;
};

const extractResponse = response => {
  if (response.ok == null) {
    console.log({ response }); // eslint-disable-line no-console
    return Promise.reject(new Error('Network error!'));
  }

  return response.json().then(({ data, error }) => {
    if (data) return Promise.resolve(data);
    if (error)
      return Promise.reject(new Error(extractErrorCodeAndMessage(error)));
  });
};

export default extractResponse;
