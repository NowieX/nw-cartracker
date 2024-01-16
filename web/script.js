$(document).ready(function() {
    $(".container").hide();
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case "open":
                OpenShopCartracker();
                break;
            case "close":
                stopDisplayingContainer();
                break;
        }
    });

    $(document).keyup(function(e) {
        if (e.key === "Escape") { // escape key maps to keycode `27`
            stopDisplayingContainer()
            $.post('http://nw-cartracker/nw-cartracker:client:closeUI')
        }
    });
});

function OpenShopCartracker() {
    $(".container").slideDown(1000);
}

function giveCarTracker() {
    $(".container").slideUp(1000);
    $.post('http://nw-cartracker/nw-cartracker:client:giveCarTracker')
}

function stopDisplayingContainer() {
    $(".container").slideUp(1000);
    $.post('http://nw-cartracker/nw-cartracker:client:closeUI')
}