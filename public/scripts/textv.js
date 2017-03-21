var text = function(evt) {
    var theEvent = evt || window.event;
    var key = theEvent.keyCode || theEvent.which;
    
    if (key == 9 || key == 8 || key == 46 ) { //TAB was pressed
        return;
    }
    
    key = String.fromCharCode( key );
    var regex = /[0-9]|\.\t/;
    
    if( !regex.test(key) ) {
        theEvent.returnValue = false;
        if(theEvent.preventDefault) { theEvent.preventDefault(); }
    }
};

var update = function(reply) {
    console.log(reply);
    if (reply == "BadgeNum") {
        $('#dropdownbox').hide();
        $('#inputbox').show();
    } else if (reply == 'Department') {
        $('#dropdownbox').show();
        $('#inputbox').hide();
    }
}