import completion from './completion';
import actions from './actions';

export default {
  init(config) {
    this.config = config;
    completion.init(config);
  },
  execute() {
    const [node, file, command, ...args] = process.argv;
    if (!actions[command]) {
      console.error(`Unknown command: ${command}`);
      process.exit(-1);
    }
    actions[command](args, this.config);
  }
}
