# 🍃 하토피아 위키 (Heartopia Wiki) - 포트폴리오 및 이력서 가이드

이 문서는 `heartopia-wiki-project`의 실제 코드와 아키텍처를 분석하여, **GitHub README** 및 **이력서(트러블 슈팅 중심)**에 바로 활용할 수 있도록 정리된 문서입니다. 프로젝트의 객관적인 강점과 약점, 그리고 이를 해결해 나간 엔지니어링 과정이 포함되어 있습니다.

---

## 🛠 기술 스택 및 아키텍처
- **Backend:** Java 17, Spring Boot 3.4.2
- **Frontend:** Thymeleaf (SSR), Vanilla JavaScript (ES6+ Module Pattern), Leaflet.js
- **Database:** MySQL 8.0, MyBatis (SQL 제어 최적화)
- **Infra & DevOps:** Docker, Docker Compose, Nginx, Bash Script (Blue-Green 배포)
- **Security:** Spring Security, CSRF Protection

---

## 💡 프로젝트의 강점 (Strengths)

1. **SEO와 UX의 하이브리드 설계**
   - 크롤러 노출이 필수적인 위키 데이터(물고기, 곤충, 주민 도감 등)는 **Thymeleaf 기반 SSR(서버 사이드 렌더링)**로 구현하여 검색 엔진 최적화(SEO) 및 [GSC(Google Search Console) 색인 통과]를 유도했습니다.
   - 반면 실시간 반응이 필요한 인터랙티브 지도와 검색 자동완성은 **Vanilla JS 기반 Fetch API**를 활용하여 화면 깜빡임 없는 매끄러운 UX를 제공합니다.

2. **안정적인 무중단 배포(Blue-Green) 파이프라인 자작**
   - AWS나 거대 플랫폼에 의존하지 않고, 순수 Docker Compose와 Bash 스크립트를 활용해 **Nginx 스위칭 방식의 무중단 배포 시스템**을 직접 구축했습니다. (`deploy.sh`)

3. **중앙 집중형 예외 처리 및 모니터링 노이즈 제어**
   - `@ControllerAdvice`를 활용해 API 통신과 뷰 렌더링 시 발생하는 에러를 분기 처리(Accept Header 분석)하여 시스템 안정성을 높였습니다.

---

## 🔥 핵심 트러블 슈팅 (이력서 공략 포인트)

이력서 면접관의 이목을 끌 수 있는 기술적 난제와 해결 과정입니다.

### 1. Nginx 라우팅 갱신 및 무중단 배포(Blue-Green) 정합성 확보
- **문제 상황:** 배포 스크립트 실행 시 새 컨테이너(Green)가 완전히 켜지기 전에 Nginx가 라우팅을 넘겨버리면 `502 Bad Gateway`가 간헐적으로 발생했습니다. 또한, 호스트에서 `sed` 명령어로 `nginx.conf`를 수정해도 Nginx 컨테이너가 즉각적으로 마운트된 Inode 변경을 감지하지 못했습니다.
- **해결 과정 (Action):** 
  - 단순 `sleep`이 아닌, `docker exec nginx` 내부에서 타겟 컨테이너의 8080 포트를 `curl`로 직접 찌르는 **Health Check 30회 핑 로직**을 구현했습니다.
  - Inode 변경 인식 문제를 해결하기 위해 `cp /tmp -> .conf` 로직 적용 후 `docker restart nginx`를 명시하여 확실한 캐시 무효화를 수행했습니다.
- **결과:** 단 1초의 다운타임도 허용하지 않는 완벽한 Blue-Green 배포 스크립트 완성.

### 2. 인터랙티브 지도 계층형 지역 탐색 및 UX 개선
- **문제 상황:** 유저가 특정 아이템(예: 하위 지역이 없는 "전체" 범위의 물고기)을 검색했을 때, 단일 좌표(`[lat, lng]`)가 존재하지 않아 지도 카메라가 허공을 비추거나 에러가 발생했습니다.
- **해결 과정 (Action):**
  - 자바스크립트 `map-core.js` 코어 로직에서 `resolveZoneKeys`를 통해 부모(전체) 지역에 속한 **하위 지역 좌표 배열을 모두 수집**하도록 재설계했습니다.
  - 단일 좌표가 아닌 `L.latLngBounds`를 이용해 하위 지역 좌표들의 바운더리를 계산한 뒤, `map.fitBounds(bounds.pad(0.3))`를 통해 **카메라 줌 레벨을 전체가 다 보이도록 동적으로 조절**했습니다. 
