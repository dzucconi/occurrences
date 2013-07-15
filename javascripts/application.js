$.getJSON("/archiver/lib/data/data.json", function(data) {
  var html = $.map(data, function(record) {
    console.log(record);
    return record.title;
  });

  $("body").html(html.join("<br>"));
});
