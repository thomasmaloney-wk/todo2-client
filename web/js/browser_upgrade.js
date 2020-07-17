// This file is generated by the Wdesk SDK. Please see the README for more information.
/*
    Script to determine whether the browser meets the minimum version
    requirements and redirect to the browser upgrade page if it does
    not meet those requirements. The comparison algorithm here roughly
    matches the algorithm found in the H5 viewer.
 */

(function() {
    'use strict';
    
    var userAgent = window.navigator.userAgent.toLowerCase();
    var index = userAgent.indexOf('msie');

    if (index === -1) {
        return;
    }

    var version = parseFloat(userAgent.substring(index + 5));
    
    if (version >= 11.0) {
        return;
    }
    
    window.location = '/browser-upgrade.html';
})();
