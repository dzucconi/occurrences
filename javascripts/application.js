(function($) {
  // Fisher-Yates shuffle
  $.shuffle = function(arr) {
    var length, j, t;

    length = arr.length;

    while (--length > 0) {
      j           = ~~(Math.random() * (length + 1));
      t           = arr[j];
      arr[j]      = arr[length];
      arr[length] = t;
    }

    return arr;
  };
}(jQuery));

;(function(exports) {
  var randomColor = function() {
    return "#" + (Math.random() * 0xFFFFFF << 0).toString(16);
  };

  var queryString = function(options) {
    return "http://xxith.com/?" + $.map(options, function(value, key) {
      return key + "=" + value;
    }).join("&");
  }

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
        var date, options, href;

        date = record.mid.split("-");

        options = {
          year:     date[0],
          month:    months[date[1] - 1],
          day:      date[2],
          color:    randomColor(),
          bgcolor:  randomColor()
        };

        href = queryString(options);

        return "<a href='" + href + "' target='_blank'>" + record.title + "</a>";
      });

      $("body").html(links.join(""));
    });
  }

  $(function() { initialize(); });
}(this));
