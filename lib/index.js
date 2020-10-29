#!/usr/bin/env node
import Config from './config';
import Mustache from 'mustache';
import cmdline from './cmdline';
import { readFile } from './utils';
import path from 'path';
import fs from 'fs';

const config = Config.load();

cmdline.init(config);

const tpl = readFile(path.join(__dirname, '../tpls/Makefile.tpl'));
const output = Mustache.render(tpl, config);

fs.writeFileSync('maak.mk', output);

cmdline.execute();
