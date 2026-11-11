#!/usr/bin/env node
// web-review-loop static check — zero dependencies, Node >= 18.
// Scans .html/.htm files in a project directory and reports
// heuristic candidates only. It does not parse or render pages;
// rendering checks belong to the browser phase of the skill.
//
// Usage: node static-check.mjs <project-dir> [--budget-kb 200]
// Exit: 0 = scan completed, 2 = no HTML files or invalid input. Findings require verification.
// FAIL = broken or harmful now. WARN = likely problem, human looks.

import { readdirSync, readFileSync, statSync, existsSync } from "node:fs";
import { join, dirname, resolve, extname } from "node:path";

const args = process.argv.slice(2);
const rootArg = args[0] && !args[0].startsWith("--") ? args[0] : ".";
const root = resolve(rootArg);
if (!existsSync(root) || !statSync(root).isDirectory()) {
  console.error("SKIPPED: project directory does not exist or is not a directory");
  process.exit(2);
}
const opt = (name, dflt) => {
  const i = args.indexOf(name);
  return i >= 0 ? Number(args[i + 1]) : dflt;
};
const BUDGET = opt("--budget-kb", 200) * 1024;
if (!Number.isFinite(BUDGET) || BUDGET <= 0) { console.error("Invalid --budget-kb"); process.exit(2); }

const findings = []; // {level, file, line, msg}
const add = (level, file, line, msg) => findings.push({ level, file, line, msg });

function* walk(dir) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    if (e.name.startsWith(".") || e.name === "node_modules" || e.name === "dist") continue;
    const p = join(dir, e.name);
    if (e.isDirectory()) yield* walk(p);
    else if (/\.html?$/i.test(e.name)) yield p;
  }
}
const lineOf = (text, idx) => text.slice(0, idx).split("\n").length;
const isLocal = (u) => u && !/^(https?:)?\/\//i.test(u) && !/^(data:|mailto:|tel:|#|javascript:)/i.test(u);
const cleanRef = (u) => u.split("#")[0].split("?")[0];

let files = 0;
for (const file of walk(root)) {
  files++;
  const html = readFileSync(file, "utf8");
  const rel = file.slice(root.length + 1);
  const dir = dirname(file);

  if (!/<html[^>]*\blang\s*=/i.test(html)) add("FAIL", rel, 1, "<html> has no lang attribute (screen readers/search get the language wrong)");
  if (!/<title[^>]*>[^<]+<\/title>/i.test(html)) add("FAIL", rel, 1, "missing or empty <title>");
  if (!/<meta[^>]*name\s*=\s*["']description["']/i.test(html)) add("WARN", rel, 1, "no meta description (search/chat share previews will be auto-generated)");
  if (!/<meta[^>]*name\s*=\s*["']viewport["']/i.test(html)) add("FAIL", rel, 1, "no viewport meta (mobile layout will be wrong)");

  const h1s = (html.match(/<h1[\s>]/gi) || []).length;
  if (h1s === 0) add("WARN", rel, 1, "no <h1> on the page");
  

  // duplicate ids
  const ids = new Map();
  for (const m of html.matchAll(/\bid\s*=\s*["']([^"']+)["']/gi)) {
    if (ids.has(m[1])) add("FAIL", rel, lineOf(html, m.index), `possible duplicate id (first at line ${ids.get(m[1])}); verify rendered DOM`);
    else ids.set(m[1], lineOf(html, m.index));
  }

  // images: alt, local existence, size budget
  for (const m of html.matchAll(/<img\b[^>]*>/gi)) {
    const tag = m[0], line = lineOf(html, m.index);
    if (!/\balt\s*=/i.test(tag)) add("FAIL", rel, line, "possible img without alt attribute; verify rendered DOM");
    const src = (tag.match(/\bsrc\s*=\s*["']([^"']+)["']/i) || [])[1];
    if (isLocal(src) && !src.startsWith("/") && !/[{}]/.test(src)) {
      const p = resolve(dir, cleanRef(src));
      if (!existsSync(p)) add("FAIL", rel, line, "possible missing relative image; verify routing and build output");
      else if (statSync(p).size > BUDGET) add("WARN", rel, line, `image over ${Math.round(BUDGET / 1024)}KB budget (${Math.round(statSync(p).size / 1024)}KB)`);
    }
  }

  // inline event handlers + javascript: urls
  for (const m of html.matchAll(/\son(click|change|submit|input|load|mouseover|keydown)\s*=/gi))
    add("WARN", rel, lineOf(html, m.index), `inline event handler "${m[0].trim()}" (hides behavior, fights CSP)`);
  for (const m of html.matchAll(/href\s*=\s*["']\s*javascript:/gi))
    add("FAIL", rel, lineOf(html, m.index), "javascript: URL in href");

  // HTTP subresources are only potential mixed content on a secure page.
  for (const m of html.matchAll(/<(?:script|img|iframe|link|audio|video|source)\b[^>]*\b(?:src|href)\s*=\s*["']http:\/\/[^"']+["'][^>]*>/gi))
    add("WARN", rel, lineOf(html, m.index), "HTTP subresource: check actual HTTPS deployment and browser behavior");

  // local references that must exist (a/link/script)
  for (const m of html.matchAll(/<(?:a|link|script)\b[^>]*>/gi)) {
    const tag = m[0];
    const ref = (tag.match(/\b(?:href|src)\s*=\s*["']([^"']+)["']/i) || [])[1];
    if (isLocal(ref) && cleanRef(ref) && !ref.startsWith("/") && !/[{}]/.test(ref)) {
      const target = resolve(dir, cleanRef(ref));
      const ok = existsSync(target) || existsSync(join(target, "index.html"));
      if (!ok) add("FAIL", rel, lineOf(html, m.index), "possible missing relative reference; verify routing and build output");
    }
  }

  // form inputs without labels (rough heuristic: id referenced by <label for>, or wrapped)
  const labelled = new Set([...html.matchAll(/<label[^>]*\bfor\s*=\s*["']([^"']+)["']/gi)].map(m => m[1]));
  for (const m of html.matchAll(/<(?:input|select|textarea)\b[^>]*>/gi)) {
    const tag = m[0];
    if (/type\s*=\s*["'](hidden|submit|button)["']/i.test(tag)) continue;
    const id = (tag.match(/\bid\s*=\s*["']([^"']+)["']/i) || [])[1];
    if (!id || !labelled.has(id)) add("WARN", rel, lineOf(html, m.index), "possible field without a label; check wrapping labels and accessible name in rendered DOM");
  }
}

if (!files) { console.log("SKIPPED: no HTML files found; framework output and routes were not checked"); process.exit(2); }
// Regex cannot distinguish templates, comments, generated markup, or routing.
// Every candidate needs manual verification; do not expose input values.
for (const finding of findings) finding.level = "WARN";
const fails = findings.filter(f => f.level === "FAIL");
const warns = findings.filter(f => f.level === "WARN");
console.log(`web-review static check — ${files} HTML file(s) under ${root}`);
for (const f of findings) console.log(`${f.level}  ${f.file}:${f.line}  ${f.msg}`);
console.log(`\nSummary: FAIL=${fails.length} WARN=${warns.length}`);
console.log("Heuristic scan only: warnings are not confirmed defects, and no warnings is not a pass.");
process.exit(0);
