const Benchmark = require('benchmark');

const leven = require('leven');
const elmApp = require('./elm-app.js').Elm.Main.init();

const log = (...args) => {
  console.log(...args);

  return args[0];
};

const chars = 'abcdefghijklmnopqrstuvwxyz';

const randStr = len => {
  let str;

  for (str = ''; len > 0; len--) {
    str += chars.charAt(Math.random() * chars.length | 0);
  }

  return str;
};

const text = randStr(10000);
const pattern = randStr(1000);

new Benchmark.Suite()
  .add('elm-app levenshtein', {
    defer: true,
    fn: deferred => {
      elmApp.ports.sendDistance.subscribe(_dist => deferred.resolve());
      elmApp.ports.calcDistance.send({ text, pattern });
    }
  })
  .add('leven', () => {
    leven(text, pattern);
  })
  .on('cycle', event => {
    const { name, stats, times } = event.target;

    log(' === ', name, ' === ');
    log(stats);
    log(times);
  })
  .run();
