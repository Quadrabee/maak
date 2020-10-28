import readFile from './readFile';
import YAML from 'yaml';

const loadYAML = (path) => {
  try {
    return YAML.parse(readFile(path));
  } catch (err) {
    console.error(`YAML parse error: ${path}`);
    console.error(err);
    process.exit(-1);
  }
}

export default loadYAML;
