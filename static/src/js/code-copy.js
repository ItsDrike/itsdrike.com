(() => {
    "use strict";

    function flashCopyMessage(el, msg) {
        el.textContent = msg;
        setTimeout(() => { el.textContent = "Copy"; }, 1000);
    }

    function handleClick(containerEl, copyBtn) {
        // Find the pre element containing the source code.
        // If this is a regular codeblock, there should only be 1 pre element
        // If this is a hugo highlight block with linenumers, there will be 2 elements,
        // where, the first will contain line numbers, and second will contain the code
        let preElements = containerEl.getElementsByTagName("pre");
        let preEl = preElements[preElements.length - 1]

        let codeEl = preEl.firstElementChild;
        let text = codeEl.textContent;

        navigator.clipboard.writeText(text)
            .then(() => { flashCopyMessage(copyBtn, "Copied!"); })
            .catch((error) => { 
                    console && console.log(error);
                    flashCopyMessage(copyBtn, "Failed :'(");
                })
    }

    function addCopyButton(containerEl) {
        let copyBtn = document.createElement("button");
        copyBtn.className = "copy-button";
        copyBtn.textContent = "Copy";
        copyBtn.addEventListener("click", () => handleClick(containerEl, copyBtn));
        containerEl.appendChild(copyBtn);
    }

    // Add copy button to code blocks
    let highlightBlocks = document.getElementsByClassName("highlight");
    Array.prototype.forEach.call(highlightBlocks, addCopyButton);
})();
