const Container = require('./container');

module.exports = class Component {
  constructor(id, config) {
    Object.defineProperty(this, "config", {
      enumerable: false,
      value: config
    })
    this.id = id;
  }

  get containers() {
    const containers = this.config.containers || {
      [this.id]: {
        single: true
      }
    };
    return Object.keys(containers)
      .map((id) => {
        const def = containers[id] || {};
        return new Container(id, def, this);
      });
  }

  get name() {
    return this.id;
  }

  get context() {
    return this.id;
  }
}
