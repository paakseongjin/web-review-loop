# web-review-loop — 웹사이트 전용 코드리뷰 루프 스킬팩

버전 1.1.0 · Claude Code / Cursor 양쪽 대응 · HTML/CSS/JS 웹사이트 전용

웹사이트와 웹 애플리케이션을 위한 근거 기반 리뷰 스킬입니다.
코드를 읽지 못하는 운영자를 전제로 설계했습니다. 화면 동작은 렌더링·측정 결과로, 코드와 구조는 소스 및 관련 근거로 확인합니다.

## 무엇을 하나요?

- **렌더링 우선**: 선정한 범위의 페이지를 데스크톱 1440 / 태블릿 768 / 모바일 390px로
  실제로 열어 스크린샷과 콘솔 오류를 증거로 남깁니다. 렌더링을 못 한 리뷰는
  판정이 "조건부"로 상한이 걸립니다.
- **무설치 정적 검사기 내장**: Node로 HTML 소스의 점검 후보를 찾습니다.
  정규식 기반이므로 오탐과 누락이 있고, 경고는 실제 화면이나 파서로
  확인해야 합니다. HTML이 없으면 미검사로 처리합니다.
- **세 전문 스킬과 웹 검토 렌즈**: HTML 시맨틱, CSS·반응형, JS 동작·안전, 접근성
  (WCAG 2.2 AA), 성능(Core Web Vitals 예산: LCP ≤ 2.5초, INP ≤ 200ms,
  CLS ≤ 0.1), SEO·공유 미리보기, 클라이언트 보안·개인정보, 폼·사용자 흐름,
  콘텐츠 무결성(가격·연락처가 운영자 원본과 일치하는지), 자산·링크·서드파티,
  코드 유지보수성과 웹 구조를 검토합니다.
- **평문 용어사전 내장**: 판정 보고서에 나오는 용어(콘솔 오류, 혼합 콘텐츠,
  클라이언트에 노출된 비밀키 등)를 비개발자 언어로 풀어 주는
  `references/plain-language-glossary.md`를 함께 제공합니다.
- **점수 사기 방지 규칙**: alt나 메타 태그를 지워서 검사·점수를 통과시키는
  행위를 금지하고, 접근성 자동 점수 100점이어도 키보드·스크린리더 수동
  점검을 별도로 요구합니다(자동 검사는 WCAG 문제의 일부만 잡습니다).

## 설치

[상세 설치 안내](docs/INSTALL.md)에서 Windows와 macOS/Linux의 Cursor 스킬,
Claude Code 스킬, 로컬 플러그인, GitHub 마켓플레이스 설치와 갱신·삭제를
단계별로 확인할 수 있습니다. 사용할 앱이 필요하며 Git은 저장소를 clone할 때만 필요합니다.

빠른 시작 (저장소를 내려받은 뒤 저장소 폴더에서 실행):

```powershell
# Windows PowerShell — 검토할 프로젝트 폴더를 지정합니다.
.\install.ps1 "C:\path\to\your-project" both
```

```bash
# macOS / Linux
bash install.sh /path/to/your-project both
```

`both`는 Claude Code와 Cursor에 총괄 스킬과 세 전문 스킬을 모두 설치합니다. `claude` 또는 `cursor`를
지정하면 한쪽만 설치합니다. Cursor 설치 시 항상 적용되는 별도 규칙도
복사합니다. 이 규칙을 원하지 않으면 상세 안내의 수동 설치를 이용하세요.

Claude Code 플러그인으로 설치할 때는 명령 이름이 다릅니다.
프로젝트에 복사한 단독 스킬은 `/web-review-loop`, 플러그인 스킬은
`/web-review-loop:web-review-loop`입니다.

## 사용법

```
/web-review-loop                    현재 프로젝트의 범위를 정해 리뷰
/web-review-loop . business         경로 + 등급 지정
/web-review-loop https://… commerce 배포된 URL 기준 리뷰
```

등급: `showcase`(폼·로그인 없는 소개 사이트) · `business`(문의·예약 폼,
외부 위젯) · `commerce`(로그인·결제·계정 기능). 서버·데이터는 별도 검토가
필요하며 이 스킬의 판정은 프론트엔드 범위에 한정됩니다.

단축 모드: "게이트만" / "빠른 리뷰"(홈 + 핵심 페이지 1곳, 부분 리뷰 명시).

리뷰만 요청하면 파일을 수정하지 않습니다. 수정을 원하면 “확인된 문제를
수정하고 다시 검사해줘”라고 요청하세요. 보고서는 확인된 문제, 가능성,
개선 제안과 미검증 사항을 구분하고, 영향·근거·권장 조치를 쉬운 말로 설명합니다.

