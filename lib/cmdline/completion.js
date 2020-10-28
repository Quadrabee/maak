import omelette from 'omelette';
import actions from './actions';

export default {
  init(config) {
    const completion = omelette('maak <action> <component>');

    completion.on('action', ({reply}) => {
      reply(Object.keys(actions));
    });

    completion.on('component', ({reply}) => {
      const comp = config.components.map((c) => c.id);
      reply(comp);
    });

    completion.init();
  }
};
