/* eslint-disable no-console */
let jQuery = require('jquery');

let WebAPIUtils = {

  get: function(url, options = {}) {
    let ajaxOptions = {
      type: 'GET',
      url: url,
      dataType: options.dataType || 'json' // set options.dataType to "html" to receive server generated content
    };

    return jQuery.ajax(ajaxOptions)
      .fail((msg) => { console.error('Error: ', msg); });
  },

  post: function(url, data, options = {}) {
    let ajaxOptions = {
      type: 'POST',
      url: url,
      data: data,
      dataType: options.dataType || 'json'
    };

    // If uploading files as part of the request, disable jQuery from transforming the
    // data into a query string.  Refer to: http://api.jquery.com/jquery.ajax/
    if (options.isMultiPart) {
      ajaxOptions.contentType = false;
      ajaxOptions.processData = false;
      ajaxOptions.cache = false;
    }

    return jQuery.ajax(ajaxOptions)
      .fail((msg) => { console.error('Error: ', msg); });
  },

  patch: function(url, data, options = {}) {
    let ajaxOptions = {
      type: 'PATCH',
      url: url,
      data: data,
      dataType: options.dataType || 'json'
    };

    return jQuery.ajax(ajaxOptions)
      .fail((msg) => { console.error('Error: ', msg); });
  },

  put: function(url, data, options = {}) {
    let ajaxOptions = {
      type: 'PUT',
      url: url,
      data: data,
      dataType: options.dataType || 'json'
    };

    return jQuery.ajax(ajaxOptions)
      .fail((msg) => { console.error('Error: ', msg); });
  },

  delete: function(url, options = {}) {
    let ajaxOptions = {
      type: 'DELETE',
      url: url,
      dataType: options.dataType || 'json'
    };

    return jQuery.ajax(ajaxOptions)
      .fail((msg) => { console.error('Error: ', msg); });
  }
};

module.exports = WebAPIUtils;
/* eslint-enable no-console */
