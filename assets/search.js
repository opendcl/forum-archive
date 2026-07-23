
(function () {
  const input = document.getElementById('q');
  const out = document.getElementById('search-results');
  const meta = document.getElementById('search-meta');
  let index = null;

  async function loadIndex() {
    if (index) return index;
    const res = await fetch('search-index.json');
    index = await res.json();
    return index;
  }

  function tokenize(s) {
    return (s || '').toLowerCase().split(/[^a-z0-9_]+/).filter(t => t.length > 1);
  }

  function search(q) {
    const terms = tokenize(q);
    if (!terms.length) return [];
    const scored = [];
    for (const doc of index.docs) {
      let score = 0;
      const hay = doc.text;
      for (const t of terms) {
        if (doc.title.toLowerCase().includes(t)) score += 8;
        if (doc.author.toLowerCase().includes(t)) score += 3;
        const c = hay.split(t).length - 1;
        score += c;
      }
      if (score > 0) scored.push({ score, doc });
    }
    scored.sort((a, b) => b.score - a.score);
    return scored.slice(0, 50);
  }

  function render(results, q) {
    if (!q.trim()) {
      meta.textContent = 'Enter a search term.';
      out.innerHTML = '';
      return;
    }
    meta.textContent = results.length + ' result(s) for “' + q + '”';
    out.innerHTML = results.map(({ doc }) => {
      const snip = doc.snippet || '';
      return '<div class="hit"><a href="' + doc.url + '">' + escapeHtml(doc.title) +
        '</a><div class="meta">' + escapeHtml(doc.board) + ' · ' + escapeHtml(doc.author) +
        ' · ' + escapeHtml(doc.date) + '</div><div class="muted">' + escapeHtml(snip) +
        '</div></div>';
    }).join('');
  }

  function escapeHtml(s) {
    return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
  }

  async function run() {
    await loadIndex();
    const q = input.value || '';
    render(search(q), q);
  }

  document.getElementById('search-form').addEventListener('submit', function (e) {
    e.preventDefault();
    run();
  });

  const params = new URLSearchParams(location.search);
  if (params.get('q')) {
    input.value = params.get('q');
    run();
  } else {
    meta.textContent = 'Index: topic titles, post bodies, and authors (this prototype board).';
  }
})();
