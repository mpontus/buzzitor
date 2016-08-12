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
  this.App || (this.App = {});
  this.App.Monitoring = {
    init: function (id) {
      this.obj = {};
      var url = Routes.monitoring_context_path(id, {format: 'json'});
      var poll = function () {
        setTimeout(function () {
          $.get(url).then( function (obj) {
            if (obj != this.obj) {
              this.obj = obj;
              iframe = $('iframe').attr(src, obj.content_url);
              $('#preview').children().remove();
              $('#preview').append(iframe);
            }
            poll();
          });
        }, 1000);
      }
      poll();
    }
  }
}).call(this);

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/serviceworker.js').then(initialiseState);
} else {
  console.warn("Service workers aren't supported in this browser");
}

// Once the service worker is registered set the initial state
function initialiseState() {
  // Are notifications supported in the service worker?
  if (!('showNotification' in ServiceWorkerRegistration.prototype)) {
    console.warn("Notifications aren't supported");
    return;
  }

  // Check the notification permission. If its denied, its a permanent block
  // until the user changes the permission
  if (Notification.permission === 'denied') {
    console.warn("The user has blocked notifications");
    return;
  }

  // Check if push messaging is supported
  if (!('PushManager' in window)) {
    console.warn("Push messaging isn't supported");
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
        console.warn("Error during getSubscription()", err);
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
          console.warn("Permission for Notifications was denied.");
        } else {
          // A problem occurred with the subscription; common reasons include
          // network errors, and lacking gcm_sender_id and/or
          // gcm_user_visible_only in the manifest
          console.error("Unable to subscribe to push", err);
        }
      });
  });
}

function sendSubscriptionToServer(subscription) {
  console.log("The user has successfully subscribed", subscription.endpoint);
}
