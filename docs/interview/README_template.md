# 🍃 하토피아(Heartopia) 공략 종합 위키

> 게임 '두근두근라이프(Heartopia)'의 유저들을 위한 도감, 공략, 지도 정보를 제공하는 종합 위키 서비스입니다.

[![배포 상태](https://img.shields.io/badge/Deploy-Success-brightgreen)](#)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.1.2-6DB33F?logo=springboot&logoColor=white)](#)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](#)

<br/>

## 🔗 링크
- **배포 주소:** [https://본인도메인/](https://본인도메인/)
- **관련 블로그(트러블슈팅 회고):** [블로그 주소 링크](https://velog.io/@...)

<br/>

## 🛠 주요 기능 및 화면 (Features)
*(여기에 핵심 기능들의 실행 모습을 GIF나 좋은 화질의 캡처본으로 넣어주세요)*

1. **상세 도감 시스템 (동물/곤충/물고기 등)**
   - 종류별 필터링 및 서식지, 출현 시간 정보 제공
2. **커스텀 맵 마커 기능**
   - 게임 내 중요 자원 및 채집 위치를 지도에 시각화
3. **반응형 웹 UI (모바일 최적화)**
   - 스마트폰에서도 도감을 쉽게 찾아볼 수 있도록 반응형 UI 구현

<br/>

## 🎯 기술 스택 (Tech Stack)

### **Backend**
- Java 17, Spring Boot 3.x
- Spring Data JPA
- MySQL 8.0

### **Frontend**
- HTML5, CSS3, Vanilla JavaScript
- Thymeleaf

### **Infrastructure & DevOps**
- AWS EC2, GitHub Actions (배포 자동화에 사용했다면 작성)
- Nginx

<br/>

## 🔥 트러블슈팅 (Trouble Shooting)
*(이력서에서 눈길을 끌 수 있는 핵심 문제 해결 경험 1~2가지를 요약해서 적고, 자세한 내용은 블로그/Wiki 링크를 연결하세요)*

### 1. 많은 이미지 렌더링으로 인한 모바일 화면 로딩 속도 저하
- **문제점:** 도감 페이지에서 수십 개의 고해상도 이미지를 한 번에 불러와 모바일 환경에서 렌더링이 지연(3초 이상)되는 현상 발생.
- **해결 방안:** 
  - Lazy Loading 적용으로 스크롤 시 화면에 보이는 이미지만 로드하도록 개선.
  - 정적 리소스(이미지 등)를 Nginx 레벨에서 캐싱 처리.
- **결과:** 초기 로딩 속도 60% 개선 (3.2초 -> 1.2초).

### 2. 검색 엔진 최적화(SEO) 대응
- **문제점:** 서비스 런칭 초기, 명확하지 않은 사이트 제목('두근두근라이프')으로 인해 검색 포털 유입이 거의 발생하지 않음.
- **해결 방안:**
  - 사용자가 주로 찾는 키워드('공략', '도감', '하토피아')를 분석하여 `<title>`과 `<meta description>` 태그 동적 개선.
- **[👉 더 자세한 트러블슈팅 과정 보기 (Wiki/블로그 링크)](#)**

<br/>

## ⚙️ 로컬 실행 방법 (Getting Started)
*(면접관이 로컬에서 쉽게 실행해볼 수 있도록 환경 설정 방법을 명확히 작성합니다)*

```bash
# 1. 저장소 클론
$ git clone https://github.com/본인계정/heartopia-wiki-project.git

# 2. application.yml 설정 (DB 계정 정보 등 환경에 맞게 수정)
$ src/main/resources/application.yml 수정

# 3. 프로젝트 빌드 및 실행
$ ./gradlew build
$ java -jar build/libs/heartopia-wiki-0.0.1-SNAPSHOT.jar
```
