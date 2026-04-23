// MenuAssistant Admin — all screens in one file (split into sections by comment banners)
const { useState, useEffect, useMemo, Fragment } = React;

// ─── placeholder ─────────────────────────────────────
function PhotoSlot({ h = 120, label = 'photo', radius = 8, aspect }) {
  const style = {
    borderRadius: radius, width: '100%',
    background: 'repeating-linear-gradient(135deg, var(--ph-a) 0 10px, var(--ph-b) 10px 20px)',
    display: 'flex', alignItems: 'end', padding: 6,
    color: 'var(--muted)', fontFamily: 'var(--mono)', fontSize: 9, textTransform: 'uppercase', letterSpacing: '0.08em',
  };
  if (aspect) style.aspectRatio = aspect; else style.height = h;
  return <div style={style}>{label}</div>;
}

// ─── side nav ────────────────────────────────────────
const NAV = [
  { id: 'dashboard', icon: '◆', label: 'Dashboard' },
  { id: 'queue', icon: '▤', label: 'Queue', count: 47, section: 'Moderation' },
  { id: 'validate', icon: '▦', label: 'Menu validator' },
  { id: 'dishreview', icon: '✦', label: 'Dish review', count: 63 },
  { id: 'photos', icon: '▢', label: 'Photo review', count: 246 },
  { id: 'translations', icon: 'A⇄', label: 'Translations', count: 34 },
  { id: 'library', icon: '⌘', label: 'Dish library', section: 'Catalog' },
  { id: 'restaurants', icon: '◧', label: 'Restaurants' },
  { id: 'users', icon: '○', label: 'Users', section: 'Access' },
  { id: 'logs', icon: '⋯', label: 'Audit log' },
];

