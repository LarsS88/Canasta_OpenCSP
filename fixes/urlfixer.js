(function () {
    function runFixLogic() {
        const runFix = function () {
            const scriptPath = mw.config.get('wgScriptPath') || '';
            if (!scriptPath || scriptPath === '/') {
                return;
            }

            const fixUrl = (url) => {
                if (
                    url.startsWith('/') &&
                    !url.startsWith(scriptPath) &&
                    !url.startsWith('//')
                ) {
                    return scriptPath + url;
                }
                return url;
            };

            const fixAttributes = (selector, attr) => {
                const elements = document.querySelectorAll(selector);
                elements.forEach(el => {
                    const val = el.getAttribute(attr);
                    if (val) {
                        const newVal = fixUrl(val);
                        if (newVal !== val) {
                            el.setAttribute(attr, newVal);
                        }
                    }
                });
            };

            fixAttributes('img', 'src');
            fixAttributes('script', 'src');
            fixAttributes('link[rel="stylesheet"]', 'href');
            fixAttributes('iframe', 'src');
            fixAttributes('source', 'src');
        };

        const debounce = (func, delay) => {
            let timerId;
            return function (...args) {
                clearTimeout(timerId);
                timerId = setTimeout(() => func.apply(this, args), delay);
            };
        };

        const debouncedFix = debounce(runFix, 200);
        runFix();

        const observer = new MutationObserver((mutationsList) => {
            for (const mutation of mutationsList) {
                if (mutation.addedNodes.length > 0) {
                    debouncedFix();
                    break;
                }
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }

    let retries = 0;
    const maxRetries = 20;
    const interval = 250;

    function waitForMwLoader() {
        try {
            if (window.mw && mw.loader && typeof $ !== 'undefined') {
                mw.loader.using(['mediawiki.util'], function () {
                    $(runFixLogic);
                });
            } else {
                throw new Error('mw or $ not ready');
            }
        } catch (e) {
            retries++;
            if (retries <= maxRetries) {
                setTimeout(waitForMwLoader, interval);
            }
        }
    }

    waitForMwLoader();
})();
