$(function() {
    window.Session = Backbone.Model.extend({
        defaults: {
            logged: false
        },

        initialize: function(){
            _.bindAll(this, 'session_changed', 'first_time_session');

        },
        session_changed: function(session_data){
            alert("Session " + session_data.status);
            this.set({
                'logged': session_data.status == "connected"
                });
            $.ajax({
                url: "/user_sessions/",
                type: 'POST',
                data: session_data.session,
                success: function(){
                    alert("User session created OK");
                }
            })
        },
        first_time_session: function(session_data){
            //New user on site, notify it
            $.ajax({
                url: "/users/",
                type: 'POST',
                data: session_data.session,
                success: function(response){
                    alert("New User created OK");
                }
            })
        }
    });

    window.User = Backbone.Model.extend({

        });
    window.SessionView = Backbone.View.extend({
        id: "user_panel",
        initialize: function(){
            _.bindAll(this, 'render');
            this.model.bind('change', this.render);
        },
        render: function(){
            if (this.model.get('logged')) {
                $(this.el).hide();
            } else {
                $(this.el).show();
            }
        }
    });
    window.session = new Session();
    window.session_view = new SessionView({
        model: window.session
        });


    window.fbAsyncInit = function() {
        FB.init({
            appId: '123164501100199',
            status: true,
            cookie: true,
            xfbml: true
        });
        FB.Event.subscribe('auth.sessionChange', window.session.session_changed);
        FB.Event.subscribe('auth.login', window.session.first_time_session);
        FB.Event.subscribe('auth.statusChange', function(response) {
            //alert("Status: " + response.status);
            });
        FB.getLoginStatus(function(response) {
            if (response.session) {
                window.session.session_changed(response)
            } else {
        // no user session available, someone you dont know
        }
        });

    };

    $('body').append('<div id="fb-root"></div>');

    $.getScript(document.location.protocol + '//static.ak.fbcdn.net/connect/en_US/core.debug.js');
})