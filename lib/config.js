import Component from './component';
import { loadYAML } from './utils';
import findUp from 'find-up';

module.exports = class Config {
  constructor(config) {
    Object.assign(this, config, {
      components: Object.keys(config.components || {})
        .map((id) => {
          const def = config.components[id] || {};
          return new Component(id, def);
        })
    });
  }

  get containers() {
    return this.components.reduce((containers, comp) => {
      return containers.concat(comp.containers);
    }, []);
  }

  get dockerPrefix() {
    return this.project.name;
  }

  static load() {
    const path = findUp.sync('maak.yaml');
    if (!path) {
      console.error('Unable to find a maak.yaml');
      process.exit(-1);
    }
    const config = loadYAML(path);
    return new Config(config);
  }
}