- **결과:** 유저가 'XX 채집물 전체'를 검색할 때 직관적으로 해당 범위 전체 폴리곤이 빛나며 자연스러운 카메라 트래킹이 적용됨.

### 3. AOP를 활용한 사용자 친화적 에러 라우팅 및 리소스 최적화
- **문제 상황:** 브라우저가 자동으로 요청하는 `favicon.ico`나 누락된 이미지 요청이 발생할 때마다 벡엔드에서 404 에러 `NoResourceFoundException`이 뿜어져 나와, 정작 중요한 서버 에러 로그를 덮는 현상이 발생했습니다. 또한 비동기(AJAX) 요청 중 에러가 날 경우 HTML 에러 페이지가 JSON으로 파싱되어 FE 단에서 터지는 문제가 있었습니다.
- **해결 과정 (Action):**
  - `GlobalExceptionHandler`를 구현해 이미지가 없을 시 발생하는 404 예외는 로그를 출력하지 않고(`ignoring`) 조용히 넘어가게 설계했습니다.
  - HTTP `Accept` 헤더에 `application/json`이 포함된 경우와 그렇지 않은 경우를 명확히 분기하여, API 요청에는 일관된 JSON 에러 구조(`{success: false, message: ...}`)를 반환하도록 방어 코드를 작성했습니다.

### 4. Fetch API와 Spring Security CSRF 토큰 하이브리드 연동 (과거 이력 참조)
- **문제 내용:** Thymeleaf에서는 CSRF 토큰이 자동 삽입되나, 지도 핀을 CRUD 하는 비동기 Javascript 모듈(`window.MapApp`)에서는 토큰이 없어 403 Forbidden 차단이 발생.
- **해결 방안:** HTML `<meta>` 태그에 CSRF 토큰을 주입하고, JS에서 이를 읽어 모든 HTTP Header에 실어 보내는 공통 API 래핑 모듈을 작성하여 해결.

---

## 🧱 보완해야 할 점 (Weakness & Next Steps)
이력서 면접에서 "이 프로젝트에서 아쉬운 점은 무엇인가" 라는 공격에 방어/성장성을 어필할 수 있는 포인트입니다.

1. **RDBMS Like 검색의 한계와 성능 최적화 여지**
   - 현재 도감 검색은 `%keyword%`를 이용한 패턴 매칭이 주를 이룹니다. 데이터가 많아질 경우 인덱스를 타지 못해 Full-Table Scan이 발생할 우려가 있습니다.
   - *성장 답변:* "추후 트래픽이 늘어난다면 검색엔진(Elasticsearch) 도입이나, Redis를 활용해 자주 검색되는 키워드 캐싱 테이블을 별도로 구성해보고 싶습니다."

2. **JavaScript 모듈의 전역 의존성**
   - `window.MapApp`과 같이 전역 객체를 사용하여 캡슐화를 꾀했지만, 프론트 리소스가 커지면서 Webpack이나 Vite 같은 번들러 환경의 부재로 의존성 관리가 조금 아쉽습니다.
   - *성장 답변:* "차기 프로젝트 혹은 뷰 단 고도화 시, 로컬에서 Vite + TypeScript를 연동해 빌드 파이프라인을 개선해보고자 합니다."

3. **테스트 커버리지 (JUnit5)**
   - `HeartopiaWikiApplicationTest.java` 등 틀은 존재하나 비즈니스 핵심 로직(`MapPinService` 등) 구석구석에 대한 엣지 케이스 단위 테스트가 아직 부족합니다.
   - *성장 답변:* "현재 배포 파이프라인은 갖췄기 때문에, 향후 CI 과정(GitHub Actions)에서 테스트 통과 여부에 따라 빌드(Green)를 차단하는 CD의 안정성을 높이는 방향으로 보완 중입니다."
