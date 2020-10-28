import fs from 'fs';

const readFile = (path) => {
  if (!fs.existsSync(path)) {
    console.error(`File not found: ${path}`);
    process.exit(-1);
  }
  return fs.readFileSync(path).toString();
};

export default readFile;
