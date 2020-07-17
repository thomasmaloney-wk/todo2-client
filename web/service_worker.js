// This file is generated by the Wdesk SDK. Please see the README for more information.
var CACHE_PREFIX = '{codegen:appname}-sw-cache-';
var APP_VERSION = '{codegen:version}';
var ASSET_WORKER_PATH = '{codegen:asset_worker_path}';
var SESSION_WORKER_PATH = '{codegen:session_worker_path}';

// Set the `wdesk` flag to make imported scripts aware that they are being
// imported within the wdesk application.
self.wdesk = true;

// Attach the cache key to the SW scope so that scripts imported via
// importScripts() can use it. Imported scripts need not worry about clearing
// the cache during the SW upgrade process - simply use this cache key.
self.cacheKey = CACHE_PREFIX + APP_VERSION;

// FUTURE: These are available for custom scripts, but need to be incorporated into the
// asset and session worker.
let debugServiceWorker = {codegen:debug_service_worker};
let enableLocalhostCache = {codegen:enable_localhost_service_worker_cache};

self.addEventListener('install', function(event) {
  // Don't wait for clients to stop using the previous SW.
  self.skipWaiting();
});

self.addEventListener('activate', function(event) {
  // Clear all previous caches.
  event.waitUntil(
    caches.keys().then(function(cacheKeys) {
      return Promise.all(
        cacheKeys.filter(function(key) {
          if (key !== self.cacheKey) {
            return caches.delete(key);
          }
        })
      );
    })
  );
});

var ASSET_WORKER_ENABLED = {codegen:asset_worker_enabled};
var SESSION_WORKER_ENABLED = {codegen:session_worker_enabled};

if (ASSET_WORKER_ENABLED) {
  self.importScripts(ASSET_WORKER_PATH);
}
if (SESSION_WORKER_ENABLED) {
  self.importScripts(SESSION_WORKER_PATH);
}

// If the import scripts change, the service worker does not reinstall.
// This is not a problem for prod because of APP_VERSION, but for local dev it is.
// Devs will need to have their devtools update on reload if they are changing imported scripts.
// https://github.com/w3c/ServiceWorker/issues/839
self.importScripts({codegen:custom_service_worker_scripts});