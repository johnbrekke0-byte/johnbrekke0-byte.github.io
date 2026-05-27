# johnbrekke0-byte.github.io<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CNC Lathe Basics — Interactive Training | Module 1</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tabler-icons/2.44.0/iconfont/tabler-icons.min.css">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  :root {
    --teal-50:#E1F5EE; --teal-100:#9FE1CB; --teal-400:#1D9E75; --teal-600:#0F6E56; --teal-800:#085041; --teal-900:#04342C;
    --amber-50:#FAEEDA; --amber-100:#FAC775; --amber-400:#BA7517; --amber-800:#633806;
    --coral-50:#FAECE7; --coral-400:#D85A30; --coral-800:#4A1B0C;
    --gray-50:#F7F6F3; --gray-100:#EEECE8; --gray-200:#D3D1C7; --gray-400:#888780; --gray-600:#5F5E5A; --gray-800:#2C2C2A;
    --text:#1a1a18; --text-muted:#5F5E5A; --text-hint:#888780;
    --border:rgba(0,0,0,0.10); --border-med:rgba(0,0,0,0.18);
    --bg:#FAFAF8; --surface:#FFFFFF;
    --radius:10px; --radius-lg:14px;
  }
  body { font-family:'DM Sans',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; line-height:1.6; }
  .page-wrap { display:grid; grid-template-columns:260px 1fr; min-height:100vh; }

  /* Sidebar */
  .sidebar { background:var(--gray-800); color:#fff; display:flex; flex-direction:column; position:sticky; top:0; height:100vh; overflow-y:auto; }
  .sidebar-brand { padding:2rem 1.5rem 1.25rem; border-bottom:0.5px solid rgba(255,255,255,0.1); }
  .brand-label { font-size:10px; font-weight:600; letter-spacing:0.12em; text-transform:uppercase; color:var(--teal-100); margin-bottom:6px; }
  .brand-title { font-size:18px; font-weight:600; color:#fff; line-height:1.3; }
  .sidebar-nav { padding:1.25rem 0; flex:1; }
  .nav-section-label { font-size:10px; font-weight:600; letter-spacing:0.1em; text-transform:uppercase; color:rgba(255,255,255,0.35); padding:0 1.5rem; margin-bottom:6px; margin-top:1rem; }
  .nav-item { display:flex; align-items:center; gap:10px; padding:9px 1.5rem; font-size:13.5px; color:rgba(255,255,255,0.55); cursor:pointer; transition:color 0.15s, background 0.15s; border-left:2px solid transparent; }
  .nav-item i { font-size:16px; flex-shrink:0; }
  .nav-item:hover { color:rgba(255,255,255,0.85); background:rgba(255,255,255,0.05); }
  .nav-item.active { color:#fff; background:rgba(29,158,117,0.2); border-left-color:var(--teal-400); font-weight:500; }
  .nav-item.done { color:var(--teal-100); }
  .nav-item.done .nav-check { display:flex; }
  .nav-check { display:none; margin-left:auto; font-size:14px; color:var(--teal-400); }
  .sidebar-footer { padding:1.25rem 1.5rem; border-top:0.5px solid rgba(255,255,255,0.1); }
  .progress-label { font-size:11px; color:rgba(255,255,255,0.4); margin-bottom:8px; }
  .progress-track { height:4px; background:rgba(255,255,255,0.12); border-radius:2px; overflow:hidden; }
  .progress-fill { height:100%; background:var(--teal-400); border-radius:2px; transition:width 0.4s ease; }

  /* Main */
  .main { display:flex; flex-direction:column; }
  .topbar { background:var(--surface); border-bottom:0.5px solid var(--border); padding:1rem 2.5rem; display:flex; align-items:center; justify-content:space-between; position:sticky; top:0; z-index:10; }
  .topbar-breadcrumb { font-size:13px; color:var(--text-hint); display:flex; align-items:center; gap:6px; }
  .topbar-breadcrumb span { color:var(--text-muted); }
  .topbar-slide-count { font-size:13px; font-weight:500; color:var(--text-muted); background:var(--gray-100); padding:4px 12px; border-radius:20px; }
  .content-area { padding:3rem 2.5rem; max-width:820px; flex:1; }

  /* Slides */
  .slide { display:none; animation:fadeIn 0.25s ease; }
  .slide.active { display:block; }
  @keyframes fadeIn { from{opacity:0;transform:translateY(8px)} to{opacity:1;transform:translateY(0)} }

  /* Typography */
  .module-tag { display:inline-flex; align-items:center; gap:5px; font-size:11px; font-weight:600; letter-spacing:0.08em; text-transform:uppercase; color:var(--teal-600); background:var(--teal-50); padding:4px 11px; border-radius:5px; margin-bottom:14px; }
  h1 { font-size:32px; font-weight:600; color:var(--text); line-height:1.2; margin-bottom:12px; }
  .lead { font-size:16px; color:var(--text-muted); line-height:1.7; max-width:640px; margin-bottom:2rem; }

  /* Photo hero */
  .photo-hero { position:relative; width:100%; border-radius:var(--radius-lg); overflow:hidden; margin-bottom:2rem; background:var(--gray-800); }
  .photo-hero img { width:100%; height:360px; object-fit:cover; display:block; }
  .photo-caption { position:absolute; bottom:0; left:0; right:0; background:linear-gradient(transparent,rgba(0,0,0,0.72)); padding:1.25rem 1.25rem 1rem; color:#fff; font-size:12px; }
  .photo-caption strong { font-weight:600; font-size:13px; display:block; margin-bottom:2px; }
  .photo-credit { font-size:10px; opacity:0.6; margin-top:4px; }

  /* Callout */
  .callout { display:flex; gap:12px; background:var(--teal-50); border:0.5px solid var(--teal-100); border-radius:var(--radius); padding:1rem 1.25rem; margin-bottom:1.5rem; }
  .callout-icon { font-size:20px; color:var(--teal-400); flex-shrink:0; margin-top:2px; }
  .callout-text { font-size:14px; color:var(--teal-800); line-height:1.65; }
  .callout-text strong { font-weight:600; display:block; margin-bottom:3px; }

  .callout.amber { background:var(--amber-50); border-color:var(--amber-100); }
  .callout.amber .callout-icon { color:var(--amber-400); }
  .callout.amber .callout-text { color:var(--amber-800); }

  /* Parts grid */
  .parts-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(175px,1fr)); gap:10px; margin-bottom:1.5rem; }
  .part-card { background:var(--surface); border:0.5px solid var(--border); border-radius:var(--radius-lg); padding:1.1rem; cursor:pointer; transition:border-color 0.2s, box-shadow 0.2s, transform 0.15s; }
  .part-card:hover { border-color:var(--border-med); box-shadow:0 2px 12px rgba(0,0,0,0.06); transform:translateY(-1px); }
  .part-card.selected { border-color:var(--teal-400); background:var(--teal-50); box-shadow:0 0 0 3px rgba(29,158,117,0.12); }
  .part-icon { font-size:22px; color:var(--teal-400); margin-bottom:8px; }
  .part-name { font-size:14px; font-weight:600; color:var(--text); margin-bottom:3px; }
  .part-brief { font-size:12px; color:var(--text-hint); line-height:1.5; }
  .info-box { background:var(--surface); border:0.5px solid var(--border); border-left:3px solid var(--teal-400); border-radius:0 var(--radius) var(--radius) 0; padding:1.1rem 1.4rem; margin-bottom:2rem; min-height:70px; }
  .info-box-title { font-size:13px; font-weight:600; color:var(--teal-600); margin-bottom:6px; }
  .info-box-text { font-size:14px; color:var(--text-muted); line-height:1.7; }

  /* Photo grid for turret & workholding */
  .photo-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:12px; margin-bottom:1.5rem; }
  .photo-card { background:var(--surface); border:0.5px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; }
  .photo-card img { width:100%; height:180px; object-fit:cover; display:block; background:var(--gray-100); }
  .photo-card-body { padding:10px 12px; }
  .photo-card-title { font-size:13px; font-weight:600; color:var(--text); margin-bottom:3px; }
  .photo-card-desc { font-size:12px; color:var(--text-muted); line-height:1.5; }
  .photo-card-credit { font-size:10px; color:var(--text-hint); margin-top:4px; }

  /* Schaublin spotlight */
  .schaublin-section { background:var(--surface); border:0.5px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; margin-bottom:2rem; }
  .schaublin-header { background:var(--gray-800); padding:14px 1.25rem; display:flex; align-items:center; gap:10px; }
  .schaublin-header-text { font-size:13px; font-weight:600; color:#fff; }
  .schaublin-header-sub { font-size:11px; color:rgba(255,255,255,0.5); margin-top:1px; }
  .schaublin-badge { font-size:10px; font-weight:600; letter-spacing:0.06em; text-transform:uppercase; color:var(--teal-100); background:rgba(29,158,117,0.25); padding:3px 8px; border-radius:4px; margin-left:auto; }
  .schaublin-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(190px,1fr)); }
  .schaublin-item { padding:1rem; border-right:0.5px solid var(--border); border-top:0.5px solid var(--border); }
  .schaublin-item:nth-child(1) { border-top:none; }
  .schaublin-item img { width:100%; height:120px; object-fit:contain; display:block; background:var(--gray-50); border-radius:var(--radius); margin-bottom:10px; padding:8px; }
  .schaublin-item-title { font-size:13px; font-weight:600; color:var(--text); margin-bottom:4px; }
  .schaublin-item-desc { font-size:12px; color:var(--text-muted); line-height:1.5; }

  /* Operations */
  .ops-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(190px,1fr)); gap:10px; margin-bottom:2rem; }
  .op-card { background:var(--surface); border:0.5px solid var(--border); border-radius:var(--radius-lg); padding:1.1rem; }
  .op-tag { display:inline-block; font-size:10px; font-weight:600; letter-spacing:0.06em; text-transform:uppercase; padding:3px 9px; border-radius:4px; margin-bottom:8px; }
  .op-name { font-size:14px; font-weight:600; color:var(--text); margin-bottom:5px; }
  .op-desc { font-size:12.5px; color:var(--text-muted); line-height:1.55; }

  /* Safety */
  .safety-list { display:flex; flex-direction:column; gap:10px; margin-bottom:2rem; }
  .safety-item { display:flex; align-items:flex-start; gap:12px; background:var(--surface); border:0.5px solid var(--border); border-radius:var(--radius); padding:14px 16px; transition:border-color 0.15s; }
  .safety-item:hover { border-color:var(--border-med); }
  .safety-icon { font-size:20px; flex-shrink:0; margin-top:1px; }
  .safety-text { font-size:14px; color:var(--text-muted); line-height:1.6; }
  .safety-text strong { font-weight:600; color:var(--text); }

  /* Quiz */
  .quiz-section { margin-bottom:1.75rem; }
  .quiz-q { font-size:16px; font-weight:500; color:var(--text); margin-bottom:12px; line-height:1.5; }
  .quiz-options { display:flex; flex-direction:column; gap:8px; }
  .quiz-opt { background:var(--surface); border:0.5px solid var(--border); border-radius:var(--radius); padding:13px 16px; font-size:14px; font-family:'DM Sans',sans-serif; color:var(--text); cursor:pointer; text-align:left; transition:border-color 0.15s, background 0.15s; line-height:1.5; }
  .quiz-opt:hover:not(:disabled) { border-color:var(--border-med); background:var(--gray-50); }
  .quiz-opt.correct { border-color:var(--teal-400) !important; background:var(--teal-50) !important; color:var(--teal-800) !important; font-weight:500; }
  .quiz-opt.wrong { border-color:#D85A30 !important; background:#FAECE7 !important; color:#4A1B0C !important; }
  .quiz-feedback { margin-top:10px; font-size:14px; line-height:1.65; padding:11px 15px; border-radius:var(--radius); display:none; }
  .quiz-feedback.show { display:block; }
  .quiz-feedback.correct { background:var(--teal-50); color:var(--teal-800); }
  .quiz-feedback.wrong { background:#FAECE7; color:#4A1B0C; }

  /* Complete */
  .complete-screen { text-align:center; padding:3rem 1rem; }
  .complete-icon { font-size:56px; color:var(--teal-400); margin-bottom:1.25rem; }
  .complete-screen h1 { font-size:28px; margin-bottom:10px; }
  .complete-text { font-size:15px; color:var(--text-muted); line-height:1.7; max-width:480px; margin:0 auto 1.5rem; }
  .score-badge { display:inline-block; font-size:32px; font-weight:600; color:var(--teal-600); background:var(--teal-50); border-radius:var(--radius-lg); padding:14px 40px; margin-bottom:2rem; }
  .next-modules { display:flex; gap:10px; justify-content:center; flex-wrap:wrap; margin-top:1rem; }
  .next-btn { background:var(--surface); border:0.5px solid var(--border-med); border-radius:var(--radius); padding:10px 18px; font-size:13.5px; font-family:'DM Sans',sans-serif; font-weight:500; color:var(--text); cursor:pointer; text-decoration:none; display:inline-flex; align-items:center; gap:6px; transition:border-color 0.15s, background 0.15s, transform 0.15s; }
  .next-btn:hover { border-color:var(--teal-400); background:var(--teal-50); transform:translateY(-1px); }

  /* Nav */
  .nav-controls { display:flex; align-items:center; justify-content:space-between; margin-top:2rem; padding-top:1.5rem; border-top:0.5px solid var(--border); }
  .nav-btn { display:inline-flex; align-items:center; gap:7px; padding:10px 20px; font-size:14px; font-family:'DM Sans',sans-serif; font-weight:500; border-radius:var(--radius); cursor:pointer; transition:background 0.15s, border-color 0.15s; }
  .nav-btn-ghost { background:transparent; border:0.5px solid var(--border-med); color:var(--text-muted); }
  .nav-btn-ghost:hover { background:var(--gray-50); }
  .nav-btn-ghost:disabled { opacity:0.35; cursor:default; }
  .nav-btn-primary { background:var(--teal-400); border:none; color:#fff; }
  .nav-btn-primary:hover { background:var(--teal-600); }
  .nav-btn-primary:disabled { opacity:0.4; cursor:default; }

  .section-divider { height:0.5px; background:var(--border); margin:1.75rem 0; }

  @media(max-width:768px) {
    .page-wrap { grid-template-columns:1fr; }
    .sidebar { position:static; height:auto; }
    .content-area { padding:2rem 1.25rem; }
    h1 { font-size:24px; }
    .topbar { padding:0.75rem 1.25rem; }
    .photo-hero img { height:220px; }
  }
</style>
</head>
<body>
<div class="page-wrap">

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="brand-label">Machine Tools Training</div>
      <div class="brand-title">CNC Lathe Basics<br>Module 1</div>
    </div>
    <nav class="sidebar-nav">
      <div class="nav-section-label">Contents</div>
      <div class="nav-item active" onclick="goTo(0)" id="nav0"><i class="ti ti-home"></i> Introduction <span class="nav-check"><i class="ti ti-check"></i></span></div>
      <div class="nav-item" onclick="goTo(1)" id="nav1"><i class="ti ti-components"></i> Major Components <span class="nav-check"><i class="ti ti-check"></i></span></div>
      <div class="nav-item" onclick="goTo(2)" id="nav2"><i class="ti ti-rotate-clockwise"></i> Turret &amp; Tooling <span class="nav-check"><i class="ti ti-check"></i></span></div>
      <div class="nav-item" onclick="goTo(3)" id="nav3"><i class="ti ti-circle-dotted"></i> Workholding <span class="nav-check"><i class="ti ti-check"></i></span></div>
      <div class="nav-item" onclick="goTo(4)" id="nav4"><i class="ti ti-tool"></i> Operations <span class="nav-check"><i class="ti ti-check"></i></span></div>
      <div class="nav-item" onclick="goTo(5)" id="nav5"><i class="ti ti-shield-check"></i> Safety Rules <span class="nav-check"><i class="ti ti-check"></i></span></div>
      <div class="nav-item" onclick="goTo(6)" id="nav6"><i class="ti ti-list-check"></i> Knowledge Check <span class="nav-check"><i class="ti ti-check"></i></span></div>
      <div class="nav-item" onclick="goTo(7)" id="nav7"><i class="ti ti-award"></i> Complete <span class="nav-check"><i class="ti ti-check"></i></span></div>
    </nav>
    <div class="sidebar-footer">
      <div class="progress-label" id="progressLabel">0% complete</div>
      <div class="progress-track"><div class="progress-fill" id="progressFill" style="width:0%"></div></div>
    </div>
  </aside>

  <!-- Main -->
  <div class="main">
    <div class="topbar">
      <div class="topbar-breadcrumb">Machine Tools <i class="ti ti-chevron-right" style="font-size:12px"></i> <span>CNC Lathe Basics</span></div>
      <div class="topbar-slide-count" id="slideCount">1 of 8</div>
    </div>

    <div class="content-area">

      <!-- Slide 0: Intro -->
      <div class="slide active" id="slide0">
        <div class="module-tag"><i class="ti ti-book" style="font-size:11px"></i> Module 1 · Basics</div>
        <h1>Introduction to the CNC Lathe</h1>
        <p class="lead">A CNC lathe rotates a workpiece at high speed while computer-controlled cutting tools precisely remove material. This module covers the machine's major components, the turret tool system, workholding methods, and fundamental safety rules.</p>

        <div class="photo-hero">
          <img src="https://commons.wikimedia.org/wiki/Special:FilePath/Small_CNC_Turning_Center.jpg"
               alt="CNC Turning Center — a modern CNC lathe with slant bed and enclosed work area"
               onerror="this.parentElement.style.background='#444';this.style.display='none'">
          <div class="photo-caption">
            <strong>CNC Turning Center</strong>
            A modern slant-bed CNC lathe. The workpiece rotates in the spindle (left), while the multi-station turret (right) indexes different cutting tools automatically under CNC program control.
            <div class="photo-credit">Image: Wikimedia Commons / CC BY-SA</div>
          </div>
        </div>

        <div class="callout">
          <div class="callout-icon"><i class="ti ti-info-circle"></i></div>
          <div class="callout-text">
            <strong>What makes a CNC lathe different from a manual lathe?</strong>
            All axis movements, spindle speeds, tool selections and feed rates are controlled by a CNC program (G-code), eliminating manual handwheel operation. This enables high repeatability, tight tolerances and unmanned production runs.
          </div>
        </div>

        <p style="font-size:15px;color:var(--text-muted);line-height:1.7">This module focuses on the machine structure, with special attention to the <strong>turret / tool magazine</strong> and <strong>workholding</strong> — the areas where precision Swiss tooling from manufacturers like Schaublin makes a critical difference to part quality.</p>

        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" disabled><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" onclick="changeSlide(1)">Next <i class="ti ti-arrow-right"></i></button>
        </div>
      </div>

      <!-- Slide 1: Components -->
      <div class="slide" id="slide1">
        <div class="module-tag"><i class="ti ti-components" style="font-size:11px"></i> Parts</div>
        <h1>Major Components</h1>
        <p class="lead">Select any component to read a detailed description of its function.</p>

        <div class="parts-grid">
          <div class="part-card" onclick="selectPart(0)"><div class="part-icon"><i class="ti ti-circuit-motor"></i></div><div class="part-name">Headstock</div><div class="part-brief">Houses the motor and spindle drive</div></div>
          <div class="part-card" onclick="selectPart(1)"><div class="part-icon"><i class="ti ti-circle-dotted"></i></div><div class="part-name">Spindle / Chuck</div><div class="part-brief">Grips and rotates the workpiece</div></div>
          <div class="part-card" onclick="selectPart(2)"><div class="part-icon"><i class="ti ti-minus"></i></div><div class="part-name">Bed</div><div class="part-brief">The rigid base — usually slant-bed on CNC</div></div>
          <div class="part-card" onclick="selectPart(3)"><div class="part-icon"><i class="ti ti-arrows-move"></i></div><div class="part-name">Carriage / Slide</div><div class="part-brief">Moves the turret in X and Z axes</div></div>
          <div class="part-card" onclick="selectPart(4)"><div class="part-icon"><i class="ti ti-rotate-clockwise"></i></div><div class="part-name">Turret</div><div class="part-brief">Indexes multiple tools automatically</div></div>
          <div class="part-card" onclick="selectPart(5)"><div class="part-icon"><i class="ti ti-arrow-bar-to-right"></i></div><div class="part-name">Tailstock</div><div class="part-brief">Supports long workpieces or holds a drill</div></div>
          <div class="part-card" onclick="selectPart(6)"><div class="part-icon"><i class="ti ti-cpu"></i></div><div class="part-name">CNC Controller</div><div class="part-brief">Executes the G-code program</div></div>
          <div class="part-card" onclick="selectPart(7)"><div class="part-icon"><i class="ti ti-droplet"></i></div><div class="part-name">Coolant System</div><div class="part-brief">Cools tools and flushes chips</div></div>
        </div>

        <div class="info-box">
          <div class="info-box-title" id="partInfoTitle">Select a part above</div>
          <div class="info-box-text" id="partInfoText">Click any component card to read a detailed description of its function.</div>
        </div>

        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" onclick="changeSlide(-1)"><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" onclick="changeSlide(1)">Next <i class="ti ti-arrow-right"></i></button>
        </div>
      </div>

      <!-- Slide 2: Turret -->
      <div class="slide" id="slide2">
        <div class="module-tag"><i class="ti ti-rotate-clockwise" style="font-size:11px"></i> Turret &amp; Tooling</div>
        <h1>The Tool Turret</h1>
        <p class="lead">The turret is the heart of a CNC lathe's tooling system. It holds multiple cutting tools and indexes rapidly between them under program control — eliminating manual tool changes and enabling complex multi-operation parts in a single setup.</p>

        <div class="photo-grid">
          <div class="photo-card">
            <img src="https://helmanCNC.com/wp-content/uploads/2021/08/cnc-lathe-tool-turret.jpg"
                 alt="CNC lathe tool turret close up showing tool stations"
                 onerror="this.src='https://commons.wikimedia.org/wiki/Special:FilePath/2346_Automatic_Tool-changing_Mechanisms_on_Turning_Center.png'">
            <div class="photo-card-body">
              <div class="photo-card-title">12-station VDI turret</div>
              <div class="photo-card-desc">Each station holds one tool holder. The turret indexes by rotating to the required position, locks precisely, then the tool engages the workpiece.</div>
            </div>
          </div>
          <div class="photo-card">
            <img src="https://commons.wikimedia.org/wiki/Special:FilePath/2346_Automatic_Tool-changing_Mechanisms_on_Turning_Center.png"
                 alt="Automatic tool changing mechanisms on turning center diagram"
                 onerror="this.parentElement.style.background='#f0f0f0'">
            <div class="photo-card-body">
              <div class="photo-card-title">Tool station indexing</div>
              <div class="photo-card-desc">The program calls tools using T-codes (e.g. T0101). The turret rotates to the correct station in under a second.</div>
              <div class="photo-card-credit">Wikimedia Commons / CC BY-SA</div>
            </div>
          </div>
        </div>

        <div class="callout amber">
          <div class="callout-icon"><i class="ti ti-bulb"></i></div>
          <div class="callout-text">
            <strong>VDI vs BMT turret interfaces</strong>
            VDI (Verein Deutscher Ingenieure) and BMT (Base Mount Turret) are the two most common tool holder interface standards. The interface determines which tool holders — including precision Swiss holders like those from Schaublin — are compatible with a given lathe.
          </div>
        </div>

        <h2 style="font-size:17px;font-weight:600;margin-bottom:12px;color:var(--text)">Types of turret tooling</h2>
        <div class="ops-grid" style="margin-bottom:1rem">
          <div class="op-card"><span class="op-tag" style="background:#E1F5EE;color:#085041">Static</span><div class="op-name">OD Turning Holders</div><div class="op-desc">Fixed holders for external turning, facing, and grooving. The most common turret tool type.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#EEEDFE;color:#26215C">Static</span><div class="op-name">Boring Bars</div><div class="op-desc">Internal turning tools for enlarging and finishing holes. Held rigidly in the turret bore.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#FAEEDA;color:#412402">Live</span><div class="op-name">Driven Tool Holders</div><div class="op-desc">Motor-driven spindles in the turret for milling, drilling off-centre, and cross-working — turning the lathe into a turn-mill centre.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#E6F1FB;color:#042C53">Swiss</span><div class="op-name">Swiss-Type Gang Tools</div><div class="op-desc">Used on sliding-headstock Swiss lathes. Tools are arranged in a linear gang plate rather than a rotating turret.</div></div>
        </div>

        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" onclick="changeSlide(-1)"><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" onclick="changeSlide(1)">Next <i class="ti ti-arrow-right"></i></button>
        </div>
      </div>

      <!-- Slide 3: Workholding -->
      <div class="slide" id="slide3">
        <div class="module-tag"><i class="ti ti-circle-dotted" style="font-size:11px"></i> Workholding</div>
        <h1>Workholding — Chucks &amp; Collets</h1>
        <p class="lead">How the workpiece is gripped directly determines part quality, runout, and cycle time. Precision Swiss workholding — such as Schaublin's W-series and ESX collets — is used where tight tolerances and minimal runout are critical.</p>

        <div class="photo-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr))">
          <div class="photo-card">
            <img src="https://commons.wikimedia.org/wiki/Special:FilePath/Royal_Quick-Grip_Accu-Length_CNC_Collet_Chuck.jpg"
                 alt="CNC collet chuck"
                 onerror="this.style.height='120px';this.style.background='#eee';this.removeAttribute('src')">
            <div class="photo-card-body">
              <div class="photo-card-title">3-jaw power chuck</div>
              <div class="photo-card-desc">The standard CNC workholding for most bar and billet work. Hydraulically or pneumatically actuated for fast part changes.</div>
            </div>
          </div>
          <div class="photo-card">
            <img src="http://www.schaublin.ch/img/custom/ods/sermat.jpg"
                 alt="Schaublin material tightening workholding collets"
                 onerror="this.style.background='#f5f5f3'">
            <div class="photo-card-body">
              <div class="photo-card-title">Schaublin W-series collets</div>
              <div class="photo-card-desc">Dead-length workholding collets for Swiss-type and precision lathes. Pull-back or thrust-type actuation with minimal runout.</div>
              <div class="photo-card-credit">Image © Schaublin SA</div>
            </div>
          </div>
          <div class="photo-card">
            <img src="http://www.schaublin.ch/img/custom/ods/srs.jpg"
                 alt="Schaublin SRS runout adjustment collet chuck system"
                 onerror="this.style.background='#f5f5f3'">
            <div class="photo-card-body">
              <div class="photo-card-title">Schaublin SRS collet chuck</div>
              <div class="photo-card-desc">The SRS (Runout Adjustment System) allows micro-adjustment of concentricity. Critical for secondary operations on already-machined surfaces.</div>
              <div class="photo-card-credit">Image © Schaublin SA</div>
            </div>
          </div>
        </div>

        <div class="schaublin-section">
          <div class="schaublin-header">
            <i class="ti ti-award" style="font-size:20px;color:var(--teal-100)"></i>
            <div>
              <div class="schaublin-header-text">Schaublin SA — Swiss precision tooling</div>
              <div class="schaublin-header-sub">Founded 1915 · Delémont, Switzerland · RBC Bearings Group</div>
            </div>
            <span class="schaublin-badge">Swiss Made</span>
          </div>
          <div class="schaublin-grid">
            <div class="schaublin-item">
              <img src="http://www.schaublin.ch/img/custom/ods/sermat.jpg" alt="Schaublin material tightening collets">
              <div class="schaublin-item-title">Material tightening collets</div>
              <div class="schaublin-item-desc">W, B and ESX-series collets for gripping bar stock in lathes and Swiss-type machines. Available in drawback (pull) and dead-length (thrust) types.</div>
            </div>
            <div class="schaublin-item">
              <img src="http://www.schaublin.ch/img/custom/ods/srs.jpg" alt="Schaublin SRS runout adjustment system">
              <div class="schaublin-item-title">SRS runout adjustment chuck</div>
              <div class="schaublin-item-desc">Patented system allowing the operator to dial in concentricity at the collet, achieving sub-micron runout for grinding and finish turning applications.</div>
            </div>
            <div class="schaublin-item">
              <img src="http://www.schaublin.ch/img/custom/ods/serout.jpg" alt="Schaublin tool holders">
              <div class="schaublin-item-title">Tool holders</div>
              <div class="schaublin-item-desc">ISO, HSK and proprietary Schaublin-standard tool holders for turrets and spindles. Compatible with VDI and BMT turret interfaces.</div>
            </div>
            <div class="schaublin-item">
              <img src="http://www.schaublin.ch/img/custom/ods/seracc.jpg" alt="Schaublin accessories">
              <div class="schaublin-item-title">Derivatives &amp; accessories</div>
              <div class="schaublin-item-desc">Collet-bodied accessories including special-form gripping jaws, adapters and blanks for custom clamping applications in secondary spindles.</div>
            </div>
          </div>
        </div>

        <div class="callout">
          <div class="callout-icon"><i class="ti ti-star"></i></div>
          <div class="callout-text">
            <strong>Why precision workholding matters</strong>
            Even 0.01 mm of runout at the chuck can produce out-of-tolerance parts. Schaublin's W-series collets hold tolerances to within a few microns, making them the standard choice for watchmaking, medical, and aerospace component turning.
          </div>
        </div>

        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" onclick="changeSlide(-1)"><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" onclick="changeSlide(1)">Next <i class="ti ti-arrow-right"></i></button>
        </div>
      </div>

      <!-- Slide 4: Operations -->
      <div class="slide" id="slide4">
        <div class="module-tag"><i class="ti ti-tool" style="font-size:11px"></i> Operations</div>
        <h1>Common CNC Lathe Operations</h1>
        <p class="lead">A CNC lathe can perform many different machining operations in a single setup, switching tools automatically via the turret.</p>

        <div class="ops-grid">
          <div class="op-card"><span class="op-tag" style="background:#E1F5EE;color:#085041">Diameter</span><div class="op-name">Turning</div><div class="op-desc">Reduces outer diameter by feeding the tool in Z (parallel to the axis).</div></div>
          <div class="op-card"><span class="op-tag" style="background:#EEEDFE;color:#26215C">Face</span><div class="op-name">Facing</div><div class="op-desc">Creates a flat end surface perpendicular to the axis, by feeding in X.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#E6F1FB;color:#042C53">Bore</span><div class="op-name">Boring</div><div class="op-desc">Enlarges and finishes an existing hole with a boring bar, improving diameter accuracy and surface finish.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#FAEEDA;color:#412402">Thread</span><div class="op-name">Threading</div><div class="op-desc">Cuts external or internal threads using a thread insert and synchronised Z-axis movement to spindle rotation.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#FAECE7;color:#4A1B0C">Separate</span><div class="op-name">Parting</div><div class="op-desc">Severs the finished part from bar stock using a narrow parting blade fed in X to the centreline.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#EAF3DE;color:#173404">Taper</span><div class="op-name">Taper Turning</div><div class="op-desc">Produces a conical surface using simultaneous X and Z movement (interpolation).</div></div>
          <div class="op-card"><span class="op-tag" style="background:#E1F5EE;color:#04342C">Finish</span><div class="op-name">Knurling</div><div class="op-desc">Rolls a cross-hatch grip pattern onto the surface with hardened knurling wheels.</div></div>
          <div class="op-card"><span class="op-tag" style="background:#E6F1FB;color:#0C447C">Hole</span><div class="op-name">Drilling</div><div class="op-desc">Drills a centre-axis hole by advancing a drill bit held in the turret or tailstock.</div></div>
        </div>

        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" onclick="changeSlide(-1)"><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" onclick="changeSlide(1)">Next <i class="ti ti-arrow-right"></i></button>
        </div>
      </div>

      <!-- Slide 5: Safety -->
      <div class="slide" id="slide5">
        <div class="module-tag"><i class="ti ti-shield-check" style="font-size:11px"></i> Safety</div>
        <h1>Essential Safety Rules</h1>
        <p class="lead">CNC lathes are powerful, fast and enclosed — but hazards still exist during setup, tool changes and maintenance. Always follow these rules.</p>
        <div class="safety-list">
          <div class="safety-item"><div class="safety-icon" style="color:#D85A30"><i class="ti ti-eye"></i></div><div class="safety-text"><strong>Always wear safety glasses.</strong> Chips and coolant can be ejected at speed when the guard is open during setup or tool change.</div></div>
          <div class="safety-item"><div class="safety-icon" style="color:#D85A30"><i class="ti ti-shirt-off"></i></div><div class="safety-text"><strong>No loose clothing, gloves, or jewellery.</strong> Even on a CNC machine, access to the spindle zone during setup carries entanglement risk.</div></div>
          <div class="safety-item"><div class="safety-icon" style="color:#BA7517"><i class="ti ti-key"></i></div><div class="safety-text"><strong>Use the correct torque for tooling.</strong> Under-torqued tool holders will pull out under cutting forces. Always use the specified torque values for VDI, BMT and collet chuck fasteners.</div></div>
          <div class="safety-item"><div class="safety-icon" style="color:#BA7517"><i class="ti ti-hand-stop"></i></div><div class="safety-text"><strong>Never reach into the work zone with the door open and spindle running.</strong> The door interlock should always be operational. Never bypass it.</div></div>
          <div class="safety-item"><div class="safety-icon" style="color:#1D9E75"><i class="ti ti-ruler-2"></i></div><div class="safety-text"><strong>Check clearance before running a new program.</strong> Use single-block mode and feedrate override at 0% to step through the first cycle and verify no collision with the chuck, turret, or tailstock.</div></div>
          <div class="safety-item"><div class="safety-icon" style="color:#1D9E75"><i class="ti ti-adjustments-alt"></i></div><div class="safety-text"><strong>Verify tool offsets before cutting.</strong> Incorrect tool length or radius offsets are a leading cause of crashes and scrapped parts. Always confirm offsets with a test cut or touch-off cycle.</div></div>
          <div class="safety-item"><div class="safety-icon" style="color:#534AB7"><i class="ti ti-circles-relation"></i></div><div class="safety-text"><strong>Support long bar stock properly.</strong> Bar extending more than 3× its diameter beyond the chuck requires a bar feeder, steady rest, or tailstock support to prevent dangerous whipping at speed.</div></div>
        </div>
        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" onclick="changeSlide(-1)"><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" onclick="changeSlide(1)">Next <i class="ti ti-arrow-right"></i></button>
        </div>
      </div>

      <!-- Slide 6: Quiz -->
      <div class="slide" id="slide6">
        <div class="module-tag"><i class="ti ti-list-check" style="font-size:11px"></i> Knowledge Check</div>
        <h1>Check Your Understanding</h1>
        <p class="lead">Answer these questions based on what you've just learned.</p>

        <div class="quiz-section">
          <div class="quiz-q">1. What is the primary function of the turret on a CNC lathe?</div>
          <div class="quiz-options">
            <button class="quiz-opt" onclick="answer(this,'q1',false)">To hold and rotate the workpiece</button>
            <button class="quiz-opt" onclick="answer(this,'q1',true)">To hold multiple cutting tools and index between them automatically</button>
            <button class="quiz-opt" onclick="answer(this,'q1',false)">To support the right end of long workpieces</button>
            <button class="quiz-opt" onclick="answer(this,'q1',false)">To execute the G-code program</button>
          </div>
          <div class="quiz-feedback" id="q1-fb"></div>
        </div>

        <div class="section-divider"></div>

        <div class="quiz-section">
          <div class="quiz-q">2. What advantage does a Schaublin SRS collet chuck offer over a standard 3-jaw chuck?</div>
          <div class="quiz-options">
            <button class="quiz-opt" onclick="answer(this,'q2',false)">It can grip larger diameter workpieces</button>
            <button class="quiz-opt" onclick="answer(this,'q2',false)">It operates at higher spindle speeds</button>
            <button class="quiz-opt" onclick="answer(this,'q2',true)">It allows micro-adjustment of runout concentricity for ultra-precise workholding</button>
            <button class="quiz-opt" onclick="answer(this,'q2',false)">It automatically changes to different jaw sizes</button>
          </div>
          <div class="quiz-feedback" id="q2-fb"></div>
        </div>

        <div class="section-divider"></div>

        <div class="quiz-section">
          <div class="quiz-q">3. Which safety procedure is correct when running a new CNC lathe program for the first time?</div>
          <div class="quiz-options">
            <button class="quiz-opt" onclick="answer(this,'q3',false)">Run it at full speed to check cycle time</button>
            <button class="quiz-opt" onclick="answer(this,'q3',true)">Use single-block mode with feedrate override at 0% to step through and verify clearances</button>
            <button class="quiz-opt" onclick="answer(this,'q3',false)">Open the guard door to watch the tool path</button>
            <button class="quiz-opt" onclick="answer(this,'q3',false)">Trust the simulation — no dry run is needed</button>
          </div>
          <div class="quiz-feedback" id="q3-fb"></div>
        </div>

        <div class="section-divider"></div>

        <div class="quiz-section">
          <div class="quiz-q">4. What is a "dead-length" or "thrust-type" collet?</div>
          <div class="quiz-options">
            <button class="quiz-opt" onclick="answer(this,'q4',false)">A collet that pulls the workpiece back into the spindle as it closes</button>
            <button class="quiz-opt" onclick="answer(this,'q4',true)">A collet where closing force is applied axially but the workpiece position does not move — ensuring consistent Z-axis location</button>
            <button class="quiz-opt" onclick="answer(this,'q4',false)">A collet that grips only on the outer diameter</button>
            <button class="quiz-opt" onclick="answer(this,'q4',false)">A single-use collet that is replaced after each part</button>
          </div>
          <div class="quiz-feedback" id="q4-fb"></div>
        </div>

        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" onclick="changeSlide(-1)"><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" onclick="changeSlide(1)">See Results <i class="ti ti-arrow-right"></i></button>
        </div>
      </div>

      <!-- Slide 7: Complete -->
      <div class="slide" id="slide7">
        <div class="complete-screen">
          <div class="complete-icon"><i class="ti ti-award"></i></div>
          <h1>Module 1 Complete!</h1>
          <p class="complete-text">You've finished CNC Lathe Basics — covering the major components, turret &amp; tooling systems, Schaublin precision workholding, eight common operations, and CNC-specific safety rules.</p>
          <div class="score-badge" id="scoreDisplay">Quiz: – / 4</div>
          <p class="complete-text" style="margin-bottom:0.5rem">What would you like to tackle next?</p>
          <div class="next-modules">
            <a class="next-btn" href="#"><i class="ti ti-cut"></i> Cutting Tools &amp; Insert Geometry</a>
            <a class="next-btn" href="#"><i class="ti ti-gauge"></i> Speeds, Feeds &amp; Depth of Cut</a>
            <a class="next-btn" href="#"><i class="ti ti-adjustments"></i> Advanced Workholding</a>
            <a class="next-btn" href="#" onclick="goTo(0);return false;"><i class="ti ti-refresh"></i> Restart Module</a>
          </div>
        </div>
        <div class="nav-controls">
          <button class="nav-btn nav-btn-ghost" onclick="changeSlide(-1)"><i class="ti ti-arrow-left"></i> Previous</button>
          <button class="nav-btn nav-btn-primary" disabled style="opacity:0.3">All done <i class="ti ti-check"></i></button>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
const TOTAL = 8;
let current = 0;
let quizScore = 0;
let answered = {};
let visited = new Set([0]);

const partData = [
  { title:"Headstock", text:"The headstock is the primary power unit of the CNC lathe. It contains the main spindle, drive motor (usually a servo or AC spindle motor), gearbox, and the spindle nose where the chuck or collet chuck is mounted. On CNC lathes the spindle speed is programmable via S-code in the G-code program. The spindle bore allows bar stock to pass through from a bar feeder." },
  { title:"Spindle / Chuck", text:"The spindle is the rotating shaft that drives the workpiece. Mounted on its nose is the workholding device — most commonly a 3-jaw hydraulic chuck for general work, or a collet chuck for high-precision applications. The chuck is actuated by a draw tube running through the spindle, connected to a hydraulic or pneumatic cylinder. Collet chucks such as Schaublin's W-series offer far lower runout than jaw chucks." },
  { title:"Bed", text:"The bed is the structural backbone of the machine, cast from high-quality Meehanite iron or polymer concrete for vibration damping. Most CNC lathes use a slant-bed design (typically 45° or 60°), which positions the turret above the workpiece, improving chip fall-away, reducing the machine's footprint, and enabling easy operator access. The linear guide-ways are hardened and ground to sub-micron tolerances." },
  { title:"Carriage / Slide", text:"The CNC lathe carriage moves in two servo-controlled axes: Z (along the bed, parallel to the spindle axis) and X (perpendicular, setting the cutting diameter). Ball screws driven by servo motors move the slides. On turn-mill centres a Y-axis (vertical cross) is also present. The position resolution of modern CNC slides is typically 0.0001 mm (0.1 µm)." },
  { title:"Turret", text:"The turret is an indexable tool magazine mounted on the carriage. It holds 8, 10, or 12 tool stations and rotates to position any tool at the cutting point in under a second. VDI and BMT are the two dominant interface standards. Live tool turrets include driven spindles in each station, enabling milling, drilling off-centre, and polygon turning — making the machine a full turn-mill centre." },
  { title:"Tailstock", text:"The tailstock is located on the far right of the machine and can slide along the bed to accommodate different workpiece lengths. It holds a live centre to support the right end of slender or long workpieces, preventing deflection under cutting forces. On CNC machines the tailstock can often be programmed to advance and retract automatically, and may also hold a drill chuck for axial drilling." },
  { title:"CNC Controller", text:"The CNC controller is the machine's brain. It reads and executes the machining program (G-code / M-code), commanding the servo drives for each axis, the spindle motor, the tool turret, coolant, and auxiliaries. Common controllers include Fanuc, Siemens Sinumerik, Mitsubishi, and Heidenhain. The operator interacts with the machine via the control panel's MDI keyboard and screen." },
  { title:"Coolant System", text:"The coolant system pumps cutting fluid (typically water-soluble oil) to the cutting zone to cool tools and workpiece, lubricate the cut, and flush chips away. Modern CNC lathes often include through-tool coolant (high-pressure coolant through the turret and tool holder to the cutting edge), chip conveyors, and coolant filtration/recycling systems. Coolant pressure can range from 20 bar for standard work to 70+ bar for deep-hole drilling." }
];

const feedbacks = {
  q1:{ correct:"Correct! The turret holds multiple cutting tools and indexes automatically under program control — the key feature that makes CNC lathes so versatile.", wrong:"Not quite. The turret is the tool-holding magazine that rotates to present each cutting tool in turn. The chuck holds the workpiece; the tailstock supports it; the controller runs the program." },
  q2:{ correct:"Correct! The SRS (Runout Adjustment System) allows the operator to micro-adjust concentricity at the collet, achieving sub-micron runout — critical for grinding and precision turning.", wrong:"Not quite. The SRS's key advantage is its built-in runout adjustment, which allows operators to dial in concentricity far beyond what a standard chuck can achieve." },
  q3:{ correct:"Correct! Single-block mode with feedrate override at 0% lets you step through each line of code, verifying tool paths before any cutting occurs — the standard safe first-run procedure.", wrong:"Not quite. Always use single-block mode with feedrate override at 0% for first-run verification. This lets you pause the program at every block and confirm clearances before any movement occurs." },
  q4:{ correct:"Correct! In a dead-length (thrust-type) collet, the workpiece does not move axially as the collet closes. This ensures every part is at exactly the same Z-axis datum — critical for length consistency in production.", wrong:"Not quite. A dead-length collet grips the workpiece without pulling it back in Z, so every part is located at the same axial position. This is contrast to pull-back collets, which draw the workpiece into the spindle as they close." }
};

function selectPart(idx) {
  document.querySelectorAll('.part-card').forEach((c,i) => c.classList.toggle('selected', i===idx));
  document.getElementById('partInfoTitle').textContent = partData[idx].title;
  document.getElementById('partInfoText').textContent = partData[idx].text;
}

function answer(btn, qid, correct) {
  if (answered[qid]) return;
  answered[qid] = true;
  const section = btn.closest('.quiz-section');
  const buttons = section.querySelectorAll('.quiz-opt');
  buttons.forEach(b => b.disabled = true);
  btn.classList.add(correct ? 'correct' : 'wrong');
  if (correct) { quizScore++; }
  else { buttons.forEach(b => { if (b.getAttribute('onclick') && b.getAttribute('onclick').includes(',true)')) b.classList.add('correct'); }); }
  const fb = document.getElementById(qid+'-fb');
  fb.textContent = (correct ? '✓ ' : '✗ ') + feedbacks[qid][correct ? 'correct' : 'wrong'];
  fb.className = 'quiz-feedback show ' + (correct ? 'correct' : 'wrong');
}

function updateUI() {
  for (let i = 0; i < TOTAL; i++) {
    const nav = document.getElementById('nav'+i);
    nav.classList.remove('active','done');
    if (i === current) nav.classList.add('active');
    else if (visited.has(i)) nav.classList.add('done');
  }
  const pct = Math.round((visited.size / TOTAL) * 100);
  document.getElementById('progressFill').style.width = pct+'%';
  document.getElementById('progressLabel').textContent = pct+'% complete';
  document.getElementById('slideCount').textContent = (current+1)+' of '+TOTAL;
}

function goTo(idx) {
  document.getElementById('slide'+current).classList.remove('active');
  current = idx;
  visited.add(idx);
  document.getElementById('slide'+current).classList.add('active');
  window.scrollTo({ top: 0, behavior: 'smooth' });
  if (current === 7) document.getElementById('scoreDisplay').textContent = 'Quiz: '+quizScore+' / 4';
  updateUI();
}

function changeSlide(dir) {
  const next = current + dir;
  if (next < 0 || next >= TOTAL) return;
  goTo(next);
}

updateUI();
</script>
</body>
</html>
