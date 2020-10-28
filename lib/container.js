module.exports = class Container {
  constructor(id, config, component) {
    Object.defineProperty(this, 'config', {
      enumerable: false,
      value: Object.assign({}, {
        deps: {
        }
      }, config)
    });
    this.id = id;
    this.component = component;
  }

  get dependencies() {
    return this.dependencies || this.context;
  }

  get context() {
    return this.component.name;
  }

  get name() {
    return this.config.single
      ? this.component.name
      : `${this.component.name}.${this.id}`;
  }

  get dockerfile() {
    return this.config.single
      ? `${this.component.name}/Dockerfile`
      : `${this.component.name}/Dockerfile.${this.id}`;
  }

  get dockerbuilt() {
    return this.config.single
      ? `${this.component.name}/Dockerfile.built`
      : `${this.component.name}/Dockerfile.${this.id}.built`;
  }

  get dockerpushed() {
    return this.config.single
      ? `${this.component.name}/Dockerfile.pushed`
      : `${this.component.name}/Dockerfile.${this.id}.pushed`;
  }

  get dockerlog() {
    return this.config.single
      ? `${this.component.name}/Dockerfile.log`
      : `${this.component.name}/Dockerfile.${this.id}.log`;
  }

  get depsignore() {
    const exclude = this.config.deps.exclude;
    const list = [
      'Dockerfile.*.built',
      'Dockerfile.*.pushed',
      'Dockerfile.*.log'
    ];
    if (exclude) {
      list.push(exclude);
    }
    return list.join('\\|')
  }

  get depsinclude() {
    const include = this.config.deps.include || '.*';
    return [this.dockerfile, include].join('\\|');
  }

}
