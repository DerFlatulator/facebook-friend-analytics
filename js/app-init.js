App = {};

App.user = {};
App.fbLoaded = function (response) {
 	if (response.status !== 'connected') {
	    $('#login').show();
 	} else {
 		App.loginSuccess();
 	}
};

App.assertFBLogin = function () {
	FB.login(function(response) {
        if (response.authResponse) {
        	App.loginSuccess();
        } else {
        	assertFBLogin();
        }
    },
    {
    	scope: 'read_friendlists,user_relationships,friends_relationships'
    });
};

function testAPI() {
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {
        console.log('Good to see you, ' + response.name + '.');
    });
}
jQuery(document).ready(function($) {
	$('#login').click(function(e) {
		e.preventDefault();
		console.log("Attempting to log into Facebook.");
		App.assertFBLogin();
	});
});


App.loginSuccess = function() {
	// Definately logged in and authenticated by now.
 	// testAPI();
 	$('#login').hide();

 	// wait... 
 	console.log("Getting basic info.");
 	FB.api('/me', function(response) {
 		App.me = response;
        $('#info-pane').append($('<h1/>').text(response.name));
    });
    console.log("Getting friends list");
    FB.api('/me/friends?fields=name,id,relationship_status,significant_other,picture', function(response) {
    	App.friends = response.data; // TODO error checking here
    	$('#info-pane').append('<h2>Friends</h2>');
    	console.log(App.friends);
    	for (i in App.friends) {
    		var friend = App.friends[i];
    		console.log(friend.name);
    		var $person = $('<div>').addClass('person');
    		$person.append($('<img>').attr('src', friend.picture.data.url));
    		$person.append($('<div>').append(
    			$('<a>').attr('href', 'https://facebook.com/' + friend.id).text(friend.name)
    		));
    		$person.appendTo('#info-pane');
    	}

    	App.computeMutualInfo();
    });

};

App.computeMutualInfo = function () {
	for (i in App.friends) {
		var friend = App.friends[i];
		// TODO use BATCH request (remember max: 50 requests.)
		FB.api('/me/mutualfriends/' + friend.id + '?fields=id,name', function(response) {
			App.friends[i].mutualFriends = response.data; // TODO check error here
		});
	}
};