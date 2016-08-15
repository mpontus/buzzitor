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
//= require turbolinks
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
    init: function (id) {
      var sub = App.cable.subscriptions.create(
        { channel: 'MonitoringChannel', id: id }
      );
      sub.received = function(data) {
        if (data.latest_content !== null) {
          $('#preview').children().remove();
          $('<iframe/>').appendTo('#preview');
          $('iframe').attr('src', data.latest_content.url)
        }
      }
    }
  }
}).call(this);

(function() {
  this.App || (this.App = {});
  this.App.MonitoringSubscription = {
    init: function (id) {
      obtainSubscription()
        .then(function (subscription) {
          var url = Routes.monitoring_subscribers_path(id, {format: 'json'});
          $.post(url, {endpoint: subscription.endpoint});
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
