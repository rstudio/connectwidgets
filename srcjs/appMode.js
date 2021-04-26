const appsModeMap = {
  // internal types to type name
  'api': 'API',
  'shiny': 'Application',
  'rmd-shiny': 'Document',
  'rmd-static': 'Document',
  'jupyter-static': 'Document',
  'static': {
    'plot': 'Plot',
    'pin': 'Pin',
  },
  'tensorflow-saved-model': 'Model',
  'python-api': 'API',
  'python-dash': 'Application',
  'python-streamlit': 'Application',
  'python-bokeh': 'Application',

  // name to applicable internal types
  'API': ['api', 'python-api'],
  'Document': ['rmd-shiny', 'rmd-static', 'jupyter-static'],
  'Application': ['shiny', 'python-dash', 'python-streamlit', 'python-bokeh'],
  'Plot': [['static', 'plot']],
  'Pin': [['static', 'pin']],
  'Model': ['tensorflow-saved-model'],
};

/**
 * Get human friendly content type name from internal type id.
 * @param {string} id Connect's internal content type id. E.g "jupyter-static".
 * @param {string} category Connect's internal sub-type content type id. E.g "pin".
 * @returns {string} A human friendly content type.
 */
export const appTypeOf = (id, category) => {
  let type = appsModeMap[id];
  if (category) {
    type = type[category];
  }
  return type || 'Other';
};
