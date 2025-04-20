(function () {
    function runFixLogic() {
        const runFix = function () {
            console.log('[PathFixer] Running fix...');
            const scriptPath = mw.config.get('wgScriptPath') || '';
            if (!scriptPath || scriptPath === '/') {
                console.log('[PathFixer] No meaningful wgScriptPath found. Skipping.');
                return;
            }

            const fixUrl = (url) => {
                if (
                    url.startsWith('/') &&
                    !url.startsWith(scriptPath) &&
                    !url.startsWith('//')
                ) {
                    console.log(`[PathFixer] Fixing URL: ${url} -> ${scriptPath + url}`);
                    return scriptPath + url;
                }
                return url;
            };

            const fixAttributes = (selector, attr) => {
                const elements = document.querySelectorAll(selector);
                console.log(`[PathFixer] Checking <${selector}> elements for "${attr}" attribute. Found: ${elements.length}`);
                let fixedCount = 0;
                elements.forEach(el => {
                    const val = el.getAttribute(attr);
                    if (val) {
                        const newVal = fixUrl(val);
                        if (newVal !== val) {
                            el.setAttribute(attr, newVal);
                            fixedCount++;
                        }
                    }
                });
                console.log(`[PathFixer] Updated ${fixedCount} out of ${elements.length} <${selector}> elements.`);
            };

            console.log('[PathFixer] Starting resource URL path fix...');
            fixAttributes('img', 'src');
            fixAttributes('script', 'src');
            fixAttributes('link[rel="stylesheet"]', 'href');
            fixAttributes('iframe', 'src');
            fixAttributes('source', 'src');
            console.log('[PathFixer] Resource URL path fix complete.');
        };

        const debounce = (func, delay) => {
            let timerId;
            return function (...args) {
                clearTimeout(timerId);
                timerId = setTimeout(() => func.apply(this, args), delay);
            };
        };

        const debouncedFix = debounce(runFix, 200);
        runFix(); // Initial run

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
        console.log('[PathFixer] MutationObserver set with debounce.');
    }

    // Retry setup logic with try/catch
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
                console.log(`[PathFixer] Retry ${retries}: ${e.message}`);
                setTimeout(waitForMwLoader, interval);
            } else {
                console.error('[PathFixer] Gave up waiting for mw loader.');
            }
        }
    }

    waitForMwLoader();
})();
