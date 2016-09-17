// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require js-routes
//= require_tree .

(function() {
  var self = this;
  this.App || (this.App = {});
  this.App.Monitoring = {
    init: function (id) {
      self.App.MonitoringPreview.init(id);
      self.App.MonitoringSubscription.init(id);
    }
  }
}).call(this);

(function() {
  this.App || (this.App = {});
  this.App.MonitoringPreview = {
    updateResultHeight: function () {
        var toolbarHeight = $('.monitoring .toolbar').outerHeight();
        var windowHeight = $(window).outerHeight();
        $('.monitoring .result').css('height', windowHeight - toolbarHeight);
    },
    init: function (id) {
      $(window).resize(this.updateResultHeight);
      $(document).ready(this.updateResultHeight);
      $('#delete_form').on('ajax:complete', function () {
        window.location = Routes.root_path();
      });
      var sub = App.cable.subscriptions.create(
        { channel: 'MonitoringChannel', id: id }
      );
      sub.received = function(data) {
        $('#pause, #resume').attr('disabled', null);
        $('#pause').toggle(data.active);
        $('#resume').toggle(!data.active);
        var result;
        if (data.latest_result !== null) {
          $('.result .loading').hide();
          var result = data.latest_result;
          switch (result.status) {
            case 'content':
              if ($('iframe.content').attr('src') != result.content_url) {
                $('iframe.content').attr('src', result.content_url);
              }
              $('iframe.content').show();
              $('.result .error').remove();
              break;
            case 'error':
              $('iframe.content').hide();
              var msg_and_desc =
                error_message_and_description(result.error_code);
              $('<div class="error">')
                .html("<h1>"+msg_and_desc[0]+"</h1><p>"+msg_and_desc[1]+"</p>")
                .appendTo('.result');
              break;
          }
        }
      }
    },
    
  }

  function error_message_and_description(error_code) {
    switch (error_code) {
      case 101:
        return [
          "Server is inaccessible",
          "We were unable to connect to the host. "
          + " Our attempts will continue and you will be notified "
          + " when situation changes."
        ];
      case 102:
        return [
          "Timeout error",
          "Server was unable to respond to our request in reasonable time."
          + " Our attempts will continue and you will be notified "
          + " when situation changes."
        ];
      default:
        return [
          "Unknown error",
          " An error occured while trying to retrieve the page."
          + " Our attempts will continue and you will be notified "
          + " when situation changes."
        ];
    }
  }

}).call(this);

(function() {
  this.App || (this.App = {});
  this.App.MonitoringSubscription = {
    init: function (id) {
      obtainSubscription()
        .then(function (subscription) {
          var url = Routes.monitoring_context_subscribers_path(id, {format: 'json'});
          $.post(url, {subscription: subscription.toJSON()});
        })
        .catch(function (error) {
          console.warn(error);
        });
    }
  }

  function obtainSubscription() {
    return new Promise(function (resolve, reject) {
      if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/serviceworker.js').then(initialiseState);
      } else {
        reject("Service workers aren't supported in this browser");
      }

      // Once the service worker is registered set the initial state
      function initialiseState() {
        // Are notifications supported in the service worker?
        if (!('showNotification' in ServiceWorkerRegistration.prototype)) {
          reject("Notifications aren't supported");
          return;
        }

        // Check the notification permission. If its denied, its a permanent block
        // until the user changes the permission
        if (Notification.permission === 'denied') {
          reject("The user has blocked notifications");
          return;
        }

        // Check if push messaging is supported
        if (!('PushManager' in window)) {
          reject("Push messaging isn't supported");
          return;
        }

        // We need the service worker registration to check for a subscription
        navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
          // Do we already have a push message subscription?
          serviceWorkerRegistration.pushManager.getSubscription()
            .then(function(subscription) {
              if (subscription) {
                sendSubscriptionToServer(subscription);
              } else {
                subscribe();
              }
            })
            .catch(function(err) {
              reject("Error during getSubscription()", err);
            });
        });
      }

      function subscribe() {
        navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
          serviceWorkerRegistration.pushManager.subscribe({userVisibleOnly: true})
            .then(function(subscription) {
              sendSubscriptionToServer(subscription);
            })
            .catch(function (err) {
              if (Notification.permission === 'denied') {
                // The user denied the notification permission which means we failed
                // to subscribe and the user will need to manually change the
                // notification permission to subscribe to push messages
                reject("Permission for Notifications was denied.");
              } else {
                // A problem occurred with the subscription; common reasons include
                // network errors, and lacking gcm_sender_id and/or
                // gcm_user_visible_only in the manifest
                reject("Unable to subscribe to push", err);
              }
            });
        });
      }

      function sendSubscriptionToServer(subscription) {
        resolve(subscription);
      }
    });
  };
}).call(this);
