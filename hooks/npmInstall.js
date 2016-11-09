module.exports = function (context) {
  var shell = context.requireCordovaModule('shelljs');
  shell.cd(context.opts.plugin.dir);
  shell.exec('npm install');
};
