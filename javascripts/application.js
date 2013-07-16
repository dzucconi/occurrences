(function($) {
  // Fisher-Yates shuffle
  $.shuffle = function(arr) {
    var length, j, t;

    length = arr.length;

    while (--length > 0) {
      j           = ~~(Math.random() * (length + 1)); // double NOT bitwise operator as substitute for Math.floor
      t           = arr[j];
      arr[j]      = arr[length];
      arr[length] = t;
    };

    return arr;
  };

  $.toQueryString = function(options) {
    return $.map(options, function(value, key) {
      return key + "=" + value;
    }).join("&");
  };

  $.randomColor = function() {
    return "#" + ("000000" + (Math.random() * 0xFFFFFF << 0).toString(16)).slice(-6);
  };
}(jQuery));

(function(exports) {
  var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  var initialize = function() {
    $.getJSON("archiver/lib/data/data.json", function(data) {
      var links = $.map($.shuffle(data), function(record) {
        var date, options;

        date = record.mid.split("-");

        options = {
          year:     date[0],
          month:    months[date[1] - 1],
          day:      date[2],
          color:    $.randomColor(),
          bgcolor:  $.randomColor()
        };

        return "<a href='http://xxith.com/?" + $.toQueryString(options) + "' target='_blank'>" +
          record.title +
        "</a>";
      });

      $("body").html(links.join(""));
    });
  }

  $(function() { initialize(); });
}(this));
