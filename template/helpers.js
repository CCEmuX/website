module.exports.register = handlebars => handlebars.registerHelper({
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
