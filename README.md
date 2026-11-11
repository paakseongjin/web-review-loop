# web-review-loop — 웹사이트 전용 코드리뷰 루프 스킬팩

버전 1.0.0 · Claude Code / Cursor 양쪽 대응 · HTML/CSS/JS 웹사이트 전용

앞선 `review-loop`(일반·서버 포함용)의 웹사이트 특화판입니다.
코드를 읽지 못하는 운영자를 전제로 설계했습니다. 화면 동작은 렌더링·측정 결과로, 코드와 구조는 소스 및 관련 근거로 확인합니다.

## 무엇이 다른가 (일반 review-loop 대비)

- **렌더링 우선**: 선정한 범위의 페이지를 데스크톱 1440 / 태블릿 768 / 모바일 390px로
  실제로 열어 스크린샷과 콘솔 오류를 증거로 남깁니다. 렌더링을 못 한 리뷰는
  판정이 "조건부"로 상한이 걸립니다.
- **무설치 정적 검사기 내장**: Node로 HTML 소스의 점검 후보를 찾습니다.
  정규식 기반이므로 오탐과 누락이 있고, 경고는 실제 화면이나 파서로
  확인해야 합니다. HTML이 없으면 미검사로 처리합니다.
- **웹 전용 렌즈 11종**: HTML 시맨틱, CSS·반응형, JS 동작·안전, 접근성
  (WCAG 2.2 AA), 성능(Core Web Vitals 예산: LCP ≤ 2.5초, INP ≤ 200ms,
  CLS ≤ 0.1), SEO·공유 미리보기, 클라이언트 보안·개인정보, 폼·사용자 흐름,
  콘텐츠 무결성(가격·연락처가 운영자 원본과 일치하는지), 자산·링크·서드파티.
- **평문 용어사전 내장**: 판정 보고서에 나오는 용어(콘솔 오류, 혼합 콘텐츠,
  클라이언트에 노출된 비밀키 등)를 비개발자 언어로 풀어 주는
  `references/plain-language-glossary.md`를 함께 제공합니다.
- **점수 사기 방지 규칙**: alt나 메타 태그를 지워서 검사·점수를 통과시키는
  행위를 금지하고, 접근성 자동 점수 100점이어도 키보드·스크린리더 수동
  점검을 별도로 요구합니다(자동 검사는 WCAG 문제의 일부만 잡습니다).

## 설치

[상세 설치 안내](docs/INSTALL.md)에서 Windows와 macOS/Linux의 Cursor 스킬,
Claude Code 스킬, 로컬 플러그인, GitHub 마켓플레이스 설치와 갱신·삭제를
단계별로 확인할 수 있습니다. 설치 전 해당 앱과 Git이 필요합니다.

빠른 시작 (저장소를 내려받은 뒤 저장소 폴더에서 실행):

```powershell
# Windows PowerShell — 검토할 프로젝트 폴더를 지정합니다.
.\install.ps1 "C:\path\to\your-project" both
```

```bash
# macOS / Linux
bash install.sh /path/to/your-project both
```

`both`는 Claude Code와 Cursor에 모두 설치합니다. `claude` 또는 `cursor`를
지정하면 한쪽만 설치합니다. Cursor 설치 시 항상 적용되는 별도 규칙도
복사합니다. 이 규칙을 원하지 않으면 상세 안내의 수동 설치를 이용하세요.

Claude Code 플러그인으로 설치할 때는 명령 이름이 다릅니다.
프로젝트에 복사한 단독 스킬은 `/web-review-loop`, 플러그인 스킬은
`/web-review-loop:web-review-loop`입니다.

## 사용법

```
/web-review-loop                    현재 프로젝트의 사이트 전체 리뷰
/web-review-loop . business         경로 + 등급 지정
/web-review-loop https://… commerce 배포된 URL 기준 리뷰
```

등급: `showcase`(폼·로그인 없는 소개 사이트) · `business`(문의·예약 폼,
외부 위젯) · `commerce`(로그인·결제·개인정보 — 이 경우 서버/데이터 쪽은
일반 `review-loop` 병행 권장, 이 스킬의 판정은 프론트엔드 한정임을 명시).

단축 모드: "게이트만" / "빠른 리뷰"(홈 + 핵심 페이지 1곳, 부분 리뷰 명시).

## 구성

```
web-review-loop/
├── README.md
├── .claude-plugin/            plugin.json + marketplace.json
├── skills/web-review-loop/
│   ├── SKILL.md               본체: Phase 0~6 루프와 강제 규칙
│   ├── references/
│   │   ├── web-lenses.md              웹 리뷰 렌즈
│   │   ├── code-and-architecture.md   코드·구조·근거 검토
│   │   ├── web-gates.md               게이트 도구표
│   │   ├── evidence-and-severity.md   증거 형식·심각도·판정 매핑
│   │   └── plain-language-glossary.md 비개발자용 용어 풀이
│   ├── templates/
│   │   ├── site-spec.md               사이트 명세·페이지 목록 양식
│   │   ├── web-review-report.md       판정 보고서 양식
│   │   ├── fix-loop-log.md            수정 기록 양식
│   │   └── project-guardrails-web.md  AGENTS.md 상시 규칙 (웹용)
│   └── scripts/
│       ├── static-check.mjs   무의존 정적 검사 (Node만으로 실행)
│       └── web-gate.sh        프로젝트 빌드·린트·테스트 게이트
├── cursor/web-review-guardrails.mdc
├── examples/example-report.md
├── install.sh / install.ps1
└── validate.py
```

## 한계

- 렌더링·Lighthouse·접근성 스캔은 실행 환경(브라우저, 도구 설치 여부)에
  의존합니다. 못 돌린 검사는 보고서에 SKIPPED로 남습니다.
- 자동 접근성 검사는 실제 장벽의 일부만 탐지합니다. 수동 점검 항목이
  비어 있으면 그만큼 미검증입니다.
- 서버·DB·결제의 안전은 이 스킬의 범위가 아닙니다. `commerce` 등급은
  일반 review-loop 스킬과 사람 전문가 점검을 병행하십시오.

## 근거

Core Web Vitals 기준값은 web.dev 공식 기준(LCP 2.5초, INP 200ms,
CLS 0.1, 방문 75백분위)을 따릅니다. 접근성 자동 검사의 부분 탐지
한계는 axe-core/Lighthouse의 공개된 특성입니다. 전체 방법론의 배경
(기계 게이트 우선, 근거에 기반한 수정, 렌즈 분리)은 review-loop와
비슷합니다. 실측 INP는 현장 데이터로 판단하며 Lighthouse TBT는 진단용 대리지표입니다.
