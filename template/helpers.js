module.exports.register = handlebars => handlebars.registerHelper({
  link: function (linkTo, context, options) {
    const extra = linkTo == context.url ? ` class="active"` : '';
    return `<a href="${linkTo}" ${extra}>${options.fn(this)}</a>`;
  },
});
