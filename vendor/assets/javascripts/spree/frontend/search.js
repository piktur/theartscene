var ready;
ready = function () {
  // var autocomplete = $.getJSON('/assets/spree/frontend/autocomplete.json');

  var search = $('.typeahead'),
      engine = new Bloodhound({
        remote: {
          // url: api/products/autocomplete?query=canson&token=
          // url: '/api/products/autocomplete/?query=%QUERY',
          url: '/products/autocomplete?query=%QUERY',
          wildcard: '%QUERY'
        },
        // local: autocomplete.responseJSON,
        datumTokenizer: function (d) {
          return Bloodhound.tokenizers.whitespace(d.name);
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace
      });

  var promise = engine.initialize();

  promise
      .done(function () {console.log('success')})
      .fail(function () {console.log('err')});

  search.typeahead(
      {
        hint: true,
        highlight: true,
        minLength: 2
      },
      {
        displayKey: 't',
        source: engine.ttAdapter()
      }
  );
};

$(document).ready(ready);
$(document).on('page:load', ready);

