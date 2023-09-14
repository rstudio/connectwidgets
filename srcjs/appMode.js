import ApiImg from '@/images/api.svg';
import AppImg from '@/images/app.svg';
import DocImg from '@/images/doc.svg';
import ModelImg from '@/images/model.svg';
import PinImg from '@/images/pin.svg';
import PlotImg from '@/images/plot.svg';
import SiteImg from '@/images/site.svg';

const appsModeMap = {
  // internal types to type name
  'api': 'API',
  'shiny': 'Application',
  'rmd-shiny': 'Document',
  'rmd-static': {
    'site': 'Site',
    'default': 'Document',
  },
  'jupyter-static': 'Document',
  'static': {
    'plot': 'Plot',
    'pin': 'Pin',
    'site': 'Site',
    'default': 'Document',
  },
  'tensorflow-saved-model': 'Model',
  'python-api': 'API',
  'python-dash': 'Application',
  'python-streamlit': 'Application',
  'python-bokeh': 'Application',
  'python-fastapi': 'API',
  'quarto-shiny': 'Document',
  'quarto-static': {
    'site': 'Site',
    'default': 'Document',
  },
  'python-shiny': 'Application',
  'jupyter-voila': 'Document',
};

/**
 * Get human friendly content type name from internal type id.
 * @param {string} id Connect's internal content type id. E.g "jupyter-static".
 * @param {string} category Connect's internal sub-type content type id. E.g "pin".
 * @returns {string} A human friendly content type.
 */
export const appTypeOf = (id, category) => {
  let type = "Other";

  if (id in appsModeMap) {
    const appMode = appsModeMap[id];

    if (typeof appMode === 'string') {
      type = appMode;
    } else {
      if (category in appMode) {
        type = appMode[category];
      } else if (appMode.default) {
        type = appMode.default;
      }
    }
  }

  return type;
};

/**
 * Get the default image for a given content app mode.
 * @param {string} appMode The content app mode.
 * @param {string} contentCategory Connect's internal sub-type content type id. E.g "pin".
 * @returns The default image.
 */
export const appModeImg = (appMode, contentCategory) => {
  const type = appTypeOf(appMode, contentCategory);

  switch (type) {
    case 'API':
      return ApiImg;
    case 'Document':
      return DocImg;
    case 'Plot':
      return PlotImg;
    case 'Pin':
      return PinImg;
    case 'Model':
      return ModelImg;
    case 'Site':
      return SiteImg;
    default:
      return AppImg;
  }
};
