var SearchFormView = Backbone.View.extend({

  el: "body",

  initialize: function() {
    this.$form = this.$(".search-form");
  },

  toggleForm: function() {
    this.$form.fadeToggle(100);
    this.$("input:visible, select:visible, textarea:visible").first().focus();
  },

  events: {
    "click .search-form-toggle": "toggleForm"
  }

});

new SearchFormView;
