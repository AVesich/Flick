function setupButtonScrolling() {
    const featuresBtn = document.querySelector('#featuresBtn');
    const featuresSection = document.querySelector('#features');
    const comparisonBtn = document.querySelector('#comparisonBtn');
    const comparisonSection = document.querySelector('#comparison');
    const roadmapBtn = document.querySelector('#roadmapBtn');
    const roadmapSection = document.querySelector('#roadmap');
    const faqBtn = document.querySelector('#faqBtn');
    const faqSection = document.querySelector('#faq');

    featuresBtn.addEventListener("click", () => {
        featuresSection.scrollIntoView({behavior: "smooth", block: "center"});
    });
    comparisonBtn.addEventListener("click", () => {
        comparisonSection.scrollIntoView({behavior: "smooth", block: "center"});
    });
    roadmapBtn.addEventListener("click", () => {
        roadmapSection.scrollIntoView({behavior: "smooth", block: "center"});
    });
    faqBtn.addEventListener("click", () => {
        faqSection.scrollIntoView({behavior: "smooth", block: "center"});
    });
}

console.log("starting...");
setupButtonScrolling();