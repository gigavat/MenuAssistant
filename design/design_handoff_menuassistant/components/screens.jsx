// MenuAssistant — mobile screen mockups
const { useState, useEffect } = React;

// ─── shared palette mirrors the CSS ───
const getCSSVar = (v) => getComputedStyle(document.documentElement).getPropertyValue(v).trim();

// striped photo placeholder matching the landing
function PhotoSlot({ h = 120, label = 'food photo', radius = 12, dark = false }) {
  const bg = dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)';
  const stripe = dark ? 'rgba(255,255,255,0.09)' : 'color-mix(in srgb, var(--ink) 5%, var(--surface-2))';
  return (
    <div style={{
      height: h, borderRadius: radius, width: '100%',
      backgroundImage: `repeating-linear-gradient(135deg, ${stripe} 0 10px, ${bg} 10px 20px)`,
      display: 'flex', alignItems: 'end', justifyContent: 'start',
      padding: 8,
      color: 'var(--muted)', fontFamily: 'var(--mono)', fontSize: 10,
      textTransform: 'uppercase', letterSpacing: '0.08em'
    }}>{label}</div>);

}

// ─── phone shell (simpler than starter, styled in our brand) ───
function Phone({ children, variant, label, title, status = 'dark' }) {
  const darkMode = variant === 'dark';
  const bgs = {
    warm: 'var(--surface)',
    editorial: '#FDFAF3',
    dark: '#0F0E0C'
  };
  const bg = bgs[variant] || 'var(--surface)';
  const ink = darkMode ? '#F5EFE6' : 'var(--ink)';

  return (
    <div style={{ width: 320, display: 'flex', flexDirection: 'column', gap: 14 }}>
      <div style={{
        width: 320, height: 660, borderRadius: 44, position: 'relative',
        background: bg, overflow: 'hidden',
        boxShadow: '0 40px 60px -20px rgba(26,23,19,0.3), 0 0 0 8px #1A1713, 0 0 0 9px #2E2A24',
        color: ink
      }}>
        {/* notch */}
        <div style={{
          position: 'absolute', top: 8, left: '50%', transform: 'translateX(-50%)',
          width: 100, height: 28, borderRadius: 20, background: '#1A1713', zIndex: 50
        }} />
        {/* status bar */}
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, zIndex: 20,
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
          padding: '14px 28px 0',
          fontFamily: 'system-ui, -apple-system', fontWeight: 600, fontSize: 13,
          color: darkMode ? '#fff' : '#000'
        }}>
          <span>9:41</span>
          <span style={{ display: 'flex', gap: 5, alignItems: 'center' }}>
            <svg width="16" height="11" viewBox="0 0 16 11"><path d="M1 9h2v2H1zM5 7h2v4H5zM9 5h2v6H9zM13 3h2v8h-2z" fill="currentColor" /></svg>
            <svg width="22" height="11" viewBox="0 0 22 11"><rect x="0.5" y="0.5" width="18" height="10" rx="2.5" fill="none" stroke="currentColor" opacity="0.4" /><rect x="2" y="2" width="15" height="7" rx="1" fill="currentColor" /></svg>
          </span>
        </div>
        {/* content */}
        <div style={{ paddingTop: 48, height: '100%', overflow: 'hidden', position: 'relative' }}>
          {children}
        </div>
        {/* home indicator */}
        <div style={{
          position: 'absolute', bottom: 8, left: '50%', transform: 'translateX(-50%)',
          width: 120, height: 4, borderRadius: 2, background: darkMode ? 'rgba(255,255,255,0.4)' : 'rgba(0,0,0,0.25)',
          zIndex: 50
        }} />
      </div>
      {label &&
      <div className="screen-caption">
          <div className="tag">{label.tag}</div>
          <div className="title" style={{ fontFamily: 'var(--serif)' }}>{label.title}</div>
          <div className="desc">{label.desc}</div>
        </div>
      }
    </div>);

}

