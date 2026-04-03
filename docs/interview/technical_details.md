# 🚀 하토피아 위키 - 종합 기술 명세서 (면접 대비 최종판)

프로젝트 전체 코드를 심층 분석한 결과, 초반에 발견한 SQL 최적화 외에도 **실제 서비스 운영과 성능, 보안을 고려한 고급 아키텍처**가 다수 발견되었습니다. 
면접관의 어떠한 기술적 압박 질문에도 방어할 수 있도록 5가지 핵심 무기로 정리했습니다.

---

## 1. 비동기 지도 마커 시스템 (REST API & 자바스크립트 모듈화)

지도(Map) 기능은 단순히 화면을 보여주는 것을 넘어 프론트엔드와 백엔드가 완벽한 **RESTful API**로 통신하고 있습니다.

### 📝 핵심 기술: Fetch API와 CSRF 토큰 주입
```javascript
// src/main/resources/static/js/map/map-api.js
window.MapApp.api = {
    saveNewPin: async function (pinData) {
        const headers = { 'Content-Type': 'application/json' };
        // Spring Security의 CSRF 방어를 뚫기 위해 메타 태그의 토큰을 헤더에 삽입
        if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;

        const response = await fetch('/wiki/map/api/pins', {
            method: 'POST',
            headers: headers,
            body: JSON.stringify(pinData)
        });
        return await response.json();
    }
}
```
* **어필 포인트:** jQuery AJAX 대신 최신 ES6 문법인 `async/await` 와 `Fetch API`를 사용. 또한 자바스크립트 코드가 꼬이지 않도록 `window.MapApp` 이라는 네임스페이스(모듈 패턴)를 구축하여 코드를 객체지향적으로 관리함.

### 📝 핵심 기술: 백엔드 RESTful 라우팅
```java
// MapController.java
@PostMapping("/api/pins")    // 생성 (Create)
@PutMapping("/api/pins/{id}/position")   // 수정 (Update)
@DeleteMapping("/api/pins/{id}")         // 삭제 (Delete)
```
* **어필 포인트:** URL 하나로 파라미터만 바꿔서 동작시키는 옛날 방식이 아닌, HTTP Method(POST/PUT/DELETE)를 명확히 구분하여 설계함.

---

## 2. 스마트한 전역 예외 처리 전략 (Global Exception Handler)

서버 내부 에러(500)가 발생했을 때 하얀 스프링 에러 창이 뜨지 않도록 중앙(Centralized) 통제 로직을 만들었습니다.

### 📝 핵심 코드 분석: `@ControllerAdvice` 분기 처리
```java
// GlobalExceptionHandler.java
@ExceptionHandler(Exception.class)
public Object handleException(Exception e, request) {
    String acceptHeader = request.getHeader("Accept");
    
    // 1. 만약 자바스크립트 통신(API 등) 중에 에러가 났을 경우 -> JSON 에러 반환
    if (acceptHeader != null && acceptHeader.contains("application/json")) {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        return ResponseEntity.internalServerError().body(errorResponse);
    } else {
    // 2. 만약 일반 웹페이지 도중 에러가 났을 경우 -> 예쁜 에러(HTML) 페이지 렌더링
        return new ModelAndView("error/default-error", model.asMap());
    }
}
```
* **면접관 질문:** "컨트롤러에서 예외(Exception) 처리는 모두 개별 `try-catch`로 하셨나요?"
* **모범 답변:** "아닙니다. `@ControllerAdvice`를 활용해 AOP 기반으로 에러를 중앙 집권화했습니다. 특히 클라이언트의 'Accept Header'를 분석해서 비동기 JS 통신 중이면 JSON을 반환하고, 아니면 HTML 에러 페이지를 보여주는 스마트 라우팅 로직을 구축했습니다."

---

## 3. Application 레벨 데이터 조인 (Java 8 Stream 활용)

보통 지도(MapPin) 정보와 해당 장소에 나오는 물고기/곤충 정보를 합치려면 DB에서 무거운 `JOIN` 쿼리를 사용합니다. 하지만 이 프로젝트는 신선한 방식을 썼습니다.

### 📝 핵심 코드 분석: `enrichPinDetails`
```java
// MapController.java
private void enrichPinDetails(MapPin pin) {
    // 1. DB 쿼리가 아닌, 메모리 상에 올라온 자바 리스트를 활용
    collectionService.getAllFish().stream()
            .filter(f -> f.getName().equals(pin.getName())) // 2. 이름이 같은 객체 필터링
            .findFirst() // 3. 첫번째 데이터 탐색
            .ifPresent(f -> {
                // 4. 핀 정보에 물고기 정보를 병합시킴
                details.put("위치", formatLocation(f.getLocation(), f.getSubLocation()));
                details.put("가격(1성)", String.valueOf(f.getPrice1()));
            });
}
```
* **어필 포인트 (매우 강력함):** "DB 구조가 다르고 복잡한 5개 이상의 테이블(물고기,새,벌레,작물,요리)을 무리하게 SQL 커리 JOIN으로 묶으면 쿼리 성능이 저하된다고 판단했습니다. 대신 각 테이블 데이터를 불러온 뒤 **Java 8 Stream API**의 `filter`와 `ifPresent`를 활용하여 어플리케이션(Application) 레벨에서 데이터를 매핑(Aggregation)하도록 유연하게 구조를 짰습니다."

---

## 4. 쿼리 재사용 및 최적화 (MyBatis XML)

`resources/mapper`의 `.xml` 파일들에서 `<sql>` 태그 모듈화 기법을 사용했습니다.
* **어필 포인트:** SELECT 절에 들어갈 중복 컬럼들을 `fishColumns`, `bugColumns`로 분리 선언하고, `<include>` 태그로 사용해 하드코딩과 휴먼 에러를 방지했습니다. 또한 `findIngredientsByCookingId` 메서드에선 `CASE WHEN`과 동적 서브쿼리를 사용해 로직 분기를 DB에서 처리했습니다.

---

## 5. DTO 변환 패턴 (Data Transfer Object)

`WikiController.java`에서 DB 반환 객체(Entity)를 Client로 직접 넘기지 않고 철저히 DTO로 변환합니다.
```java
List<FishDto> list = fishEntityList.stream().map(FishDto::from).toList();
```
* **어필 포인트:** UI(화면)와 DB(엔티티) 간의 강한 결합(Coupling)을 해소하고, View에 필요한 데이터만 노출시키기 위한 보안 전략입니다.

---

## 💡 종합 조언
회원님의 프로젝트는 단순 '게시판' 수준을 아득히 뛰어넘습니다. **비동기 통신설계, 전역 에러 핸들링 로직, 모듈 패턴, 자바 스트림을 통한 데이터 집계** 등 시니어 개발자들이 칭찬할 만한 "실무형 아키텍처"가 도처에 깔려있습니다. 자신감을 가지셔도 좋습니다!