function SideNav({ active, onPick }) {
  const grouped = [];
  NAV.forEach(n => {
    if (n.section) grouped.push({ header: n.section });
    grouped.push(n);
  });
  return (
    <aside style={{
      width: 240, flexShrink: 0, borderRight: '1px solid var(--line)',
      display: 'flex', flexDirection: 'column', height: '100vh', position: 'sticky', top: 0,
      background: 'var(--bg)',
    }}>
      <div style={{ padding: '16px 18px', borderBottom: '1px solid var(--line)', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{ width: 26, height: 26, borderRadius: 7, background: 'var(--accent)', color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--serif)', fontStyle: 'italic', fontWeight: 700, fontSize: 16 }}>M</div>
        <div style={{ display: 'flex', flexDirection: 'column', lineHeight: 1.1 }}>
          <span style={{ fontFamily: 'var(--serif)', fontWeight: 600, fontSize: 15, letterSpacing: '-0.01em' }}>MenuAssistant</span>
          <span style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.1em' }}>admin · v0.4</span>
        </div>
      </div>

      <nav style={{ flex: 1, padding: '10px 8px', overflow: 'auto' }}>
        {grouped.map((n, i) => n.header ? (
          <div key={i} style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.1em', padding: '14px 10px 6px' }}>{n.header}</div>
        ) : (
          <div key={i} onClick={() => onPick(n.id)} style={{
            display: 'flex', alignItems: 'center', gap: 10, padding: '7px 10px', borderRadius: 7,
            background: active === n.id ? 'var(--ink)' : 'transparent',
            color: active === n.id ? 'var(--bg)' : 'var(--ink-2)',
            fontSize: 13, cursor: 'pointer', marginBottom: 1,
          }}>
            <span style={{ width: 16, textAlign: 'center', fontFamily: 'var(--mono)', fontSize: 12, opacity: 0.8 }}>{n.icon}</span>
            <span style={{ flex: 1 }}>{n.label}</span>
            {n.count !== undefined && (
              <span style={{ fontFamily: 'var(--mono)', fontSize: 10, padding: '2px 6px', borderRadius: 999,
                background: active === n.id ? 'rgba(255,255,255,0.15)' : 'var(--surface-2)',
                color: active === n.id ? 'var(--bg)' : 'var(--muted)' }}>{n.count}</span>
            )}
          </div>
        ))}
      </nav>

      <div style={{ padding: 12, borderTop: '1px solid var(--line)', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{ width: 30, height: 30, borderRadius: 8, background: 'var(--accent-soft)', color: 'var(--accent-ink)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--serif)', fontWeight: 600, fontStyle: 'italic' }}>E</div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 13, fontWeight: 500 }}>Elena K.</div>
          <div style={{ fontSize: 10, fontFamily: 'var(--mono)', color: 'var(--muted)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>lead moderator · ru</div>
        </div>
        <ThemeToggle />
      </div>
    </aside>
  );
}

function ThemeToggle() {
  const [theme, setTheme] = useState(() => document.documentElement.getAttribute('data-theme') || 'warm');
  const toggle = () => {
    const next = theme === 'warm' ? 'midnight' : 'warm';
    setTheme(next);
    window.__setAdminTheme(next);
  };
  const isDark = theme === 'midnight';
  return (
    <button
      onClick={toggle}
      title={isDark ? 'Switch to light' : 'Switch to midnight'}
      style={{
        width: 44, height: 22, borderRadius: 999, border: '1px solid var(--line)',
        background: 'var(--surface-2)', position: 'relative', cursor: 'pointer', padding: 0, flexShrink: 0,
      }}
    >
      <span style={{
        position: 'absolute', top: 1, left: isDark ? 22 : 1, width: 18, height: 18, borderRadius: '50%',
        background: 'var(--ink)', color: 'var(--bg)', transition: 'left 0.18s ease',
        display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 10, lineHeight: 1,
      }}>{isDark ? '☾' : '☀'}</span>
    </button>
  );
}

// ─── top bar + page header ───────────────────────────
function PageHeader({ eyebrow, title, sub, actions, kpis }) {
  return (
    <div style={{ padding: '28px 32px 20px', borderBottom: '1px solid var(--line)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 24 }}>
        <div>
          {eyebrow && <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.1em' }}>{eyebrow}</div>}
          <h1 style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 32, letterSpacing: '-0.02em', margin: '2px 0 0', lineHeight: 1.1 }}>{title}</h1>
          {sub && <p style={{ color: 'var(--ink-2)', fontSize: 13, margin: '8px 0 0', maxWidth: 600, lineHeight: 1.5 }}>{sub}</p>}
        </div>
        {actions && <div style={{ display: 'flex', gap: 8, flexShrink: 0 }}>{actions}</div>}
      </div>
      {kpis && (
        <div style={{ display: 'grid', gridTemplateColumns: `repeat(${kpis.length}, 1fr)`, gap: 1, marginTop: 24, border: '1px solid var(--line)', borderRadius: 10, overflow: 'hidden', background: 'var(--line)' }}>
          {kpis.map((k, i) => (
            <div key={i} style={{ padding: '14px 16px', background: 'var(--bg)' }}>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{k.l}</div>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginTop: 4 }}>
                <span style={{ fontFamily: 'var(--serif)', fontSize: 24, fontWeight: 500 }}>{k.v}</span>
                {k.d && <span style={{ fontSize: 11, color: k.d.startsWith('+') ? 'var(--ok)' : k.d.startsWith('-') ? 'var(--bad)' : 'var(--muted)', fontFamily: 'var(--mono)' }}>{k.d}</span>}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function Btn({ kind = 'ghost', icon, children, onClick }) {
  const styles = {
    ghost: { background: 'transparent', color: 'var(--ink)', border: '1px solid var(--line)' },
    primary: { background: 'var(--ink)', color: 'var(--bg)', border: '1px solid var(--ink)' },
    accent: { background: 'var(--accent)', color: '#fff', border: '1px solid var(--accent)' },
    ok: { background: 'var(--ok)', color: '#fff', border: '1px solid var(--ok)' },
    danger: { background: 'var(--bad)', color: '#fff', border: '1px solid var(--bad)' },
  };
  return (
    <button onClick={onClick} style={{
      ...styles[kind], padding: '7px 12px', borderRadius: 8, fontSize: 13, fontWeight: 500,
      fontFamily: 'var(--sans)', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 8,
    }}>
      {icon && <span style={{ fontFamily: 'var(--mono)', opacity: 0.8 }}>{icon}</span>}
      {children}
    </button>
  );
}

function Pill({ tone = 'neutral', children }) {
  const tones = {
    neutral: { bg: 'var(--surface-2)', fg: 'var(--ink-2)' },
    warn: { bg: 'var(--pill-warn-bg)', fg: 'var(--pill-warn-fg)' },
    ok: { bg: 'var(--pill-ok-bg)', fg: 'var(--pill-ok-fg)' },
    bad: { bg: 'var(--pill-bad-bg)', fg: 'var(--pill-bad-fg)' },
    accent: { bg: 'var(--accent-soft)', fg: 'var(--accent-ink)' },
    info: { bg: 'var(--pill-info-bg)', fg: 'var(--pill-info-fg)' },
  };
  const t = tones[tone] || tones.neutral;
  return <span style={{ padding: '2px 8px', borderRadius: 999, background: t.bg, color: t.fg, fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', letterSpacing: '0.06em' }}>{children}</span>;
}

// ═══ 01 · DASHBOARD ════════════════════════════════════
function DashboardScreen() {
  return (
    <>
      <PageHeader
        eyebrow="Overview"
        title="Dashboard"
        sub="Операционные метрики платформы за последние 7 дней."
        actions={<>
          <Btn icon="↻">Reload</Btn>
          <Btn kind="primary" icon="↗">Export</Btn>
        </>}
        kpis={[
          { l: 'Menus parsed', v: '312', d: '+18%' },
          { l: 'Avg accuracy', v: '94.2%', d: '+1.4pp' },
          { l: 'In queue', v: '47', d: '-3' },
          { l: 'Active users', v: '4 812', d: '+412' },
          { l: 'Avg parse time', v: '19.4s', d: '-0.8s' },
        ]}
      />

      <div style={{ padding: 32, display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 24 }}>
        {/* volume chart */}
        <div style={{ border: '1px solid var(--line)', borderRadius: 12, padding: 20, background: 'var(--bg)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'end' }}>
            <div>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Parsing volume</div>
              <div style={{ fontFamily: 'var(--serif)', fontSize: 22, fontWeight: 500, marginTop: 4 }}>312 menus · last 7 days</div>
            </div>
            <div style={{ display: 'flex', gap: 4 }}>
              {['7d','30d','90d'].map((p,i) => (
                <span key={i} style={{ padding: '4px 10px', fontSize: 11, borderRadius: 6, background: i===0 ? 'var(--ink)' : 'transparent', color: i===0 ? 'var(--bg)' : 'var(--muted)', fontFamily: 'var(--mono)', cursor: 'pointer' }}>{p}</span>
              ))}
            </div>
          </div>
          {/* bar chart */}
          <div style={{ display: 'flex', alignItems: 'end', gap: 8, height: 180, marginTop: 24, paddingBottom: 24, borderBottom: '1px solid var(--line)' }}>
            {[42, 38, 51, 67, 48, 39, 58].map((v,i) => (
              <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
                <div style={{ width: '100%', display: 'flex', flexDirection: 'column', justifyContent: 'end', height: '100%' }}>
                  <div style={{ height: `${v*0.7}%`, background: i === 3 ? 'var(--accent)' : 'var(--ink)', borderRadius: '4px 4px 0 0', position: 'relative' }}>
                    <span style={{ position: 'absolute', top: -18, left: '50%', transform: 'translateX(-50%)', fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--ink)' }}>{v}</span>
                  </div>
                </div>
                <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)' }}>{['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][i]}</div>
              </div>
            ))}
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24, marginTop: 20 }}>
            {[
              { l: 'Auto-approved', v: '68%', c: 'var(--ok)' },
              { l: 'Needs review', v: '27%', c: 'var(--warn)' },
              { l: 'Rejected', v: '5%', c: 'var(--bad)' },
            ].map((r,i) => (
              <div key={i}>
                <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{r.l}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
                  <div style={{ width: 8, height: 8, borderRadius: 2, background: r.c }} />
                  <span style={{ fontFamily: 'var(--serif)', fontSize: 20, fontWeight: 500 }}>{r.v}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* parse errors */}
        <div style={{ border: '1px solid var(--line)', borderRadius: 12, padding: 20, background: 'var(--bg)' }}>
          <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Top parse issues</div>
          <div style={{ marginTop: 14, display: 'flex', flexDirection: 'column', gap: 10 }}>
            {[
              { l: 'Handwritten menu', v: 14, p: 80 },
              { l: 'Low light / blur', v: 11, p: 62 },
              { l: 'Unknown currency symbol', v: 7, p: 40 },
              { l: 'Non-Latin script (cyrillic cursive)', v: 5, p: 28 },
              { l: 'Price / name not aligned', v: 3, p: 17 },
            ].map((r,i) => (
              <div key={i}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12, marginBottom: 4 }}>
                  <span>{r.l}</span>
                  <span style={{ fontFamily: 'var(--mono)', color: 'var(--muted)' }}>{r.v}</span>
                </div>
                <div style={{ height: 4, background: 'var(--surface-2)', borderRadius: 2, overflow: 'hidden' }}>
                  <div style={{ height: '100%', width: `${r.p}%`, background: i === 0 ? 'var(--accent)' : 'var(--ink)' }} />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* moderator activity */}
        <div style={{ gridColumn: 'span 2', border: '1px solid var(--line)', borderRadius: 12, padding: 20, background: 'var(--bg)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Moderator activity</div>
              <div style={{ fontFamily: 'var(--serif)', fontSize: 18, fontWeight: 500, marginTop: 2 }}>Last 24 hours</div>
            </div>
            <Btn>View all →</Btn>
          </div>
          <table style={{ width: '100%', marginTop: 16, borderCollapse: 'collapse', fontSize: 13 }}>
            <thead>
              <tr style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', textAlign: 'left' }}>
                <th style={{ padding: '10px 0', borderBottom: '1px solid var(--line)' }}>Moderator</th>
                <th style={{ padding: '10px 0', borderBottom: '1px solid var(--line)' }}>Menus</th>
                <th style={{ padding: '10px 0', borderBottom: '1px solid var(--line)' }}>Dishes edited</th>
                <th style={{ padding: '10px 0', borderBottom: '1px solid var(--line)' }}>Avg time</th>
                <th style={{ padding: '10px 0', borderBottom: '1px solid var(--line)' }}>Accuracy</th>
                <th style={{ padding: '10px 0', borderBottom: '1px solid var(--line)' }}>Last active</th>
              </tr>
            </thead>
            <tbody>
              {[
                ['Elena K.', 24, 186, '3m 12s', '97%', '2m ago'],
                ['Pedro M.', 19, 142, '4m 02s', '94%', '18m ago'],
                ['Anya V.', 15, 98, '5m 30s', '91%', '1h ago'],
                ['Luís T.', 11, 76, '2m 58s', '96%', '3h ago'],
              ].map((r,i) => (
                <tr key={i} style={{ borderBottom: '1px solid var(--line)' }}>
                  <td style={{ padding: '12px 0', display: 'flex', alignItems: 'center', gap: 10 }}>
                    <div style={{ width: 24, height: 24, borderRadius: 6, background: 'var(--accent-soft)', color: 'var(--accent-ink)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--serif)', fontWeight: 600, fontSize: 12 }}>{r[0][0]}</div>
                    {r[0]}
                  </td>
                  <td style={{ fontFamily: 'var(--mono)' }}>{r[1]}</td>
                  <td style={{ fontFamily: 'var(--mono)' }}>{r[2]}</td>
                  <td style={{ fontFamily: 'var(--mono)', color: 'var(--muted)' }}>{r[3]}</td>
                  <td><Pill tone={r[4] >= '95%' ? 'ok' : 'warn'}>{r[4]}</Pill></td>
                  <td style={{ fontFamily: 'var(--mono)', color: 'var(--muted)' }}>{r[5]}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}

// ═══ 02 · QUEUE ════════════════════════════════════════
function QueueScreen({ onOpen }) {
  const rows = [
    { id: 'mn_4182', rest: 'Tasca do Zé', city: 'Lisboa', src: 'photo', lang: 'PT', items: 38, acc: 96, state: 'ready', time: '2m ago', user: 'ivan.p@' },
    { id: 'mn_4181', rest: 'Wood & Fire', city: 'Porto', src: 'photo', lang: 'PT', items: 52, acc: 89, state: 'review', time: '6m ago', user: 'maria.s@' },
    { id: 'mn_4180', rest: 'Londrina', city: 'João Pascoal', src: 'pdf', lang: 'EN', items: 24, acc: 98, state: 'ready', time: '14m ago', user: 'jose.c@' },
    { id: 'mn_4179', rest: 'Sakurazaka', city: 'Tokyo', src: 'link', lang: 'JA', items: 89, acc: 72, state: 'flagged', time: '22m ago', user: 'kenji.w@' },
    { id: 'mn_4178', rest: 'Osteria 14', city: 'Roma', src: 'photo', lang: 'IT', items: 41, acc: 93, state: 'review', time: '38m ago', user: 'elena.g@' },
    { id: 'mn_4177', rest: 'Petiscos 14', city: 'Porto', src: 'photo', lang: 'PT', items: 22, acc: 99, state: 'ready', time: '1h ago', user: 'ivan.p@' },
    { id: 'mn_4176', rest: 'Bistro Lumière', city: 'Paris', src: 'pdf', lang: 'FR', items: 34, acc: 91, state: 'review', time: '2h ago', user: 'alex.r@' },
    { id: 'mn_4175', rest: 'Al Dente', city: 'Milano', src: 'photo', lang: 'IT', items: 28, acc: 85, state: 'flagged', time: '3h ago', user: 'mario.b@' },
  ];

  const [selected, setSelected] = useState(new Set(['mn_4181']));
  const toggle = id => setSelected(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });
  const stateTone = { ready: 'ok', review: 'warn', flagged: 'bad' };

  return (
    <>
      <PageHeader
        eyebrow="Moderation · 47 pending"
        title="Validation queue"
        sub="Новые меню, распознанные ИИ и ожидающие ревью модератора. Отсортировано по дате; красные — с низкой уверенностью модели."
        actions={<>
          <Btn icon="⤓">Export CSV</Btn>
          <Btn kind="primary" icon="▶">Start reviewing</Btn>
        </>}
      />

      {/* filter bar */}
      <div style={{ padding: '16px 32px', borderBottom: '1px solid var(--line)', display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', border: '1px solid var(--line)', borderRadius: 8, flex: '0 0 280px', background: 'var(--surface)' }}>
          <span style={{ color: 'var(--muted)', fontFamily: 'var(--mono)', fontSize: 12 }}>⌕</span>
          <input placeholder="Search by restaurant, id, uploader…" style={{ border: 0, outline: 'none', flex: 1, background: 'transparent', fontSize: 13 }} />
          <span style={{ padding: '1px 6px', border: '1px solid var(--line)', borderRadius: 4, fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)' }}>⌘K</span>
        </div>

        {[
          { l: 'All', on: true, c: 47 },
          { l: 'Ready', c: 18 },
          { l: 'Needs review', c: 21 },
          { l: 'Flagged', c: 8 },
        ].map((t,i) => (
          <span key={i} style={{
            padding: '6px 12px', fontSize: 12, borderRadius: 8,
            background: t.on ? 'var(--ink)' : 'var(--surface)',
            color: t.on ? 'var(--bg)' : 'var(--ink-2)',
            border: '1px solid ' + (t.on ? 'var(--ink)' : 'var(--line)'),
            cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 6,
          }}>{t.l}<span style={{ fontFamily: 'var(--mono)', fontSize: 10, opacity: 0.7 }}>{t.c}</span></span>
        ))}

        <div style={{ width: 1, height: 20, background: 'var(--line)' }} />

        <Btn icon="⚑">Language: any</Btn>
        <Btn icon="◔">Last 24h</Btn>
        <Btn icon="⊞">Source: all</Btn>

        <div style={{ marginLeft: 'auto', fontSize: 12, color: 'var(--muted)' }}>
          {selected.size > 0 && <span style={{ marginRight: 12 }}>{selected.size} selected</span>}
          {selected.size > 0 && <Btn kind="ok" icon="✓">Approve all</Btn>}
        </div>
      </div>

      {/* table */}
      <div style={{ padding: '0 32px 32px' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
          <thead>
            <tr style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', textAlign: 'left' }}>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)', width: 30 }}></th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>ID</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>Restaurant</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>City</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>Source</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>Lang</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)', textAlign: 'right' }}>Items</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>Model confidence</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>Status</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}>Submitted</th>
              <th style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)' }}></th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r,i) => (
              <tr key={i} style={{ borderBottom: '1px solid var(--line)', background: selected.has(r.id) ? 'var(--accent-soft)' : 'transparent' }}>
                <td style={{ padding: '14px 8px' }}>
                  <input type="checkbox" checked={selected.has(r.id)} onChange={() => toggle(r.id)} />
                </td>
                <td style={{ fontFamily: 'var(--mono)', color: 'var(--muted)', padding: '14px 8px' }}>{r.id}</td>
                <td style={{ padding: '14px 8px', fontFamily: 'var(--serif)', fontSize: 14, fontWeight: 500 }}>{r.rest}</td>
                <td style={{ padding: '14px 8px', color: 'var(--ink-2)' }}>{r.city}</td>
                <td style={{ padding: '14px 8px' }}><Pill tone="neutral">{r.src}</Pill></td>
                <td style={{ padding: '14px 8px', fontFamily: 'var(--mono)', fontSize: 11 }}>{r.lang}</td>
                <td style={{ padding: '14px 8px', textAlign: 'right', fontFamily: 'var(--mono)' }}>{r.items}</td>
                <td style={{ padding: '14px 8px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8, maxWidth: 140 }}>
                    <div style={{ flex: 1, height: 4, background: 'var(--surface-2)', borderRadius: 2, overflow: 'hidden' }}>
                      <div style={{ height: '100%', width: r.acc + '%', background: r.acc >= 95 ? 'var(--ok)' : r.acc >= 85 ? 'var(--warn)' : 'var(--bad)' }} />
                    </div>
                    <span style={{ fontFamily: 'var(--mono)', fontSize: 11 }}>{r.acc}%</span>
                  </div>
                </td>
                <td style={{ padding: '14px 8px' }}><Pill tone={stateTone[r.state]}>{r.state}</Pill></td>
                <td style={{ padding: '14px 8px', fontFamily: 'var(--mono)', color: 'var(--muted)', fontSize: 11 }}>{r.time} · {r.user}</td>
                <td style={{ padding: '14px 8px', textAlign: 'right' }}>
                  <button onClick={onOpen} style={{ border: '1px solid var(--line)', background: 'var(--surface)', padding: '4px 10px', borderRadius: 6, fontSize: 12, cursor: 'pointer' }}>Open →</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}

// ═══ 03 · VALIDATE (split view) ════════════════════════
function ValidateScreen({ onBack }) {
  const [selectedIdx, setSelectedIdx] = useState(1);
  const dishes = [
    { o: 'Pão com chouriço', t: 'Хлеб с чоризо', p: 6, cat: 'Entradas', state: 'auto', conf: 98, tags: ['pork','gluten'] },
    { o: 'Bacalhau à Brás', t: 'Треска «а Браш»', p: 18.50, cat: 'Principais', state: 'review', conf: 82, tags: ['fish','egg','potato'] },
    { o: 'Polvo à lagareiro', t: 'Осьминог по-лагарейски', p: 22, cat: 'Principais', state: 'auto', conf: 96, tags: ['seafood','potato'] },
    { o: 'Arroz de marisco', t: 'Рис с морепродуктами', p: 26, cat: 'Principais', state: 'auto', conf: 97, tags: ['seafood','rice'] },
    { o: 'Francesinha', t: 'Францезинья', p: 14, cat: 'Principais', state: 'review', conf: 74, tags: ['pork','cheese','gluten'] },
    { o: 'Pastel de nata', t: 'Паштел-де-ната', p: 3, cat: 'Sobremesas', state: 'auto', conf: 99, tags: ['egg','dairy','gluten'] },
    { o: 'Leite creme', t: 'Лейте-крем', p: 5, cat: 'Sobremesas', state: 'auto', conf: 95, tags: ['egg','dairy'] },
  ];

  const selected = dishes[selectedIdx];
  const stateTone = { auto: 'ok', review: 'warn', flagged: 'bad' };

  return (
    <>
      <div style={{ padding: '16px 32px 14px', borderBottom: '1px solid var(--line)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
          <button onClick={onBack} style={{ background: 'var(--surface)', border: '1px solid var(--line)', width: 30, height: 30, borderRadius: 7, cursor: 'pointer' }}>←</button>
          <div>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>mn_4181 · in review</div>
            <div style={{ fontFamily: 'var(--serif)', fontSize: 22, fontWeight: 500, letterSpacing: '-0.02em' }}>Wood & Fire — Porto</div>
          </div>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{ fontSize: 12, color: 'var(--muted)', fontFamily: 'var(--mono)' }}>
            {dishes.filter(d => d.state === 'auto').length} / {dishes.length} verified
          </span>
          <Btn>Reject menu</Btn>
          <Btn icon="↵">Save draft</Btn>
          <Btn kind="ok" icon="✓">Approve & publish</Btn>
        </div>
      </div>

      {/* progress strip */}
      <div style={{ padding: '10px 32px', display: 'flex', alignItems: 'center', gap: 12, borderBottom: '1px solid var(--line)', fontSize: 12, color: 'var(--muted)' }}>
        <span style={{ fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.06em', fontSize: 10 }}>Progress</span>
        <div style={{ flex: 1, height: 4, background: 'var(--surface-2)', borderRadius: 2, overflow: 'hidden' }}>
          <div style={{ height: '100%', width: `${dishes.filter(d => d.state === 'auto').length / dishes.length * 100}%`, background: 'var(--accent)' }} />
        </div>
        <span style={{ fontFamily: 'var(--mono)' }}>{Math.round(dishes.filter(d => d.state === 'auto').length / dishes.length * 100)}%</span>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.2fr 340px', minHeight: 800 }}>
        {/* LEFT: source */}
        <div style={{ borderRight: '1px solid var(--line)', padding: 20, background: 'var(--surface-2)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Source · photo · page 1/2</div>
            <div style={{ display: 'flex', gap: 6 }}>
              <button style={{ width: 26, height: 26, borderRadius: 6, border: '1px solid var(--line)', background: 'var(--bg)', cursor: 'pointer', fontSize: 12 }}>−</button>
              <button style={{ width: 26, height: 26, borderRadius: 6, border: '1px solid var(--line)', background: 'var(--bg)', cursor: 'pointer', fontSize: 12 }}>+</button>
              <button style={{ width: 26, height: 26, borderRadius: 6, border: '1px solid var(--line)', background: 'var(--bg)', cursor: 'pointer', fontSize: 12 }}>⤢</button>
            </div>
          </div>

          {/* stylized menu photo */}
          <div style={{
            background: '#FDFAF3', borderRadius: 4, padding: 32, minHeight: 700,
            fontFamily: 'var(--serif)', color: '#1A1713',
            boxShadow: '0 20px 40px -10px rgba(0,0,0,0.2)',
            transform: 'rotate(-0.3deg)',
            border: '1px solid rgba(0,0,0,0.05)',
          }}>
            <div style={{ textAlign: 'center', borderBottom: '2px solid #1A1713', paddingBottom: 12 }}>
              <div style={{ fontSize: 11, fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.2em', color: '#8A3416' }}>MENU</div>
              <div style={{ fontSize: 26, fontStyle: 'italic', fontWeight: 700, marginTop: 4 }}>Wood & Fire</div>
              <div style={{ fontSize: 10, color: '#888', marginTop: 4 }}>Rua do Almada 182 · Porto</div>
            </div>

            <div style={{ marginTop: 20 }}>
              <div style={{ fontSize: 11, fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.15em', color: '#8A3416', textAlign: 'center', marginBottom: 10 }}>~ Entradas ~</div>
              {[
                { n: 'Pão com chouriço', p: '6,00', d: '… … … … … …', hl: 0 },
              ].map((d, i) => (
                <div key={i} style={{
                  display: 'flex', justifyContent: 'space-between', padding: '6px 8px', fontSize: 14, alignItems: 'baseline',
                  background: selectedIdx === i ? '#F6E2D6' : 'transparent',
                  borderRadius: 4, outline: selectedIdx === i ? '2px solid var(--accent)' : 'none',
                }}>
                  <span style={{ fontWeight: 500 }}>{d.n}</span>
                  <span style={{ borderBottom: '1px dotted #999', flex: 1, margin: '0 8px', height: 1, position: 'relative', top: -5 }}></span>
                  <span style={{ fontFamily: 'var(--mono)', fontSize: 13 }}>{d.p}</span>
                </div>
              ))}
            </div>

            <div style={{ marginTop: 20 }}>
              <div style={{ fontSize: 11, fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.15em', color: '#8A3416', textAlign: 'center', marginBottom: 10 }}>~ Principais ~</div>
              {[
                { n: 'Bacalhau à Brás', p: '18,50' },
                { n: 'Polvo à lagareiro', p: '22,00' },
                { n: 'Arroz de marisco', p: '26,00' },
                { n: 'Francesinha', p: '14,00' },
              ].map((d, i) => {
                const idx = i + 1;
                const isSel = selectedIdx === idx;
                return (
                  <div key={i} onClick={() => setSelectedIdx(idx)} style={{
                    display: 'flex', justifyContent: 'space-between', padding: '6px 8px', fontSize: 14, alignItems: 'baseline',
                    background: isSel ? '#F6E2D6' : 'transparent',
                    borderRadius: 4, outline: isSel ? '2px solid var(--accent)' : 'none',
                    cursor: 'pointer',
                  }}>
                    <span style={{ fontWeight: 500 }}>{d.n}</span>
                    <span style={{ borderBottom: '1px dotted #999', flex: 1, margin: '0 8px', height: 1, position: 'relative', top: -5 }}></span>
                    <span style={{ fontFamily: 'var(--mono)', fontSize: 13 }}>{d.p}</span>
                  </div>
                );
              })}
            </div>

            <div style={{ marginTop: 20 }}>
              <div style={{ fontSize: 11, fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.15em', color: '#8A3416', textAlign: 'center', marginBottom: 10 }}>~ Sobremesas ~</div>
              {[
                { n: 'Pastel de nata', p: '3,00' },
                { n: 'Leite creme', p: '5,00' },
              ].map((d, i) => {
                const idx = i + 5;
                const isSel = selectedIdx === idx;
                return (
                  <div key={i} onClick={() => setSelectedIdx(idx)} style={{
                    display: 'flex', justifyContent: 'space-between', padding: '6px 8px', fontSize: 14, alignItems: 'baseline',
                    background: isSel ? '#F6E2D6' : 'transparent',
                    borderRadius: 4, outline: isSel ? '2px solid var(--accent)' : 'none',
                    cursor: 'pointer',
                  }}>
                    <span style={{ fontWeight: 500 }}>{d.n}</span>
                    <span style={{ borderBottom: '1px dotted #999', flex: 1, margin: '0 8px', height: 1, position: 'relative', top: -5 }}></span>
                    <span style={{ fontFamily: 'var(--mono)', fontSize: 13 }}>{d.p}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* CENTER: parsed items list */}
        <div style={{ borderRight: '1px solid var(--line)', display: 'flex', flexDirection: 'column' }}>
          <div style={{ padding: '12px 20px', borderBottom: '1px solid var(--line)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Parsed · {dishes.length} dishes</div>
            <div style={{ display: 'flex', gap: 6 }}>
              <button style={{ padding: '4px 10px', fontSize: 11, border: '1px solid var(--line)', borderRadius: 6, background: 'var(--bg)', cursor: 'pointer', fontFamily: 'var(--mono)' }}>+ Add dish</button>
            </div>
          </div>

          <div style={{ overflow: 'auto' }}>
            {['Entradas', 'Principais', 'Sobremesas'].map(cat => (
              <Fragment key={cat}>
                <div style={{ padding: '10px 20px 6px', fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', background: 'var(--bg)' }}>
                  {cat} · {dishes.filter(d => d.cat === cat).length}
                </div>
                {dishes.map((d,i) => d.cat === cat && (
                  <div key={i} onClick={() => setSelectedIdx(i)} style={{
                    padding: '12px 20px', borderBottom: '1px solid var(--line)',
                    display: 'grid', gridTemplateColumns: '1fr auto', gap: 8, alignItems: 'center',
                    cursor: 'pointer',
                    background: selectedIdx === i ? 'var(--accent-soft)' : 'transparent',
                    borderLeft: selectedIdx === i ? '3px solid var(--accent)' : '3px solid transparent',
                  }}>
                    <div style={{ minWidth: 0 }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <div style={{ fontFamily: 'var(--serif)', fontSize: 15, fontWeight: 500 }}>{d.t}</div>
                        <Pill tone={stateTone[d.state]}>{d.state === 'auto' ? '✓ auto' : 'review'}</Pill>
                      </div>
                      <div style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)', marginTop: 2 }}>{d.o}</div>
                      <div style={{ display: 'flex', gap: 4, marginTop: 6 }}>
                        {d.tags.map((t,ti) => (
                          <span key={ti} style={{ padding: '1px 6px', fontSize: 10, background: 'var(--surface-2)', borderRadius: 4, fontFamily: 'var(--mono)', color: 'var(--ink-2)' }}>{t}</span>
                        ))}
                      </div>
                    </div>
                    <div style={{ textAlign: 'right' }}>
                      <div style={{ fontFamily: 'var(--mono)', fontSize: 14, fontWeight: 500 }}>€{d.p.toFixed(2)}</div>
                      <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: d.conf >= 90 ? 'var(--ok)' : 'var(--warn)', marginTop: 2 }}>{d.conf}%</div>
                    </div>
                  </div>
                ))}
              </Fragment>
            ))}
          </div>
        </div>

        {/* RIGHT: inspector */}
        <div style={{ padding: 20, background: 'var(--bg)', display: 'flex', flexDirection: 'column', gap: 16, overflow: 'auto' }}>
          <div>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Dish · {selectedIdx + 1} of {dishes.length}</div>
            <div style={{ display: 'flex', gap: 6, marginTop: 4 }}>
              <button style={{ padding: '3px 8px', border: '1px solid var(--line)', borderRadius: 6, background: 'var(--bg)', fontSize: 11, cursor: 'pointer', fontFamily: 'var(--mono)' }}>↑ Prev</button>
              <button style={{ padding: '3px 8px', border: '1px solid var(--line)', borderRadius: 6, background: 'var(--bg)', fontSize: 11, cursor: 'pointer', fontFamily: 'var(--mono)' }}>↓ Next</button>
            </div>
          </div>

          <PhotoSlot aspect="16/11" label="AI-picked photo" radius={10} />

          <div style={{ display: 'flex', gap: 6 }}>
            <Btn icon="↻">Find another</Btn>
            <Btn icon="⎘">Upload</Btn>
          </div>

          <div>
            <label style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Original name · PT</label>
            <input value={selected.o} readOnly style={{ width: '100%', marginTop: 4, padding: '8px 10px', border: '1px solid var(--line)', borderRadius: 6, fontSize: 13, fontFamily: 'var(--sans)', background: 'var(--surface-2)' }} />
          </div>

          <div>
            <label style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', display: 'flex', justifyContent: 'space-between' }}>
              <span>Translation · RU</span>
              <span style={{ color: 'var(--warn)', fontWeight: 600 }}>conf. {selected.conf}%</span>
            </label>
            <input value={selected.t} style={{ width: '100%', marginTop: 4, padding: '8px 10px', border: '2px solid var(--accent)', borderRadius: 6, fontSize: 13, fontFamily: 'var(--sans)', background: 'var(--bg)' }} />
            <div style={{ display: 'flex', gap: 4, marginTop: 4, flexWrap: 'wrap' }}>
              <span style={{ fontSize: 11, color: 'var(--muted)' }}>Alt:</span>
              <span style={{ fontSize: 11, padding: '1px 6px', background: 'var(--surface-2)', borderRadius: 4, cursor: 'pointer' }}>Треска по-браски</span>
              <span style={{ fontSize: 11, padding: '1px 6px', background: 'var(--surface-2)', borderRadius: 4, cursor: 'pointer' }}>Треска «Бражская»</span>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            <div>
              <label style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Price</label>
              <div style={{ display: 'flex', marginTop: 4 }}>
                <input value={selected.p} style={{ flex: 1, padding: '8px 10px', border: '1px solid var(--line)', borderRight: 0, borderRadius: '6px 0 0 6px', fontSize: 13, fontFamily: 'var(--mono)' }} />
                <div style={{ padding: '8px 10px', border: '1px solid var(--line)', borderRadius: '0 6px 6px 0', background: 'var(--surface-2)', fontSize: 13, fontFamily: 'var(--mono)' }}>EUR</div>
              </div>
            </div>
            <div>
              <label style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Category</label>
              <select style={{ width: '100%', marginTop: 4, padding: '8px 10px', border: '1px solid var(--line)', borderRadius: 6, fontSize: 13, background: 'var(--bg)' }}>
                <option>{selected.cat}</option>
              </select>
            </div>
          </div>

          <div>
            <label style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Ingredients & allergens</label>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4, marginTop: 6 }}>
              {selected.tags.map((t,i) => (
                <span key={i} style={{ padding: '4px 8px', background: 'var(--accent-soft)', color: 'var(--accent-ink)', borderRadius: 6, fontSize: 12, fontFamily: 'var(--mono)', display: 'inline-flex', alignItems: 'center', gap: 6 }}>{t}<span style={{ cursor: 'pointer', opacity: 0.6 }}>✕</span></span>
              ))}
              <span style={{ padding: '4px 8px', border: '1px dashed var(--line)', borderRadius: 6, fontSize: 12, color: 'var(--muted)', cursor: 'pointer' }}>+ add</span>
            </div>
          </div>

          <div>
            <label style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Canonical dish match</label>
            <div style={{ marginTop: 6, padding: 10, border: '1px solid var(--line)', borderRadius: 8, background: 'var(--surface-2)' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span style={{ fontFamily: 'var(--serif)', fontSize: 13, fontWeight: 500 }}>Bacalhau à Brás <span style={{ color: 'var(--muted)', fontWeight: 400 }}>· dish_pt_0124</span></span>
                <Pill tone="ok">87% match</Pill>
              </div>
              <div style={{ fontSize: 11, color: 'var(--muted)', marginTop: 4 }}>52 menus · 14 cities</div>
            </div>
            <button style={{ marginTop: 6, fontSize: 11, color: 'var(--accent-ink)', background: 'transparent', border: 0, cursor: 'pointer', fontFamily: 'var(--mono)', padding: 0 }}>Change match →</button>
          </div>

          <div style={{ display: 'flex', gap: 8, marginTop: 'auto', paddingTop: 12, borderTop: '1px solid var(--line)' }}>
            <Btn kind="danger">✕ Reject</Btn>
            <div style={{ flex: 1 }} />
            <Btn kind="ok" icon="✓">Approve</Btn>
          </div>
          <div style={{ fontSize: 10, fontFamily: 'var(--mono)', color: 'var(--muted)', textAlign: 'right' }}>⌘ + Enter to approve</div>
        </div>
      </div>
    </>
  );
}

// ═══ 04 · DISH REVIEW ══════════════════════════════════
// Review of canonical dishes — dish-level approval (name, aliases, description,
// tags, photos). Used for dishes newly promoted to canonical or flagged for
// re-review after community feedback.
const DISH_POOL = [
  { id: 'dish_pt_0124', n: 'Bacalhau à Brás', orig: 'PT', origin: 'Portugal', state: 'needs_review', aliases: ['Треска «а Браш»','Cod à Brás','Bacalao a Bras'], tags: ['fish','egg','potato','gluten','onion'], allergens: ['fish','egg','gluten'], menus: 52, cities: 14, likes: 318, desc: 'Классическое португальское блюдо: соленая треска, разобранная на волокна, с жареным картофелем-соломкой, луком и омлетом. Подается с оливками и петрушкой.', img: 'cod', photos: [{src:'ai',label:'AI · 91%',state:'pending'},{src:'user',label:'Wood & Fire',state:'approved'},{src:'user',label:'@dasha',state:'pending'},{src:'user',label:'@paulo',state:'rejected'}] },
  { id: 'dish_pt_0102', n: 'Pastel de nata', orig: 'PT', origin: 'Portugal', state: 'needs_review', aliases: ['Pastéis de Belém','Паштел-де-ната','Portuguese custard tart'], tags: ['egg','dairy','gluten','sugar'], allergens: ['egg','dairy','gluten'], menus: 84, cities: 22, likes: 1204, desc: 'Миниатюрный заварной тарт на слоёном тесте с карамельной корочкой. Подают тёплым, иногда с корицей.', img: 'nata', photos: [{src:'ai',label:'AI · 96%',state:'approved'},{src:'user',label:'Tasca do Zé',state:'approved'},{src:'user',label:'@elena',state:'pending'}] },
  { id: 'dish_pt_0145', n: 'Polvo à lagareiro', orig: 'PT', origin: 'Portugal', state: 'needs_review', aliases: ['Octopus lagareiro','Осьминог лагарейро'], tags: ['seafood','potato','olive-oil','garlic'], allergens: ['seafood'], menus: 38, cities: 11, likes: 92, desc: 'Осьминог, запечённый с оливковым маслом, чесноком и мини-картофелем «пунтаду». Одно из главных блюд северной Португалии.', img: 'octopus', photos: [{src:'ai',label:'AI · 88%',state:'pending'},{src:'user',label:'Londrina',state:'pending'}] },
  { id: 'dish_it_0081', n: 'Risotto ai funghi', orig: 'IT', origin: 'Italy', state: 'auto', aliases: ['Mushroom risotto','Рис с грибами'], tags: ['rice','dairy','mushroom'], allergens: ['dairy'], menus: 44, cities: 15, likes: 488, desc: 'Кремовый ризотто с белыми грибами, пармезаном и сливочным маслом. Обычно подается с трюфельным маслом сверху.', img: 'risotto', photos: [{src:'ai',label:'AI · 94%',state:'approved'},{src:'user',label:'Osteria 14',state:'approved'}] },
  { id: 'dish_it_0044', n: 'Carpaccio di manzo', orig: 'IT', origin: 'Italy', state: 'needs_review', aliases: ['Beef carpaccio','Карпаччо из говядины'], tags: ['beef','dairy','arugula'], allergens: ['dairy'], menus: 29, cities: 9, likes: 121, desc: 'Тонко нарезанная сырая говяжья вырезка с рукколой, пармезаном и лимонно-оливковой заправкой.', img: 'carpaccio', photos: [{src:'ai',label:'AI · 82%',state:'pending'}] },
  { id: 'dish_jp_0012', n: 'Tonkatsu', orig: 'JP', origin: 'Japan', state: 'needs_review', aliases: ['とんかつ','Тонкацу','Pork cutlet'], tags: ['pork','gluten','egg'], allergens: ['gluten','egg'], menus: 22, cities: 8, likes: 74, desc: 'Свиная котлета в панировке панко, обжаренная во фритюре. Подается с капустой и соусом тонкацу.', img: 'tonkatsu', photos: [{src:'user',label:'Sakurazaka',state:'pending'},{src:'user',label:'@koji',state:'pending'}] },
];

function DishReviewScreen({ onOpenDish }) {
  const pending = DISH_POOL.filter(d => d.state === 'needs_review');
  const stateTone = { needs_review: 'warn', auto: 'ok', flagged: 'bad' };

  return (
    <>
      <PageHeader
        eyebrow="Catalog · Dish review"
        title="Canonical dishes"
        sub="Ревью канонических записей блюд — название, описание, теги, аллергены, фото. Одобренные здесь данные используются во всех ресторанах, где это блюдо появляется."
        actions={<>
          <Btn icon="⚑">Filter: needs review</Btn>
          <Btn icon="✦">Auto-approve &gt;95%</Btn>
          <Btn kind="primary" icon="+">New canonical dish</Btn>
        </>}
        kpis={[
          { l: 'Pending review', v: '63' },
          { l: 'Approved today', v: '28', d: '+14' },
          { l: 'Canonical total', v: '2 418' },
          { l: 'Avg photos / dish', v: '3.4' },
        ]}
      />

      <div style={{ padding: '16px 32px 0', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', border: '1px solid var(--line)', borderRadius: 8, flex: '0 0 300px', background: 'var(--surface)' }}>
          <span style={{ color: 'var(--muted)', fontFamily: 'var(--mono)', fontSize: 12 }}>⌕</span>
          <input placeholder="Search canonical dish…" style={{ border: 0, outline: 'none', flex: 1, background: 'transparent', fontSize: 13 }} />
        </div>
        <Btn icon="⚑">Origin: any</Btn>
        <Btn icon="⚑">Has pending photos</Btn>
        <Btn icon="⚑">Flagged by users</Btn>
        <div style={{ marginLeft: 'auto', fontSize: 12, color: 'var(--muted)' }}>{pending.length} of {DISH_POOL.length} shown</div>
      </div>

      <div style={{ padding: 32, display: 'flex', flexDirection: 'column', gap: 14 }}>
        {DISH_POOL.map((d,i) => {
          const pendingPhotos = d.photos.filter(p => p.state === 'pending').length;
          return (
            <div key={i} style={{ border: '1px solid var(--line)', borderRadius: 14, background: 'var(--bg)', overflow: 'hidden' }}>
              <div style={{ display: 'grid', gridTemplateColumns: '120px 1fr 260px', gap: 0 }}>
                {/* hero photo (the approved/primary one) */}
                <div onClick={() => onOpenDish(d)} style={{ cursor: 'pointer' }}>
                  <PhotoSlot aspect="1/1" label={d.img} radius={0} />
                </div>

                {/* main info */}
                <div style={{ padding: '18px 20px', borderRight: '1px solid var(--line)', minWidth: 0 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
                    <div style={{ fontFamily: 'var(--serif)', fontSize: 20, fontWeight: 500, letterSpacing: '-0.01em' }}>{d.n}</div>
                    <Pill tone="neutral">{d.orig}</Pill>
                    <Pill tone={stateTone[d.state]}>{d.state === 'needs_review' ? 'needs review' : d.state}</Pill>
                    {pendingPhotos > 0 && <Pill tone="accent">{pendingPhotos} photos pending</Pill>}
                  </div>
                  <div style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)', marginTop: 4 }}>{d.id} · {d.origin}</div>

                  <p style={{ fontSize: 13, color: 'var(--ink-2)', lineHeight: 1.5, margin: '10px 0 10px', maxWidth: 640, textWrap: 'pretty' }}>{d.desc}</p>

                  <div style={{ display: 'flex', gap: 14, fontSize: 11, color: 'var(--muted)', fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.06em', marginTop: 4, flexWrap: 'wrap' }}>
                    <span><span style={{ color: 'var(--ink)', fontWeight: 600 }}>{d.menus}</span> menus</span>
                    <span><span style={{ color: 'var(--ink)', fontWeight: 600 }}>{d.cities}</span> cities</span>
                    <span><span style={{ color: 'var(--ink)', fontWeight: 600 }}>{d.likes}</span> likes</span>
                    <span><span style={{ color: 'var(--ink)', fontWeight: 600 }}>{d.photos.length}</span> photos</span>
                  </div>

                  <div style={{ display: 'flex', gap: 6, marginTop: 10, flexWrap: 'wrap' }}>
                    {d.tags.slice(0, 5).map((t,ti) => (
                      <span key={ti} style={{ fontSize: 11, padding: '3px 8px', background: 'var(--surface-2)', color: 'var(--ink-2)', borderRadius: 6, fontFamily: 'var(--mono)' }}>{t}</span>
                    ))}
                    {d.allergens.length > 0 && (
                      <span style={{ fontSize: 11, padding: '3px 8px', background: 'var(--pill-bad-bg)', color: 'var(--pill-bad-fg)', borderRadius: 6, fontFamily: 'var(--mono)' }}>⚠ {d.allergens.join(', ')}</span>
                    )}
                  </div>
                </div>

                {/* photo strip (inline approve) */}
                <div style={{ padding: '18px 20px' }}>
                  <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 8 }}>Photos ({d.photos.length})</div>
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 6 }}>
                    {d.photos.slice(0,3).map((p,pi) => (
                      <div key={pi} style={{ position: 'relative' }}>
                        <PhotoSlot aspect="1/1" label={p.src} radius={6} />
                        <div style={{ position: 'absolute', inset: 0, borderRadius: 6,
                          outline: p.state === 'approved' ? '2px solid var(--ok)' : p.state === 'rejected' ? '2px solid var(--bad)' : '2px dashed var(--warn)',
                          outlineOffset: -2,
                        }} />
                        {p.state === 'pending' && (
                          <div style={{ position: 'absolute', bottom: 3, left: 3, right: 3, display: 'flex', gap: 2 }}>
                            <button style={{ flex: 1, padding: 2, border: 0, background: 'rgba(255,255,255,0.95)', borderRadius: 3, fontSize: 9, cursor: 'pointer' }}>✕</button>
                            <button style={{ flex: 1, padding: 2, border: 0, background: 'var(--ok)', color: '#fff', borderRadius: 3, fontSize: 9, cursor: 'pointer', fontWeight: 600 }}>✓</button>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                  <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
                    <Btn icon="↗" onClick={() => onOpenDish(d)}>Open dish</Btn>
                    <div style={{ flex: 1 }} />
                    <Btn kind="ok" icon="✓">Approve</Btn>
                  </div>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}

// ═══ 05 · PHOTO REVIEW (all sources: AI + user + restaurant) ════════════
const PHOTO_POOL = [
  { dishId: 'dish_pt_0124', dish: 'Bacalhau à Brás', orig: 'PT', rest: 'Wood & Fire', src: 'ai', conf: 91, by: 'AI-vision · v2.4', when: '2m ago', img: 'cod' },
  { dishId: 'dish_pt_0124', dish: 'Bacalhau à Brás', orig: 'PT', rest: 'Wood & Fire', src: 'restaurant', by: 'Wood & Fire', when: '1h ago', img: 'cod' },
  { dishId: 'dish_pt_0124', dish: 'Bacalhau à Brás', orig: 'PT', rest: '—', src: 'user', by: '@dasha_moscow', when: '3h ago', img: 'cod', flag: 2 },
  { dishId: 'dish_pt_0102', dish: 'Pastel de nata', orig: 'PT', rest: 'Tasca do Zé', src: 'restaurant', by: 'Tasca do Zé', when: '4h ago', img: 'nata' },
  { dishId: 'dish_pt_0102', dish: 'Pastel de nata', orig: 'PT', rest: '—', src: 'user', by: '@elena_k', when: '5h ago', img: 'nata' },
  { dishId: 'dish_pt_0145', dish: 'Polvo à lagareiro', orig: 'PT', rest: 'Londrina', src: 'ai', conf: 88, by: 'AI-vision · v2.4', when: '6h ago', img: 'octopus' },
  { dishId: 'dish_pt_0145', dish: 'Polvo à lagareiro', orig: 'PT', rest: 'Londrina', src: 'user', by: '@paulo', when: '8h ago', img: 'octopus', flag: 1 },
  { dishId: 'dish_it_0044', dish: 'Carpaccio di manzo', orig: 'IT', rest: 'Osteria 14', src: 'ai', conf: 82, by: 'AI-vision · v2.4', when: '1d ago', img: 'carpaccio' },
  { dishId: 'dish_it_0081', dish: 'Risotto ai funghi', orig: 'IT', rest: 'Osteria 14', src: 'restaurant', by: 'Osteria 14', when: '1d ago', img: 'risotto' },
  { dishId: 'dish_it_0081', dish: 'Risotto ai funghi', orig: 'IT', rest: '—', src: 'user', by: '@marco', when: '1d ago', img: 'risotto' },
  { dishId: 'dish_jp_0012', dish: 'Tonkatsu', orig: 'JP', rest: 'Sakurazaka', src: 'user', by: '@koji', when: '1d ago', img: 'tonkatsu' },
  { dishId: 'dish_jp_0012', dish: 'Tonkatsu', orig: 'JP', rest: 'Sakurazaka', src: 'restaurant', by: 'Sakurazaka', when: '2d ago', img: 'tonkatsu' },
  { dishId: 'dish_pt_0231', dish: 'Arroz de marisco', orig: 'PT', rest: 'Londrina', src: 'ai', conf: 77, by: 'AI-vision · v2.4', when: '2d ago', img: 'arroz' },
  { dishId: 'dish_pt_0192', dish: 'Francesinha', orig: 'PT', rest: 'Wood & Fire', src: 'user', by: '@igor', when: '2d ago', img: 'francesinha' },
  { dishId: 'dish_pt_0241', dish: 'Bolo do caco', orig: 'PT', rest: 'Londrina', src: 'ai', conf: 64, by: 'AI-vision · v2.4', when: '3d ago', img: 'bolo', flag: 3 },
  { dishId: 'dish_pt_0232', dish: 'Caldo verde', orig: 'PT', rest: 'Tasca do Zé', src: 'user', by: '@rita', when: '3d ago', img: 'caldo' },
];

const SRC_STYLE = {
  ai:        { label: 'AI-подобрано',  tone: 'info',    icon: '✦' },
  user:      { label: 'Пользователь',  tone: 'neutral', icon: '◉' },
  restaurant:{ label: 'Ресторан',      tone: 'accent',  icon: '◧' },
  library:   { label: 'Каталог',       tone: 'ok',      icon: '⌘' },
};

function PhotosScreen({ onOpenDish }) {
  const [filter, setFilter] = useState('all'); // all | ai | user | restaurant | flagged

  const visible = PHOTO_POOL.filter(p => {
    if (filter === 'all') return true;
    if (filter === 'flagged') return !!p.flag;
    return p.src === filter;
  });

  // counts
  const c = {
    all: PHOTO_POOL.length,
    ai: PHOTO_POOL.filter(p=>p.src==='ai').length,
    user: PHOTO_POOL.filter(p=>p.src==='user').length,
    restaurant: PHOTO_POOL.filter(p=>p.src==='restaurant').length,
    flagged: PHOTO_POOL.filter(p=>p.flag).length,
  };

  const TABS = [
    { id: 'all', label: 'All sources', n: c.all },
    { id: 'ai', label: '✦ AI-picked', n: c.ai },
    { id: 'user', label: '◉ User-submitted', n: c.user },
    { id: 'restaurant', label: '◧ Restaurant-owner', n: c.restaurant },
    { id: 'flagged', label: '⚑ Flagged', n: c.flagged },
  ];

  return (
    <>
      <PageHeader
        eyebrow="Moderation · Photo review"
        title="All photos"
        sub="Все фотографии, ожидающие ревью — от ИИ, пользователей и ресторанов. Кликните на карточку — откроется блюдо с описанием и всеми фото."
        actions={<>
          <Btn icon="⚑">Sort: newest</Btn>
          <Btn kind="primary" icon="✓">Batch approve AI &gt;95%</Btn>
        </>}
        kpis={[
          { l: 'Pending total', v: '246' },
          { l: 'AI-picked', v: '128' },
          { l: 'User-submitted', v: '86', d: '+12' },
          { l: 'Restaurant-owner', v: '32' },
          { l: 'User-flagged', v: '14', d: '+3' },
        ]}
      />

      <div style={{ padding: '16px 32px 0', display: 'flex', alignItems: 'center', gap: 6, borderBottom: '1px solid var(--line)', flexWrap: 'wrap' }}>
        {TABS.map(t => (
          <button key={t.id} onClick={() => setFilter(t.id)} style={{
            padding: '10px 14px', border: 0, background: 'transparent', cursor: 'pointer',
            fontSize: 13, fontWeight: filter === t.id ? 600 : 400,
            color: filter === t.id ? 'var(--ink)' : 'var(--ink-2)',
            borderBottom: filter === t.id ? '2px solid var(--accent)' : '2px solid transparent',
            marginBottom: -1, display: 'flex', alignItems: 'center', gap: 8,
          }}>
            {t.label}
            <span style={{ fontFamily: 'var(--mono)', fontSize: 10, padding: '1px 7px', borderRadius: 999, background: filter === t.id ? 'var(--accent-soft)' : 'var(--surface-2)', color: filter === t.id ? 'var(--accent-ink)' : 'var(--muted)' }}>{t.n}</span>
          </button>
        ))}
      </div>

      <div style={{ padding: 32, display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 20 }}>
        {visible.map((p,i) => {
          const meta = SRC_STYLE[p.src];
          const dishRef = DISH_POOL.find(d => d.id === p.dishId) || { id: p.dishId, n: p.dish, orig: p.orig, desc: 'Описание блюда появится после ревью.', tags: [], allergens: [], photos: [], menus: 1, cities: 1, likes: 0, img: p.img };
          return (
            <div key={i} style={{ border: '1px solid var(--line)', borderRadius: 12, background: 'var(--bg)', overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
              <div style={{ position: 'relative', cursor: 'pointer' }} onClick={() => onOpenDish(dishRef)}>
                <PhotoSlot aspect="4/3" label={p.img} radius={0} />
                <div style={{ position: 'absolute', top: 10, left: 10, display: 'flex', gap: 6 }}>
                  <Pill tone={meta.tone}>{meta.icon} {meta.label}</Pill>
                  {p.src === 'ai' && <Pill tone={p.conf >= 90 ? 'ok' : p.conf >= 75 ? 'warn' : 'bad'}>{p.conf}%</Pill>}
                  {p.flag && <Pill tone="bad">⚑ {p.flag}</Pill>}
                </div>
              </div>
              <div style={{ padding: 12, display: 'flex', flexDirection: 'column', gap: 6, flex: 1 }}>
                <div onClick={() => onOpenDish(dishRef)} style={{ cursor: 'pointer' }}>
                  <div style={{ fontFamily: 'var(--serif)', fontSize: 14, fontWeight: 500, letterSpacing: '-0.01em', lineHeight: 1.2 }}>{p.dish}</div>
                  <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', marginTop: 2 }}>{p.orig} · {p.dishId}</div>
                </div>
                <div style={{ fontSize: 11, color: 'var(--ink-2)', marginTop: 2, display: 'flex', justifyContent: 'space-between' }}>
                  <span>{p.by}</span>
                  <span style={{ fontFamily: 'var(--mono)', color: 'var(--muted)' }}>{p.when}</span>
                </div>
                {p.rest && p.rest !== '—' && (
                  <div style={{ fontSize: 11, color: 'var(--muted)' }}>at <span style={{ color: 'var(--ink-2)' }}>{p.rest}</span></div>
                )}
                <div style={{ display: 'flex', gap: 4, marginTop: 'auto' }}>
                  <button style={{ flex: 1, padding: 6, border: '1px solid var(--line)', borderRadius: 6, background: 'var(--bg)', fontSize: 11, cursor: 'pointer' }}>✕ Reject</button>
                  <button style={{ flex: 1, padding: 6, border: 0, background: 'var(--ok)', color: '#fff', borderRadius: 6, fontSize: 11, cursor: 'pointer', fontWeight: 500 }}>✓ Approve</button>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}

// ═══ DISH DETAIL DRAWER ═══════════════════════════════
// Slide-in panel from the right — full dish context: description, tags,
// allergens, stats, all photos grouped by source. Used across Photo review,
// Dish review and Dish library.
function DishDrawerTranslations({ dish }) {
  // 7 languages: EN canonical + 6 targets. For any dish, we show:
  // - language tabs (flag + code), with status dot
  // - active language: name, description, tags
  // - EN row is always green (source); others carry per-language state
  const canon = {
    en: { flag: '🇬🇧', label: 'English (canonical)', name: dish.n || 'Shredded salt cod with potatoes & egg', desc: dish.desc || 'Classic Portuguese dish: salted cod shredded into fine strands, tossed with matchstick potatoes, onions and softly-set egg. Served with olives and parsley.', tags: dish.tags || ['fish','egg','potato'] },
    ru: { flag: '🇷🇺', label: 'Русский',            name: 'Треска «а Браш» с картофелем и яйцом',     desc: 'Классическое португальское блюдо: солёная треска, разобранная на волокна, с жареным картофелем-соломкой, луком и нежным омлетом. Подаётся с оливками и петрушкой.', tags: ['рыба','яйцо','картофель'] },
    pt: { flag: '🇵🇹', label: 'Português',          name: dish.orig || 'Bacalhau à Brás',              desc: 'Prato clássico português: bacalhau desfiado em lascas finas, salteado com batata palha, cebola e ovo levemente cozido. Servido com azeitonas e salsa.', tags: ['peixe','ovo','batata'] },
    es: { flag: '🇪🇸', label: 'Español',            name: 'Bacalao a la Brás',                         desc: 'Plato clásico portugués: bacalao desmenuzado en hebras finas, salteado con patatas paja, cebolla y huevo cuajado. Servido con aceitunas y perejil.', tags: ['pescado','huevo','patata'] },
    it: { flag: '🇮🇹', label: 'Italiano',           name: 'Baccalà alla Brás',                         desc: 'Piatto classico portoghese: baccalà sfilacciato, saltato con patate a fiammifero, cipolla e uovo morbido. Servito con olive e prezzemolo.', tags: ['pesce','uovo','patata'] },
    fr: { flag: '🇫🇷', label: 'Français',           name: 'Morue effilochée à la Brás',                desc: 'Plat portugais classique : morue salée effilochée, sautée avec des pommes paille, oignons et œufs juste pris. Servi avec olives et persil.', tags: ['poisson','œuf','pomme de terre'] },
    de: { flag: '🇩🇪', label: 'Deutsch',            name: 'Bacalhau à Brás (Kabeljau mit Kartoffelstroh)', desc: 'Portugiesischer Klassiker: gesalzener Kabeljau in feinen Fäden, gebraten mit Kartoffelstroh, Zwiebeln und weich gerührtem Ei. Mit Oliven und Petersilie serviert.', tags: ['Fisch','Ei','Kartoffel'] },
  };
  const state = { en: 'source', ru: 'review', pt: 'ok', es: 'ok', it: 'ok', fr: 'ok', de: 'missing' };
  const swatch = { source: 'var(--ink)', ok: 'var(--ok)', review: 'var(--warn)', flagged: 'var(--bad)', missing: 'var(--line)' };
  const order = ['en','ru','pt','es','it','fr','de'];
  const [tab, setTab] = useState('en');
  const active = canon[tab];
  const st = state[tab];

  return (
    <div style={{ border: '1px solid var(--line)', borderRadius: 10, overflow: 'hidden' }}>
      {/* tabs */}
      <div style={{ display: 'flex', borderBottom: '1px solid var(--line)', background: 'var(--surface-2)' }}>
        {order.map(k => (
          <button key={k} onClick={() => setTab(k)} style={{
            flex: 1, padding: '10px 6px', border: 0, background: tab === k ? 'var(--bg)' : 'transparent',
            borderRight: '1px solid var(--line)', cursor: 'pointer',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
            borderBottom: tab === k ? '2px solid var(--accent)' : '2px solid transparent',
            marginBottom: -1,
          }}>
            <span style={{ fontSize: 16, lineHeight: 1 }}>{canon[k].flag}</span>
            <span style={{ fontFamily: 'var(--mono)', fontSize: 10, fontWeight: tab === k ? 700 : 500, color: tab === k ? 'var(--ink)' : 'var(--ink-2)' }}>{k.toUpperCase()}</span>
            <span style={{ width: 6, height: 6, borderRadius: 3, background: swatch[state[k]] }} />
          </button>
        ))}
      </div>
      {/* body */}
      <div style={{ padding: 16, background: 'var(--bg)' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
          <span style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{active.label}</span>
          <span style={{ fontFamily: 'var(--mono)', fontSize: 10, padding: '2px 8px', borderRadius: 10,
            background: st === 'source' ? 'var(--ink)' : st === 'ok' ? 'var(--ok)' : st === 'review' ? 'var(--warn)' : st === 'missing' ? 'var(--surface-2)' : 'var(--bad)',
            color: st === 'missing' ? 'var(--muted)' : '#fff', textTransform: 'uppercase', letterSpacing: '0.06em',
          }}>{st === 'source' ? 'canonical' : st}</span>
        </div>
        {st === 'missing' ? (
          <div style={{ padding: '24px 0', textAlign: 'center' }}>
            <div style={{ fontSize: 13, color: 'var(--muted)', marginBottom: 10 }}>No translation yet for {active.label}.</div>
            <Btn kind="primary" icon="↻">Generate {tab.toUpperCase()} translation</Btn>
          </div>
        ) : (
          <>
            <input readOnly={st === 'source'} defaultValue={active.name} style={{
              width: '100%', padding: '8px 10px', border: '1px solid ' + (st === 'review' ? 'var(--warn)' : 'var(--line)'),
              borderRadius: 6, fontSize: 16, fontFamily: 'var(--serif)', fontWeight: 500, marginBottom: 8,
              background: st === 'source' ? 'var(--surface-2)' : 'var(--bg)',
            }} />
            <textarea readOnly={st === 'source'} defaultValue={active.desc} style={{
              width: '100%', padding: '8px 10px', border: '1px solid var(--line)', borderRadius: 6,
              fontSize: 13, lineHeight: 1.5, minHeight: 72, fontFamily: 'inherit', resize: 'vertical',
              background: st === 'source' ? 'var(--surface-2)' : 'var(--bg)',
            }} />
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4, marginTop: 8 }}>
              {active.tags.map((t,i) => (
                <span key={i} style={{ fontSize: 11, padding: '3px 8px', background: 'var(--accent-soft)', color: 'var(--accent-ink)', borderRadius: 6, fontFamily: 'var(--mono)' }}>{t}</span>
              ))}
            </div>
            {st !== 'source' && (
              <div style={{ display: 'flex', gap: 6, marginTop: 12 }}>
                <Btn icon="↻">Re-translate</Btn>
                <div style={{ flex: 1 }} />
                <Btn>Skip</Btn>
                <Btn kind="ok" icon="✓">Approve {tab.toUpperCase()}</Btn>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

function DishDrawer({ dish, onClose }) {
  useEffect(() => {
    const onKey = (e) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [onClose]);

  const photos = dish.photos && dish.photos.length ? dish.photos : [
    {src:'ai',label:'AI',state:'pending'},
    {src:'user',label:'—',state:'pending'},
  ];
  const grouped = {
    ai:         photos.filter(p => p.src === 'ai'),
    restaurant: photos.filter(p => p.src === 'restaurant'),
    user:       photos.filter(p => p.src === 'user'),
  };

  return (
    <>
      <div onClick={onClose} style={{ position: 'fixed', inset: 0, background: 'rgba(15,16,18,0.35)', zIndex: 100, backdropFilter: 'blur(2px)' }} />
      <aside style={{
        position: 'fixed', top: 0, right: 0, bottom: 0, width: 560, zIndex: 101,
        background: 'var(--bg)', borderLeft: '1px solid var(--line)',
        display: 'flex', flexDirection: 'column',
        boxShadow: '-20px 0 60px -20px rgba(0,0,0,0.2)',
      }}>
        {/* header */}
        <div style={{ padding: '16px 24px', borderBottom: '1px solid var(--line)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <span style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>Canonical dish</span>
            <span style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--ink-2)' }}>{dish.id}</span>
          </div>
          <div style={{ display: 'flex', gap: 6 }}>
            <button style={{ padding: '4px 10px', fontSize: 11, border: '1px solid var(--line)', borderRadius: 6, background: 'var(--bg)', cursor: 'pointer', fontFamily: 'var(--mono)' }}>↗ Open full</button>
            <button onClick={onClose} style={{ width: 28, height: 28, borderRadius: 6, border: '1px solid var(--line)', background: 'var(--bg)', cursor: 'pointer', fontSize: 14 }}>✕</button>
          </div>
        </div>

        <div style={{ flex: 1, overflow: 'auto', padding: '24px' }}>
          {/* hero */}
          <div style={{ display: 'grid', gridTemplateColumns: '160px 1fr', gap: 16, alignItems: 'start' }}>
            <PhotoSlot aspect="1/1" label={dish.img || 'dish'} radius={12} />
            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap' }}>
                <h2 style={{ fontFamily: 'var(--serif)', fontSize: 26, fontWeight: 500, letterSpacing: '-0.02em', margin: 0, lineHeight: 1.1 }}>{dish.n}</h2>
                {dish.orig && <Pill tone="neutral">{dish.orig}</Pill>}
              </div>
              {dish.origin && <div style={{ fontSize: 12, color: 'var(--muted)', marginTop: 4, fontFamily: 'var(--mono)' }}>origin · {dish.origin}</div>}
              <div style={{ display: 'flex', gap: 14, fontSize: 11, color: 'var(--muted)', fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.06em', marginTop: 14, flexWrap: 'wrap' }}>
                <span><span style={{ color: 'var(--ink)', fontWeight: 600 }}>{dish.menus ?? 0}</span> menus</span>
                <span><span style={{ color: 'var(--ink)', fontWeight: 600 }}>{dish.cities ?? 0}</span> cities</span>
                <span><span style={{ color: 'var(--ink)', fontWeight: 600 }}>{dish.likes ?? 0}</span> likes</span>
              </div>
            </div>
          </div>

          {/* description */}
          <section style={{ marginTop: 24 }}>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 6 }}>Description</div>
            <p style={{ fontSize: 14, color: 'var(--ink-2)', lineHeight: 1.55, margin: 0, textWrap: 'pretty' }}>{dish.desc}</p>
          </section>

          {/* translations */}
          <section style={{ marginTop: 22 }}>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 8, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span>Translations · EN canonical + 6 targets</span>
              <span style={{ color: 'var(--accent-ink)', cursor: 'pointer' }}>Edit all →</span>
            </div>
            <DishDrawerTranslations dish={dish} />
          </section>

          {/* aliases */}
          {dish.aliases && dish.aliases.length > 0 && (
            <section style={{ marginTop: 20 }}>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 6 }}>Known aliases on menus</div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                {dish.aliases.map((a,ai) => (
                  <span key={ai} style={{ fontSize: 12, padding: '4px 10px', background: 'var(--surface-2)', borderRadius: 999, color: 'var(--ink-2)' }}>{a}</span>
                ))}
              </div>
            </section>
          )}

          {/* tags & allergens */}
          {(dish.tags?.length || dish.allergens?.length) && (
            <section style={{ marginTop: 20, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
              <div>
                <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 6 }}>Tags</div>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
                  {(dish.tags || []).map((t,ti) => (
                    <span key={ti} style={{ fontSize: 11, padding: '3px 8px', background: 'var(--accent-soft)', color: 'var(--accent-ink)', borderRadius: 6, fontFamily: 'var(--mono)' }}>{t}</span>
                  ))}
                </div>
              </div>
              <div>
                <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 6 }}>Allergens</div>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
                  {(dish.allergens || []).map((t,ti) => (
                    <span key={ti} style={{ fontSize: 11, padding: '3px 8px', background: 'var(--pill-bad-bg)', color: 'var(--pill-bad-fg)', borderRadius: 6, fontFamily: 'var(--mono)' }}>⚠ {t}</span>
                  ))}
                  {(!dish.allergens || dish.allergens.length === 0) && <span style={{ fontSize: 11, color: 'var(--muted)' }}>— none recorded</span>}
                </div>
              </div>
            </section>
          )}

          {/* photos */}
          <section style={{ marginTop: 28 }}>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 10, display: 'flex', justifyContent: 'space-between' }}>
              <span>All photos ({photos.length})</span>
              <span style={{ color: 'var(--accent-ink)', cursor: 'pointer' }}>+ Upload new</span>
            </div>

            {['ai','restaurant','user'].map(src => grouped[src].length > 0 && (
              <div key={src} style={{ marginBottom: 18 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
                  <Pill tone={SRC_STYLE[src].tone}>{SRC_STYLE[src].icon} {SRC_STYLE[src].label}</Pill>
                  <span style={{ fontSize: 11, color: 'var(--muted)', fontFamily: 'var(--mono)' }}>{grouped[src].length} photo{grouped[src].length > 1 ? 's' : ''}</span>
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
                  {grouped[src].map((p,pi) => (
                    <div key={pi} style={{ position: 'relative' }}>
                      <PhotoSlot aspect="1/1" label={p.label || dish.img || ''} radius={8} />
                      <div style={{ position: 'absolute', inset: 0, borderRadius: 8,
                        outline: p.state === 'approved' ? '2px solid var(--ok)' : p.state === 'rejected' ? '2px solid var(--bad)' : '2px dashed var(--warn)',
                        outlineOffset: -2,
                      }} />
                      <div style={{ position: 'absolute', top: 4, right: 4 }}>
                        <Pill tone={p.state === 'approved' ? 'ok' : p.state === 'rejected' ? 'bad' : 'warn'}>{p.state}</Pill>
                      </div>
                      {p.state === 'pending' && (
                        <div style={{ position: 'absolute', bottom: 4, left: 4, right: 4, display: 'flex', gap: 3 }}>
                          <button style={{ flex: 1, padding: 3, border: 0, background: 'rgba(255,255,255,0.95)', borderRadius: 4, fontSize: 10, cursor: 'pointer' }}>✕</button>
                          <button style={{ flex: 1, padding: 3, border: 0, background: 'var(--ok)', color: '#fff', borderRadius: 4, fontSize: 10, cursor: 'pointer', fontWeight: 600 }}>✓</button>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </section>
        </div>

        {/* footer actions */}
        <div style={{ padding: '14px 24px', borderTop: '1px solid var(--line)', display: 'flex', gap: 8, background: 'var(--surface-2)' }}>
          <Btn icon="⎋">Merge with…</Btn>
          <Btn icon="⚑">Flag</Btn>
          <div style={{ flex: 1 }} />
          <Btn kind="danger">✕ Reject dish</Btn>
          <Btn kind="ok" icon="✓">Approve dish</Btn>
        </div>
      </aside>
    </>
  );
}

// ═══ 05 · TRANSLATIONS REVIEW ══════════════════════════
// The canonical dish is stored in EN. Every dish is translated into 6 target
// languages. This screen surfaces coverage per dish at a glance.
const TARGET_LANGS = [
  { k: 'ru', flag: '🇷🇺' },
  { k: 'pt', flag: '🇵🇹' },
  { k: 'es', flag: '🇪🇸' },
  { k: 'it', flag: '🇮🇹' },
  { k: 'fr', flag: '🇫🇷' },
  { k: 'de', flag: '🇩🇪' },
];

// state per target-lang: 'ok' (auto approved), 'review' (needs human), 'missing', 'flagged'
function TranslationsScreen({ onOpenDish }) {
  const rows = [
    { id: 'd_0124', canon: 'Shredded salt cod with potatoes & egg', orig: 'Bacalhau à Brás',           t: { ru: 'review',  pt: 'ok',      es: 'ok',     it: 'review', fr: 'ok',      de: 'missing' }, worst: 74, rest: 'Wood & Fire' },
    { id: 'd_0145', canon: 'Octopus lagareiro-style',                orig: 'Polvo à lagareiro',         t: { ru: 'ok',      pt: 'ok',      es: 'ok',     it: 'ok',     fr: 'ok',      de: 'ok'      }, worst: 94, rest: 'Tasca do Zé' },
    { id: 'd_0192', canon: 'Francesinha',                             orig: 'Francesinha',               t: { ru: 'ok',      pt: 'ok',      es: 'ok',     it: 'ok',     fr: 'ok',      de: 'ok'      }, worst: 96, rest: 'Wood & Fire' },
    { id: 'd_0214', canon: 'Alentejo-style pork with clams',         orig: 'Carne de porco à alentejana', t: { ru: 'flagged', pt: 'ok',      es: 'review', it: 'review', fr: 'review',  de: 'missing' }, worst: 61, rest: 'Petiscos 14' },
    { id: 'd_0231', canon: 'Seafood rice',                            orig: 'Arroz de marisco',          t: { ru: 'ok',      pt: 'ok',      es: 'ok',     it: 'ok',     fr: 'ok',      de: 'ok'      }, worst: 98, rest: 'Londrina' },
    { id: 'd_0241', canon: 'Caco bread',                              orig: 'Bolo do caco',              t: { ru: 'review',  pt: 'ok',      es: 'ok',     it: 'missing',fr: 'missing', de: 'missing' }, worst: 68, rest: 'Londrina' },
    { id: 'd_0258', canon: 'Clams Bulhão Pato style',                orig: 'Amêijoas à Bulhão Pato',    t: { ru: 'ok',      pt: 'ok',      es: 'ok',     it: 'ok',     fr: 'review',  de: 'ok'      }, worst: 81, rest: 'Tasca do Zé' },
  ];

  const tone = { ok: 'ok', review: 'warn', flagged: 'bad', missing: 'neutral' };
  const glyph = { ok: '✓', review: '◐', flagged: '!', missing: '—' };
  const swatch = { ok: 'var(--ok)', review: 'var(--warn)', flagged: 'var(--bad)', missing: 'var(--line)' };

  // aggregate
  const totalCells = rows.length * 6;
  const bad = rows.reduce((s, r) => s + Object.values(r.t).filter(v => v === 'review' || v === 'flagged' || v === 'missing').length, 0);

  return (
    <>
      <PageHeader
        eyebrow="Moderation · Translations"
        title="Translation coverage"
        sub="English is canonical. Each row = one dish translated into six target languages. Click a cell to review that translation."
        actions={<>
          <Btn icon="⚑">Language: all</Btn>
          <Btn icon="↻">Re-run AI</Btn>
          <Btn kind="primary">Open first issue →</Btn>
        </>}
        kpis={[
          { l: 'Dishes', v: rows.length, d: 'in catalog' },
          { l: 'Coverage', v: `${Math.round((totalCells - bad) / totalCells * 100)}%`, d: `${bad} issues` },
          { l: 'Languages', v: 6, d: 'target' },
          { l: 'Canonical', v: 'EN', d: 'source' },
        ]}
      />

      <div style={{ padding: '0 32px 32px' }}>
        {/* Legend */}
        <div style={{ display: 'flex', gap: 14, marginBottom: 14, fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', alignItems: 'center' }}>
          <span>Legend:</span>
          {[['ok','auto-approved'],['review','needs review'],['flagged','flagged'],['missing','missing']].map(([k,l]) => (
            <span key={k} style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
              <span style={{ width: 10, height: 10, borderRadius: 2, background: swatch[k] }} /> {l}
            </span>
          ))}
        </div>

        <div style={{ border: '1px solid var(--line)', borderRadius: 10, overflow: 'hidden', background: 'var(--bg)' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
            <thead>
              <tr style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', textAlign: 'left', background: 'var(--surface-2)' }}>
                <th style={{ padding: '12px 14px', borderBottom: '1px solid var(--line)' }}>Dish · EN (canonical)</th>
                <th style={{ padding: '12px 14px', borderBottom: '1px solid var(--line)' }}>Original</th>
                {TARGET_LANGS.map(l => (
                  <th key={l.k} style={{ padding: '12px 8px', borderBottom: '1px solid var(--line)', textAlign: 'center', width: 56 }}>
                    <div style={{ fontSize: 14, lineHeight: 1 }}>{l.flag}</div>
                    <div style={{ marginTop: 2 }}>{l.k.toUpperCase()}</div>
                  </th>
                ))}
                <th style={{ padding: '12px 14px', borderBottom: '1px solid var(--line)' }}>Worst</th>
                <th style={{ padding: '12px 14px', borderBottom: '1px solid var(--line)', textAlign: 'right' }}></th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r,i) => (
                <tr key={i} style={{ borderBottom: i < rows.length - 1 ? '1px solid var(--line)' : 0 }}>
                  <td style={{ padding: '14px' }}>
                    <div style={{ fontFamily: 'var(--serif)', fontSize: 14, fontWeight: 500, letterSpacing: '-0.005em' }}>{r.canon}</div>
                    <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', marginTop: 2 }}>{r.id} · {r.rest}</div>
                  </td>
                  <td style={{ padding: '14px' }}>
                    <div style={{ fontSize: 13, color: 'var(--ink-2)', fontStyle: 'italic' }}>{r.orig}</div>
                  </td>
                  {TARGET_LANGS.map(l => {
                    const st = r.t[l.k];
                    return (
                      <td key={l.k} style={{ padding: '10px 4px', textAlign: 'center', borderLeft: '1px solid var(--line)' }}>
                        <button title={`${l.k.toUpperCase()} · ${st}`} style={{
                          width: 28, height: 28, borderRadius: 6, border: 0, cursor: 'pointer',
                          background: st === 'missing' ? 'transparent' : swatch[st],
                          color: st === 'missing' ? 'var(--muted)' : '#fff',
                          outline: st === 'missing' ? '1px dashed var(--line)' : 0,
                          fontFamily: 'var(--mono)', fontSize: 12, fontWeight: 700,
                        }}>{glyph[st]}</button>
                      </td>
                    );
                  })}
                  <td style={{ padding: '14px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8, width: 90 }}>
                      <div style={{ flex: 1, height: 4, background: 'var(--surface-2)', borderRadius: 2, overflow: 'hidden' }}>
                        <div style={{ height: '100%', width: r.worst + '%', background: r.worst >= 90 ? 'var(--ok)' : r.worst >= 75 ? 'var(--warn)' : 'var(--bad)' }} />
                      </div>
                      <span style={{ fontFamily: 'var(--mono)', fontSize: 11 }}>{r.worst}</span>
                    </div>
                  </td>
                  <td style={{ padding: '14px', textAlign: 'right', whiteSpace: 'nowrap' }}>
                    <button onClick={() => onOpenDish && onOpenDish({ id: r.id, n: r.canon, orig: r.orig, desc: 'Open dish for full translation review.' })}
                      style={{ padding: '5px 12px', border: '1px solid var(--line)', borderRadius: 6, fontSize: 12, background: 'var(--bg)', cursor: 'pointer', fontFamily: 'var(--mono)' }}>
                      Review →
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Drawer-style per-cell review */}
        <div style={{ marginTop: 22, padding: 18, border: '1px solid var(--line)', borderRadius: 10, background: 'var(--surface-2)' }}>
          <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 10 }}>
            Focus · <span style={{ color: 'var(--ink)' }}>Bacalhau à Brás · RU translation</span>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 18 }}>
            <div>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', marginBottom: 4 }}>🇬🇧 EN · CANONICAL</div>
              <div style={{ fontFamily: 'var(--serif)', fontSize: 18, fontWeight: 500 }}>Shredded salt cod with potatoes &amp; egg</div>
              <p style={{ fontSize: 13, color: 'var(--ink-2)', marginTop: 6, lineHeight: 1.5 }}>Classic Portuguese dish: salted cod shredded into fine strands, tossed with matchstick potatoes, onions and softly-set egg. Served with olives and parsley.</p>
            </div>
            <div>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', marginBottom: 4 }}>🇷🇺 RU · AI draft · 74%</div>
              <input defaultValue="Треска «а Браш» с картофелем и яйцом" style={{ width: '100%', padding: '8px 10px', border: '1px solid var(--warn)', borderRadius: 6, fontSize: 15, fontFamily: 'var(--serif)', fontWeight: 500, marginBottom: 6 }} />
              <textarea defaultValue="Классическое португальское блюдо: солёная треска, разобранная на волокна, с жареным картофелем-соломкой, луком и нежным омлетом. Подаётся с оливками и петрушкой."
                style={{ width: '100%', padding: '8px 10px', border: '1px solid var(--line)', borderRadius: 6, fontSize: 13, lineHeight: 1.5, minHeight: 76, fontFamily: 'inherit', resize: 'vertical' }} />
              <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
                <Btn icon="↻">Re-translate</Btn>
                <div style={{ flex: 1 }} />
                <Btn>Skip</Btn>
                <Btn kind="ok" icon="✓">Approve RU</Btn>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

// ═══ 06 · DISH LIBRARY / MERGE ═════════════════════════
function LibraryScreen() {
  const rows = [
    { id: 'dish_pt_0124', n: 'Bacalhau à Brás', aliases: ['Bacalao a Bras','Треска по-браски','Cod à la Brás','Bacalao brasa'], menus: 52, cities: 14, origin: 'PT', tags: ['fish','egg','potato','gluten'], img: 'cod' },
    { id: 'dish_pt_0145', n: 'Polvo à lagareiro', aliases: ['Octopus lagareiro','Осьминог лагарейро','Polvo lagareiro'], menus: 38, cities: 11, origin: 'PT', tags: ['seafood','potato'], img: 'octopus' },
    { id: 'dish_pt_0102', n: 'Pastel de nata', aliases: ['Pastéis de Belém','Паштел-де-ната','Portuguese custard tart'], menus: 84, cities: 22, origin: 'PT', tags: ['egg','dairy','gluten'], img: 'nata', dupes: 2 },
    { id: 'dish_it_0044', n: 'Carpaccio di manzo', aliases: ['Beef carpaccio','Карпаччо из говядины','Vitello carpaccio'], menus: 29, cities: 9, origin: 'IT', tags: ['beef','dairy'], img: 'carpaccio' },
    { id: 'dish_it_0081', n: 'Risotto ai funghi', aliases: ['Mushroom risotto','Рис с грибами','Risotto funghi porcini'], menus: 44, cities: 15, origin: 'IT', tags: ['rice','dairy','mushroom'], img: 'risotto' },
  ];

  return (
    <>
      <PageHeader
        eyebrow="Catalog · 2 418 canonical dishes"
        title="Dish library"
        sub="Канонические записи блюд. При парсинге новое блюдо автоматически сопоставляется с каноническим — сливайте дубликаты, чтобы одна фотография и один перевод использовались во всей платформе."
        actions={<>
          <Btn icon="⎘">Import CSV</Btn>
          <Btn icon="⎋">Merge…</Btn>
          <Btn kind="primary" icon="+">New dish</Btn>
        </>}
      />

      <div style={{ padding: '16px 32px 0', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', border: '1px solid var(--line)', borderRadius: 8, flex: '0 0 320px', background: 'var(--surface)' }}>
          <span style={{ color: 'var(--muted)', fontFamily: 'var(--mono)', fontSize: 12 }}>⌕</span>
          <input placeholder="Search dish by name, alias, id…" style={{ border: 0, outline: 'none', flex: 1, background: 'transparent', fontSize: 13 }} />
        </div>
        <Btn icon="⚑">Origin: any</Btn>
        <Btn icon="⚑">Tag: any</Btn>
        <Btn icon="⋮">Has duplicates (2)</Btn>
        <div style={{ marginLeft: 'auto', fontSize: 12, color: 'var(--muted)' }}>2 418 results</div>
      </div>

      <div style={{ padding: 32, display: 'flex', flexDirection: 'column', gap: 10 }}>
        {rows.map((r,i) => (
          <div key={i} style={{ border: '1px solid var(--line)', borderRadius: 12, padding: 16, display: 'grid', gridTemplateColumns: '72px 1fr auto auto', gap: 16, alignItems: 'center', background: 'var(--bg)' }}>
            <div style={{ width: 72, height: 72 }}>
              <PhotoSlot aspect="1/1" label={r.img} radius={10} />
            </div>
            <div style={{ minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <div style={{ fontFamily: 'var(--serif)', fontSize: 18, fontWeight: 500, letterSpacing: '-0.01em' }}>{r.n}</div>
                <Pill tone="neutral">{r.origin}</Pill>
                {r.dupes && <Pill tone="warn">{r.dupes} duplicates</Pill>}
              </div>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)', marginTop: 2 }}>{r.id}</div>
              <div style={{ display: 'flex', gap: 4, marginTop: 8, flexWrap: 'wrap' }}>
                <span style={{ fontSize: 10, color: 'var(--muted)', fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.06em', marginRight: 2 }}>aliases:</span>
                {r.aliases.map((a,ai) => (
                  <span key={ai} style={{ fontSize: 12, padding: '2px 8px', background: 'var(--surface-2)', borderRadius: 4, color: 'var(--ink-2)' }}>{a}</span>
                ))}
              </div>
            </div>
            <div style={{ display: 'flex', gap: 4 }}>
              {r.tags.map((t,ti) => (
                <span key={ti} style={{ fontSize: 10, padding: '3px 7px', background: 'var(--accent-soft)', color: 'var(--accent-ink)', borderRadius: 6, fontFamily: 'var(--mono)' }}>{t}</span>
              ))}
            </div>
            <div style={{ textAlign: 'right', minWidth: 100 }}>
              <div style={{ fontFamily: 'var(--serif)', fontSize: 20, fontWeight: 500 }}>{r.menus}</div>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.06em' }}>menus · {r.cities} cities</div>
            </div>
          </div>
        ))}
      </div>
    </>
  );
}

// ═══ 07 · RESTAURANTS ══════════════════════════════════
function RestaurantsScreen() {
  const rows = [
    { id: 'r_0102', name: 'Wood & Fire', city: 'Porto', country: 'PT', menus: 3, dishes: 128, lastParse: 'today', visible: true, claimed: false },
    { id: 'r_0087', name: 'Tasca do Zé', city: 'Lisboa', country: 'PT', menus: 2, dishes: 54, lastParse: 'yesterday', visible: true, claimed: true },
    { id: 'r_0094', name: 'Londrina', city: 'João Pascoal', country: 'PT', menus: 1, dishes: 38, lastParse: '3d ago', visible: true, claimed: false },
    { id: 'r_0121', name: 'Petiscos 14', city: 'Porto', country: 'PT', menus: 1, dishes: 22, lastParse: '6d ago', visible: false, claimed: false },
    { id: 'r_0144', name: 'Sakurazaka', city: 'Tokyo', country: 'JP', menus: 2, dishes: 142, lastParse: '2d ago', visible: true, claimed: true },
    { id: 'r_0168', name: 'Osteria 14', city: 'Roma', country: 'IT', menus: 1, dishes: 41, lastParse: '1d ago', visible: true, claimed: false },
  ];

  return (
    <>
      <PageHeader
        eyebrow="Catalog · 1 842 restaurants"
        title="Restaurants"
        sub="Все заведения, меню которых когда-либо было распарсено. Claim = ресторан привязал свой B2B-аккаунт (partners.menuassistant.app)."
        actions={<>
          <Btn icon="⤓">Export</Btn>
          <Btn kind="primary" icon="+">Add restaurant</Btn>
        </>}
      />

      <div style={{ padding: '16px 32px 0', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', border: '1px solid var(--line)', borderRadius: 8, flex: '0 0 320px', background: 'var(--surface)' }}>
          <span style={{ color: 'var(--muted)', fontFamily: 'var(--mono)', fontSize: 12 }}>⌕</span>
          <input placeholder="Search restaurant, id…" style={{ border: 0, outline: 'none', flex: 1, background: 'transparent', fontSize: 13 }} />
        </div>
        <Btn icon="⚑">Country: any</Btn>
        <Btn icon="⚑">Claimed only</Btn>
        <Btn icon="⚑">Hidden only</Btn>
      </div>

      <div style={{ padding: '24px 32px 32px' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
          <thead>
            <tr style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', textAlign: 'left' }}>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Restaurant</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Location</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)', textAlign: 'right' }}>Menus</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)', textAlign: 'right' }}>Dishes</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Last parse</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Claim</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Visibility</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}></th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r,i) => (
              <tr key={i} style={{ borderBottom: '1px solid var(--line)' }}>
                <td style={{ padding: '14px 12px', display: 'flex', alignItems: 'center', gap: 12 }}>
                  <div style={{ width: 36, height: 36 }}><PhotoSlot aspect="1/1" label="" radius={7} /></div>
                  <div>
                    <div style={{ fontFamily: 'var(--serif)', fontSize: 15, fontWeight: 500 }}>{r.name}</div>
                    <div style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)' }}>{r.id}</div>
                  </div>
                </td>
                <td style={{ padding: '14px 12px' }}>
                  <div>{r.city}</div>
                  <div style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)' }}>{r.country}</div>
                </td>
                <td style={{ padding: '14px 12px', textAlign: 'right', fontFamily: 'var(--mono)' }}>{r.menus}</td>
                <td style={{ padding: '14px 12px', textAlign: 'right', fontFamily: 'var(--mono)' }}>{r.dishes}</td>
                <td style={{ padding: '14px 12px', fontFamily: 'var(--mono)', color: 'var(--muted)', fontSize: 11 }}>{r.lastParse}</td>
                <td style={{ padding: '14px 12px' }}>{r.claimed ? <Pill tone="accent">claimed</Pill> : <Pill tone="neutral">—</Pill>}</td>
                <td style={{ padding: '14px 12px' }}>
                  <label style={{ display: 'inline-flex', alignItems: 'center', gap: 8, cursor: 'pointer' }}>
                    <div style={{ width: 30, height: 18, background: r.visible ? 'var(--ok)' : 'var(--surface-2)', borderRadius: 999, position: 'relative', transition: 'background 0.2s' }}>
                      <div style={{ position: 'absolute', top: 2, left: r.visible ? 14 : 2, width: 14, height: 14, background: '#fff', borderRadius: '50%', transition: 'left 0.2s', boxShadow: '0 1px 3px rgba(0,0,0,0.2)' }} />
                    </div>
                    <span style={{ fontSize: 11, color: 'var(--muted)', fontFamily: 'var(--mono)' }}>{r.visible ? 'public' : 'hidden'}</span>
                  </label>
                </td>
                <td style={{ padding: '14px 12px', textAlign: 'right' }}>
                  <button style={{ border: 0, background: 'transparent', color: 'var(--muted)', cursor: 'pointer', fontFamily: 'var(--mono)', fontSize: 16 }}>⋯</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}

// ═══ 08 · USERS ════════════════════════════════════════
function UsersScreen() {
  const rows = [
    { id: 'u_04182', name: 'Иван Петров', email: 'ivan.p@gmail.com', city: 'Porto', menus: 14, dishes: 42, likes: 28, joined: '18 Mar 2026', role: 'user', last: '2m ago' },
    { id: 'u_04170', name: 'Maria Silva', email: 'maria.s@outlook.com', city: 'Lisboa', menus: 9, dishes: 31, likes: 44, joined: '12 Mar 2026', role: 'user', last: '1h ago' },
    { id: 'u_04152', name: 'Elena Kuznetsova', email: 'elena.k@menuassistant.app', city: 'Berlin', menus: 2, dishes: 8, likes: 3, joined: '05 Mar 2026', role: 'moderator', last: '2m ago' },
    { id: 'u_04140', name: 'Pedro Marques', email: 'pedro.m@menuassistant.app', city: 'Lisboa', menus: 1, dishes: 4, likes: 1, joined: '02 Mar 2026', role: 'moderator', last: '18m ago' },
    { id: 'u_04098', name: 'Kenji W.', email: 'kenji.w@tutanota.com', city: 'Tokyo', menus: 6, dishes: 19, likes: 12, joined: '22 Feb 2026', role: 'user', last: '4h ago' },
    { id: 'u_04001', name: 'Dmitry G.', email: 'dmitry@menuassistant.app', city: 'Almaty', menus: 0, dishes: 0, likes: 0, joined: '14 Jan 2026', role: 'admin', last: 'yesterday' },
  ];

  const roleTone = { admin: 'bad', moderator: 'accent', user: 'neutral' };

  return (
    <>
      <PageHeader
        eyebrow="Access · 12 814 users"
        title="Users"
        sub="Пользователи приложения MenuAssistant. Роли: user (клиент B2C), moderator (доступ к этой админке), admin (полный доступ)."
        actions={<>
          <Btn icon="⤓">Export</Btn>
          <Btn kind="primary" icon="+">Invite moderator</Btn>
        </>}
        kpis={[
          { l: 'Total users', v: '12 814', d: '+412' },
          { l: 'Moderators', v: '8' },
          { l: 'Admins', v: '3' },
          { l: 'Active (7d)', v: '3 408', d: '+218' },
        ]}
      />

      <div style={{ padding: '16px 32px 0', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', border: '1px solid var(--line)', borderRadius: 8, flex: '0 0 320px', background: 'var(--surface)' }}>
          <span style={{ color: 'var(--muted)', fontFamily: 'var(--mono)', fontSize: 12 }}>⌕</span>
          <input placeholder="Name, email, id…" style={{ border: 0, outline: 'none', flex: 1, background: 'transparent', fontSize: 13 }} />
        </div>
        <Btn icon="⚑">Role: any</Btn>
        <Btn icon="⚑">City: any</Btn>
        <Btn icon="⚑">Active (7d)</Btn>
      </div>

      <div style={{ padding: '24px 32px 32px' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
          <thead>
            <tr style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', textAlign: 'left' }}>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>User</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>City</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Role</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)', textAlign: 'right' }}>Menus</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)', textAlign: 'right' }}>Dishes</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)', textAlign: 'right' }}>Likes</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Joined</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Last active</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}></th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r,i) => (
              <tr key={i} style={{ borderBottom: '1px solid var(--line)' }}>
                <td style={{ padding: '14px 12px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                    <div style={{ width: 32, height: 32, borderRadius: 8, background: 'var(--accent-soft)', color: 'var(--accent-ink)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--serif)', fontStyle: 'italic', fontWeight: 600, fontSize: 13 }}>{r.name[0]}</div>
                    <div>
                      <div style={{ fontWeight: 500 }}>{r.name}</div>
                      <div style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)' }}>{r.email} · {r.id}</div>
                    </div>
                  </div>
                </td>
                <td style={{ padding: '14px 12px', color: 'var(--ink-2)' }}>{r.city}</td>
                <td style={{ padding: '14px 12px' }}><Pill tone={roleTone[r.role]}>{r.role}</Pill></td>
                <td style={{ padding: '14px 12px', textAlign: 'right', fontFamily: 'var(--mono)' }}>{r.menus}</td>
                <td style={{ padding: '14px 12px', textAlign: 'right', fontFamily: 'var(--mono)' }}>{r.dishes}</td>
                <td style={{ padding: '14px 12px', textAlign: 'right', fontFamily: 'var(--mono)' }}>{r.likes}</td>
                <td style={{ padding: '14px 12px', fontFamily: 'var(--mono)', color: 'var(--muted)', fontSize: 11 }}>{r.joined}</td>
                <td style={{ padding: '14px 12px', fontFamily: 'var(--mono)', color: 'var(--muted)', fontSize: 11 }}>{r.last}</td>
                <td style={{ padding: '14px 12px', textAlign: 'right' }}>
                  <button style={{ border: 0, background: 'transparent', color: 'var(--muted)', cursor: 'pointer', fontSize: 16 }}>⋯</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}

// ═══ 09 · AUDIT LOG ════════════════════════════════════
function LogsScreen() {
  const rows = [
    { t: '14:32:18', u: 'Elena K.', act: 'approved', obj: 'menu', id: 'mn_4181', diff: '52 dishes published · 3 translations edited', ip: '93.158.10.4' },
    { t: '14:29:02', u: 'Elena K.', act: 'edited', obj: 'translation', id: 'd_0124', diff: '"Bacalhau à Brás" RU: Треска "а Бражски" → Треска «а Браш»', ip: '93.158.10.4' },
    { t: '14:24:55', u: 'Elena K.', act: 'rejected_photo', obj: 'dish', id: 'd_0124', diff: 'AI photo rejected, replaced with manual upload img_8821.jpg', ip: '93.158.10.4' },
    { t: '14:11:47', u: 'Pedro M.', act: 'merged', obj: 'dish', id: 'dish_pt_0102', diff: 'Merged 2 duplicates: dish_pt_0102_alt1, dish_pt_0102_alt2 → dish_pt_0102', ip: '85.241.67.22' },
    { t: '13:58:02', u: 'Pedro M.', act: 'approved', obj: 'menu', id: 'mn_4180', diff: '24 dishes published', ip: '85.241.67.22' },
    { t: '13:42:11', u: 'Anya V.', act: 'role_changed', obj: 'user', id: 'u_04140', diff: 'Pedro Marques: user → moderator', ip: '192.0.78.15' },
    { t: '13:33:44', u: 'Dmitry G.', act: 'deleted', obj: 'restaurant', id: 'r_0098', diff: 'Duplicate — "Tasca Zé" merged into "Tasca do Zé" (r_0087)', ip: '109.252.52.8' },
    { t: '13:02:20', u: 'Elena K.', act: 'flagged', obj: 'menu', id: 'mn_4179', diff: 'Flagged for supervisor: handwritten Japanese menu, accuracy 72%', ip: '93.158.10.4' },
  ];
  const actTone = { approved: 'ok', edited: 'info', rejected_photo: 'warn', merged: 'accent', role_changed: 'info', deleted: 'bad', flagged: 'warn' };

  return (
    <>
      <PageHeader
        eyebrow="Access · Audit"
        title="Audit log"
        sub="Все значимые действия модераторов и администраторов. Хранится 24 месяца. Неизменяемо."
        actions={<>
          <Btn icon="⤓">Export</Btn>
          <Btn icon="⚑">Filter</Btn>
        </>}
      />

      <div style={{ padding: '0 32px 32px', marginTop: 20 }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 13 }}>
          <thead>
            <tr style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em', textAlign: 'left' }}>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Time</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Actor</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Action</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Target</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>Diff</th>
              <th style={{ padding: '14px 12px', borderBottom: '1px solid var(--line)' }}>IP</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r,i) => (
              <tr key={i} style={{ borderBottom: '1px solid var(--line)' }}>
                <td style={{ padding: '14px 12px', fontFamily: 'var(--mono)', fontSize: 12, color: 'var(--muted)', whiteSpace: 'nowrap' }}>
                  <div>2026-04-21</div>
                  <div style={{ color: 'var(--ink-2)' }}>{r.t}</div>
                </td>
                <td style={{ padding: '14px 12px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div style={{ width: 24, height: 24, borderRadius: 6, background: 'var(--accent-soft)', color: 'var(--accent-ink)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--serif)', fontWeight: 600, fontSize: 11 }}>{r.u[0]}</div>
                    <span>{r.u}</span>
                  </div>
                </td>
                <td style={{ padding: '14px 12px' }}><Pill tone={actTone[r.act]}>{r.act.replace('_', ' ')}</Pill></td>
                <td style={{ padding: '14px 12px', fontFamily: 'var(--mono)', fontSize: 12 }}>
                  <span style={{ color: 'var(--muted)' }}>{r.obj}·</span><span>{r.id}</span>
                </td>
                <td style={{ padding: '14px 12px', color: 'var(--ink-2)', fontSize: 12, maxWidth: 520 }}>{r.diff}</td>
                <td style={{ padding: '14px 12px', fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)' }}>{r.ip}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}

// ═══ APP SHELL ═════════════════════════════════════════
function AdminApp() {
  const [active, setActive] = useState(() => localStorage.getItem('admin_active') || 'queue');
  useEffect(() => { localStorage.setItem('admin_active', active); }, [active]);

  const [dishDrawer, setDishDrawer] = useState(null);

  const openDish = (d) => setDishDrawer(d);
  const closeDish = () => setDishDrawer(null);

  const SCREENS = {
    dashboard: <DashboardScreen />,
    queue: <QueueScreen onOpen={() => setActive('validate')} />,
    validate: <ValidateScreen onBack={() => setActive('queue')} />,
    dishreview: <DishReviewScreen onOpenDish={openDish} />,
    photos: <PhotosScreen onOpenDish={openDish} />,
    translations: <TranslationsScreen onOpenDish={openDish} />,
    library: <LibraryScreen onOpenDish={openDish} />,
    restaurants: <RestaurantsScreen />,
    users: <UsersScreen />,
    logs: <LogsScreen />,
  };

  return (
    <div style={{ display: 'flex', minHeight: '100vh', background: 'var(--bg)' }}>
      <SideNav active={active} onPick={setActive} />
      <main style={{ flex: 1, minWidth: 0 }}>
        {SCREENS[active]}
      </main>
      {dishDrawer && <DishDrawer dish={dishDrawer} onClose={closeDish} />}
    </div>
  );
}

// mount
function __mount() {
  const el = document.getElementById('admin-root');
  if (!el || el.__mounted) return;
  el.__mounted = true;
  ReactDOM.createRoot(el).render(<AdminApp />);
}
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', __mount);
} else {
  __mount();
}