// ─── app-wide top bar used in several screens ───
function AppBar({ title, sub, onBack, right, dark }) {
  return (
    <div style={{ padding: '8px 20px 14px', display: 'flex', flexDirection: 'column', gap: 10 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', height: 32 }}>
        {onBack &&
        <div style={{
          width: 32, height: 32, borderRadius: 10,
          background: dark ? 'rgba(255,255,255,0.08)' : 'var(--surface-2)',
          display: 'flex', alignItems: 'center', justifyContent: 'center'
        }}>
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L3 7l6 5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" /></svg>
          </div>
        }
        {right}
      </div>
      {title &&
      <div>
          {sub && <div style={{ fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', letterSpacing: '0.1em', color: 'var(--muted)' }}>{sub}</div>}
          <h1 style={{
          fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 30,
          letterSpacing: '-0.02em', margin: '2px 0 0', lineHeight: 1.02
        }}>{title}</h1>
        </div>
      }
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 1 — Onboarding
// ═══════════════════════════════════════════════════════
function OnboardingScreen({ variant, t }) {
  const dark = variant === 'dark';
  return (
    <div style={{ height: '100%', padding: '8px 24px 28px', display: 'flex', flexDirection: 'column' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)' }}>
        <span>01 / 03</span>
        <span>{t('skip', 'Пропустить', 'Skip')}</span>
      </div>

      {/* visual */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', position: 'relative', margin: '20px 0' }}>
        <div style={{ position: 'relative', width: 230, height: 290 }}>
          {/* paper menu */}
          <div style={{
            position: 'absolute', inset: 0, background: dark ? '#FBF8F3' : 'var(--bg)',
            borderRadius: 6, padding: 20,
            fontFamily: 'var(--serif)', color: '#1A1713',
            boxShadow: '0 20px 40px -10px rgba(0,0,0,0.3), 0 0 0 1px rgba(0,0,0,0.06)',
            transform: 'rotate(-4deg)'
          }}>
            <div style={{ fontSize: 12, fontStyle: 'italic', fontWeight: 600, textAlign: 'center', borderBottom: '1px solid #999', paddingBottom: 6 }}>Tasca do Zé</div>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 8, marginTop: 10, lineHeight: 1.7 }}>
              <div>Bacalhau à Brás · 18€</div>
              <div>Polvo à Lagareiro · 22€</div>
              <div>Arroz de Marisco · 26€</div>
              <div>Francesinha · 14€</div>
              <div>Pastel de Nata · 3€</div>
              <div style={{ color: '#888', marginTop: 6 }}>Entradas</div>
              <div>Peixinhos da Horta · 8€</div>
              <div>Chouriço Assado · 9€</div>
            </div>
          </div>
          {/* phone capturing */}
          <div style={{
            position: 'absolute', right: -30, bottom: -10,
            width: 110, height: 180, borderRadius: 18,
            background: 'var(--accent)',
            boxShadow: '0 14px 30px -8px rgba(196,78,42,0.5)',
            padding: 10,
            transform: 'rotate(6deg)'
          }}>
            <div style={{ width: '100%', height: '100%', borderRadius: 10, background: 'rgba(255,255,255,0.15)', border: '2px dashed rgba(255,255,255,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="28" height="22" viewBox="0 0 28 22" fill="none"><rect x="1" y="5" width="26" height="16" rx="3" stroke="#fff" strokeWidth="1.5" /><circle cx="14" cy="13" r="5" stroke="#fff" strokeWidth="1.5" /><rect x="10" y="1" width="8" height="4" rx="1" stroke="#fff" strokeWidth="1.5" /></svg>
            </div>
          </div>
        </div>
      </div>

      <div style={{ marginBottom: 24 }}>
        <h2 style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 30, letterSpacing: '-0.02em', lineHeight: 1.05, margin: 0, color: dark ? '#F5EFE6' : 'var(--ink)' }}>
          {t('ob1h', <>Любое меню — <em style={{ color: 'var(--accent)' }}>по-вашему.</em></>, <>Any menu — <em style={{ color: 'var(--accent)' }}>your way.</em></>)}
        </h2>
        <p style={{ color: 'var(--ink-2)', fontSize: 13, lineHeight: 1.5, marginTop: 10 }}>
          {t('ob1p', 'Сфотографируйте меню в кафе — получите красивый каталог с фото, переводом и ингредиентами.', 'Snap a menu — get a beautiful catalogue with photos, translation and ingredients.')}
        </p>
      </div>

      <div style={{ display: 'flex', gap: 6, justifyContent: 'center', marginBottom: 16 }}>
        <div style={{ width: 20, height: 4, borderRadius: 2, background: 'var(--accent)' }} />
        <div style={{ width: 4, height: 4, borderRadius: 2, background: 'var(--line)' }} />
        <div style={{ width: 4, height: 4, borderRadius: 2, background: 'var(--line)' }} />
      </div>

      <button style={{
        background: 'var(--ink)', color: 'var(--bg)', padding: '14px', border: 0,
        borderRadius: 14, fontWeight: 500, fontFamily: 'var(--sans)', fontSize: 15, cursor: 'pointer'
      }}>{t('continue', 'Далее', 'Continue')}</button>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 2 — Auth
// ═══════════════════════════════════════════════════════
function AuthScreen({ variant, t }) {
  const dark = variant === 'dark';
  return (
    <div style={{ height: '100%', padding: '8px 24px 28px', display: 'flex', flexDirection: 'column' }}>
      <div style={{ marginTop: 16 }}>
        <div style={{ fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', letterSpacing: '0.1em', color: 'var(--muted)' }}>
          {t('welcome', 'Добро пожаловать', 'Welcome')}
        </div>
        <h1 style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 34, letterSpacing: '-0.025em', margin: '6px 0 0', lineHeight: 1 }}>
          {t('auth_h', <>Откройте меню <em style={{ color: 'var(--accent)' }}>мира.</em></>, <>Unlock the menus <em style={{ color: 'var(--accent)' }}>of the world.</em></>)}
        </h1>
        <p style={{ color: 'var(--ink-2)', fontSize: 13, lineHeight: 1.5, marginTop: 12 }}>
          {t('auth_p', 'Войдите, чтобы сохранять места, блюда и историю.', 'Sign in to save places, dishes and history.')}
        </p>
      </div>

      <div style={{ marginTop: 28, display: 'flex', flexDirection: 'column', gap: 10 }}>
        <div style={{ border: '1px solid var(--line)', borderRadius: 14, padding: '14px 16px', display: 'flex', gap: 10, alignItems: 'center', background: dark ? 'rgba(255,255,255,0.03)' : 'var(--surface)' }}>
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="1" y="3" width="14" height="10" rx="2" stroke="var(--muted)" strokeWidth="1.5" /><path d="M1.5 4L8 9l6.5-5" stroke="var(--muted)" strokeWidth="1.5" /></svg>
          <span style={{ color: 'var(--muted)', fontSize: 14 }}>email@example.com</span>
        </div>
        <div style={{ border: '1px solid var(--line)', borderRadius: 14, padding: '14px 16px', display: 'flex', gap: 10, alignItems: 'center', background: dark ? 'rgba(255,255,255,0.03)' : 'var(--surface)' }}>
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="var(--muted)" strokeWidth="1.5" /><path d="M5 7V5a3 3 0 016 0v2" stroke="var(--muted)" strokeWidth="1.5" /></svg>
          <span style={{ color: 'var(--muted)', fontSize: 14 }}>••••••••</span>
        </div>

        <button style={{ background: 'var(--accent)', color: '#fff', padding: '14px', border: 0, borderRadius: 14, fontWeight: 500, fontFamily: 'var(--sans)', fontSize: 15, cursor: 'pointer', marginTop: 4 }}>
          {t('auth_btn', 'Войти или создать', 'Sign in or create')}
        </button>
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: 10, margin: '20px 0' }}>
        <div style={{ flex: 1, height: 1, background: 'var(--line)' }} />
        <span style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.1em' }}>{t('or', 'или', 'or')}</span>
        <div style={{ flex: 1, height: 1, background: 'var(--line)' }} />
      </div>

      <button style={{ background: dark ? 'rgba(255,255,255,0.05)' : 'var(--surface)', color: 'inherit', border: '1px solid var(--line)', padding: '14px', borderRadius: 14, fontSize: 14, fontFamily: 'var(--sans)', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10, cursor: 'pointer' }}>
          <svg width="16" height="16" viewBox="0 0 18 18"><path fill="#4285F4" d="M17.6 9.2l-.1-1.1H9v2.1h4.8a4.1 4.1 0 01-1.8 2.7v2.2h2.9c1.7-1.6 2.7-3.9 2.7-6z" /><path fill="#34A853" d="M9 18c2.4 0 4.5-.8 6-2.2l-2.9-2.2c-.8.6-1.9.9-3.1.9-2.4 0-4.4-1.6-5.1-3.8H.9v2.3A9 9 0 009 18z" /><path fill="#FBBC05" d="M3.9 10.7a5.4 5.4 0 010-3.4V5H.9a9 9 0 000 8l3-2.3z" /><path fill="#EA4335" d="M9 3.6c1.3 0 2.5.5 3.4 1.3L15 2.3A9 9 0 00.9 5l3 2.3C4.6 5.1 6.6 3.6 9 3.6z" /></svg>
          {t('google', 'Продолжить с Google', 'Continue with Google')}
      </button>

      <div style={{ marginTop: 'auto', paddingTop: 20, fontSize: 11, color: 'var(--muted)', textAlign: 'center', lineHeight: 1.6 }}>
        {t('tos', 'Продолжая, вы принимаете условия и политику конфиденциальности', 'By continuing you accept our terms & privacy policy')}
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 3 — Home (Restaurants list)
// ═══════════════════════════════════════════════════════
function HomeScreen({ variant, t }) {
  const dark = variant === 'dark';
  const rests = [
  { name: 'Wood & Fire', loc: 'Porto', tag: t('tag_grill', 'Гриль · Стейкхаус', 'Grill · Steakhouse'), liked: true, visited: t('visited_today', 'сегодня', 'today') },
  { name: 'Londrina', loc: 'João Pascoal', tag: t('tag_wine', 'Винный бар', 'Wine bar'), liked: false, visited: t('visited_yday', 'вчера', 'yesterday') },
  { name: 'A Tasca do Zé', loc: 'Lisboa', tag: t('tag_trad', 'Трад. португальская', 'Portuguese trad.'), liked: true, visited: 'Пт · 18 апр' },
  { name: 'Petiscos 14', loc: 'Porto', tag: 'Tapas · Small plates', liked: false, visited: '15 Апр' }];


  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      {/* Top pills bar */}
      <div style={{ padding: '8px 20px 14px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{
          flex: 1, height: 44, borderRadius: 14,
          background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)',
          display: 'flex', alignItems: 'center', padding: '0 14px', gap: 10
        }}>
          <svg width="14" height="14" viewBox="0 0 16 16" fill="none"><circle cx="7" cy="7" r="5" stroke="var(--muted)" strokeWidth="1.6" /><path d="M11 11l4 4" stroke="var(--muted)" strokeWidth="1.6" strokeLinecap="round" /></svg>
          <span style={{ color: 'var(--muted)', fontSize: 14 }}>{t('search_home', 'Места, блюда, рестораны…', 'Places, dishes, cuisines…')}</span>
        </div>
        <div style={{ width: 44, height: 44, borderRadius: 14, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <div style={{ width: 22, height: 22, borderRadius: '50%', background: 'var(--accent-soft)', color: 'var(--accent-ink)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 11, fontWeight: 600, fontFamily: 'var(--serif)' }}>И</div>
        </div>
      </div>

      {/* Greeting */}
      <div style={{ padding: '4px 20px 16px' }}>
        <div style={{ fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', color: 'var(--muted)', letterSpacing: '0.1em' }}>
          {t('greeting', 'Привет, Иван', 'Hi, Ivan')}
        </div>
        <h1 style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 28, letterSpacing: '-0.02em', margin: '4px 0 0', lineHeight: 1.05 }}>
          {t('home_h', <>Куда сегодня? <em style={{ color: 'var(--accent)' }}>Ваши меню.</em></>, <>Where today? <em style={{ color: 'var(--accent)' }}>Your menus.</em></>)}
        </h1>
      </div>

      {/* Filter chips */}
      <div style={{ padding: '0 20px 14px', display: 'flex', gap: 8, overflowX: 'auto' }}>
        {[
        { t: t('chip_recent', 'Недавние', 'Recent'), on: true },
        { t: t('chip_liked', 'Любимые', 'Liked') },
        { t: 'Porto' },
        { t: 'Lisboa' },
        { t: t('chip_gf', 'Без глютена', 'Gluten-free') }].
        map((c, i) =>
        <span key={i} style={{
          padding: '6px 12px', borderRadius: 999, fontSize: 12, whiteSpace: 'nowrap',
          background: c.on ? 'var(--ink)' : dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)',
          color: c.on ? 'var(--bg)' : 'inherit'
        }}>{c.t}</span>
        )}
      </div>

      {/* List */}
      <div style={{ flex: 1, overflow: 'hidden', padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {rests.map((r, i) =>
        <div key={i} style={{
          display: 'flex', gap: 12, padding: 10, borderRadius: 16,
          background: dark ? 'rgba(255,255,255,0.03)' : 'var(--surface)',
          border: '1px solid var(--line)'
        }}>
            <div style={{ width: 64, height: 64, flexShrink: 0 }}>
              <PhotoSlot h={64} radius={12} label={r.name.split(' ')[0].toLowerCase()} dark={dark} />
            </div>
            <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'space-between', minWidth: 0 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8 }}>
                <div style={{ minWidth: 0 }}>
                  <div style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 16, letterSpacing: '-0.01em', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{r.name}</div>
                  <div style={{ fontSize: 11, color: 'var(--muted)', marginTop: 2 }}>{r.tag}</div>
                </div>
                <svg width="16" height="16" viewBox="0 0 24 24" style={{ flexShrink: 0 }}>
                  <path d="M12 21s-7-4.5-7-10a4 4 0 017-2.6A4 4 0 0119 11c0 5.5-7 10-7 10z"
                fill={r.liked ? 'var(--accent)' : 'none'}
                stroke={r.liked ? 'var(--accent)' : 'var(--muted)'} strokeWidth="1.6" />
                </svg>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: 11, color: 'var(--muted)', fontFamily: 'var(--mono)' }}>
                <span>📍 {r.loc}</span>
                <span>{r.visited}</span>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* FAB */}
      <div style={{ position: 'absolute', right: 20, bottom: 24 }}>
        <div style={{
          width: 60, height: 60, borderRadius: 20, background: 'var(--accent)',
          boxShadow: '0 10px 30px -5px rgba(196,78,42,0.5)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff'
        }}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none"><rect x="2" y="6" width="20" height="14" rx="3" stroke="currentColor" strokeWidth="1.8" /><circle cx="12" cy="13" r="4" stroke="currentColor" strokeWidth="1.8" /><rect x="8" y="2" width="8" height="4" rx="1" stroke="currentColor" strokeWidth="1.8" /></svg>
        </div>
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 4 — Restaurant with categories
// ═══════════════════════════════════════════════════════
function RestaurantScreen({ variant, t }) {
  const dark = variant === 'dark';
  const cats = [
  { n: t('cat_starter', 'Закуски', 'Starters'), c: 8 },
  { n: t('cat_carpaccio', 'Карпаччо & тартар', 'Carpaccio & tartare'), c: 4 },
  { n: t('cat_salad', 'Салаты', 'Salads'), c: 6 },
  { n: t('cat_brusc', 'Брускетты', 'Bruschetta'), c: 5 },
  { n: t('cat_main', 'Основные блюда', 'Mains'), c: 12 },
  { n: t('cat_dessert', 'Десерты', 'Desserts'), c: 7 }];

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      {/* hero image + overlay */}
      <div style={{ height: 180, position: 'relative' }}>
        <PhotoSlot h={180} radius={0} label="restaurant · hero" dark={dark} />
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, rgba(0,0,0,0.4) 0%, rgba(0,0,0,0) 40%, rgba(0,0,0,0.5) 100%)' }} />
        <div style={{ position: 'absolute', top: 12, left: 20, right: 20, display: 'flex', justifyContent: 'space-between' }}>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(8px)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff' }}>
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L3 7l6 5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" /></svg>
          </div>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(8px)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff' }}>
            <svg width="14" height="14" viewBox="0 0 24 24"><path d="M12 21s-7-4.5-7-10a4 4 0 017-2.6A4 4 0 0119 11c0 5.5-7 10-7 10z" fill="var(--accent)" stroke="var(--accent)" strokeWidth="1.6" /></svg>
          </div>
        </div>
        <div style={{ position: 'absolute', bottom: 14, left: 20, right: 20, color: '#fff' }}>
          <div style={{ fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', letterSpacing: '0.1em', opacity: 0.8 }}>Porto · Гриль</div>
          <div style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 28, letterSpacing: '-0.02em' }}>Wood & Fire</div>
        </div>
      </div>

      {/* search in menu */}
      <div style={{ padding: '14px 20px 10px' }}>
        <div style={{
          height: 40, borderRadius: 12, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)',
          display: 'flex', alignItems: 'center', padding: '0 14px', gap: 10
        }}>
          <svg width="13" height="13" viewBox="0 0 16 16" fill="none"><circle cx="7" cy="7" r="5" stroke="var(--muted)" strokeWidth="1.6" /><path d="M11 11l4 4" stroke="var(--muted)" strokeWidth="1.6" strokeLinecap="round" /></svg>
          <span style={{ color: 'var(--muted)', fontSize: 13 }}>{t('search_dish', '«что-то с треской, до 25€»', '"something with cod, under 25€"')}</span>
        </div>
      </div>

      {/* filters */}
      <div style={{ padding: '0 20px 12px', display: 'flex', gap: 6, flexWrap: 'wrap' }}>
        <span style={{ padding: '5px 10px', borderRadius: 999, fontSize: 11, background: 'var(--accent)', color: '#fff', fontFamily: 'var(--mono)' }}>RU ↔ PT</span>
        <span style={{ padding: '5px 10px', borderRadius: 999, fontSize: 11, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)', fontFamily: 'var(--mono)' }}>€</span>
        <span style={{ padding: '5px 10px', borderRadius: 999, fontSize: 11, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)' }}>🌱</span>
        <span style={{ padding: '5px 10px', borderRadius: 999, fontSize: 11, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)' }}>gf</span>
      </div>

      {/* categories list */}
      <div style={{ flex: 1, overflow: 'hidden', padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {cats.map((c, i) =>
        <div key={i} style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
          padding: '12px 14px', borderRadius: 12,
          background: i === 0 ? dark ? 'rgba(255,255,255,0.04)' : 'var(--surface)' : 'transparent',
          border: i === 0 ? '1px solid var(--line)' : '1px solid transparent',
          borderBottom: i !== 0 ? '1px solid var(--line)' : undefined,
          borderRadius: i === 0 ? 12 : 0
        }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <span style={{ fontFamily: 'var(--mono)', fontSize: 10, color: 'var(--muted)', width: 16 }}>0{i + 1}</span>
              <span style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 17, letterSpacing: '-0.01em' }}>{c.n}</span>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <span style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)' }}>{c.c}</span>
              <svg width="10" height="10" viewBox="0 0 8 14" fill="none"><path d="M1 1l6 6-6 6" stroke="var(--muted)" strokeWidth="1.5" strokeLinecap="round" /></svg>
            </div>
          </div>
        )}
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 5 — Dish list in category
// ═══════════════════════════════════════════════════════
function DishListScreen({ variant, t }) {
  const dark = variant === 'dark';
  const dishes = [
  { n: t('d1', "Рости из говядины с альпийским соусом", "Beef rösti with alpine sauce"), p: 48, tags: ['beef', 'potato'], orig: 'Rösti di manzo' },
  { n: t('d2', 'Капрезе со спельты и печёной свёклой', 'Spelt caprese with baked beet'), p: 24, tags: ['veg'], orig: 'Caprese di farro' },
  { n: t('d3', 'Салат с томатами и миндалём', 'Tomato & almond salad'), p: 18, tags: ['vegan', 'gf'], orig: 'Insalata' },
  { n: t('d4', 'Хамон с форелью', 'Jamón with trout'), p: 32, tags: ['fish', 'cured'], orig: 'Jamón & trota' }];

  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <AppBar
        onBack
        sub="Wood & Fire · 01"
        title={t('cat_starter', 'Закуски', 'Starters')}
        dark={dark}
        right={
        <div style={{ display: 'flex', gap: 8 }}>
            <div style={{ width: 32, height: 32, borderRadius: 10, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="13" height="13" viewBox="0 0 14 14" fill="none"><rect x="1" y="1" width="5" height="5" rx="1" stroke="currentColor" strokeWidth="1.5" /><rect x="8" y="1" width="5" height="5" rx="1" stroke="currentColor" strokeWidth="1.5" /><rect x="1" y="8" width="5" height="5" rx="1" stroke="currentColor" strokeWidth="1.5" /><rect x="8" y="8" width="5" height="5" rx="1" stroke="currentColor" strokeWidth="1.5" /></svg>
            </div>
            <div style={{ width: 32, height: 32, borderRadius: 10, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="13" height="13" viewBox="0 0 14 14" fill="none"><path d="M2 3h10M4 7h6M6 11h2" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" /></svg>
            </div>
          </div>
        } />
      

      <div style={{ flex: 1, overflow: 'hidden', padding: '0 20px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, alignContent: 'start' }}>
        {dishes.map((d, i) =>
        <div key={i} style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <div style={{ position: 'relative' }}>
              <PhotoSlot h={120} radius={14} label={d.n.split(' ')[0].toLowerCase()} dark={dark} />
              <div style={{ position: 'absolute', top: 6, right: 6, width: 24, height: 24, borderRadius: 8, background: 'rgba(255,255,255,0.9)', backdropFilter: 'blur(6px)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <svg width="11" height="11" viewBox="0 0 24 24"><path d="M12 21s-7-4.5-7-10a4 4 0 017-2.6A4 4 0 0119 11c0 5.5-7 10-7 10z" fill={i === 0 ? 'var(--accent)' : 'none'} stroke={i === 0 ? 'var(--accent)' : '#888'} strokeWidth="2" /></svg>
              </div>
              {d.tags.includes('vegan') &&
            <div style={{ position: 'absolute', bottom: 6, left: 6, padding: '3px 7px', borderRadius: 6, background: 'rgba(63,122,59,0.9)', color: '#fff', fontSize: 9, fontFamily: 'var(--mono)' }}>🌱</div>
            }
            </div>
            <div>
              <div style={{ fontFamily: 'var(--mono)', fontSize: 9, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.06em' }}>{d.orig}</div>
              <div style={{ fontFamily: 'var(--serif)', fontSize: 14, fontWeight: 500, lineHeight: 1.2, marginTop: 2, letterSpacing: '-0.01em' }}>{d.n}</div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 6 }}>
                <span style={{ fontFamily: 'var(--mono)', fontSize: 12, fontWeight: 500 }}>€{d.p}.00</span>
                <div style={{ display: 'flex', gap: 3 }}>
                  {d.tags.slice(0, 2).map((tg, ti) =>
                <span key={ti} style={{ padding: '2px 5px', borderRadius: 4, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)', fontSize: 9, fontFamily: 'var(--mono)' }}>{tg}</span>
                )}
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 6 — Dish detail
// ═══════════════════════════════════════════════════════
function DishScreen({ variant, t }) {
  const dark = variant === 'dark';
  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <div style={{ height: 260, position: 'relative' }}>
        <PhotoSlot h={260} radius={0} label="dish · hero" dark={dark} />
        <div style={{ position: 'absolute', top: 12, left: 20, right: 20, display: 'flex', justifyContent: 'space-between' }}>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: 'rgba(0,0,0,0.5)', backdropFilter: 'blur(8px)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff' }}>
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L3 7l6 5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" /></svg>
          </div>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: 'rgba(0,0,0,0.5)', backdropFilter: 'blur(8px)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--accent)' }}>
            <svg width="14" height="14" viewBox="0 0 24 24"><path d="M12 21s-7-4.5-7-10a4 4 0 017-2.6A4 4 0 0119 11c0 5.5-7 10-7 10z" fill="currentColor" stroke="currentColor" strokeWidth="1.6" /></svg>
          </div>
        </div>
        <div style={{ position: 'absolute', bottom: 10, left: 14, display: 'flex', gap: 4 }}>
          {[0, 1, 2].map((i) => <div key={i} style={{ width: 32, height: 4, borderRadius: 2, background: i === 0 ? '#fff' : 'rgba(255,255,255,0.4)' }} />)}
        </div>
      </div>

      <div style={{ flex: 1, overflow: 'hidden', padding: '18px 20px 20px' }}>
        <div style={{ fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', letterSpacing: '0.1em', color: 'var(--muted)' }}>
          Rösti di manzo con salsa alpina
        </div>
        <h1 style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 24, letterSpacing: '-0.02em', margin: '4px 0 0', lineHeight: 1.1 }}>
          {t('dish_h', 'Рости из говядины с альпийским соусом', 'Beef rösti with alpine sauce')}
        </h1>

        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginTop: 14, paddingBottom: 14, borderBottom: '1px solid var(--line)' }}>
          <span style={{ fontFamily: 'var(--mono)', fontSize: 11, color: 'var(--muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{t('price', 'Цена', 'Price')}</span>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}>
            <span style={{ fontFamily: 'var(--serif)', fontSize: 28, fontWeight: 500 }}>48.00</span>
            <span style={{ fontFamily: 'var(--mono)', fontSize: 12, color: 'var(--muted)' }}>EUR</span>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginTop: 14 }}>
          {[
          { t: 'Beef', on: true }, { t: 'Potato', on: true }, { t: 'Spinach', on: true },
          { t: '🌾 gluten' }, { t: '🥛 lactose' }].
          map((t, i) =>
          <span key={i} style={{
            padding: '5px 10px', borderRadius: 8, fontSize: 11,
            background: t.on ? 'var(--accent-soft)' : dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)',
            color: t.on ? 'var(--accent-ink)' : 'inherit',
            fontFamily: 'var(--mono)'
          }}>{t.t}</span>
          )}
        </div>

        <div style={{ marginTop: 18 }}>
          <div style={{ fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', letterSpacing: '0.1em', color: 'var(--muted)' }}>{t('composition', 'Состав', 'Composition')}</div>
          <p style={{ fontSize: 13, lineHeight: 1.55, marginTop: 6, color: 'var(--ink-2)' }}>
            {t('dish_desc', 'Картофельные rösti с сочной говядиной, подаются с альпийским соусом на основе трав и свежим шпинатом. Готовятся на открытом огне.', 'Potato rösti with juicy beef, served with a herb-based alpine sauce and fresh spinach. Cooked over open fire.')}
          </p>
        </div>
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 7 — Add menu (bottom sheet)
// ═══════════════════════════════════════════════════════
function AddMenuScreen({ variant, t }) {
  const dark = variant === 'dark';
  // show a dimmed home underneath with bottom sheet
  return (
    <div style={{ height: '100%', position: 'relative', overflow: 'hidden' }}>
      <div style={{ filter: 'blur(3px)', opacity: 0.5 }}>
        <HomeScreen variant={variant} t={t} />
      </div>
      <div style={{ position: 'absolute', inset: 0, background: 'rgba(26,23,19,0.35)' }} />

      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: dark ? '#17181B' : 'var(--surface)',
        borderRadius: '28px 28px 0 0',
        padding: '10px 20px 24px',
        boxShadow: '0 -20px 40px -10px rgba(0,0,0,0.2)'
      }}>
        <div style={{ width: 40, height: 4, borderRadius: 2, background: 'var(--line)', margin: '0 auto 16px' }} />

        <div style={{ fontFamily: 'var(--mono)', fontSize: 10, textTransform: 'uppercase', letterSpacing: '0.1em', color: 'var(--muted)' }}>
          {t('add_eye', 'Новое меню', 'New menu')}
        </div>
        <h2 style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 24, letterSpacing: '-0.02em', margin: '4px 0 6px' }}>
          {t('add_h', <>Сфотографируйте — <em style={{ color: 'var(--accent)' }}>мы сделаем остальное</em></>, <>Snap it — <em style={{ color: 'var(--accent)' }}>we do the rest</em></>)}
        </h2>
        <p style={{ fontSize: 12, color: 'var(--muted)', lineHeight: 1.5, marginBottom: 18 }}>
          {t('add_p', 'Обработка занимает около 20 секунд. Можно закрыть приложение — придёт уведомление.', 'Processing takes about 20 seconds. You can close the app — we\'ll notify you.')}
        </p>

        {/* primary action */}
        <div style={{
          padding: 16, borderRadius: 16,
          background: 'var(--accent)', color: '#fff',
          display: 'flex', alignItems: 'center', gap: 14, marginBottom: 10
        }}>
          <div style={{ width: 48, height: 48, borderRadius: 14, background: 'rgba(255,255,255,0.2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none"><rect x="2" y="6" width="20" height="14" rx="3" stroke="currentColor" strokeWidth="1.8" /><circle cx="12" cy="13" r="4" stroke="currentColor" strokeWidth="1.8" /><rect x="8" y="2" width="8" height="4" rx="1" stroke="currentColor" strokeWidth="1.8" /></svg>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 17 }}>{t('action_camera', 'Сделать снимок', 'Take a photo')}</div>
            <div style={{ fontSize: 11, opacity: 0.85 }}>{t('action_camera_hint', 'Бумажное меню на столе', 'Paper menu on the table')}</div>
          </div>
          <svg width="16" height="16" viewBox="0 0 8 14" fill="none"><path d="M1 1l6 6-6 6" stroke="currentColor" strokeWidth="1.8" /></svg>
        </div>

        {/* secondary actions */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>
          {[
          { i: '🖼', lbl: t('action_photo', 'Из галереи', 'From gallery') },
          { i: '📄', lbl: t('action_doc', 'PDF / doc', 'PDF / doc') },
          { i: '🔗', lbl: t('action_link', 'Ссылка', 'Link') }].
          map((a, i) =>
          <div key={i} style={{
            padding: 12, borderRadius: 12,
            background: dark ? 'rgba(255,255,255,0.04)' : 'var(--surface-2)',
            border: '1px solid var(--line)',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6
          }}>
              <span style={{ fontSize: 22 }}>{a.i}</span>
              <span style={{ fontSize: 11, color: 'var(--ink-2)' }}>{a.lbl}</span>
            </div>
          )}
        </div>
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 8 — Account / Profile
// ═══════════════════════════════════════════════════════
function AccountScreen({ variant, t }) {
  const dark = variant === 'dark';
  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <AppBar onBack dark={dark} right={
      <div style={{ width: 32, height: 32, borderRadius: 10, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="7" cy="3" r="1.3" fill="currentColor" /><circle cx="7" cy="7" r="1.3" fill="currentColor" /><circle cx="7" cy="11" r="1.3" fill="currentColor" /></svg>
        </div>
      } />

      <div style={{ padding: '0 20px 14px', display: 'flex', gap: 14, alignItems: 'center' }}>
        <div style={{ width: 64, height: 64, borderRadius: 20, background: 'var(--accent-soft)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--serif)', fontSize: 26, color: 'var(--accent-ink)', fontStyle: 'italic', fontWeight: 600 }}>И</div>
        <div>
          <div style={{ fontFamily: 'var(--serif)', fontSize: 22, fontWeight: 500, letterSpacing: '-0.02em' }}>КАПРЕЗЕ</div>
          <div style={{ fontSize: 12, color: 'var(--muted)', fontFamily: 'var(--mono)' }}>ivan@example.com</div>
        </div>
      </div>

      {/* stats */}
      <div style={{ padding: '0 20px 18px', display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
        {[
        { n: 14, l: t('stat_places', 'Места', 'Places') },
        { n: 42, l: t('stat_dishes', 'Блюда', 'Dishes') },
        { n: 7, l: t('stat_cities', 'Города', 'Cities') }].
        map((s, i) =>
        <div key={i} style={{ padding: 12, borderRadius: 14, border: '1px solid var(--line)', background: dark ? 'rgba(255,255,255,0.03)' : 'var(--surface)' }}>
            <div style={{ fontFamily: 'var(--serif)', fontSize: 24, fontWeight: 500 }}>{s.n}</div>
            <div style={{ fontSize: 10, color: 'var(--muted)', fontFamily: 'var(--mono)', textTransform: 'uppercase', letterSpacing: '0.08em', marginTop: 2 }}>{s.l}</div>
          </div>
        )}
      </div>

      <div style={{ flex: 1, overflow: 'hidden', padding: '0 20px' }}>
        {[
        { i: '♡', l: t('menu_liked_p', 'Любимые места', 'Liked places'), c: 14 },
        { i: '⭐', l: t('menu_liked_d', 'Любимые блюда', 'Liked dishes'), c: 42 },
        { i: '🌐', l: t('menu_lang', 'Язык интерфейса', 'Interface language'), v: 'Русский' },
        { i: '€', l: t('menu_curr', 'Валюта', 'Currency'), v: 'EUR' },
        { i: '🥗', l: t('menu_diet', 'Диета и аллергены', 'Diet & allergens'), v: t('menu_diet_v', 'Без глютена', 'Gluten-free') },
        { i: '◐', l: t('menu_theme', 'Тема', 'Theme'), v: t('menu_theme_v', 'Авто', 'Auto') }].
        map((row, i) =>
        <div key={i} style={{
          display: 'flex', alignItems: 'center', gap: 14, padding: '12px 0',
          borderBottom: '1px solid var(--line)'
        }}>
            <div style={{ width: 32, height: 32, borderRadius: 10, background: dark ? 'rgba(255,255,255,0.04)' : 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 14 }}>{row.i}</div>
            <div style={{ flex: 1, fontSize: 14 }}>{row.l}</div>
            {row.v && <span style={{ fontSize: 12, color: 'var(--muted)', fontFamily: 'var(--mono)' }}>{row.v}</span>}
            {row.c !== undefined && <span style={{ fontSize: 12, color: 'var(--muted)', fontFamily: 'var(--mono)' }}>{row.c}</span>}
            <svg width="8" height="10" viewBox="0 0 8 14" fill="none"><path d="M1 1l6 6-6 6" stroke="var(--muted)" strokeWidth="1.5" strokeLinecap="round" /></svg>
          </div>
        )}
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// SCREEN 9 — Empty state (no menus yet)
// ═══════════════════════════════════════════════════════
function EmptyScreen({ variant, t }) {
  const dark = variant === 'dark';
  return (
    <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '8px 20px 14px', display: 'flex', gap: 10 }}>
        <div style={{ flex: 1, height: 44, borderRadius: 14, background: dark ? 'rgba(255,255,255,0.06)' : 'var(--surface-2)', display: 'flex', alignItems: 'center', padding: '0 14px', color: 'var(--muted)', fontSize: 14 }}>
          {t('search_home', 'Места, блюда, рестораны…', 'Places, dishes, cuisines…')}
        </div>
      </div>

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 32px', textAlign: 'center' }}>
        {/* illustration: stack of paper menus */}
        <div style={{ position: 'relative', width: 180, height: 180, marginBottom: 24 }}>
          <div style={{ position: 'absolute', inset: 0, transform: 'rotate(-8deg)', background: dark ? '#1E2024' : '#FDFAF3', borderRadius: 10, boxShadow: '0 8px 20px -5px rgba(0,0,0,0.15)', border: '1px solid var(--line)' }} />
          <div style={{ position: 'absolute', inset: 10, transform: 'rotate(4deg)', background: dark ? '#22252A' : '#FBF8F3', borderRadius: 10, boxShadow: '0 8px 20px -5px rgba(0,0,0,0.1)', border: '1px solid var(--line)', padding: 20 }}>
            <div style={{ fontFamily: 'var(--serif)', fontSize: 14, fontStyle: 'italic', fontWeight: 600, textAlign: 'center', borderBottom: '1px solid var(--line)', paddingBottom: 6 }}>Menu</div>
            <div style={{ fontFamily: 'var(--mono)', fontSize: 8, lineHeight: 1.8, marginTop: 8, color: 'var(--muted)' }}>
              <div>— · — · —</div>
              <div>— · — · —</div>
              <div>— · — · —</div>
            </div>
          </div>
          <div style={{ position: 'absolute', right: -10, bottom: -10, width: 50, height: 50, borderRadius: 16, background: 'var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', boxShadow: '0 10px 20px -5px rgba(196,78,42,0.5)' }}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M12 5v14M5 12h14" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" /></svg>
          </div>
        </div>

        <h2 style={{ fontFamily: 'var(--serif)', fontWeight: 500, fontSize: 26, letterSpacing: '-0.02em', lineHeight: 1.1, margin: 0 }}>
          {t('empty_h', <>Пока <em style={{ color: 'var(--accent)' }}>пусто.</em></>, <>Still <em style={{ color: 'var(--accent)' }}>empty.</em></>)}
        </h2>
        <p style={{ color: 'var(--ink-2)', fontSize: 13, lineHeight: 1.5, marginTop: 10, maxWidth: 240 }}>
          {t('empty_p', 'Сфотографируйте меню в любом кафе — оно появится здесь через 20 секунд.', 'Snap a menu at any café — it\'ll be here in 20 seconds.')}
        </p>

        <button style={{
          marginTop: 20, padding: '14px 24px', borderRadius: 14, border: 0,
          background: 'var(--ink)', color: 'var(--bg)', fontFamily: 'var(--sans)', fontSize: 14, fontWeight: 500,
          display: 'flex', alignItems: 'center', gap: 10
        }}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><rect x="2" y="6" width="20" height="14" rx="3" stroke="currentColor" strokeWidth="1.8" /><circle cx="12" cy="13" r="4" stroke="currentColor" strokeWidth="1.8" /></svg>
          {t('empty_cta', 'Снять первое меню', 'Capture first menu')}
        </button>
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════
// RENDER
// ═══════════════════════════════════════════════════════

// Additional translations for all supported languages.
// Signature: t(key, ru_default, en_default) — if a language-specific entry
// exists in SCREEN_I18N[key][lang], it's used; otherwise falls back to ru/en.
const SCREEN_I18N = {
  // Onboarding
  skip: { pt: 'Pular', es: 'Saltar', it: 'Salta', fr: 'Passer', de: 'Überspringen' },
  continue: { pt: 'Continuar', es: 'Siguiente', it: 'Avanti', fr: 'Suivant', de: 'Weiter' },
  ob1p: { pt: 'Fotografe o menu num café — receba um catálogo bonito com fotos, tradução e ingredientes.', es: 'Fotografía el menú en el café — recibe un catálogo con fotos, traducción e ingredientes.', it: 'Fotografa il menu al bar — ricevi un bel catalogo con foto, traduzione e ingredienti.', fr: 'Photographiez le menu au café — obtenez un beau catalogue avec photos, traduction et ingrédients.', de: 'Fotografiere die Karte im Café — erhalte einen schönen Katalog mit Fotos, Übersetzung und Zutaten.' },
  // Auth
  welcome: { pt: 'Bem-vindo', es: 'Bienvenido', it: 'Benvenuto', fr: 'Bienvenue', de: 'Willkommen' },
  auth_p: { pt: 'Entre para guardar locais, pratos e histórico.', es: 'Inicia sesión para guardar lugares, platos e historial.', it: 'Accedi per salvare luoghi, piatti e cronologia.', fr: 'Connectez-vous pour sauvegarder lieux, plats et historique.', de: 'Melde dich an, um Orte, Gerichte und Verlauf zu speichern.' },
  auth_btn: { pt: 'Entrar ou criar', es: 'Entrar o crear', it: 'Accedi o crea', fr: 'Se connecter ou créer', de: 'Anmelden oder erstellen' },
  or: { pt: 'ou', es: 'o', it: 'o', fr: 'ou', de: 'oder' },
  google: { pt: 'Continuar com Google', es: 'Continuar con Google', it: 'Continua con Google', fr: 'Continuer avec Google', de: 'Mit Google fortfahren' },
  tos: { pt: 'Ao continuar, você aceita os termos e a política de privacidade', es: 'Al continuar, aceptas los términos y la política de privacidad', it: 'Continuando accetti termini e privacy', fr: 'En continuant, vous acceptez les conditions et la politique de confidentialité', de: 'Mit dem Fortfahren akzeptieren Sie die Bedingungen und Datenschutzrichtlinien' },
  // Home
  search_home: { pt: 'Locais, pratos, cozinhas…', es: 'Lugares, platos, cocinas…', it: 'Luoghi, piatti, cucine…', fr: 'Lieux, plats, cuisines…', de: 'Orte, Gerichte, Küchen…' },
  greeting: { pt: 'Olá, Ivan', es: 'Hola, Ivan', it: 'Ciao, Ivan', fr: 'Salut, Ivan', de: 'Hallo, Ivan' },
  chip_recent: { pt: 'Recentes', es: 'Recientes', it: 'Recenti', fr: 'Récents', de: 'Letzte' },
  chip_liked: { pt: 'Favoritos', es: 'Favoritos', it: 'Preferiti', fr: 'Favoris', de: 'Favoriten' },
  chip_gf: { pt: 'Sem glúten', es: 'Sin gluten', it: 'Senza glutine', fr: 'Sans gluten', de: 'Glutenfrei' },
  tag_grill: { pt: 'Grelha · Steakhouse', es: 'Parrilla · Steakhouse', it: 'Griglia · Steakhouse', fr: 'Grill · Steakhouse', de: 'Grill · Steakhouse' },
  tag_wine: { pt: 'Bar de vinhos', es: 'Vinoteca', it: 'Enoteca', fr: 'Bar à vins', de: 'Weinbar' },
  tag_trad: { pt: 'Tradicional port.', es: 'Portuguesa trad.', it: 'Port. tradizionale', fr: 'Portugaise trad.', de: 'Portug. traditionell' },
  visited_today: { pt: 'hoje', es: 'hoy', it: 'oggi', fr: 'aujourd\'hui', de: 'heute' },
  visited_yday: { pt: 'ontem', es: 'ayer', it: 'ieri', fr: 'hier', de: 'gestern' },
  // Restaurant / categories
  search_dish: { pt: '«algo com bacalhau, até 25€»', es: '«algo con bacalao, hasta 25€»', it: '«qualcosa col merluzzo, fino a 25€»', fr: '«quelque chose avec morue, sous 25€»', de: '„etwas mit Kabeljau, unter 25€"' },
  cat_starter: { pt: 'Entradas', es: 'Entrantes', it: 'Antipasti', fr: 'Entrées', de: 'Vorspeisen' },
  cat_carpaccio: { pt: 'Carpaccio e tártaro', es: 'Carpaccio y tártaro', it: 'Carpaccio e tartare', fr: 'Carpaccio & tartare', de: 'Carpaccio & Tatar' },
  cat_salad: { pt: 'Saladas', es: 'Ensaladas', it: 'Insalate', fr: 'Salades', de: 'Salate' },
  cat_brusc: { pt: 'Brusquetas', es: 'Bruschettas', it: 'Bruschette', fr: 'Bruschettas', de: 'Bruschetta' },
  cat_main: { pt: 'Pratos principais', es: 'Platos principales', it: 'Piatti principali', fr: 'Plats', de: 'Hauptgerichte' },
  cat_dessert: { pt: 'Sobremesas', es: 'Postres', it: 'Dolci', fr: 'Desserts', de: 'Desserts' },
  // Dish list
  d1: { pt: 'Rösti de vaca com molho alpino', es: 'Rösti de ternera con salsa alpina', it: 'Rösti di manzo con salsa alpina', fr: 'Rösti de bœuf à la sauce alpine', de: 'Rindfleisch-Rösti mit Alpensauce' },
  d2: { pt: 'Caprese de espelta com beterraba assada', es: 'Caprese de espelta con remolacha asada', it: 'Caprese di farro con barbabietola al forno', fr: 'Caprese d\'épeautre à la betterave rôtie', de: 'Dinkel-Caprese mit gebackener Rote Bete' },
  d3: { pt: 'Salada de tomate com amêndoas', es: 'Ensalada de tomate con almendras', it: 'Insalata di pomodoro e mandorle', fr: 'Salade de tomates aux amandes', de: 'Tomaten-Mandel-Salat' },
  d4: { pt: 'Presunto com truta', es: 'Jamón con trucha', it: 'Prosciutto con trota', fr: 'Jambon et truite', de: 'Schinken mit Forelle' },
  // Dish
  dish_h: { pt: 'Rösti de vaca com molho alpino', es: 'Rösti de ternera con salsa alpina', it: 'Rösti di manzo con salsa alpina', fr: 'Rösti de bœuf à la sauce alpine', de: 'Rindfleisch-Rösti mit Alpensauce' },
  price: { pt: 'Preço', es: 'Precio', it: 'Prezzo', fr: 'Prix', de: 'Preis' },
  composition: { pt: 'Composição', es: 'Composición', it: 'Composizione', fr: 'Composition', de: 'Zutaten' },
  dish_desc: { pt: 'Rösti de batata com carne suculenta, servidos com molho alpino à base de ervas e espinafres frescos. Preparados em fogo aberto.', es: 'Rösti de patata con carne jugosa, servidos con salsa alpina a base de hierbas y espinacas frescas. Cocinados al fuego abierto.', it: 'Rösti di patate con carne succosa, serviti con salsa alpina a base di erbe e spinaci freschi. Cotti al fuoco vivo.', fr: 'Rösti de pommes de terre avec bœuf juteux, servis avec une sauce alpine aux herbes et épinards frais. Cuits au feu ouvert.', de: 'Kartoffel-Rösti mit saftigem Rind, serviert mit Kräuter-Alpensauce und frischem Spinat. Über offenem Feuer zubereitet.' },
  // Add menu
  add_eye: { pt: 'Novo menu', es: 'Nuevo menú', it: 'Nuovo menu', fr: 'Nouveau menu', de: 'Neues Menü' },
  add_p: { pt: 'O processamento leva cerca de 20 segundos. Pode fechar a app — enviaremos notificação.', es: 'El procesamiento tarda unos 20 segundos. Puedes cerrar la app — te avisaremos.', it: 'L\'elaborazione richiede circa 20 secondi. Puoi chiudere l\'app — ti avviseremo.', fr: 'Le traitement prend environ 20 secondes. Vous pouvez fermer l\'app — on vous préviendra.', de: 'Die Verarbeitung dauert etwa 20 Sekunden. Du kannst die App schließen — wir benachrichtigen dich.' },
  action_camera: { pt: 'Tirar foto', es: 'Hacer foto', it: 'Scatta foto', fr: 'Prendre une photo', de: 'Foto aufnehmen' },
  action_camera_hint: { pt: 'Menu em papel sobre a mesa', es: 'Menú de papel en la mesa', it: 'Menu cartaceo sul tavolo', fr: 'Menu papier sur la table', de: 'Papierkarte auf dem Tisch' },
  action_photo: { pt: 'Da galeria', es: 'De la galería', it: 'Dalla galleria', fr: 'Depuis la galerie', de: 'Aus Galerie' },
  action_doc: { pt: 'PDF / doc', es: 'PDF / doc', it: 'PDF / doc', fr: 'PDF / doc', de: 'PDF / doc' },
  action_link: { pt: 'Link', es: 'Enlace', it: 'Link', fr: 'Lien', de: 'Link' },
  // Profile
  stat_places: { pt: 'Locais', es: 'Lugares', it: 'Luoghi', fr: 'Lieux', de: 'Orte' },
  stat_dishes: { pt: 'Pratos', es: 'Platos', it: 'Piatti', fr: 'Plats', de: 'Gerichte' },
  stat_cities: { pt: 'Cidades', es: 'Ciudades', it: 'Città', fr: 'Villes', de: 'Städte' },
  menu_liked_p: { pt: 'Locais favoritos', es: 'Lugares favoritos', it: 'Luoghi preferiti', fr: 'Lieux favoris', de: 'Lieblingsorte' },
  // Empty state
  empty_cta: { pt: 'Adicionar menu', es: 'Añadir menú', it: 'Aggiungi menu', fr: 'Ajouter un menu', de: 'Menü hinzufügen' },
  // Screen labels
  l_onb: { pt: 'Onboarding', es: 'Onboarding', it: 'Onboarding', fr: 'Onboarding', de: 'Onboarding' },
  l_auth: { pt: 'Autenticação', es: 'Autenticación', it: 'Accesso', fr: 'Connexion', de: 'Anmeldung' },
  l_home: { pt: 'Início', es: 'Inicio', it: 'Home', fr: 'Accueil', de: 'Start' },
  l_rest: { pt: 'Restaurante', es: 'Restaurante', it: 'Ristorante', fr: 'Restaurant', de: 'Restaurant' },
  l_list: { pt: 'Pratos', es: 'Platos', it: 'Piatti', fr: 'Plats', de: 'Gerichte' },
  l_dish: { pt: 'Ficha do prato', es: 'Ficha del plato', it: 'Scheda piatto', fr: 'Fiche plat', de: 'Gericht' },
  l_add: { pt: 'Adicionar menu', es: 'Añadir menú', it: 'Aggiungi menu', fr: 'Ajouter un menu', de: 'Menü hinzufügen' },
  l_acc: { pt: 'Perfil', es: 'Perfil', it: 'Profilo', fr: 'Profil', de: 'Profil' },
  l_empty: { pt: 'Estado vazio', es: 'Estado vacío', it: 'Stato vuoto', fr: 'État vide', de: 'Leerer Zustand' }
};

function tFactory() {
  const lang = window.getLang ? window.getLang() : 'ru';
  return (key, ru, en) => {
    // language-specific override from the table?
    const entry = SCREEN_I18N[key];
    if (entry && entry[lang]) return entry[lang];
    // fallbacks:
    if (lang === 'en') return en;
    if (lang === 'ru') return ru;
    // other language without entry → prefer English as neutral fallback
    return en;
  };
}

function HeroPhone() {
  const [, force] = useState(0);
  useEffect(() => {
    const handler = () => force((x) => x + 1);
    window.addEventListener('ma-rerender', handler);
    return () => window.removeEventListener('ma-rerender', handler);
  }, []);
  const t = tFactory();
  return <Phone variant="warm"><DishScreen variant="warm" t={t} /></Phone>;
}

function ScreenGrid() {
  const [, force] = useState(0);
  const [idx, setIdx] = useState(0);
  useEffect(() => {
    const handler = () => force((x) => x + 1);
    window.addEventListener('ma-rerender', handler);
    return () => window.removeEventListener('ma-rerender', handler);
  }, []);
  const variant = window.getVariant ? window.getVariant() : 'warm';
  const t = tFactory();
  const items = [
  { C: OnboardingScreen, tag: '01', title: t('l_onb', 'Онбординг', 'Onboarding'), desc: t('l_onb_d', 'Первое впечатление: большой сериф, живое фото, один чёткий CTA.', 'First impression: a large serif, a living photo, one clear CTA.') },
  { C: AuthScreen, tag: '02', title: t('l_auth', 'Авторизация', 'Auth'), desc: t('l_auth_d', 'Осмысленный заголовок вместо сухого «Авторизация». Терракотовый CTA.', 'Meaningful heading instead of a dry "Auth". Terracotta CTA.') },
  { C: HomeScreen, tag: '03', title: t('l_home', 'Главная', 'Home'), desc: t('l_home_d', 'Список вместо пустых карточек. Фото, локация, тег, последний визит.', 'A list, not empty tiles. Photo, location, tag, last visit.') },
  { C: RestaurantScreen, tag: '04', title: t('l_rest', 'Ресторан', 'Restaurant'), desc: t('l_rest_d', 'Hero-фото, умный поиск на естественном языке, категории с нумерацией.', 'Hero photo, natural-language search, numbered categories.') },
  { C: DishListScreen, tag: '05', title: t('l_list', 'Блюда', 'Dishes'), desc: t('l_list_d', 'Сетка 2×N с оригинальным названием сверху и переводом серифом снизу.', '2×N grid with the original name above and the serif translation below.') },
  { C: DishScreen, tag: '06', title: t('l_dish', 'Карточка блюда', 'Dish'), desc: t('l_dish_d', 'Цена — крупно, серифом. Теги с аллергенами и конвертация валюты.', 'Price — big, in serif. Allergen tags and live currency conversion.') },
  { C: AddMenuScreen, tag: '07', title: t('l_add', 'Добавить меню', 'Add menu'), desc: t('l_add_d', '«Сделать снимок» — главная кнопка. Остальные — вторичные.', '"Take a photo" — the primary action. Rest are secondary.') },
  { C: AccountScreen, tag: '08', title: t('l_acc', 'Профиль', 'Profile'), desc: t('l_acc_d', 'Статистика путешественника-едока + все настройки рядом.', 'Traveller-eater stats + all settings in one calm list.') },
  { C: EmptyScreen, tag: '09', title: t('l_empty', 'Пустое состояние', 'Empty state'), desc: t('l_empty_d', 'Не молчаливый экран, а руководство к первому действию.', 'Not a silent screen — a nudge toward the first action.') }];

  const total = items.length;
  const prev = () => setIdx((i) => (i - 1 + total) % total);
  const next = () => setIdx((i) => (i + 1) % total);
  const active = items[idx];
  const A = active.C;

  // keyboard arrows
  useEffect(() => {
    const onKey = (e) => {
      if (e.key === 'ArrowLeft') prev();else
      if (e.key === 'ArrowRight') next();
    };
    const host = document.getElementById('screen-grid');
    if (!host) return;
    host.tabIndex = 0;
    host.addEventListener('keydown', onKey);
    return () => host.removeEventListener('keydown', onKey);
  }, [total]);

  return (
    <div className="screens-carousel">
      {/* stage: prev peek · active phone · next peek */}
      <div className="screens-stage">
        <button className="screens-arrow left" onClick={prev} aria-label="Previous">‹</button>
        <div className="screens-track">
          {[(idx - 1 + total) % total, idx, (idx + 1) % total].map((i, pos) => {
            const it = items[i];
            const IC = it.C;
            const state = pos === 1 ? 'active' : pos === 0 ? 'prev' : 'next';
            return (
              <div key={`${i}-${state}`} className={`screens-slot ${state}`} onClick={() => pos !== 1 && setIdx(i)}>
                <Phone variant={variant}>
                  <IC variant={variant} t={t} />
                </Phone>
              </div>);

          })}
        </div>
        <button className="screens-arrow right" onClick={next} aria-label="Next">›</button>
      </div>

      {/* caption for the active screen */}
      <div className="screens-caption">
        <div className="screens-caption-tag">
          <span>{active.tag}</span>
          <span className="screens-caption-count">{idx + 1} / {total}</span>
        </div>
        <div className="screens-caption-title">{active.title}</div>
        <div className="screens-caption-desc">{active.desc}</div>
      </div>

      {/* thumb strip */}
      <div className="screens-strip" role="tablist">
        {items.map((it, i) =>
        <button
          key={i}
          className={`screens-dot ${i === idx ? 'is-active' : ''}`}
          onClick={() => setIdx(i)}
          aria-label={it.title}
          aria-selected={i === idx}>
          
            <span className="screens-dot-num">{it.tag}</span>
            <span className="screens-dot-label">{it.title}</span>
          </button>
        )}
      </div>
    </div>);

}

// mount — Babel transpiles async, so DOMContentLoaded may have already fired
function __mountScreens() {
  const heroMount = document.getElementById('hero-phone-slot');
  if (heroMount && !heroMount.__mounted) {
    heroMount.__mounted = true;
    ReactDOM.createRoot(heroMount).render(<HeroPhone />);
  }
  const gridMount = document.getElementById('screen-grid');
  if (gridMount && !gridMount.__mounted) {
    gridMount.__mounted = true;
    ReactDOM.createRoot(gridMount).render(<ScreenGrid />);
  }
  window.rerenderScreens = () => window.dispatchEvent(new Event('ma-rerender'));
}
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', __mountScreens);
} else {
  __mountScreens();
}

// hook into lang change: monkey-patch applyLang so phones re-render
const _origLangClick = () => {
  window.dispatchEvent(new Event('ma-rerender'));
};
document.addEventListener('click', (e) => {
  if (e.target.closest('#lang-dd-menu .lang-dd-opt') || e.target.closest('#tw-lang button')) {
    setTimeout(_origLangClick, 0);
  }
});