## 스킬 구성과 자동 진행

`web-review-loop`가 총괄 스킬입니다. 한 번 호출하면 범위를 정한 뒤 아래 세 전문 스킬의 지침을 순서대로 읽고 결과를 취합합니다. 부분 리뷰라면 해당 항목만 사용합니다.

- `web-review-experience`: 접근성·반응형 화면·방문자 흐름
- `web-review-code`: 코드 안전성·유지보수·웹 구조
- `web-review-measurement`: 검사 실행·성능 측정·검증 결과

설치만으로 사이트를 백그라운드에서 자동 검사하는 것은 아닙니다. 총괄 스킬을 호출하면 에이전트가 도구와 권한 범위 안에서 단계별로 진행합니다. 파일이나 도구가 없으면 해당 항목은 미검증으로 보고합니다. Claude Code 플러그인은 `/web-review-loop:web-review-loop`로 호출합니다. Cursor는 스킬로 설치하거나 아래 설치 안내의 로컬 플러그인 방식을 이용할 수 있습니다.

## 리뷰와 수정은 어떻게 진행되나요?

1. 요청과 프로젝트를 확인해 페이지·주요 기능·검사 범위와 통과 조건을 정합니다.
   동적으로 생기는 페이지가 많으면 대표 사례를 선정하고 제외한 범위를 밝힙니다.
2. 안전하게 실행 가능한 프로젝트 검사와 실제 브라우저 화면을 확인합니다.
   기본 화면 폭은 390·768·1440 CSS 픽셀이며 대상과 사용 환경에 맞춰 조정합니다.
   WCAG 재배치 점검은 별도로 320 CSS 픽셀 상당의 폭과 기준의 예외를 확인합니다.
   선택한 주요 동작을 안전하게 실행해 보고, 스크린샷만으로 동작을 확인했다고
   주장하지 않습니다. 사용할 도구가 없으면 `SKIPPED` 또는 `UNVERIFIED`로 남깁니다.
3. 확인한 근거와 적용 가능한 표준·공식 문서를 대조해 문제를 심각도순으로 정리합니다.
   기본 정적 검사는 후보를 찾는 도구이므로 경고나 종료 코드만으로 사이트의 합격을
   판정하지 않습니다. 프로젝트 검사 스크립트는 민감정보 노출을 줄이기 위해
   원본 출력을 숨기며, 아무 검사도 실행하지 못하면 종료 코드 2를 반환합니다.
   화면·접근성·보안 전체의 인증도 아닙니다.
4. 수정이 요청된 경우에만 관련 문제를 고치고 영향을 받은 동작과 검사를 다시 확인합니다.
   문제 하나에 대해 기본적으로 서로 다른 수정 방법을 최대 3회 시도합니다. 안전한
   방법이 없으면 더 일찍 멈추며, 해결되지 않은 항목은 `BLOCKED`로 기록하고 다른
   독립적인 작업을 계속합니다. 사용자가 지정한 횟수가 있으면 그 기준을 따릅니다.
5. 처리 결과와 남은 위험, 실행하지 못한 검사를 보고합니다. 실제 주문·결제·문의
   전송은 명시적 허가와 안전한 테스트 환경 없이 수행하지 않습니다.

실행 환경 선택과 기본 검증 항목은 [검증 안내](skills/web-review-loop/references/web-gates.md),
판정과 심각도는 [증거·심각도 기준](skills/web-review-loop/references/evidence-and-severity.md),
보고서 예시는 [예시 보고서](examples/example-report.md)를 참고하세요.

## 구성

```
web-review-loop/
├── README.md
├── plugin.json               Cursor 등 Agent Plugin용 매니페스트
├── .claude-plugin/            Claude Code 매니페스트 + marketplace.json
├── skills/web-review-experience/  접근성·화면·사용자 흐름
├── skills/web-review-code/        코드·보안·구조
├── skills/web-review-measurement/ 측정·실행·검증
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
  별도의 서버·데이터 보안 검토와 적절한 전문가 점검을 병행하십시오.

## 근거

Core Web Vitals 기준값은 web.dev 공식 기준(LCP 2.5초, INP 200ms,
CLS 0.1, 방문 75백분위)을 따릅니다. 접근성 자동 검사의 부분 탐지
한계는 axe-core/Lighthouse의 공개된 특성입니다. 실측 INP는 현장 데이터로
판단하며 Lighthouse TBT는 진단용 대리지표입니다. 관련 표준과 연구 자료는
[코드·구조 검토 지침](skills/web-review-loop/references/code-and-architecture.md)에 정리했습니다.
