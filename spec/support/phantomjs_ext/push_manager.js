(function (root) {
  var subscription = {
    'endpoint': "https://android.googleapis.com/gcm/send/ee5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU"
  };

  var PushManager = function () {};
  PushManager.prototype.getSubscription = function () {
    return new Promise(function (resolve, reject) {
      resolve(subscription);
    });
  };

  var ServiceWorkerRegistration = function () {
    this.pushManager = new PushManager();
  };
  ServiceWorkerRegistration.prototype.showNotification = function () {};

  root.PushManager = PushManager;
  root.ServiceWorkerRegistration = ServiceWorkerRegistration;
  root.navigator.serviceWorker = {
    register: function () {
      return new Promise(function (resolve, reject) {
        resolve(new ServiceWorkerRegistration());
      });
    },
    ready: new Promise(function (resolve, reject) {
      resolve(new ServiceWorkerRegistration());
    })
  };
})(this);
// window.PushManager = {};
// window.ServiceWorkerRegistration = function () {}
// window.ServiceWorkerRegistration.prototype.showNotification = function () {}

// var serviceWorkerRegistration = {
// }

// pushManager: {
//           getSubscription: function (callback) {
//             return {
//               endpoint: "https://android.googleapis.com/gcm/send/ee5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU"
//             }
//           }
//         }



