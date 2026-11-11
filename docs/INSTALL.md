# 설치 및 사용 안내

이 스킬은 **Cursor와 Claude Code**에서 웹사이트 코드와 화면을 근거 중심으로 검토하는 안내문입니다. 스킬은 해당 앱의 기능이며 브라우저, 검사 도구, Node.js를 자동으로 설치하지 않습니다. Claude Code 플러그인과 Claude.ai 웹 채팅의 플러그인은 서로 다른 기능입니다. 이 문서는 Claude Code용입니다.

공식 설치·스킬 문서 확인일: 2026-11-11. 사용하는 앱의 버전이나 조직 정책에 따라 화면과 제공 기능은 달라질 수 있습니다.

## 1. 설치 전 준비

1. 사용할 Cursor 또는 Claude Code를 설치하고 로그인합니다. 최신 사용법은 [Cursor 스킬 문서](https://cursor.com/docs/skills), [Claude Code 스킬 문서](https://code.claude.com/docs/en/skills)를 참고하세요.
2. 이 GitHub 저장소의 **Code → Download ZIP**으로 내려받아 압축을 풀거나, Code 버튼에서 복사한 주소로 `git clone <복사한-저장소-주소>`를 실행합니다. Git은 clone에만 필요합니다.
3. 터미널을 열고 압축을 푼 이 저장소 폴더로 이동합니다. 아래 명령의 `C:\path\to\...`, `/path/to/...`는 예시이므로 실제 폴더 경로로 바꾸세요. Windows 경로에 공백이 있으면 큰따옴표로 감쌉니다.
4. 검토할 웹 프로젝트의 폴더를 확인합니다. `install.ps1`, `install.sh`는 **이 저장소**에 있고, 설치 대상은 **검토할 프로젝트** 폴더입니다.

자동 HTML 후보 검사는 Node.js 18 이상이 필요합니다. 브라우저 렌더링, Lighthouse, 접근성 검사는 별도 환경과 도구가 필요하며 실행하지 못하면 미검사로 기록합니다. 실제 메시지, 결제 또는 주문을 보내는 시험은 명시적 허가와 안전한 시험 환경 없이 수행하지 않습니다.

## 2. 프로젝트에 자동 설치 — Windows

PowerShell에서 이 저장소 폴더로 이동한 후 실행합니다.

```powershell
# 두 앱 모두에 설치
.\install.ps1 "C:\path\to\your-project" both

# 하나만 설치하려면 아래 중 하나를 실행
.\install.ps1 "C:\path\to\your-project" claude
.\install.ps1 "C:\path\to\your-project" cursor
```

PowerShell 실행 정책으로 차단되면 [Microsoft의 실행 정책 안내](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_execution_policies)를 확인하거나 아래 수동 복사를 사용하세요. 시스템 전체 실행 정책을 변경할 필요는 없습니다.

## 3. 프로젝트에 자동 설치 — macOS / Linux

터미널에서 이 저장소 폴더로 이동한 후 실행합니다.

```bash
bash install.sh /path/to/your-project both
# 또는: bash install.sh /path/to/your-project claude
# 또는: bash install.sh /path/to/your-project cursor
```

자동 설치 결과:

- `claude`: 대상 프로젝트의 `.claude/skills/`에 총괄 스킬과 전문 스킬 3개를 복사합니다.
- `cursor`: `.cursor/skills/`에 총괄 스킬과 전문 스킬 3개를 복사하고 `.cursor/rules/web-review-guardrails.mdc`에 **항상 적용되는 규칙**도 추가합니다. 이 규칙은 스킬을 호출하지 않아도 프로젝트 작업에 영향을 줄 수 있습니다. 규칙을 원하지 않으면 아래 수동 설치를 사용하세요.
- `both`: 위 두 작업을 수행합니다. 기존 같은 이름은 타임스탬프가 붙은 `.bak-...`로 이동됩니다. 복사 전에 프로젝트 상태를 확인하고 백업 파일도 검토하세요. 경로가 올바른지 확인하세요.

## 4. 수동 설치 — 프로젝트 또는 개인용

파일 관리자에서 이 저장소의 `skills/` 안에 있는 `web-review-loop`, `web-review-experience`, `web-review-code`, `web-review-measurement` 폴더 **4개 전체**를 대상 `skills/` 폴더에 나란히 복사합니다. `SKILL.md` 한 파일만 복사하면 참조 자료와 전문 스킬을 사용할 수 없습니다. 같은 이름의 기존 폴더가 있다면 덮어쓰기 전에 백업하세요.

- Cursor의 현재 프로젝트만: `<프로젝트>/.cursor/skills/`
- Cursor의 현재 사용자: `~/.cursor/skills/`
- Claude Code의 현재 프로젝트만: `<프로젝트>/.claude/skills/`
- Claude Code의 현재 사용자: `~/.claude/skills/`

`~`는 사용자 홈 폴더입니다. Windows에서는 보통 파일 탐색기 주소창에 `%USERPROFILE%`을 입력해 홈 폴더를 열 수 있습니다. 숨김 폴더가 안 보이면 파일 탐색기의 숨긴 항목 표시를 켭니다. 설치 후 4개 폴더가 같은 `skills/` 바로 아래 있는지, `web-review-loop`에 `SKILL.md`, `references`, `templates`, `scripts`가 있는지 확인하세요. 프로젝트 설치는 해당 프로젝트에만 적용되고, 개인 설치는 해당 앱의 로컬 사용자 범위에 적용됩니다. 클라우드 세션에 자동으로 복사된다고 가정하지 마세요.

Cursor 공식 문서에 따르면 Cursor는 `.claude/skills/`도 호환 경로로 읽습니다. 따라서 `both`로 설치하거나 두 경로에 같은 스킬을 따로 복사하면 같은 이름이 중복 발견될 수 있습니다. Cursor의 [스킬 경로 안내](https://cursor.com/docs/skills)를 확인하고, 중복이 문제가 되면 사용할 설치 위치를 하나로 정리하세요. `~/.cursor/skills/`의 개인 스킬은 별도로 동기화해야 Cloud Agents에서 사용할 수 있습니다.

Cursor에서 개인 스킬 하나를 팀에 게시하는 기능은 그 스킬이 참조하는 다른 스킬을 자동으로 묶지 않습니다. 이 스킬팩의 네 폴더 간 참조를 유지하려면 네 폴더를 함께 설치하거나 전체 플러그인으로 배포하세요. [Cursor 플러그인 문서](https://cursor.com/docs/plugins)를 참고하세요.

수동 설치는 Cursor의 상시 규칙을 추가하지 않습니다. 규칙을 원하는 경우에만 이 저장소의 `cursor/web-review-guardrails.mdc`를 프로젝트의 `.cursor/rules/`로 복사하세요.

### Cursor 로컬 플러그인

이 저장소는 루트 `plugin.json`을 제공하는 Agent Plugin이기도 합니다. 전체 저장소 폴더를 `~/.cursor/plugins/local/web-review-loop/`에 복사하고 Cursor를 재시작하거나 Developer: Reload Window를 실행한 뒤 Customize에서 구성요소를 확인하세요. 로컬 플러그인 가져오기 허용 여부는 조직 설정에 따라 달라집니다. 로컬 플러그인 폴더 밖 저장소를 가리키는 심볼릭 링크는 사용할 수 없으므로 전체 폴더를 복사하세요. [Cursor 공식 안내](https://cursor.com/docs/plugins)를 참고하세요. 이 방법과 직접 스킬 복사 중 한 가지를 선택해 중복 설치를 피하세요.

## 5. Claude Code 로컬 플러그인으로 실행

터미널에서 검토할 프로젝트로 이동한 다음, 압축을 푼 이 저장소 **루트**를 지정해 Claude Code를 시작합니다. 경로는 예시입니다.

```powershell
# Windows
claude --plugin-dir "C:\path\to\web-review-loop"
```

```bash
# macOS / Linux
claude --plugin-dir /path/to/web-review-loop
```

Claude Code 대화창에 `/web-review-loop:web-review-loop`를 입력합니다. 이 방식은 해당 실행에서 로컬 디렉터리를 불러오는 방식이며 영구 설치와 다릅니다. 매번 옵션으로 시작하거나 아래 마켓플레이스 방법을 쓰세요. 플러그인 이름과 스킬 이름이 같으므로 이름이 반복됩니다. [Claude Code 플러그인 문서](https://code.claude.com/docs/en/plugins)를 참고하세요.

## 6. Claude Code 마켓플레이스로 설치

### GitHub에서 설치

터미널에서 아래 명령을 실행합니다. GitHub 저장소 페이지의 주소 `https://github.com/OWNER/REPO`에서 `OWNER/REPO`를 확인해 바꿔 넣으세요. 꺾쇠는 입력하지 않습니다.

```bash
claude plugin marketplace add OWNER/REPO
claude plugin install web-review-loop@web-review-loop-local
claude plugin list
```

Claude Code를 시작하거나 재시작한 뒤 대화창에서 `/web-review-loop:web-review-loop`를 실행합니다. 플러그인 목록에서 enabled 상태인지 확인합니다.

### 내 컴퓨터에 내려받은 저장소에서 설치

```powershell
# Windows: 저장소가 들어 있는 실제 폴더로 바꾸세요.
claude plugin marketplace add "C:\path\to\web-review-loop"
claude plugin install web-review-loop@web-review-loop-local
claude plugin list
```

macOS / Linux에서는 첫 명령을 `claude plugin marketplace add /path/to/web-review-loop`로 실행합니다. Claude Code 대화창에서는 각각 `/plugin marketplace add <경로>`와 `/plugin install web-review-loop@web-review-loop-local`을 사용할 수도 있습니다. 이때 설치 화면에서 설치를 완료해야 합니다. [마켓플레이스 공식 안내](https://code.claude.com/docs/en/plugin-marketplaces)를 참고하세요.

## 7. 설치 확인과 일상 사용

1. 검토할 프로젝트를 Cursor 또는 Claude Code에서 엽니다.
2. 단독 스킬을 복사했다면 대화창에 `/web-review-loop`를, Claude Code 플러그인으로 불러왔다면 `/web-review-loop:web-review-loop`를 입력합니다. Cursor에서는 Customize → Skills에서 검색할 수 있습니다.
3. 총괄 스킬을 한 번 호출하면 접근성·코드·측정 전문 스킬의 지침을 차례로 적용하고 결과를 취합합니다. 도구가 없으면 해당 검사는 미검증으로 남습니다. 예를 들어 `현재 웹사이트를 리뷰만 해줘. 수정하지 말고 방문자에게 생기는 문제, 근거와 수정 제안을 쉽게 설명해줘.`라고 요청합니다. 수정까지 원하면 `확인된 문제를 수정하고 다시 검사해줘`라고 명시합니다.
4. 보고서에서 **확인된 문제**, **가능성**, **개선 제안**, **검사하지 못한 부분**을 확인합니다. 자동 접근성 점수나 정적 검사만으로 전체 접근성·보안을 보증하지 않습니다.

개발·수정 요청이 있으면 요청된 범위를 구현하거나 고치고 관련 동작을 검증합니다. 리뷰만 요청하면 파일을 수정하지 않습니다. 서버·API·데이터와 공식 근거를 확인할 수 없으면 미검증으로 보고합니다.

수정 요청이 있는 경우 최초 리뷰를 포함해 기본 최대 3라운드이며, 문제별 수정도 기본 최대 3회 시도합니다. 어느 한 제한에 도달하거나 안전한 방법이 없으면 해당 자동 반복을 멈추고 미해결 사항을 보고합니다. 다른 횟수를 원하면 요청에 명시하세요. 브라우저나 검사 도구가 없으면 해당 검사는 `SKIPPED` 또는 `UNVERIFIED`로 기록됩니다. 화면 폭·주요 기능 등의 기본 검사 조건은 [검증 안내](../skills/web-review-loop/references/web-gates.md)를 참고하세요.

스킬이 보이지 않으면 설치한 앱과 프로젝트, 네 폴더의 `SKILL.md` 위치를 확인하고 앱을 재시작하세요. Claude Code는 `claude plugin list`, `claude plugin details web-review-loop`, `claude plugin validate <저장소-경로>`로 플러그인 상태를 확인할 수 있습니다. 이 저장소 루트에서 정적 검사만 실행하려면 `node skills/web-review-loop/scripts/static-check.mjs <프로젝트-경로>`를 사용하세요. HTML이 없으면 미검사입니다. 정적 검사 종료 코드 0은 검사 실행을 뜻할 뿐 사이트 합격이 아닙니다.

프로젝트의 빌드·린트·테스트 등은 실행 전에 명령의 외부 부작용을 확인하세요. `bash skills/web-review-loop/scripts/web-gate.sh <프로젝트-경로>`는 비밀값 노출을 줄이기 위해 원본 출력을 표시하지 않습니다. 종료 코드 0은 하나 이상 실행되어 실패가 없음을, 1은 실행된 검사 실패를, 2는 실행된 검사가 없음을 뜻합니다. 0도 웹사이트 전체의 합격을 의미하지 않습니다. 실패 원문을 확인할 때는 안전한 로컬 환경에서 직접 확인하고 공유 전에 민감정보를 제거하세요.

## 8. 갱신 및 제거

- **직접 복사 / 자동 설치:** 최신 저장소를 다시 내려받고 전체 스킬 폴더를 다시 복사하거나 설치 스크립트를 다시 실행합니다. 기존 폴더의 사용자 수정 내용을 먼저 백업하세요.
- **플러그인:** `claude plugin marketplace update web-review-loop-local`로 목록을 갱신하고, Claude Code의 플러그인 메뉴 또는 공식 안내에 따라 플러그인을 갱신하고 새 세션을 시작하거나 `/reload-plugins`를 실행합니다. 호스팅된 마켓플레이스 설치본은 캐시된 복사본이므로 마켓플레이스 목록 갱신만으로 새 내용이 적용됐다고 가정하지 말고 설치된 버전을 확인하세요. 로컬 `--plugin-dir` 방식은 원본 폴더를 갱신한 뒤 다시 시작합니다.
- **제거:** 직접 설치한 4개 스킬 폴더를 삭제합니다. 자동 설치 시 추가된 `.cursor/rules/web-review-guardrails.mdc`가 더 이상 필요하지 않으면 별도로 삭제합니다. 백업 폴더는 사용자가 확인한 후 처리하세요. 플러그인은 `claude plugin uninstall web-review-loop@web-review-loop-local`로 제거하며, 마켓플레이스 제거는 `claude plugin marketplace remove web-review-loop-local`을 사용합니다.

검사 로그와 스크린샷에 개인 정보나 비밀값이 포함될 수 있으므로 외부에 공유하기 전에 직접 확인하세요.
