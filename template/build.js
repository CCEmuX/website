/**
 * Basic script to reads a handlebars template from stdin and renders it to
 * stdout.
 *
 * This registers several additional helpers, partials from template/*.handlebars,
 * and data from pages/data.json.
 */

const fs = require("fs");
const handlebars = require("handlebars");

handlebars.registerHelper({
  link: function (linkTo, context, options) {
    const extra = linkTo === context.url || linkTo === context.groupUrl ? ` class="active"` : '';
    return `<a href="${linkTo}" ${extra}>${options.fn(this)}</a>`;
  },

  secLink: function (linkTo, context, options) {
    const extra = linkTo === context.url ? ` class="active"` : '';
    return `<a href="${linkTo}" ${extra}>${options.fn(this)}</a>`;
  },

  header: function(name, context, options) {
    const body = options.fn(this);
    (context.headers || (context.headers = [])).push({ name, body });
    return `<a class="header-link" href="#${name}" name=${name}>#</a> <span>${body}</span>`;
  },

  headers: function(context) {
    const items = (context.headers || []).map(({ name, body }) => `<li><a href="#${name}">${body}</a>`).join("");
    return new handlebars.SafeString(items);
  }
});

fs
  .readdirSync("template")
  .filter(x => x.substr(-11) == ".handlebars")
  .map(x => x.substr(0, x.length-11))
  .forEach(file => {
    handlebars.registerPartial(file, fs.readFileSync(`template/${file}.handlebars`, { encoding: "utf8"}));
  });

const contents = fs.readFileSync(0, { encoding: "utf8"});
const data = JSON.parse(fs.readFileSync("pages/data.json", { encoding: "utf8" }));
const result = handlebars.compile(contents)(data);
fs.writeFileSync(1, result);
