function loadGists() {
    var els = $('code[gist]'), gists = {}, code = [], stylesheets = [];
    // Get elements referencing a gist and build a gists hash referencing the elements that use it
    els.each(function(idx, rawEl) {
        var el = $(rawEl), gist = el.attr('gist');
        rawEl.gist = gist;
        rawEl.file = el.attr('file');
        gists[gist] = gists[gist] || { targets: [] };
        gists[gist].targets.push(el);
    });
    // Load the gists
    $.each(gists, function(name, data) {
        $.getJSON(name + '?callback=?', function(data) {
            var gist = gists[name];
            gist.data = data;
            // Only insert the stylesheets once
            if(stylesheets.indexOf(gist.data.stylesheet) < 0) {
                stylesheets.push(gist.data.stylesheet);
                $('head').append('<link rel="stylesheet" href="https://gist.github.com' + gist.data.stylesheet + '" />');
            }
            gist.files = $(gist.data.div).find('.gist-file');
            gist.outer = $(gist.data.div).first().html('');
            // Iterate elements refering to this gist
            $(gist.targets).each(function(idx, target) {
                var file = target.get(0).file;
                if(file) {
                    var o = gist.outer.clone();
                    var c = '<div class="gist-file">' + $(gist.files.get(gist.data.files.indexOf(file))).html() + '</div>';
                    o.html(c);
                    target.replaceWith(o);
                }
                else {
                    target.replaceWith(gist.data.div);
                }
            });
        });
    });
}
// Load them on document ready
$(loadGists)
$(document).on('renderedGist', loadGists)
